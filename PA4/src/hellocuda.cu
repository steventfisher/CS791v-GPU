/*
  In this program we will be using the GPU to add the product of matrices. 

  This is the main program. You should also look at the header matgpumult.h
  matcpumult.h, and matdefine.h for the important declarations, and then look
  at matgpumult.cu, matcpumult.cu, and matdefine.cu to see how the methods were
  defined.

  AUTHOR: Steven Fisher
  CLASS: CS 791-GPU Computing
  ASSIGNMENT: PA4
 */

#include <iostream>

#include "matgpumult.h"
#include "matcpumult.h"
#include "matcpuadd.h"
#include "matgpuadd.h"
#include "matdefine.h"
#include "book.h"

struct MatMultStruct
{
	int deviceID;
	int size;
	int *a;
	int *b;
	int *c;
};

struct MatAddStruct
{
	int deviceID;
	int size;
	int *a;
	int *b;
	int *c;
};

void* routineM(void *pvoidData)
{
	MatMultStruct *data = (MatMultStruct*)pvoidData;
	cudaSetDevice(data->deviceID);
	matgpumult<<<Grid,Block>>>(a,b,c,N);
	cudaDeviceSynchronize();
	return 0;
}
void* routine(void *pvoidData)
{
	MatAddStruct *data = (MatAddStruct*)pvoidData;
	cudaSetDevice(data->deviceID);
	matgpuadd<<<Grid,Block>>>(a,b,c,N);
	cudaDeviceSynchronize();
	return 0;
}

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
	int numMat = 1;
	int *a,*b,*c,*d,*e,*f;
/*
This section specifies the size limitations and allows the user to
specify the size of the matrices, the number of blocks used and the
number of threads per block to use.
*/
do{
	do {
	   std::cout << "Enter the value(size of matrix) for N (N <= 20000): ";
	   std::cin >> N;

	   if (N < 10) {
	      std::cout << "Error -- N has to be greater than 10!" << std::endl;
	   }
	   else if (N > 20000) {
 	      std::cout << "Error -- N has to be less than or equal to 20000!" << std::endl;
	   }
	} while ( N < 10 || N > 20000);

	do {
	   std::cout << "Enter the number of matrices to use (multiple of 2): ";
	   std::cin >> numMat;
	   if (numMat %2 != 0){
	      std::cout << "The number of matrices needs to be an even number." << std::endl;
	   }
	} while (numMat %2 != 0);
	
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
	//Allocating Memory for matrices
 	cudaMallocManaged( (void**) &a, numMult * N * N * sizeof(int));
	cudaMallocManaged( (void**) &b, numMult * N * N * sizeof(int));
	cudaMallocManaged( (void**) &c, numMult * N * N * sizeof(int));
	cudaMallocManaged( (void**) &d, numMult * N * N * sizeof(int));
	cudaMallocManaged( (void**) &e, numMult * N * N * sizeof(int));
	cudaMallocManaged( (void**) &f, numMult * N * N * sizeof(int));	
	
	//multiGPU
	int numGPU;
	HANDLE_ERROR(cudaGetDeviceCount(&numGPU));
	MatMultStruct * dataMult = new MatMultStruct[numGPU];
	MatAddStruct * dataAdd = new MatAddStruct[numGPU];
	//CUTThread * thread = new CUTThread[numGPU];
	std::cout << "There are " << numGPU << " GPU in this machine" << std::endl;
	
	for(int i = 0; i < numMat/2; ++i){
	    for(int j = 0; j < numGPU; ++j){
    	        fillMatrices(a,b,N);	// used to generate the arrays, found in matdefine.cu
		fillZero(c, N);
		dataMult[i].deviceID = j;
		dataMult[i].size = N * N * size(int);
		dataMult[i].a = a + i * (N/numMult);
		dataMult[i].b = b + i * (N/numMult);
		dataMult[i].c = c + i * (N/numMult);
	    }
	}

	CUTThread thread = start_thread( routineM, &(dataMult[0]));
	for(int i = 1; i < numMat/2; ++i){
	    routine( &(dataMult[i]));
	}

	end_thread(thread);
	
	//fillMatrices(d,e,N);
	

/*
In this section we will be performing the nececcary steps in
order to run our computaion on the GPU. The cudaEventCreate is
used to created the events for our timers. cudaMemcpy is used
to copy the matrix from the host to the device, which is then
used in the matgpuadd function, which used the entered results
from before, to specify the number of blocks and the number of
threads per block that will be used on the GPU
*/

	//matgpumult<<<Grid,Block>>>(a,b,c,N);
	//cudaDeviceSynchronize();
        //std::cout << "Array C from GPU" << std::endl;
	//printMatrix(c, N);

/*
In this section we will be perofming the necessary steps
to run the sequential computations on the CPU
*/

	//matcpumult(a,b,d,N);		// do calculation on the cpu
        //std::cout << "Array D from CPU" << std::endl;
	//printMatrix(d, N);	

        //std::cout << std::endl; 
	//std::cout << "Checking if the results from the cpu calculation = gpu  calculation" << std::endl;

	//for(int i = 0;i < N*N;i++) {  // checking if the matrix from the gpu is the same as cpu
	//	if (c[i] != d[i] ) { 
	//		std::cout << "ERROR results are not equal" << std::endl;
	//		break;
	//	}
	//}
	//std::cout << "Matrices are equal" << std::endl;
	
/*
Performing methods to free allocated memory
*/
	cudaFree(a);
	cudaFree(b);
	cudaFree(c);
	cudaFree(d);
	cudaFree(e);
	cudaFree(f);

	std::cout << "To continue type c, to end press q" << std::endl;
	std::cin >> check;
} while(check == 'c');
	return 0;
}

