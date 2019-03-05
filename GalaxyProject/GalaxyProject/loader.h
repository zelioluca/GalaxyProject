#ifndef LOADER_H
#define LOADER_H

/*Author Luca Zelioli*/
//c++ iinclusion
#include <iostream>
#include <fstream>
#include <stdio.h>

//project inclusion 
#include "macro.h"

//string and math inclusion
#define _USE_MATH_DEFINES
#include <string>
#include <math.h>
//time inclusion
#include <ctime>
//exception inclusion
#include <exception>



using namespace std;

double* CreateVector(string filename)
{
	//start the timer 
	clock_t begin = clock();
	//array to return 
	double* arrayToReturn = nullptr;
	//size
	int arraySize = 0;
	double temp = 0;

	try
	{
		//open the file stream
		std::ifstream MyFile(filename);

		if (MyFile.is_open())
		{
			//get the size
			for (int i = 0; i < 1; i++)
			{
				MyFile >> arraySize;
			}

			//create the array FOSE CI VUOLE IL POINTER ATTENTO!
			arrayToReturn = new double[arraySize * 2];

			for (int i = 0; i < arraySize * 2; i++)
			{
				MyFile >> temp;
				temp = temp * 1 / 60 * M_PI / 180;
				arrayToReturn[i] = temp;
			}

			//close the file 
			MyFile.close();
		}
		else
		{
			std::cout << "Unable to open the file " << filename << std::endl;
			return nullptr;
		}
	}
	catch (exception& ex)
	{
		std::cout << "The function CreateVector trow " << ex.what() << std::endl;

		//stop the timer
		clock_t end = clock();
		double elapsed = double(end - begin) / CLOCKS_PER_SEC;

		//show the time
		std::cout << "Load of " << filename << " failed elapsed time: " << elapsed << std::endl;
		return nullptr;
	}

	//end timer
	clock_t end = clock();
	double elapsed = double(end - begin) / CLOCKS_PER_SEC;

	std::cout << "Load of " << filename << " complete elapsed time: " << elapsed << std::endl;

	return arrayToReturn;
}

//this function get the vector size
int GetVectorSize(string filename)
{
	int arraysize = NULL;

	try
	{
		int temp = 0;
		std::ifstream MyFile(filename);

		if (MyFile.is_open())
		{
			//get the size
			for (int i = 0; i < 1; i++)
			{
				MyFile >> temp;
			}

			//get the size for return 
			arraysize = (temp * 2);
			//close if stream
			MyFile.close();
		}
		else
		{
			std::cout << "Get vector size says: Impossible to open the file " << std::endl;
			return NULL;
		}

	}
	catch (exception& ex)
	{
		std::cout << "Get vector size throw exception " << ex.what() << std::endl;
		return NULL;
	}

	return arraysize;
}

void WriteOutTheFile(const char *filename, unsigned long long int *arr, double *scientific)
{
	clock_t start = clock(); 

	FILE *outfile = fopen(filename, "w"); 

	try
	{
		if (arr != NULL)
		{
			for (int i = 0; i < HISTOGRAM_DEGREE / 2; i++)
			{
				fprintf(outfile, "%d, %ld\n", i, arr[i]);
			}
		}
		else
		{
			for (int i = 0; i < HISTOGRAM_DEGREE /2; i++) //ori with /2 
			{
				fprintf(outfile, "%d, %f\n", i, scientific[i]);
			}
		}
	}
	catch (exception& ex)
	{
		std::cout << "WriteOutTheFile throw exception " << ex.what() << std::endl; 
	}

	fclose(outfile); 

	clock_t end = clock(); 
	double elapsed = ((double)(end - start)) / CLOCKS_PER_SEC; 

	std::cout << "\nFinish to write the file " << filename << " in " << elapsed << " sec\n" << std::endl; 
}

void PrintLogFile(const char *filename, double elapsed, unsigned long long int *host_DD, unsigned long long int *host_DR, unsigned long long int *host_RR, double *scientific)
{
	clock_t start = clock(); 
	FILE *outfile = fopen(filename, "w"); 

	try
	{
		fprintf(outfile, "### LOG FILE ### - Author Luca Zelioli\n### Printing the host_DD ###\n\n");
		fprintf(outfile, "\n\n### Elapsed Time %f secs ###\n\n", elapsed); 
		fprintf(outfile, "### Kernel configuration ###\n\n");
		fprintf(outfile, "The grid: bx is %d by is %d\n", (NUMBERCASE + TX - 1) / TX, (NUMBERCASE + TY - 1) / TY);
		fprintf(outfile, "Number of galaxy to analyse %d * %d\n", NUMBERCASE, NUMBERCASE);
		fprintf(outfile, "Thread X is %d and Thread Y is %d\n\n", TX, TY); 
		fprintf(outfile, "### kernel configuration end ###\n\n"); 

		fprintf(outfile, "### Printing the host_DD ###\n"); 
		unsigned long long int sumDD = 0; 
		for (int i = 0; i < HISTOGRAM_DEGREE; i++)
		{
			fprintf(outfile, "host_DD[%d] => %ld\n", i, host_DD[i]);
			sumDD += host_DD[i]; 
		}
		fprintf(outfile, "Sum of host_DD is %llu\n\n### Printing the host_DR ###\n", sumDD); 

		unsigned long long int sumDR = 0; 
		for (int i = 0; i < HISTOGRAM_DEGREE; i++)
		{
			fprintf(outfile, "host_DR[%d] => %ld\n", i, host_DR[i]);
			sumDR += host_DR[i]; 
		}
		fprintf(outfile, "Sum host_DR is %llu\n\n### Printing the host_RR ###\n", sumDR);

		unsigned long long int sumRR = 0; 
		for (int i = 0; i < HISTOGRAM_DEGREE; i++)
		{
			fprintf(outfile, "host_RR[%d] => %ld\n", i, host_RR[i]);
			sumRR += host_RR[i]; 
		}
		fprintf(outfile, "Sum of host_RR is %llu\n\n### Printing the scietific mesurement ###\n", sumRR);


		for (int i = 0; i < HISTOGRAM_DEGREE; i++)
		{
			fprintf(outfile, "scientific[%d] => %f\n", i, scientific[i]);
		}
		fprintf(outfile, "### End printing the log file ###\n\nPowered by Luca Zelioli"); 
	}
	catch (exception& ex)
	{
		std::cout << "The PrintLogFile function throw exception " << ex.what() << std::endl; 
	}
	fclose(outfile);

	clock_t end = clock(); 
	double elapsedtimer = ((double)end - start) / CLOCKS_PER_SEC; 

	std::cout << "\nFinish to write the file " << filename << " in " << elapsedtimer << " secs\n " << std::endl; 
}

//function that do the scientific measurement 
double *MakeTheScientificMesurement(unsigned long long int *host_DD, unsigned long long int *host_DR, unsigned long long int *host_RR)
{
	double *temp = (double*)malloc(HISTOGRAM_DEGREE * sizeof(double)); 

	for (int i = 0; i < HISTOGRAM_DEGREE; i++)
	{
		if ((host_RR[i] != 0) || (host_RR[i] != NULL) || (host_RR[i] != NAN))
		{
			temp[i] = (int)(host_DD[i] - 2 * host_DR[i] + host_RR[i]) / (double)host_RR[i];
		}
		else
		{
			temp[i] = 0;
		}
	}

	return temp; 
}


#endif
