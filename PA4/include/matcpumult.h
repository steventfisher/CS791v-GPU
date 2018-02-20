/*
  This header demonstrates how we build cuda programs spanning
  multiple files. 
 */

#ifndef MATCPUMULT_H_
#define MATCPUMULT_H_


// This is the declaration of the function that will execute on the CPU.
void matcpumult(int *, int *, int *, int);

#endif // MATCPUMULT_H_
