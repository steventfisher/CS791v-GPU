
#include "knngp.h"
#include <math.h>

    __global__ void knnGpu(float *A, float *B, int Size)
{
    int x = threadIdx.x + blockIdx.x * blockDim.x;
    int y = threadIdx.y + blockIdx.y*blockDim.y;
    __syncthreads();
    
    float tmpdist = 0;
    for(int i = 1; i < Size*Size; i += 1){
       B[i] = 2;
    }
    
  
}