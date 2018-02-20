/*
  This header demonstrates how we build cuda programs spanning
  multiple files. 
 */

#ifndef KNNGPU_H_
#define KNNGPU_H_


// This is the declaration of the function that will execute on the GPU.
__global__ void knngpu(int *, int *, int);

#endif // KNNGPU_H_
