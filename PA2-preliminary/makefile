# Point to includes of local directories
CC=/usr/local/cuda-9.0/bin/nvcc
INCLUDES=-I../include
#O_FILES=hellocuda.o matmult.o
O_FILES=hellocuda.o vectdefine.o vectgpumult.o vectcpumult.o

all: $(O_FILES)
	$(CC) -o PA1 $(O_FILES)

hellocuda.o: ../src/hellocuda.cu
	$(CC) -c ../src/hellocuda.cu -o hellocuda.o $(INCLUDES)

vectdefine.o: ../src/vectdefine.cu
	$(CC) -c ../src/vectdefine.cu -o vectdefine.o $(INCLUDES)

vectgpumult.o: ../src/vectgpumult.cu
	$(CC) -c ../src/vectgpumult.cu -o vectgpumult.o $(INCLUDES)

vectcpuvect.o: ../src/vectcpuvect.cu
	$(CC) -c ../src/vectcpuvect.cu -o vectcpuvect.o $(INCLUDES)


clean:
	rm -f *.o
	rm -f *~
