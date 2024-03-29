/*
  This header demonstrates how we build cuda programs spanning
  multiple files. 
 */

#ifndef MATDEFINE_H_
#define MATDEFINE_H_


// This is the declaration of the function that will execute on the GPU.
void fillMatrices(int *, int *, int);
void printMatrix(int *, int);

#endif // MATDEFINE_H_
