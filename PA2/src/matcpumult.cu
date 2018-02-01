
#include "matcpuadd.h"

void matcpuadd(int *a, int *b, int *c, int N) {

  int rows, columns;

  for(rows=0; rows < N; rows++)  { // row of a
	  for(columns=0; columns < N; columns++) { // column of b
          	c[rows * N + columns]= a[rows * N + columns] + b[rows * N + columns];
	  }
  }
}
