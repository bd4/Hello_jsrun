#include <stdio.h>
#include <mpi.h>
#include <sched.h>
#include <nvml.h>

int main(int argc, char *argv[]){

	MPI_Init(&argc, &argv);

	int size;
	MPI_Comm_size(MPI_COMM_WORLD, &size);

	int rank;
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  char name[MPI_MAX_PROCESSOR_NAME];
	int resultlength;
  MPI_Get_processor_name(name, &resultlength);

	// Find out which HWThread is being used
	int hwthread = sched_getcpu();

	// Find how many GPUs CUDA runtime says are available
	int num_devices = 0;
	cudaGetDeviceCount(&num_devices);

	// Set output based on command line argument
	// => verbose shows BusID and UUID for GPUs
	char output_flag[64];
	strcpy(output_flag, "not_verbose");
	if(argc > 1){ 
		if(strlen(argv[1]) >= sizeof(output_flag)){
			printf("Argument too long: %s\n", argv[1]);
			exit(1);
		}
		else{
			strcpy(output_flag, argv[1]);
		}
	}

	if(num_devices == 0){
		printf("MPI Rank %03d of %03d on HWThread %03d of Node %s\n", rank, size, hwthread, name);
	}
	else{

		// NVML is needed to query the UUID of GPUs, which
		// allows us to check which GPU is actually being used
		// by each MPI rank
		nvmlInit();

		char uuid[NVML_DEVICE_UUID_BUFFER_SIZE];
		char busid[64];

		int gpu_id;

		// Loop over the GPUs available to each MPI rank
		for(int i=0; i<num_devices; i++){

			cudaSetDevice(i);

			// Get the PCIBusId for each GPU and use it to query for UUID
			cudaDeviceGetPCIBusId(busid, 64, i);

			// Get UUID for the device based on busid
			nvmlDevice_t device;
			nvmlDeviceGetHandleByPciBusId(busid, &device);
			nvmlDeviceGetUUID(device, uuid, NVML_DEVICE_UUID_BUFFER_SIZE);

			// Map DomainID and BusID to node-local GPU ID
			if(strcmp(busid, "0004:04:00.0") == 0){
				gpu_id = 0;
			}else if(strcmp(busid, "0004:05:00.0") == 0){
				gpu_id = 1;
			}else if(strcmp(busid, "0004:06:00.0") == 0){
				gpu_id = 2;
			}else if(strcmp(busid, "0035:03:00.0") == 0){
        gpu_id = 3;
      }else if(strcmp(busid, "0035:04:00.0") == 0){
        gpu_id = 4;
      }else if(strcmp(busid, "0035:05:00.0") == 0){
        gpu_id = 5;
      }else{
				printf("The BusID (%s) did not map correctly to a GPU. Exiting...\n", busid);
				exit(0);
			}

			if(strcmp(output_flag, "verbose") == 0){
					printf("MPI Rank %03d of %03d on HWThread %03d of Node %s - GPU %d of %d UUID: %s BusID: %s gpu_id: %d\n", rank, size, hwthread, name, i, num_devices, uuid, busid, gpu_id);
			}
			else{
					printf("MPI Rank %03d of %03d on HWThread %03d of Node %s - GPU %d of %d gpu_id: %d\n", rank, size, hwthread, name, i, num_devices, gpu_id);
			}

		}	

		nvmlShutdown();

	}

	MPI_Finalize();

	return 0;
}
