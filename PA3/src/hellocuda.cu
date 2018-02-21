/*
  In this program we will be using the GPU to add two square matrices. 

  This is the main program. You should also look at the header matgpuadd.h
  matcpuadd.h, and matdefine.h for the important declarations, and then look
  at matgpuadd.cu, matcpuadd.cu, and matdefine.cu to see how the methods were
  defined.

  AUTHOR: Steven Fisher
  CLASS: CS 791-GPU Computing
  ASSIGNMENT: PA3
 */

#include <iostream>

#include "knngpu.h"
#include "knncpu.h"
#include "knndefine.h"


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

	int N = 8;  				// size of array in each dimension
	char *a;
	//int *b,*c,*d;
/*
This section specifies the size limitations and allows the user to
specify the size of the matrices, the number of blocks used and the
number of threads per block to use.
*/
do{
	std::cout << "Maximum number of threads per block = 1024" << std::endl;
	std::cout << "Maximum sizes of the x and y dimensions of the thread block = 1024" << std::endl;
	std::cout << "Maximum size of each dimension of grid of thread blocks = 65535" << std::endl;

	do {
	   std::cout << "Enter the value(size of matrix) for N (5-129): ";
	   std::cin >> N;

	   if (N < 5) {
	      std::cout << "Error -- N has to be greater than 5!" << std::endl;
	   }
	   else if (N > 129) {
 	      std::cout << "Error -- N has to be less than or equal to 129!" << std::endl;
	   }
	} while ( N < 5 || N > 129);
	
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
	
	a = (char *) malloc(N*N);
	readCsv(*a, N);

	dim3 Grid(Grid_Dim_x, Grid_Dim_y);	//Grid structure
	dim3 Block(Block_Dim_x,Block_Dim_y);	//Number of threads per block.

/*
This section will dynamically allocate the memory needed
for the matrices in both the cpu and gpu calculations.
Here we will also be using fillMatrices from matdefine in
order to populate our two matrices.
*/

/*	cudaMallocManaged( (void**) &a, N * N * sizeof(int));
	cudaMallocManaged( (void**) &b, N * N * sizeof(int));
	cudaMallocManaged( (void**) &c, N * N * sizeof(int));
	//d = (int*) malloc(N * N * sizeof(int));
	
	fillMatrices(c,b,N);			// used to generate the arrays
	
	std::cout << "Array A" << std::endl;
	printMatrix(a, N);			// used to display matrix A, used in order to verify what was in the matrix for debugging
	std::cout << "Array B" << std::endl;
	printMatrix(b, N);			// used to display matrix B, used in order to verify what was in the matrix for debugging
*/
/*
In this section we will be performing the nececcary steps in
order to run our computaion on the GPU. The cudaEventCreate is
used to created the events for our timers. cudaMemcpy is used
to copy the matrix from the host to the device, which is then
used in the matgpuadd function, which used the entered results
from before, to specify the number of blocks and the number of
threads per block that will be used on the GPU
*/

/*	matgpumult<<<Grid,Block>>>(a,b,c,N);
	cudaDeviceSynchronize();
        std::cout << "Array C" << std::endl;
	printMatrix(c, N);
/*
/*
In this section we will be perofming the necessary steps
to run the sequential computations on the CPU
*/

/*	matcpumult(a,b,d,N);		// do calculation on the cpu
        std::cout << "Array D" << std::endl;
	printMatrix(d, N);	

        std::cout << std::endl; 
	std::cout << "Checking if the results from the cpu calculation = gpu  calculation" << std::endl;

	for(int i = 0;i < N*N;i++) {  // checking if the matrix from the gpu is the same as cpu
		if (c[i] != d[i] ) { 
			std::cout << "ERROR results are not equal" << std::endl;
			break;
		}
	}
*/	
/*
Performing methods to free allocated memory
*/
/*	cudaFree(a);
	cudaFree(b);
	cudaFree(c);
	cudaFree(d);
*/
	free(a);
	std::cout << "To continue type c, to end press q" << std::endl;
	std::cin >> check;
} while(check == 'c');
	return 0;
}
