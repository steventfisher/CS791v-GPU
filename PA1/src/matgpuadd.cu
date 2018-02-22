
#include "matgpuadd.h"

__global__ void matgpuadd(int *a, int *b, int *c, int N) {

  int columns = blockIdx.x * blockDim.x + threadIdx.x;
  int rows = blockIdx.y * blockDim.y + threadIdx.y;
  
  if(columns < N && rows < N) {
	c[rows * N + columns] =  a[rows * N + columns] + b[rows * N + columns];
  }
}

__global__ void matgpuadd_stride(int *a, int *b, int *c, int N) {

//  int columns = blockIdx.x * blockDim.x + threadIdx.x;
//  int rows = blockIdx.y * blockDim.y + threadIdx.y;
  
  for (int i = blockIdx.x * blockDim.x + threadIdx.x;
       i < N;
       i += blockDim.x * gridDim.x
       ){
	c[i] =  a[i] + b[i];
  }
}