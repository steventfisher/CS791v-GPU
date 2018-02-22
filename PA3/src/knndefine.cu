
#include "knndefine.h"
#include <iostream>
#include <math.h>
#include <time.h>
#include <fstream>
#include <sstream>

void fillMatrices(float *b, int N) {

	int rows;

	for(rows = 0; rows < N; rows++){
	    b[rows] = 0;
	}
}

void randNan(float *a, int N){
    int count = 0;
    int countEnd = floor(N * 0.1);

    srand(time(NULL));

    if(countEnd == 0){
        countEnd = 1;
    }
    while (count < countEnd){
        srand(time(NULL));
        int randChange = rand() % N;
	if(a[randChange * N + 1] != -99999){
	    a[randChange * N + 1] = -99999;
	    count += 1;
	}
	    
    }
    
}

void copyMatrix(float *a, float *b, int N){
    for (int i = 0; i < N; ++i){
        for (int j = 0; j < N; ++j){
            b[i*N + j] = a[i*N + j];
        }
    }
}

void readCsv(float *a, int numEntry) {
    std::ifstream fin;
    std::string temp;

    std::cout << std::endl << std::endl << "Reading in CSV Data..." << std::endl;

    fin.open("../src/PA3_nrdc_datav2.csv");

    // read all the AS data from the file
    for(int row = 0; row < numEntry; ++row){
        std::string line;
        std::getline(fin, line);
	if (!fin.good())
	    break;

        std::stringstream iss(line);
	for(int col = 0; col < numEntry; ++col){
	    std::string val;
	    std::getline(iss, val, ',');
	    if(!iss.good())
	        break;
            std::stringstream convertor(val);
	    convertor >> a[row*numEntry + col];
	    if (col == 0){
	        a[row*numEntry + col] = row;
	    }
	}
    }
    

    // close the file
    fin.close();

    std::cout << "Finished Reading in CSV Data" << std::endl << std::endl;
}

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
