/*
  This header demonstrates how we build cuda programs spanning
  multiple files. 
 */

#ifndef MATGPUMULT_H_
#define MATGPUMULT_H_


// This is the declaration of the function that will execute on the GPU.
__global__ void matgpumult(int *, int *, int *, int);

#endif // MATGPUMULT_H_
