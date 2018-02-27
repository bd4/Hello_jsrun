This is a simple "Hello World" type program that can be used to test the layout of resources on a Summit/SummitDev node.

You can grab 1 or more interactive nodes with the following command (edited to reflect your own project, of course):

`$ bsub -P PROJID -nnodes 1 -W 60 -alloc_flags gpumps -Is $SHELL`

**NOTE:** The `-alloc_flags gpumps` flag enables MPS (see ADDITIONAL NOTES below). 

After compiling with `make`, you can test different layouts. Also, you might want to pipe your results to `sort` to make the output easier to parse. For example

$ `jsrun -n6 -a1 -c7 -g1 ./jsrun_layout | sort`  
MPI Rank 000 of 006 on HWThread 000 of Node a16n07 - GPU 0 of 1 gpu_id: 0  
MPI Rank 001 of 006 on HWThread 028 of Node a16n07 - GPU 0 of 1 gpu_id: 1  
MPI Rank 002 of 006 on HWThread 056 of Node a16n07 - GPU 0 of 1 gpu_id: 2  
MPI Rank 003 of 006 on HWThread 088 of Node a16n07 - GPU 0 of 1 gpu_id: 3  
MPI Rank 004 of 006 on HWThread 116 of Node a16n07 - GPU 0 of 1 gpu_id: 4  
MPI Rank 005 of 006 on HWThread 144 of Node a16n07 - GPU 0 of 1 gpu_id: 5  
  
If you pass `verbose` as a command line argument to the executable, you can see the DomainID and BusID of each GPU as well:  
  
$ `jsrun -n6 -a1 -c7 -g1 ./jsrun_layout verbose | sort`  
  
**ADDITIONAL NOTES:**  

* Make sure to load the cuda module.

* During testing you might try something like `jsrun -n1 -a3 -g1 ./jsrun_layout`, which will cause multiple MPI ranks to access the same GPU. Because the compute mode of the GPUs on Summit are set to EXCLUSIVE_PROCESS by default, this will cause errors. Therefore, you should either enable MPS with the `-alloc_flags gpumps` flag or set the compute mode to DEFAULT using the `-alloc_flags gpudefault` flag. For more information about the GPU compute modes and MPS, please see https://docs.nvidia.com/deploy/pdf/CUDA_Multi_Process_Service_Overview.pdf.
