
#include "matcpumult.h"

void matcpumult(int *a, int *b, int *d, int N) {

  int i, j, k;
  int sum;

  for(i = 0; i < N; ++i)  { // row of a
	  for(j = 0; j < N; ++j) { // column of b
	      sum = 0;
	      for(k = 0; k < N; ++k){
	          sum += a[i * N + k] + b[k * N + j];
	      }
	      d[i * N + j] = sum;
	  }
  }
}
