CUCOMP  = nvcc
CUFLAGS = -arch=sm_70 -Xcompiler -fopenmp

INCLUDES  = -I$(OMPI_DIR)/include
LIBRARIES = -L$(OMPI_DIR)/lib -L$(CUDA_DIR)/targets/ppc64le-linux/lib/stubs -lmpi_ibm -lnvidia-ml

jsrun_layout: jsrun_layout.o
	$(CUCOMP) $(CUFLAGS) $(LIBRARIES) jsrun_layout.o -o jsrun_layout

jsrun_layout.o: jsrun_layout.cu
	$(CUCOMP) $(CUFLAGS) $(INCLUDES) -c jsrun_layout.cu

.PHONY: clean

clean:
	rm -f jsrun_layout *.o
