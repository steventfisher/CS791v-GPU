
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

void readCsv(int *a, int numEntry) {
std::ifstream fin;
    std::string temp;

    std::cout << std::endl << std::endl << "Reading in CSV Data..." << std::endl;

    fin.open("../data/PA3_nrdc_datav2.csv");

    // read all the AS data from the file
    for(int i = 0; i < numEntry; i++)
    {
        fin >> a[i];
    }

    // close the file
    fin.close();

    std::cout << "Finished Reading in CSV Data" << std::endl << std::endl;
}

void printMatrix(int *h, int N) {

	std::cout << "Array, First 2 columns" << std::endl;

	for (int row = 0; row < 2; row += 1) {
	  for (int col = 0; col < N; col += 1) 
	 	std::cout << h[col + row * N] << "\t";
	  std::cout << std::endl;
	}
}