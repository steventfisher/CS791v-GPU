
#include "vectdefine.h"
#include <iostream>

void fillvect(int *a, int *b, int N) {

	int rows, columns;

	srand(1);				// for repeatability
	for(rows=0; rows < N; rows++)		// load arrays with some numbers
	   for(columns=0; columns < N; columns++) {
		a[rows * N + columns] = rand() % 10;
		b[rows * N + columns] = rand() % 10;
	}
}