#include <iostream>
#include <ctime>

#define BLOCKS 16
#define THREADS 512

unsigned long long int MILLION      = 1000000;
unsigned long long int BILLION      = 1000000000;
unsigned long long int TRILLION     = 1000000000000;
unsigned long long int QUADRILLION  = 1000000000000000;
unsigned long long int LIMIT        = 1000 * MILLION;


__host__ __device__
void function_1(unsigned long long int limit) {
	for( unsigned long long int i = 0; i < limit; i++ );
} // function_1

__global__
void function_1_kernel(unsigned long long int limit) {
	function_1(limit);
}

void example_1() {

	// CPU 
	clock_t time = clock();
	function_1(LIMIT);
	time = clock() - time;
	std::cout << "CPU execution time: " << time / (double) CLOCKS_PER_SEC << std::endl;

	// GPU
	time = clock();
	function_1_kernel<<< BLOCKS, THREADS >>>(LIMIT);
	time = clock() - time;

	std::cout << "GPU execution time: " << time / (double) CLOCKS_PER_SEC << std::endl;
}

int main() {

	int numDevs;
	cudaGetDeviceCount(&numDevs);

	example_1();

	return EXIT_SUCCESS;
}

