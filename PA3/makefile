# Point to includes of local directories
CC=/usr/local/cuda-9.0/bin/nvcc
INCLUDES=-I../include
O_FILES=hellocuda.o knndefine.o knngpu.o knncpu.o

all: $(O_FILES)
	$(CC) -o PA3 $(O_FILES)

hellocuda.o: ../src/hellocuda.cu
	$(CC) -c ../src/hellocuda.cu -o hellocuda.o $(INCLUDES)

knndefine.o: ../src/knndefine.cu
	$(CC) -c ../src/knndefine.cu -o knndefine.o $(INCLUDES)

knngpu.o: ../src/knngpu.cu
	$(CC) -c ../src/knngpu.cu -o knngpu.o $(INCLUDES)

knncpu.o: ../src/knncpu.cu
	$(CC) -c ../src/knncpu.cu -o knncpu.o $(INCLUDES)


clean:
	rm -f *.o
	rm -f *~
