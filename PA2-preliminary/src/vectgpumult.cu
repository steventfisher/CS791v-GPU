
#include "vectgpumult.h"

__global__ void vectgpumult(int *a, int *b, int *c, int N) {

  __shared__ float cache[threadsPerBlock];
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  int cacheIndex = threadIdx.x;
  float temp = 0;
  
  while (tid < N) {
      temp += a[tid] * b[tid]
      tid += stride;
  }

  cache[cacheIndex] = temp;
}