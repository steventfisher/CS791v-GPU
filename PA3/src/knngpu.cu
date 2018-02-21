
#include "knngpu.h"
#include <math.h>

    __global__ void knnGpu(float *A, float *B, int Size)
{
    //int x = threadIdx.x + blockIdx.x * blockDim.x;
    //int y = threadIdx.y + blockIdx.y*blockDim.y;
    __syncthreads();
    
    float tmpdist = 0;
    for (int i = blockIdx.x*blockDim.x + threadIdx.x; i < Size*Size; i+= blockDim.x*gridDim.x){
       tmpdist = 0.0;
       if (A[i] == -99999) {
           for (int k = 0; k < Size; ++k) {
               if(k != i){
                 for (int j = 0; j < Size; ++j) {
                     tmpdist += 2;
                 }
               }
               __syncthreads();
               //B[k] = sqrt((float) tmpdist);
               B[k] = tmpdist;
            }            
       }
    }
    
  
}