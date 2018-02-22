/*
  This header demonstrates how we build cuda programs spanning
  multiple files. 
 */

#ifndef KNNDEFINE_H_
#define KNNDEFINE_H_


// This is the declaration of the function that will execute on the GPU.
//void readcsv(int *, int *, int);
void fillMatrices(float *, float *, int);
void readCsv(char *, int);
void printMatrix(float *, int);
void printVector(float *, int);
#endif // KNNDEFINE_H_
