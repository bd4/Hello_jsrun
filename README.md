This is a simple "Hello World" type program that can be used to test the layout of resources on (*only*) a Summit node using `jsrun`.

**Compiling**
After cloning this repo, load the cuda module (`module load cuda`) and then `make`.

**Running**
After compiling, you can grab an interactive job (1 or more nodes) with the following command (edited to reflect your own project, of course):
`$ bsub -P PROJID -nnodes 1 -W 60 -alloc_flags gpumps -Is $SHELL`

**NOTE:**  
* The `-alloc_flags gpumps` flag enables MPS (see ADDITIONAL NOTES below).  
* Make sure to set OMP_NUM_THREADS (the example below used `export OMP_NUM_THREADS=2`)

Now you can test different layouts using `jsrun`. Also, you might want to pipe your results to `sort` to make the output easier to parse. For example

$ `jsrun -n6 -a1 -c7 -g1 -bpacked:2 ./jsrun_layout | sort`

\*\*\* MPI Ranks: 6, OpenMP Threads: 2, GPUs per Resource Set: 1 \*\*\*  

MPI Rank 000, OMP_thread 00 on HWThread 000 of Node a09n13 - RT_GPU_id 0 : GPU_id 0  
MPI Rank 000, OMP_thread 01 on HWThread 004 of Node a09n13 - RT_GPU_id 0 : GPU_id 0   
MPI Rank 001, OMP_thread 00 on HWThread 028 of Node a09n13 - RT_GPU_id 0 : GPU_id 1  
MPI Rank 001, OMP_thread 01 on HWThread 032 of Node a09n13 - RT_GPU_id 0 : GPU_id 1  
MPI Rank 002, OMP_thread 00 on HWThread 056 of Node a09n13 - RT_GPU_id 0 : GPU_id 2  
MPI Rank 002, OMP_thread 01 on HWThread 060 of Node a09n13 - RT_GPU_id 0 : GPU_id 2  
MPI Rank 003, OMP_thread 00 on HWThread 088 of Node a09n13 - RT_GPU_id 0 : GPU_id 3  
MPI Rank 003, OMP_thread 01 on HWThread 092 of Node a09n13 - RT_GPU_id 0 : GPU_id 3  
MPI Rank 004, OMP_thread 00 on HWThread 116 of Node a09n13 - RT_GPU_id 0 : GPU_id 4  
MPI Rank 004, OMP_thread 01 on HWThread 120 of Node a09n13 - RT_GPU_id 0 : GPU_id 4  
MPI Rank 005, OMP_thread 00 on HWThread 144 of Node a09n13 - RT_GPU_id 0 : GPU_id 5  
MPI Rank 005, OMP_thread 01 on HWThread 148 of Node a09n13 - RT_GPU_id 0 : GPU_id 5 
  
If you pass `verbose` as a command line argument to the executable, you can see the DomainID, BusID, and UUID of each GPU as well:  
  
$ `jsrun -n6 -a1 -c7 -g1 -bpacked:2 ./jsrun_layout verbose | sort`
  
**ADDITIONAL NOTES:**  

* During testing you might try something like `jsrun -n1 -a3 -g1 ./jsrun_layout`, which will cause multiple MPI ranks to access the same GPU. Because the compute mode of the GPUs on Summit are set to EXCLUSIVE_PROCESS by default, this will cause errors. Therefore, you should either enable MPS with the `-alloc_flags gpumps` flag or set the compute mode to DEFAULT using the `-alloc_flags gpudefault` flag. For more information about the GPU compute modes and MPS, please see https://docs.nvidia.com/deploy/pdf/CUDA_Multi_Process_Service_Overview.pdf.

* The RT_GPU_id in the output refers to the runtime device id, whereas the GPU_id refers to the device id that would be reported by CUDA_VISIBLE_DEVICES (which is currently not available with jsrun).

* This code uses hard-coded values of the Bus IDs to map GPUs, so it will only work on Summit. You would need to modify the Bus IDs for other systems.

* Only the first 10 characters of the UUID are printed.
