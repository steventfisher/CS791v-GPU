/*
  This program demonstrates the basics of working with cuda. We use
  the GPU to add two arrays. We also introduce cuda's approach to
  error handling and timing using cuda Events.

  This is the main program. You should also look at the header add.h
  for the important declarations, and then look at add.cu to see how
  to define functions that execute on the GPU.
 */

#include <iostream>

#include "add.h"

int main() {
  
  // Arrays on the host (CPU)
  int *a, *b, *c;
  
  cudaMallocManaged( (void**) &a, N * sizeof(int));
  cudaMallocManaged( (void**) &b, N * sizeof(int));
  cudaMallocManaged( (void**) &c, N * sizeof(int));

  // These lines just fill the host arrays with some data so we can do
  // something interesting. Well, so we can add two arrays.
  for (int i = 0; i < N; ++i) {
    a[i] = i;
    b[i] = i;
  }

  /*
    FINALLY we get to run some code on the GPU. At this point, if you
    haven't looked at add.cu (in this folder), you should. The
    comments in that file explain what the add function does, so here
    let's focus on how add is being called. The first thing to notice
    is the <<<...>>>, which you should recognize as _not_ being
    standard C. This syntactic extension tells nvidia's cuda compiler
    how to parallelize the execution of the function. We'll get into
    details as the course progresses, but for we'll say that <<<N,
    1>>> is creating N _blocks_ of 1 _thread_ each. Each of these
    threads is executing add with a different data element (details of
    the indexing are in add.cu). 

    In larger programs, you will typically have many more blocks, and
    each block will have many threads. Each thread will handle a
    different piece of data, and many threads can execute at the same
    time. This is how cuda can get such large speedups.
   */
  add<<<N, 1>>>(a, b, c);
  cudaDeviceSynchronize();

  /*
    Let's check that the results are what we expect.
   */
  for (int i = 0; i < N; ++i) {
    if (c[i] != a[i] + b[i]) {
      std::cerr << "Oh no! Something went wrong. You should check your cuda install and your GPU. :(" << std::endl;

      // clean up device pointers - just like free in C. We don't have
      // to check error codes for this one.
      cudaFree(a);
      cudaFree(b);
      cudaFree(c);
      exit(1);
    }
  }

  /*
    Let's let the user know that everything is ok and then display
    some information about the times we recorded above.
   */
  std::cout << "Yay! Your program's results are correct." << std::endl;
  
  // Cleanup in the event of success.
  cudaFree(a);
  cudaFree(b);
  cudaFree(c);

}
