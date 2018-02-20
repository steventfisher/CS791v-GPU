/*
  This header demonstrates how we build cuda programs spanning
  multiple files. 
 */

#ifndef KNNCPU_H_
#define KNNCPU_H_


// This is the declaration of the function that will execute on the GPU.
__global__ void knncpu(int *, int *, int);

#endif // KNNCPU_H_
