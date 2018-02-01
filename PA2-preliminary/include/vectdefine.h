/*
  This header demonstrates how we build cuda programs spanning
  multiple files. 
 */

#ifndef VECTDEFINE_H_
#define VECTDEFINE_H_


// This is the declaration of the function that will execute on the GPU.
void fillvect(int *, int *, int);

#endif // VECTDEFINE_H_
