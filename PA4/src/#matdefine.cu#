
#include "matdefine.h"
#include <iostream>

void fillMatrices(int *a, int *b, int N) {

	int rows, columns;

	srand(1);				// for repeatability
	for(rows=0; rows < N; rows++)		// load arrays with some numbers
	   for(columns=0; columns < N; columns++) {
		a[rows * N + columns] = rand() % 10;
		b[rows * N + columns] = rand() % 10;
	}
}

void fillZero(int *a, int N) {

	int rows, columns;

	for(rows=0; rows < N; rows++)		// load arrays with some numbers
	   for(columns=0; columns < N; columns++) {
		a[rows * N + columns] = 0;
	}
}

void printMatrix(int *h, int N) {

	std::cout << "Array, every N/8 numbers, eight numbers, N => 8" << std::endl;

	for (int row = 0; row < N; row += N/8) {
	  for (int col = 0; col < N; col += N/8) 
	 	std::cout << h[col + row * N] << "\t";
	  std::cout << std::endl;
	}
}