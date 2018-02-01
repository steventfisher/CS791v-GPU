/*
  This header demonstrates how we build cuda programs spanning
  multiple files. 
 */

#ifndef MATGPUADD_H_
#define MATGPUADD_H_


// This is the declaration of the function that will execute on the GPU.
__global__ void matgpuadd(int *, int *, int *, int);
__global__ void matgpuadd_stride(int *, int *, int *, int);

#endif // MATGPUADD_H_
