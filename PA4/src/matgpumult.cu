
#include "matgpumult.h"

__global__ void matgpumult(int *a, int *b, int *c, int N) {
    int col = blockIdx.x*blockDim.x + threadIdx.x;
    int row = blockIdx.y*blockDim.y + threadIdx.y;
    __syncthreads();

    //int sum = 0;
    if(col < N && row < N)
    {
	int sum = 0;
        for(int k = 0; k < N; ++k) {
	    sum +=  (a[row * N + k] * b[k * N + col]);
        }
        c[row * N + col] = sum;
	__syncthreads();

    }
}