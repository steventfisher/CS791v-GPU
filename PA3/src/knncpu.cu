
#include "knncpu.h"
#include <math.h>
#include <iostream>
#include <algorithm>

void knncpu(float *a, float *b, int N) {

  int i, j, k, l, m;
  float tmpdst = 0;
  int q = 5;
  int count = 0;
  float tmp = 0;

  for(i = 0; i < N; ++i){
      for(j = 0; j < N; ++j){
          if(a[i*N + j] == -99999){
	      std::cout << "Found" << std::endl;
	      for(k = 0; k < N; ++k){
	          tmp = 0;
	          for(l = 2; l < N; ++l){
		      tmp += pow(a[k*N + l] - a[i*N + l],2);
		  }
		  b[k] = sqrt(tmp);
	      }
//	      std::cout << "tmp: " << tmp << std::endl;
	      std::sort(b, b + N);
	      tmpdst = 0;
	      for(m = 0; m < N; ++m){
	          if(b[m] != 0 && count < q){
	              tmpdst += b[m];
		      count += 1;
	          }
	      }
	      a[i*N + j] = tmpdst/q;
	  }
      }
  }

}
