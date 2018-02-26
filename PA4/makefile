# Point to includes of local directories
CC=/usr/local/cuda-9.0/bin/nvcc
INCLUDES=-I../include
O_FILES=hellocuda.o matdefine.o matgpumult.o matcpumult.o matgpuadd.o matgpuadd.o

all: $(O_FILES)
	$(CC) -o PA4 $(O_FILES)

hellocuda.o: ../src/hellocuda.cu
	$(CC) -c ../src/hellocuda.cu -o hellocuda.o $(INCLUDES)

matdefine.o: ../src/matdefine.cu
	$(CC) -c ../src/matdefine.cu -o matdefine.o $(INCLUDES)

matgpumult.o: ../src/matgpumult.cu
	$(CC) -c ../src/matgpumult.cu -o matgpumult.o $(INCLUDES)

matcpumult.o: ../src/matcpumult.cu
	$(CC) -c ../src/matcpumult.cu -o matcpumult.o $(INCLUDES)

matgpuadd.o: ../src/matgpuadd.cu
	$(CC) -c ../src/matgpuadd.cu -o matgpuadd.o $(INCLUDES)

matcpuadd.o: ../src/matcpuadd.cu
	$(CC) -c ../src/matcpuadd.cu -o matcpuadd.o $(INCLUDES)

clean:
	rm -f *.o
	rm -f *~
