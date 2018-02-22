#include "knngpu.h"
#include <math.h>
#include <algorithm>

__global__ void knngpu(float *a, float *b, int N)
{
	
  int i, j, k, l;
  float tmpdst = 0;
  int q = 5;
  int count = 0;
  float tmp = 0;

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
                      if(b[l] > b[k]){
                          tmpdst = b[k];
                          b[k] = b[l];
                          b[l] = tmpdst;
                      }
                  }
              }
              tmpdst = 0;
              for(k = 0; k < N; ++k){
                  if(b[k] != 0 && count < q){
                      tmpdst += b[k];
		      count += 1;
                  } 
              }	      
              a[i*N + j] = tmpdst/q;

	  }
      }
      
  }
}
