
#include "matgpuadd.h"

__global__ void matgpuadd(int *a, int *b, int *c, int N) {

  int columns = blockIdx.x * blockDim.x + threadIdx.x;
  int rows = blockIdx.y * blockDim.y + threadIdx.y;

  if(columns < N && rows < N) {
	c[rows * N + columns] =  a[rows * N + columns] + b[rows * N + columns];
  }
}
