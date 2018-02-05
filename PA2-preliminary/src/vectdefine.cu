
#include "vectdefine.h"
#include <iostream>

void fillvect(int *a, int *b, int N) {

	int i;

	srand(1);			
	for(i=0; i < N; i++)		// load arrays with random numbers
	   a[i] = rand() % 10;
	   b[i] = rand() % 10;
}