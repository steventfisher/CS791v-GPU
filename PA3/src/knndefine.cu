
#include "knndefine.h"
#include <iostream>
#include <math.h>
#include <time.h>

void fillMatrices(float *a, float *b, int N) {

	int rows, columns;
	int count = 0;
	int countEnd = floor(N * 0.1);

	srand(time(NULL));
	
	for(rows=0; rows < N; rows++)		// load arrays with some numbers
	   for(columns=0; columns < N; columns++) {
		a[rows * N + columns] = rand() %10;
	}

	for(rows = 0; rows < N; rows++){
	    b[rows] = 0;
	}
	if(countEnd == 0){
	    countEnd = 1;
	}
	std::cout << "CountEnd: " << countEnd << std::endl;
	while (count < countEnd){
	    srand(time(NULL));
            int randChange = rand() % N;
	    if(a[randChange * N + 1] != -99999){
	        std::cout << "randChange: " << randChange << std::endl;
	        a[randChange * N + 1] = -99999;
		count += 1;
	    }
	    
	}
}


/*void readCsv(float *a, int numEntry) {
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
}*/

void printMatrix(float *h, int N) {

	std::cout << "Array, First 2 columns" << std::endl;

	for (int row = 0; row < N; row += 1) {
	  for (int col = 0; col < N; col += 1) 
	 	std::cout << h[col + row * N] << "\t";
	  std::cout << std::endl;
	}
}

void printVector(float *h, int N){
	for (int row = 0; row < N; row++) {
	 	std::cout << h[row] << "\t";
	}
	std::cout << std::endl;

}