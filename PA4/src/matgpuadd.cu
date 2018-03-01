
#include "matgpuadd.h"

__global__ void matgpuadd(int *a, int *b, int *c, int N) {

//  int columns = blockIdx.x * blockDim.x + threadIdx.x;
//  int rows = blockIdx.y * blockDim.y + threadIdx.y;
  
  for (int i = blockIdx.x * blockDim.x + threadIdx.x;
       i < N;
       i += blockDim.x * gridDim.x
       ){
       for(int j = blockIdx.y*blockDim.y + threadIdx.y;
       j < N;
       j += blockDim.y * gridDim.y
       ){
	c[i*N + j] =  a[i*N + j] + b[i*N + j];
      }
  }
}