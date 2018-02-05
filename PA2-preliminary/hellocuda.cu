/*
  In this program we will be using the GPU to add two square matrices. 

  This is the main program. You should also look at the header matgpuadd.h
  matcpuadd.h, and matdefine.h for the important declarations, and then look
  at matgpuadd.cu, matcpuadd.cu, and matdefine.cu to see how the methods were
  defined.

  AUTHOR: Steven Fisher
  CLASS: CS 791-GPU Computing
  ASSIGNMENT: PA1
 */

#include <iostream>
#include <math.h>

#include "vectgpumult.h"
#include "vectcpumult.h"
#include "vectdefine.h"


int main() {
/*---------------Define Variables-----------------*/
    int *a, *b, *c;

    int BLOCK_SIZE, GRID_SIZE;

/*--------------Copy to Shared Memory-------------*/

/*--------------Run Calculations on GPU-----------*/

/*--------------Run Calculations on CPU-----------*/

/*------------------Cleanup-----------------------*/


	return 0;
}
