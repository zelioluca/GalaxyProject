//project inclusion
#include "loader.h"
#include "kernel.h"
#include "macro.h"
#include "cpu.h"

//c++ inclusion
#include <iostream>
#include <stdio.h>
#include <ctime>


int main(int argc, char *argv)
{
	//start the timer
	clock_t startMaster = clock(); 

	//load the file
	double *host_real = CreateVector("Data/data_100k_arcmin.txt"); 
	double *host_flat = CreateVector("Data/flat_100k_arcmin.txt");
	int data_size = GetVectorSize("Data/data_100k_arcmin.txt");

	//create the four array for the histogram and feed with 0
	unsigned long long int *host_DD = (unsigned long long int *)malloc(HISTOGRAM_DEGREE * sizeof(unsigned long long int));
	unsigned long long int *host_DR = (unsigned long long int *)malloc(HISTOGRAM_DEGREE * sizeof(unsigned long long int)); 
	unsigned long long int *host_RR = (unsigned long long int *)malloc(HISTOGRAM_DEGREE * sizeof(unsigned long long int)); 

	//scientific differences
	double *host_scientific_difference = (double *)malloc(HISTOGRAM_DEGREE * sizeof(double));

	for (int i = 0; i < HISTOGRAM_DEGREE; i++)
	{
		host_DD[i] = 0; 
		host_DR[i] = 0; 
		host_RR[i] = 0; 
		host_scientific_difference[i] = 0; 
	}

	int selection = 0; 
	std::cout << "### Welcome to the dark matter calculator ###\nSelect\n\t1. GPU\n\t2. CPU\n"; 
	std::cin >> selection; 

	switch (selection)
	{
	case 1:
		std::cout << "### GPU select ### - Should not take long time ###\n" << std::endl; 
		DarkMatterParallel(host_real, host_flat, host_DD, host_DR, host_RR, data_size);
		break;
	case 2:
		std::cout << "### CPU select ### - Take plenty of time" << std::endl; 
		DarkMatterCPU(host_real, host_flat, host_real, host_flat, host_DD, host_DR, host_RR, host_scientific_difference); 
		break; 
	default:
		std::cout << "Wrong selection " << std::endl; 
		break;
	}
	//inizialize the CUDA job
	//DarkMatterParallel(host_real, host_flat, host_DD, host_DR, host_RR, host_scientific_difference, data_size); 
	//debug
	if(DEBUG == 1)
	{
		unsigned long long int sumDD = 0;
		unsigned long long int sumDR = 0;
		unsigned long long int sumRR = 0;

		//debug DD
		for (int i = 0; i < HISTOGRAM_DEGREE; i++)
		{
			printf("Host_DD[%d] => %ld\n", i, host_DD[i]);
			sumDD += host_DD[i];
		}
		printf("\n");
		//debug DR
		for (int i = 0; i < HISTOGRAM_DEGREE; i++)
		{
			printf("Host_DR[%d] => %ld\n", i, host_DR[i]);
			sumDR += host_DR[i];
		}
		printf("\n");
		//debug RR
		for (int i = 0; i < HISTOGRAM_DEGREE; i++)
		{
			printf("Host_RR[%d] => %ld\n", i, host_RR[i]);
			sumRR += host_RR[i];
		}
		printf("\n");
		printf("\nThe sum of DD is %llu\n", sumDD);
		printf("\nThe sum of DR is %llu\n", sumDR);
		printf("\nThe sum of RR is %llu\n", sumRR);

	}
	//make the scientific difference on CPU 
	host_scientific_difference = MakeTheScientificMesurement(host_DD, host_DR, host_RR); 

	//writing in the file DD
	WriteOutTheFile("Output/histogramDD.csv", host_DD, NULL);
	//writing in the file DR
	WriteOutTheFile("Output/histogramDR.csv", host_DR, NULL);
	//writing in the file RR
	WriteOutTheFile("Output/histogramRR.csv", host_RR, NULL);
	//writing in the file scientific
	WriteOutTheFile("Output/scientific_diff.csv", NULL, host_scientific_difference);

	//show the time
	clock_t endMaster = clock();
	double elapsed = ((double)(endMaster - startMaster)) / CLOCKS_PER_SEC;
	printf("\nElapsed time %f secs\n", elapsed);

	//print the log file 
	PrintLogFile("Output/Log.txt", elapsed, host_DD, host_DR, host_RR, host_scientific_difference);

	//free the c++ memory
	delete[] host_real;
	delete[] host_flat;
	delete[] host_DD;
	delete[] host_DR;
	delete[] host_RR;
	delete[] host_scientific_difference;

	return 0;

}