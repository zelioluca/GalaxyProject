#ifndef CPU_H
#define CPU_H

/*Author Luca Zelioli*/
//c++ iinclusion
#include <iostream>
#include <algorithm>
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

double Clamp(double temp, double a, double b)
{
	return std::max(a, std::min(b, temp)); 
}


void DarkMatterCPU(double *host_real, double *host_flat, double *copy_real, double *copy_flat,unsigned long long int *host_DD, unsigned long long int *host_DR, unsigned long long int *host_RR, double *scientific)
{
	std::cout << "Process start " << std::endl; 
	double timer = 0.0001; 

	try
	{
		for (int row = 0; row < NUMBERCASE; row++)
		{
			for (int col = 0; col < NUMBERCASE; col++)
			{
				int tempRow = row * 2;
				int tempCol = col * 2;

				double tempDD = sin(host_real[tempRow + 1]) * sin(copy_real[tempCol + 1]) + cos(host_real[tempRow + 1]) * cos(copy_real[tempCol + 1]) * cos(host_real[tempRow] - copy_real[tempCol]);
				double tempDR = sin(host_real[tempRow + 1]) * sin(host_flat[tempCol + 1]) + cos(host_real[tempRow + 1]) * cos(host_flat[tempCol + 1]) * cos(host_real[tempRow] - host_flat[tempCol]);
				double tempRR = sin(host_flat[tempRow + 1]) * sin(copy_flat[tempCol + 1]) + cos(host_flat[tempRow + 1]) * cos(copy_flat[tempCol + 1]) * cos(host_flat[tempRow] - copy_flat[tempCol]);

				tempDD = acos(Clamp(tempDD, MINCLAMP, MAXCLAMP));
				tempDR = acos(Clamp(tempDR, MINCLAMP, MAXCLAMP)); 
				tempRR = acos(Clamp(tempRR, MINCLAMP, MAXCLAMP));

				tempDD = (int)(tempDD * 180 / M_PI * 4);
				tempDR = (int)(tempDR * 180 / M_PI * 4);
				tempRR = (int)(tempRR * 180 / M_PI * 4);

				++host_DD[(int)tempDD]; 
				++host_DR[(int)tempDR]; 
				++host_RR[(int)tempRR]; 

			}
			timer++; 
			std::cout << "Percentage of => " << timer << "%\n" << std::endl; 
		}

		for (int i = 0; i < HISTOGRAM_DEGREE; i++)
		{
			if (host_RR[i] != 0)
			{
				scientific[i] = (host_DD[i] - 2 * host_DR[i] + host_RR[i]) / (double)host_RR[i]; 
			}
			else
			{
				scientific[i] = 0; 
			}
		}
	}
	catch (exception& ex)
	{
		std::cerr << "The function DarkMatterCPU has thrown exception " << ex.what() << std::endl; 
	}
}



#endif