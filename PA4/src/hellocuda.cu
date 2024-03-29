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
	int Grid;
	int Block;
	int size;
	int *a;
	int *b;
	int *c;
};

struct MatAddStruct
{
	int deviceID;
	int Grid;
	int Block;
	int size;
	int *a;
	int *b;
	int *c;
};

void* routineM(void *pvoidData)
{
	MatMultStruct *data = (MatMultStruct*)pvoidData;
	cudaSetDevice(data->deviceID);
	matgpumult<<<data->Grid,data->Block>>>(data->a,data->b,data->c,data->size);
	cudaDeviceSynchronize();
	return 0;
}

void* routine(void *pvoidData)
{
	MatAddStruct *data = (MatAddStruct*)pvoidData;
	cudaSetDevice(data->deviceID);
	matgpuadd<<<data->Grid,data->Block>>>(data->a,data->b,data->c,data->size);
	cudaDeviceSynchronize();
	return 0;
}

int main() {
/*
This section is for the declaration of the variables that will be used
in our implementation of the matrix addition.
*/

	//char check;

	int Grid_Dim_x=32, Grid_Dim_y=32;		//Grid structure values
	int Block_Dim_x=32, Block_Dim_y=32;	//Block structure values

	//int numThreads_x;  			// number of threads available in device, each dimension
	//int numThreads_block;			// number of threads in a block

	int N = 100;  				// size of array in each dimension
	int numMat = 4;
	//int numMult = 1;
	int Size = 0;
	int *a,*b,*c,*d,*e,*f;
/*
This section specifies the size limitations and allows the user to
specify the size of the matrices, the number of blocks used and the
number of threads per block to use.
*/

	dim3 Grid(Grid_Dim_x, Grid_Dim_y);	//Grid structure
	dim3 Block(Block_Dim_x,Block_Dim_y);	//Number of threads per block.

/*
This section will dynamically allocate the memory needed
for the matrices in both the cpu and gpu calculations.
Here we will also be using fillMatrices from matdefine in
order to populate our two matrices.
*/
	Size = numMat * N * N * sizeof(int);
	//Allocating Memory for matrices
 	cudaMallocManaged( (void**) &a, numMat * N * N * sizeof(int));
	cudaMallocManaged( (void**) &b, numMat * N * N * sizeof(int));
	cudaMallocManaged( (void**) &c, N * N * sizeof(int));
	cudaMallocManaged( (void**) &d, N * N * sizeof(int));
	cudaMallocManaged( (void**) &e, numMat * N * N * sizeof(int));
	cudaMallocManaged( (void**) &f, numMat * N * N * sizeof(int));	
	
	//multiGPU
	int numGPU;
	HANDLE_ERROR(cudaGetDeviceCount(&numGPU));
	MatMultStruct * dataMult = new MatMultStruct[numGPU];
	MatAddStruct * dataAdd = new MatAddStruct[numGPU];
	//CUTThread * thread = new CUTThread[numGPU];
	std::cout << "There are " << numGPU << " GPU in this machine" << std::endl;
	
	for(int i = 0; i < numMat/2; ++i){
	    //for(int j = 0; j < numGPU; ++j){
    	        fillMatrices(a,b,Size);	// used to generate the arrays, found in matdefine.cu
		fillZero(c, Size);
		printMatrix(a,Size);
		dataMult[i].deviceID = 0;
		dataMult[i].size = N * N * sizeof(int);
		dataMult[i].a = a + i * (Size/numMat);
		dataMult[i].b = b + i * (Size/numMat);
		dataMult[i].c = c + i * (Size/numMat);
	    //}
	}

	/*CUTThread thread = start_thread( routineM, &(dataMult[0]));
	for(int i = 1; i < numMat/2; ++i){
	    routineM( &(dataMult[i]));
	}

	end_thread(thread);
	*/
	//printMatrix(dataMult.c[0], N);
	
	fillZero(d, N);
	

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

	return 0;
}

