/*
  In this program we will be using the GPU to add two square matrices. 

  This is the main program. You should also look at the header matgpuadd.h
  matcpuadd.h, and matdefine.h for the important declarations, and then look
  at matgpuadd.cu, matcpuadd.cu, and matdefine.cu to see how the methods were
  defined.

  AUTHOR: Steven Fisher
  CLASS: CS 791-GPU Computing
  ASSIGNMENT: PA1
 */

#include <iostream>

#include "matgpuadd.h"
#include "matcpuadd.h"
#include "matdefine.h"


int main() {
/*
This section is for the declaration of the variables that will be used
in our implementation of the matrix addition.
*/

	char check;

	int Grid_Dim_x=1, Grid_Dim_y=1;		//Grid structure values
	int Block_Dim_x=1, Block_Dim_y=1;	//Block structure values

	int numThreads_x;  			// number of threads available in device, each dimension
	int numThreads_block;			// number of threads in a block

	int N = 10;  				// size of array in each dimension
	int *a,*b,*c,*d, *e;
	int *dev_a, *dev_b, *dev_c, *dev_d;
	int size;					// number of elements in the matrices

	cudaEvent_t start, stop, start_stride, stop_stride, throughstart, throughstop, start_mem_cpy, stop_mem_cpy;     		// using cuda events to measure time
	float elapsed_time_gpu, elapsed_time_cpu, through_total, elapsed_mem, elapsed_stride;

/*
This section specifies the size limitations and allows the user to
specify the size of the matrices, the number of blocks used and the
number of threads per block to use.
*/

	std::cout << "Maximum number of threads per block = 1024" << std::endl;
	std::cout << "Maximum sizes of the x and y dimensions of the thread block = 1024" << std::endl;
	std::cout << "Maximum size of each dimension of grid of thread blocks = 65535" << std::endl;
do {	
	do {
	   std::cout << "Enter the value(size of matrix) for N (N <= 20000): ";
	   std::cin >> N;

	   if (N < 1) {
	      std::cout << "Error -- N has to be greater than 0!" << std::endl;
	   }
	   else if (N > 20000) {
 	      std::cout << "Error -- N has to be less than or equal to 1000!" << std::endl;
	   }
	} while ( N < 10 || N > 20000);
	
	do {//Using a do while loop, since we want it to run at least once.
		std::cout << "Enter number of blocks per grid that will be used in both the x and y dimensions: ";
		std::cin >> Grid_Dim_x;

		Grid_Dim_y = Grid_Dim_x;  // square grid

		std::cout << "Enter number of threads that will used per block in both the x and y dimensions, currently " << Block_Dim_x << " (Needs to be < 32): ";
		std::cin >> Block_Dim_x;

		Block_Dim_y = Block_Dim_x;	//square blocks

		numThreads_x = Grid_Dim_x * Block_Dim_x;		// total number of threads in x dimension
		
		numThreads_block = Block_Dim_x * Block_Dim_y;	// number of threads in a block

		if (numThreads_x < N) {
		   std::cout <<"Error -- number of threads in the x or y dimensions is less than thenumber of elements in matrix!" << std::endl;
		}
		else if (numThreads_block > 1024) {
		     std::cout << "Error -- there are too many threads in block!" << std::endl;
		}

	} while (numThreads_x < N || numThreads_block > 1024);

	dim3 Grid(Grid_Dim_x, Grid_Dim_y);	//Grid structure
	dim3 Block(Block_Dim_x,Block_Dim_y);	//Number of threads per block.

/*
This section will dynamically allocate the memory needed
for the matrices in both the cpu and gpu calculations.
Here we will also be using fillMatrices from matdefine in
order to populate our two matrices.
*/

	size = N * N * sizeof(int);		// number of bytes in total in arrays, this is needed in both malloc and cudaMalloc

	a = (int*) malloc(size);		// Dynamically allocates the memory for the matrices on the host
	b = (int*) malloc(size);
	c = (int*) malloc(size);		// this will hold the results from the GPU calculation
	d = (int*) malloc(size);		// this will hold the results from from the CPU calculation
	e = (int*) malloc(size);

	cudaMalloc((void**)&dev_a, size);	// allocate the memory for the matrices on the device
	cudaMalloc((void**)&dev_b, size);
	cudaMalloc((void**)&dev_c, size);
	cudaMalloc((void**)&dev_d, size);

	fillMatrices(a,b,N);			// used to generate the arrays, found in matdefine.cu
	
	std::cout << "Array A" << std::endl;
	printMatrix(a, N);			// used to display matrix A, used in order to verify what was in the matrix for debugging
	std::cout << "Array B" << std::endl;
	printMatrix(b, N);			// used to display matrix B, used in order to verify what was in the matrix for debugging

/*
In this section we will be performing the nececcary steps in
order to run our computaion on the GPU. The cudaEventCreate is
used to created the events for our timers. cudaMemcpy is used
to copy the matrix from the host to the device, which is then
used in the matgpuadd function, which used the entered results
from before, to specify the number of blocks and the number of
threads per block that will be used on the GPU
*/

  	cudaEventCreate(&start);     		// Creates the event for the start timer
	cudaEventCreate(&stop);			// Creates the event for the stop timer
	cudaEventCreate(&throughstart);		// Creates the event for the start timer for the throughput
	cudaEventCreate(&throughstop);		// Creates the event for the stop timer for the throughput
  	cudaEventCreate(&start_stride);     		// Creates the event for the start timer
	cudaEventCreate(&stop_stride);			// Creates the event for the stop timer
	cudaEventCreate(&start_mem_cpy);     		// Creates the event for the start timer
	cudaEventCreate(&stop_mem_cpy);			// Creates the event for the stop timer

	cudaEventRecord(start_mem_cpy, 0);
 	cudaMemcpy(dev_a, a , size ,cudaMemcpyHostToDevice); //copies the information for matrix a to dev_a on the device
	cudaMemcpy(dev_b, b , size ,cudaMemcpyHostToDevice);
	cudaEventRecord(stop_mem_cpy, 0);
	cudaEventSynchronize(stop_mem_cpy);
	cudaEventElapsedTime(&elapsed_mem, start_mem_cpy, stop_mem_cpy);

	cudaEventRecord(start, 0);
	cudaEventRecord(throughstart, 0); //records the start time for the throughput
	matgpuadd<<<Grid,Block>>>(dev_a,dev_b,dev_c,N);
	cudaDeviceSynchronize();
	cudaEventRecord(throughstop, 0);
	cudaEventSynchronize(throughstop); //records the stop time for the throughput
	cudaEventElapsedTime(&through_total, throughstart, throughstop);
	

	cudaMemcpy(c,dev_c, size ,cudaMemcpyDeviceToHost); //copies the results from the addition from the device to the host

	cudaEventRecord(stop, 0);     	// records the stop time
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsed_time_gpu, start, stop ); //stores the elapsed time for the gpu
	


	cudaEventRecord(start_stride, 0);
	matgpuadd_stride<<<Grid,Block>>>(dev_a,dev_b,dev_d,N);
	cudaDeviceSynchronize();
	cudaEventRecord(stop_stride, 0);
	cudaEventSynchronize(stop_stride);

	cudaMemcpy(e,dev_d, size ,cudaMemcpyDeviceToHost); //copies the results from the addition from the device to the host
	cudaEventElapsedTime(&elapsed_stride, start_stride, stop_stride);

	std::cout << "Time needed to calculate the results on the GPU: " << elapsed_time_gpu + elapsed_mem << " ms." << std::endl;  // print out elapsed time for gpu
	std::cout << "Throughput for gpu: " << N * N * through_total * 1000 << " calculations per second" << std::endl; // print out throughput for gpu.
	std::cout << "Time needed to calculate with striding: " << elapsed_stride + elapsed_mem << " ms." << std::endl;
	

/*
In this section we will be perofming the necessary steps
to run the sequential computations on the CPU
*/

	cudaEventRecord(start, 0);	// records the start time

	matcpuadd(a,b,d,N);		// do calculation on the cpu

	cudaEventRecord(stop, 0);     	// records the end time end time for cpu calculation
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&elapsed_time_cpu, start, stop ); //store the elaspsed time for the cpu

	printMatrix(c,N);
	printMatrix(d,N);
	printMatrix(e,N);

	std::cout << "Time needed to calculate the results on the CPU: " << elapsed_time_cpu << " ms." << std::endl;  // print out elapsed time for the cpu

        std::cout << std::endl; 
	std::cout << "Checking if the results from the cpu calculation = gpu  calculation" << std::endl;

	for(int i = 0;i < N*N;i++) {  // checking if the matrix from the gpu is the same as cpu
		if (c[i] != d[i] ) { 
			std::cout << "ERROR results are not equal" << std::endl;
			break;
		}
	}
	
	//prints out the speedup for the gpu as compared to cpu.
	std::cout << "Speedup on GPU as compared to CPU without Stride= " << ((float) elapsed_time_cpu / ((float) elapsed_time_gpu + (float) elapsed_mem)) << std::endl;
	std::cout << "Speedup on GPU as compared to CPU with Stride= " << ((float) elapsed_time_cpu / ((float) elapsed_stride + (float) elapsed_mem)) << std::endl;


/*
Performing methods to free allocated memory
*/
	free(a);
	free(b);
	free(c);
	free(d);
	free(e);
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
	cudaFree(dev_d);

	cudaEventDestroy(start);
	cudaEventDestroy(stop);
	cudaEventDestroy(throughstart);
	cudaEventDestroy(throughstop);
	cudaEventDestroy(start_stride);
	cudaEventDestroy(stop_stride);
	cudaEventDestroy(start_mem_cpy);
	cudaEventDestroy(stop_mem_cpy);	
	std::cout << "To continue type c, to end press ctrl-z" << std::endl;
	std::cin >> check;
} while(check == 'c');
	return 0;
}
