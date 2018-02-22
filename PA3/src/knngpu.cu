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
  float c[N];

  for(i = threadIdx.x + blockDim.x*blockIdx.x; i < N; i += blockDim.x*gridDim.x){
      for(j = threadIdx.y + blockDim.x * blockIdx.y; j < N; j += blockDim.y*gridDim.y){
          if(a[i*N + j] == -99999){
	      for(k = 0; k < N; ++k){
                  tmp = 0;
                  if(k != i){
	              for(l = 2; l < N; ++l){
                          tmp += pow(a[k*N + l]-a[i*N + l],2);
		      }
                  }
                  b[k] = sqrt(tmp);
              }
	      for(k = 0; k < N; ++k){
                  for(l = 0; l < N; ++l){
                      if(b[j] > b[k]){
                      }
                  }
              }	      
	  }
      }
      
  }
}
