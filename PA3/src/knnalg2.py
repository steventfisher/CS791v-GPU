#! /usr/bin/env python3

import numpy as np
import pycuda.autoinit
from pycuda import driver, compiler, gpuarray, tools
import pandas as pd
import random
import time
import math


if __name__ == '__main__':
    mod = compiler.SourceModule("""
   #include <math.h>
    __global__ void knnGpu(float *A, float *B, int Size)
{
    int x = threadIdx.x + blockIdx.x * blockDim.x;
    int y = threadIdx.y + blockIdx.y*blockDim.y;
    __syncthreads();
    
    float tmpdist = 0;
    for(int i = 1; i < Size*Size; i += 1){
       B[i] = 2;
    }
    
  
}
""")
    size = input("Please enter size of data(1-129): ")
    while True:
        GGRID = input("Please enter the number of blocks: ")
        GGRID = int(GGRID)
       
        TILE = input("Please enter the number of threads: ")
        TILE = int(TILE)

        if GGRID*TILE > int(size):
            break
        print("Error: Number of threads is less than the number of elements")
    tmpdist = 0
    tmp = 0
    N = int(size)
    cpukarray = np.full(N, 0.)
    numChange = int(0.1*N)
    count = 0
    startgpu = driver.Event()
    endgpu = driver.Event()
    df = pd.read_csv('PA3_nrdc_data.csv', header=None, skiprows=9)
    df = df.drop(df.columns[0], axis=1)
    df1 = df.loc[0:N-1, 0:N-1]
    #print(df1)
    #array = driver.managed_empty(shape = N, dtype=np.float32, mem_flags=driver.mem_attach_flags.GLOBAL) 
    array = df1.reset_index().values
    
    #karray = driver.managed_zeros(shape = N, dtype=np.float32, mem_flags=driver.mem_attach_flags.GLOBAL)
    karray = np.full(N+1, 0.)
    gpukarray = driver.mem_alloc(karray.nbytes)
    driver.memcpy_htod(gpukarray, karray)
    
    gpusize = np.int32(N)

    while count < numChange:
        randChange = random.randint(0, N-1)
        if array[randChange][1] != -99999:
            array[randChange][1] = -99999
            count += 1
    print(array)
    gpuarray = driver.mem_alloc(array.nbytes)
    driver.memcpy_htod(gpuarray, array)
    print("Starting Sequential Calculation\n")
    cpustart = time.time()
    for i in range(0,N):
        tmpdst = 0
        tmp = 0
        cpukarray = np.full(N, 0.)
        if array[i][1] == -99999:
            for k in range(0,N):
                if k != i:
                    for j in range(2,N):
                        tmpdst +=  (array[i][j] - array[k][j])**2
                    cpukarray[k] = math.sqrt(tmpdst)
            cpukarray2 = np.trim_zeros(cpukarray)
            idk = np.argpartition(cpukarray, 5)
            for k in cpukarray2[idk[:5]]:
                tmp += k
            array[i][1] = tmp/5.
    print(array)
    cpuend = time.time()
    cputotal = cpuend - cpustart
    print("Starting GPU Calculation")
    startgpu.record()
    startgpu.synchronize()
    kernel = mod.get_function("knnGpu")
    kernel(gpuarray, gpukarray, gpusize, grid = (GGRID, 1), block = (TILE,1,1))
    endgpu.record()
    endgpu.synchronize()
    gputotal = startgpu.time_till(endgpu)
    gpukresult = np.empty_like(karray)
    driver.memcpy_dtoh(gpukresult, gpukarray)
    print(gpukresult)
    gpuresult = np.empty_like(array)
    driver.memcpy_dtoh(gpuresult, gpuarray)
    print(gpuresult)
    print(cputotal)
    print(gputotal)
    
