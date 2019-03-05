//cuda inclusion
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
//c++ and project inclusion
#include <stdio.h>
#include "macro.h"

//Math inclusion
#define _USE_MATH_DEFINES
#include <math.h>
#include <cmath>

//Cuda error handling start here
inline void error_check(cudaError_t err, const char*file, int line)
{
	if (err != cudaSuccess) {
		::fprintf(stderr, "\nCUDA ERROR at %s[%d] : %s\n", file, line, cudaGetErrorString(err));
		printf("\nGeneral error at %s[%d] : %s\n", file, line, cudaGetErrorString(err));
	}
}

#define CUDA_CHECK(err) do { error_check(err, __FILE__, __LINE__); } while(0)

//this function clamp the numbers ORI with float 
__device__ double ClampTheMatter(double temp, double a, double b)
{
	return fmax(a, fmin(b, temp));
}


__global__
void TheDarkMatter(double *device_real, double *device_flat, unsigned long long int *device_DD, unsigned long long int *device_DR, unsigned long long int *device_RR, int size, double *copy_device_real, double *copy_device_flat)
{

	//index for x and y era inverso c era x r era y
	const int cIndex = blockIdx.x * blockDim.x + threadIdx.x;
	const int rIndex = blockIdx.y * blockDim.y + threadIdx.y;

	int c = cIndex * 2; //ori c 
	int r = rIndex * 2; //ori r
 
	//check the bound of the two index 
	if ((c >= W ) || (r >= H )) return; 

	//this is the temp that contain DD
	double tempDD = sin(device_real[r + 1]) * sin(copy_device_real[c + 1]) + cos(device_real[r + 1]) * cos(copy_device_real[c + 1]) * cos(device_real[r] - copy_device_real[c]);
	//this is the temp for DR
	double tempDR = sin(device_real[r + 1]) * sin(device_flat[c + 1]) + cos(device_real[r + 1]) * cos(device_flat[c + 1]) * cos(device_real[r] - device_flat[c]);
	//this is the temp that contains RR
	double tempRR = sin(device_flat[r + 1]) * sin(copy_device_flat[c + 1]) + cos(device_flat[r + 1]) * cos(copy_device_flat[c + 1]) * cos(device_flat[r] - copy_device_flat[c]);
	//__syncthreads(); 
	//clamp the number DD
	tempDD = acos(ClampTheMatter(tempDD, MINCLAMP, MAXCLAMP));
	//this is the clamp for DR
	tempDR = acos(ClampTheMatter(tempDR, MINCLAMP, MAXCLAMP));
	//clamp the number RR
	tempRR = acos(ClampTheMatter(tempRR, MINCLAMP, MAXCLAMP));

	//calulate the stuff for the histo
	tempDD = (tempDD * 180 / M_PI * 4); 
	tempDR = (tempDR * 180 / M_PI * 4);
	tempRR = (tempRR * 180 / M_PI * 4); 
	//insert in the histogram DD ORI WITH (int)
	atomicAdd(device_DD + (int)tempDD, 1); 
	//this is the histogram DR
	atomicAdd(device_DR + (int)tempDR, 1);
	//insert in the histogram RR
	atomicAdd(device_RR + (int)tempRR, 1);

	__syncthreads();
}


