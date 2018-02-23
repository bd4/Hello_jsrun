This is a simple "Hello World" type program that can be used to test the layout of resources on a Summit/SummitDev node.

You might want to put a `sort` on the end of your jsrun command to make the output easier to read. For example

$ `jsrun -n6 -a1 -c7 -g1 ./run | sort`  
MPI Rank 000 of 006 on HWThread 000 of Node a16n07 - GPU 0 of 1 gpu_id: 0  
MPI Rank 001 of 006 on HWThread 028 of Node a16n07 - GPU 0 of 1 gpu_id: 1  
MPI Rank 002 of 006 on HWThread 056 of Node a16n07 - GPU 0 of 1 gpu_id: 2  
MPI Rank 003 of 006 on HWThread 088 of Node a16n07 - GPU 0 of 1 gpu_id: 3  
MPI Rank 004 of 006 on HWThread 116 of Node a16n07 - GPU 0 of 1 gpu_id: 4  
MPI Rank 005 of 006 on HWThread 144 of Node a16n07 - GPU 0 of 1 gpu_id: 5  
  
If you pass `verbose` as a command line argument, you can see the DomainID and BusID of each GPU as well:  
  
$ `jsrun -n6 -a1 -c7 -g1 ./run verbose | sort`  
  
NOTE: During testing you might try something like `jsrun -n1 -a3 -g1 ./run`, which will allow multiple MPI ranks to access the same GPU. Currently, in order for this to work, you will need to enable MPS with the flag   
`-alloc_flags gpumps`.  
