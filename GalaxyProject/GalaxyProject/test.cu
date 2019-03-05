/////*Author Luca Zelioli*/
////
////cuda inclusion 
//#include <cuda.h>
//#include <cuda_runtime.h>
//#include <device_launch_parameters.h>
//#include <device_functions.h>
//#include <cuda_runtime_api.h>
//#include <device_atomic_functions.h>
////c++ iinclusion
//#include <iostream>
//#include <stdio.h>
//
////math library 
//#define _USE_MATH_DEFINES
//#include <math.h>
//#include <cmath>
//
//#include <string>
//#include <ctime> // maybe not needed 
//
////Histogram ORI 180
//#define HISTOGRAM_DEGREE 720
//
////define the thread in blocks
//#define THREADS_IN_BLOCKS 256
//
////project inclusion
//#include "function.h"; 
//
//using namespace std;
//
////Cuda error handling start here
//
//inline void error_check(cudaError_t err, const char*file, int line)
//{
//	if (err != cudaSuccess) {
//		::fprintf(stderr, "CUDA ERROR at %s[%d] : %s\n", file, line, cudaGetErrorString(err));
//		std::cout << "General error at %s[%d] : %s\n", file, line, cudaGetErrorString(err); 
//	}
//}
//
//#define CUDA_CHECK(err) do { error_check(err, __FILE__, __LINE__); } while(0)
//
//__global__ void DarkMatterMaster(int size, double* device_real, double* device_flat, long int* device_resultDD, long int* device_resultDR, long int* device_resultRR)
//{
//
//	//init all the histo to 0
//	for (int i = 0; i < HISTOGRAM_DEGREE; i++)
//	{
//		device_resultDD[i] = 0; 
//		device_resultDR[i] = 0; 
//		device_resultRR[i] = 0; 
//	}
//
//	//first thing copnvert in arc minutes to rad
//	int index = threadIdx.x + blockIdx.x * blockDim.x;
// 
//	//qui inizia galaxy comp
//	int i = threadIdx.x + blockIdx.x * blockDim.x;
//	int j = threadIdx.y + blockIdx.y * blockDim.y;
//	//int j = 0; 
//	if(i < size - 3)
//	{
//		//debug
//		// printf("GPU - j = %d, i =%d\n", j, i);
//		//allocate temp DD
//		double tempDD = acos(sin(device_real[j + 1]) * sin(device_real[i + 3]) + cos(device_real[j + 1])*cos(device_real[i + 3])*cos(device_real[j] - device_real[i + 2]));
//		//++device_resultDD[(int)(acos(sin(device_real[j + 1]) * sin(device_real[i + 3]) + cos(device_real[j + 1])*cos(device_real[i + 3])*cos(device_real[j] - device_real[i + 2])) * 180 / M_PI * 4)];
//		//debug
//		printf("TempDD -> %f\n", tempDD);
//		//allocate temp DR
//		double tempDR = acos(sin(device_real[j + 1]) * sin(device_flat[i + 1]) + cos(device_real[j + 1]) * cos(device_flat[i + 1]) * cos(device_real[j] - device_flat[i]));
//		//debug
//		printf("TempDR -> %f\n", tempDR);
//		//allocate temp RR
//		double tempRR = acos(sin(device_flat[j + 1]) * sin(device_flat[i + 3]) + cos(device_flat[j + 1])*cos(device_flat[i + 3])*cos(device_flat[j] - device_flat[i + 2]));
//		//debug
//		printf("TempRR -> %f\n", tempRR);
//		//atomicAdd
//		++device_resultDD[(int)(tempDD * 180 / M_PI * 4)];
//		++device_resultDR[(int)(tempDR * 180 / M_PI * 4)];
//		++device_resultRR[(int)(tempRR * 180 / M_PI * 4)];
//		//Test add 1 to go next couple of number CONTROLLARE
//		//i = i + 1; 
//		//j = j + 1; 
//		i += blockDim.x * gridDim.x;
//		j += blockDim.y * gridDim.y;
//
//	}
//
//	//sync the thread
//	__syncthreads();
//}
//
//int main(int argc, char* argv[])
//{
//	//start clock
//	clock_t masterStart = clock(); 
//	//device counter
//	int deviceCount = 0; 
//
//	//double host_real[5] = { 4646.98, 3749.51, 4644.35, 3749.52 };
//	//double host_flat[5] = { 840.961426, 387.991697, 387.368692, 2967.285746 };
//	double* host_real = CreateVector("Data/data_100k_arcmin.txt"); 
//	double* host_flat = CreateVector("Data/flat_100k_arcmin.txt");
//	size_t arraySize = GetVectorSize("Data/data_100k_arcmin.txt"); 
//	//size_t arraySize = 2; 
//
//	double* host_resultDD = (double*)malloc(HISTOGRAM_DEGREE * sizeof(double)); 
//	double* host_resultDR = (double*)malloc(HISTOGRAM_DEGREE * sizeof(double)); 
//	double* host_resultRR = (double*)malloc(HISTOGRAM_DEGREE * sizeof(double)); 
//
//	double * device_real; 
//	double * device_flat; 
//	long int * device_resultDD; 
//	long int * device_resultDR; 
//	long int * device_resultRR; 
//
//	if (cudaSuccess != cudaMalloc((void**)&device_real, arraySize * sizeof(double)))
//	{
//		std::cout << "Error in allocating device_real memory" << std::endl; 
//	}
//
//	if (cudaSuccess != cudaMalloc((void**)&device_flat, arraySize * sizeof(double)))
//	{
//		std::cout << "Error in allocating device_host memory" << std::endl;
//	}
//
//	if (cudaSuccess != cudaMalloc((void**)&device_resultDD, HISTOGRAM_DEGREE * sizeof(long int))) //usare int o lo ng int 
//	{
//		std::cout << "Error in allocating device_resultDD memory" << std::endl;
//	}
//
//	if (cudaSuccess != cudaMalloc((void**)&device_resultDR, HISTOGRAM_DEGREE * sizeof(long int)))
//	{
//		std::cout << "Error in allocating device_resultDR memory" << std::endl;
//	}
//
//	if (cudaSuccess != cudaMalloc((void**)&device_resultRR, HISTOGRAM_DEGREE * sizeof(long int)))
//	{
//		std::cout << "Error in allocating device_resultRR memory" << std::endl;
//	}
//
//	cudaMemcpy(device_real, host_real, arraySize * sizeof(double), cudaMemcpyHostToDevice); 
//	cudaMemcpy(device_flat, host_flat, arraySize * sizeof(double), cudaMemcpyHostToDevice);
//
//	//device props
//	//show device information
//	cudaGetDeviceCount(&deviceCount);
//	std::cout << "\nDevice count: " << deviceCount << std::endl;
//
//	//device property
//	for (int p = 0; p < deviceCount; p++)
//	{
//		cudaDeviceProp deviceProp;
//		cudaGetDeviceProperties(&deviceProp, p);
//
//		std::cout << "Device number " << p << std::endl;
//		std::cout << "\tDevice name " << deviceProp.name << std::endl;
//		std::cout << "\tMax threads dim " << deviceProp.maxThreadsDim << std::endl;;
//		std::cout << "\tMax grid size " << deviceProp.maxGridSize << std::endl;
//		std::cout << "\tMax threads per blocks " << deviceProp.maxThreadsPerBlock << std::endl;
//		std::cout << "\tShared memory per blocks " << deviceProp.sharedMemPerBlock << std::endl;
//		std::cout << "\tWarp size " << deviceProp.warpSize << std::endl;
//		std::cout << "\n"; 
//	}
//
//	//init set kernel
//	
//	//int blockInGrid = (arraySize + THREADS_IN_BLOCKS - 1) / THREADS_IN_BLOCKS;
//	//int limitX = 100000;
//	//int limitY = 100000;
//	//int threadLimitPerBlock = 140;
//	//int numberOfThreads = limitX * limitY;
//	//int requiredNumberOfBlocks = (numberOfThreads / threadLimitPerBlock) + 1;
// 
//	//Kernnel block and grid 
//	dim3 Grid(1, 1, 1); //348
//	dim3 ThreadsPerblock(1, 1, 1);  //288 block width 
//
//	//kernel 
//	DarkMatterMaster <<< Grid, ThreadsPerblock >>> (arraySize, device_real, device_flat, device_resultDD, device_resultDR, device_resultRR);
//	cudaDeviceSynchronize(); 
//	//error check
//	cudaError_t err = cudaGetLastError();
//	if (err != cudaSuccess)
//	{
//		std::cout << "Error in the kernel " << cudaGetErrorString(err) << std::endl;
//		return -1; 
//	}
//
//	//copy back the histogram array
//	cudaMemcpy(host_resultDD, device_resultDD, HISTOGRAM_DEGREE * sizeof(double), cudaMemcpyDeviceToHost);
//	cudaMemcpy(host_resultDR, device_resultDR, HISTOGRAM_DEGREE * sizeof(double), cudaMemcpyDeviceToHost);
//	cudaMemcpy(host_resultRR, device_resultRR, HISTOGRAM_DEGREE * sizeof(double), cudaMemcpyDeviceToHost);
//	//debug
//	
//	for (int i = 0; i < HISTOGRAM_DEGREE; i++)
//	{
//		std:cout << "hist DD=> " << i << " is "  << host_resultDD[i] << std::endl;  
//	}
//	//free c++ memory
//	std::cout << "Now frre the C++ memory\n" << std::endl; 
//	delete[] host_flat;
//	delete[] host_real; 
//	delete[] host_resultDD; 
//	delete[] host_resultDR; 
//	delete[] host_resultRR; 
//
//	//free cuda memory
//	std::cout << "Now frre the Cuda memory\n" << std::endl;
//	cudaFree(device_real); 
//	cudaFree(device_flat); 
//	cudaFree(device_resultDD); 
//	cudaFree(device_resultDR);
//	cudaFree(device_resultRR); 
//
//	//end clock
//	clock_t masterEnd = clock(); 
//	float elapsed = (float)(masterEnd - masterStart) / CLOCKS_PER_SEC; 
//	std::cout << "End procees in " << elapsed << " secs" << std::endl;
//
//
//	return EXIT_SUCCESS; 
//}