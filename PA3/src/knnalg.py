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
__global__ void knnGpu(float *A, float *B, long Size)
{
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;
    while(i < Size) {
        
    }
  
}
""")
    size = input("Please enter size of data(1-129): ")
    GGRID = input("Please enter the number of blocks: ")
    TILE = input("Please enter the number of threads: ")
    tmpdist = 0
    tmp = 0
    N = int(size)
    cpukarray = np.full(N, 0.)
    numChange = int(0.1*N)
    count = 0
    startgpu = driver.Event()
    endgpu = driver.Event()
    df = pd.read_csv('PA3_nrdc_data.csv', header=None, skiprows=9)
    df1 = df.loc[0:N, 0:N]
    #print(df1)
    array = driver.managed_empty(shape = N, dtype=np.float32, mem_flags=driver.mem_attach_flags.GLOBAL) 
    array = df1.reset_index().values
    karray = driver.managed_zeros(shape = N, dtype=np.float32, mem_flags=driver.mem_attach_flags.GLOBAL)
    karray = np.full(N, 0.)
    

    while count < numChange:
        randChange = random.randint(0, N)
        if array[randChange][2] != 'NaN':
            array[randChange][2] = 'NaN'
            count += 1
    print(array)

    print("Starting Sequential Calculation\n")
    cpustart = time.time()
    for i in range(0,N):
        tmpdst = 0
        tmp = 0
        cpukarray = np.full(N, 0.)
        if array[i][2] == 'NaN':
            for k in range(0,N):
                if k != i:
                    for j in range(3,N):
                        tmpdst +=  (array[i][j] - array[k][j])**2
                    cpukarray[k] = math.sqrt(tmpdst)
            cpukarray2 = np.trim_zeros(cpukarray)
            idk = np.argpartition(cpukarray, 5)
            print(cpukarray2)
            print(cpukarray2[idk[:5]])
            for k in cpukarray2[idk[:5]]:
                print(k)
                tmp += k
            array[i][2] = tmp/5.
    print(array)
    cpuend = time.time()
    cputotal = cpustart - cpuend
    startgpu.record()
    startgpu.synchronize()
    kernel = mod.get_function("knnGpu")
    kernel(array, karray, N, grid = (10, 10), block = (10,10,1))
    endgpu.record()
    endgpu.synchronize()
    gputotal = startgpu.time_till(endgpu)