void DarkMatterParallel(double *host_real, double *host_flat, unsigned long long int *host_DD, unsigned long long int *host_DR, unsigned long long int *host_RR, int size)
{
	//cuda malloc phase
	double *device_real = nullptr;
	double *device_flat = nullptr; 
	unsigned long long int *device_DD = nullptr;
	unsigned long long int *device_DR = nullptr;
	unsigned long long int *device_RR = nullptr; 

	//rookie level
	double *copy_device_real = nullptr;
	double *copy_device_flat = nullptr; 

	CUDA_CHECK(cudaMalloc(&device_real, W * sizeof(double))); 
	CUDA_CHECK(cudaMalloc(&device_flat, W * sizeof(double))); 
	CUDA_CHECK(cudaMalloc(&device_DD, HISTOGRAM_DEGREE * sizeof(unsigned long long int)));
	CUDA_CHECK(cudaMalloc(&device_DR, HISTOGRAM_DEGREE * sizeof(unsigned long long int)));
	CUDA_CHECK(cudaMalloc(&device_RR, HISTOGRAM_DEGREE * sizeof(unsigned long long int)));

	//rookie 
	CUDA_CHECK(cudaMalloc(&copy_device_real, W * sizeof(double)));
	CUDA_CHECK(cudaMalloc(&copy_device_flat, W * sizeof(double)));

	//copy the array in the kernel
	CUDA_CHECK(cudaMemcpy(device_real, host_real, W * sizeof(double), cudaMemcpyHostToDevice)); 
	CUDA_CHECK(cudaMemcpy(device_flat, host_flat, W * sizeof(double), cudaMemcpyHostToDevice));
	CUDA_CHECK(cudaMemcpy(device_DD, host_DD, HISTOGRAM_DEGREE * sizeof(unsigned long long int), cudaMemcpyHostToDevice));
	CUDA_CHECK(cudaMemcpy(device_DR, host_DR, HISTOGRAM_DEGREE * sizeof(unsigned long long int), cudaMemcpyHostToDevice));
	CUDA_CHECK(cudaMemcpy(device_RR, host_RR, HISTOGRAM_DEGREE * sizeof(unsigned long long int), cudaMemcpyHostToDevice));


	//rookie 
	CUDA_CHECK(cudaMemcpy(copy_device_real, host_real, W * sizeof(double), cudaMemcpyHostToDevice));
	CUDA_CHECK(cudaMemcpy(copy_device_flat, host_flat, W * sizeof(double), cudaMemcpyHostToDevice));

	//bulit the grid 
	const dim3 blockSize(TX, TY);
	const int bx = (NUMBERCASE + TX - 1) / TX; //W
	const int by = (NUMBERCASE + TY - 1) / TY; //50000 
	const dim3 gridSize = dim3(bx, by);
	
	printf("### Looking for DarkMatter ###\n\n"); 
	printf("\nGrid size is bx is %d by is %d \n\nNumber of case to analyze %ld x %ld\n\n TX is %d TY is %d\n\n", bx, by, NUMBERCASE, NUMBERCASE, TX, TY); 

	//start the kernel
	TheDarkMatter <<< gridSize, blockSize >>> (device_real, device_flat, device_DD, device_DR, device_RR, size, copy_device_real, copy_device_flat);
	cudaDeviceSynchronize();
	//check error
	cudaError_t err = cudaGetLastError();
	if (err != cudaSuccess)
	{
		printf("\nError in cuda kernel %s\n", cudaGetErrorString(err)); 

	}
	//copy result to host
	CUDA_CHECK(cudaMemcpy(host_DD, device_DD, HISTOGRAM_DEGREE * sizeof(unsigned long long int), cudaMemcpyDeviceToHost));
	CUDA_CHECK(cudaMemcpy(host_DR, device_DR, HISTOGRAM_DEGREE * sizeof(unsigned long long int), cudaMemcpyDeviceToHost));
	CUDA_CHECK(cudaMemcpy(host_RR, device_RR, HISTOGRAM_DEGREE * sizeof(unsigned long long int), cudaMemcpyDeviceToHost));

	//free the memory
	CUDA_CHECK(cudaFree(device_real));
	CUDA_CHECK(cudaFree(device_flat)); 
	CUDA_CHECK(cudaFree(device_DD));
	CUDA_CHECK(cudaFree(device_DR));
	CUDA_CHECK(cudaFree(device_RR));

	//rookie
	CUDA_CHECK(cudaFree(copy_device_real));
	CUDA_CHECK(cudaFree(copy_device_flat));

}