This is a simple "Hello World" type program that can be used to test the layout of resources on a Summit/SummitDev node.

You might want to put a `sort` on the end of your jsrun command to make the output easier to read. For example

$ jsrun -n6 -a1 -c7 -g1 ./run | sort
MPI Rank 000 of 006 on HWThread 000 of Node a16n07 - GPU 0 of 1 gpu_id: 0
MPI Rank 001 of 006 on HWThread 028 of Node a16n07 - GPU 0 of 1 gpu_id: 1
MPI Rank 002 of 006 on HWThread 056 of Node a16n07 - GPU 0 of 1 gpu_id: 2
MPI Rank 003 of 006 on HWThread 088 of Node a16n07 - GPU 0 of 1 gpu_id: 3
MPI Rank 004 of 006 on HWThread 116 of Node a16n07 - GPU 0 of 1 gpu_id: 4
MPI Rank 005 of 006 on HWThread 144 of Node a16n07 - GPU 0 of 1 gpu_id: 5

If you pass `verbose` as a command line argument, you can see the DomainID and BusID of each GPU as well:

$ jsrun -n6 -a1 -c7 -g1 ./run verbose | sort
MPI Rank 000 of 006 on HWThread 000 of Node a16n07 - GPU 0 of 1 UUID: GPU-ea3116f0-bb8c-66a4-0301-c5ccd01088f4 BusID: 0004:04:00.0 gpu_id: 0
MPI Rank 001 of 006 on HWThread 028 of Node a16n07 - GPU 0 of 1 UUID: GPU-6cb29d12-1484-fcb6-d6d5-7d6af3ec2acd BusID: 0004:05:00.0 gpu_id: 1
MPI Rank 002 of 006 on HWThread 056 of Node a16n07 - GPU 0 of 1 UUID: GPU-13cdb176-c177-6d38-394a-c40aba2f8c28 BusID: 0004:06:00.0 gpu_id: 2
MPI Rank 003 of 006 on HWThread 088 of Node a16n07 - GPU 0 of 1 UUID: GPU-93da8ea9-a03f-a32f-883f-eaf2a3274ca7 BusID: 0035:03:00.0 gpu_id: 3
MPI Rank 004 of 006 on HWThread 116 of Node a16n07 - GPU 0 of 1 UUID: GPU-e6c75eeb-8fcb-5cbf-c093-a29526e18c60 BusID: 0035:04:00.0 gpu_id: 4
MPI Rank 005 of 006 on HWThread 144 of Node a16n07 - GPU 0 of 1 UUID: GPU-9b690353-9149-97a1-15d8-0e30d5594c7e BusID: 0035:05:00.0 gpu_id: 5

NOTE: During testing you might try something like `jsrun -n1 -a3 -g1 ./run`, which will allow multiple MPI ranks to access the same GPU. Currently, in order for this to work, you will need to enable MPS with the flag `-alloc_flags gpumps`.
