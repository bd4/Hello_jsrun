CUCOMP  = nvcc
CUFLAGS = -arch=sm_70

INCLUDES  = -I$(OMPI_DIR)/include
LIBRARIES = -L$(OMPI_DIR)/lib -L$(CUDA_DIR)/targets/ppc64le-linux/lib/stubs -lmpi_ibm -lnvidia-ml

run: mpi_test.o
	$(CUCOMP) $(CUFLAGS) $(LIBRARIES) mpi_test.o -o run

mpi_test.o: mpi_test.cu
	$(CUCOMP) $(CUFLAGS) $(INCLUDES) -c mpi_test.cu

.PHONY: clean

clean:
	rm -f run *.o
