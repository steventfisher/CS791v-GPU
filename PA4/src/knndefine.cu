
#include "knndefine.h"
#include <iostream>

void fillMatrices(int *a, int *b, int N) {

	int rows, columns;

	for(rows=0; rows < N; rows++)		// load arrays with some numbers
	   for(columns=0; columns < N; columns++) {
		a[rows * N + columns] = 0;
		b[rows * N + columns] = 0;
	}
}

void printMatrix(int *h, int N) {

	std::cout << "Array, First 2 columns" << std::endl;

	for (int row = 0; row < 2; row += 1) {
	  for (int col = 0; col < N; col += 1) 
	 	std::cout << h[col + row * N] << "\t";
	  std::cout << std::endl;
	}
}