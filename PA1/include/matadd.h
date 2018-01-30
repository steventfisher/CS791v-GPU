/*
  This header demonstrates how we build cuda programs spanning
  multiple files. 
 */

#ifndef MATADD_H_
#define MATADD_H_

// This is the number of elements we want to process.
#define N 512

// This is the declaration of the function that will execute on the GPU.
__global__ void matadd(int*, int*, int*);

#endif // MATADD_H_
