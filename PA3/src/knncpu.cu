
#include "knncpu.h"

void knncpu(int *a, int *b, int N) {

  int i, j, k;
  int tmpdst = 0;
  int tmp = 0;

  for(i = 0; i < N; i++)  { // row of a
	  for(j = 0; j < N; j++) { // column of b
	      sum = 0;
	      for(k = 0; k < N; k++){
	          sum += a[i * N + k] * b[k * N + j];
	      }
	      d[i * N + j] = sum;
	  }
  }
}
