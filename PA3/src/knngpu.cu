
#include "knngpu.h"
#include <math.h>
#include <algorithm>

    __global__ void knngpu(float *a, float *b, int N)
{
	
  int i, j, k, l, m;
  float tmpdst = 0;
  //int q = 3;
  //int count = 0;
  float tmp = 0;

  for(i = threadIdx.x + blockDim.x*blockIdx.x; i < N; i += blockDim.x*gridDim.x){
      for(j = threadIdx.y + blockDim.x * blockIdx.y; j < N; j += blockDim.y*gridDim.y){
          if(a[i*N + j] == -99999){
	      for(k = 0; k < N; ++k){
	          for(j = 0; j < N; ++j){
                  b[k] += 1;
		  }
              }	      
	  }
      }
      
  }
}
