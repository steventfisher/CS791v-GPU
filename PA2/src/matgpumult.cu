
#include "matgpumult.h"

__global__ void matgpumult(int *a, int *b, int *re, int N) {
    int k;
    int sum = 0;
    
    for(k = 0; k < N; k++) {
	sum +=  a[threadIdx.y * N + k] * b[k * N + threadIdx.x];
    }
    re[threadIdx.y * N + threadIdx.x] = sum;
}