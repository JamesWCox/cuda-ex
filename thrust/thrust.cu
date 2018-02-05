#include <iostream>
#include <ctime>
#include <thrust/execution_policy.h>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/tuple.h>

#define BLOCKS 16
#define threads 32

typedef thrust::host_vector<int>::iterator             h_itr_int;
typedef thrust::host_vector<double>::iterator          h_itr_double;
typedef thrust::host_vector<float>::iterator           h_itr_float;
typedef thrust::host_vector<char>::iterator            h_itr_char;

typedef thrust::device_vector<int>::iterator           d_itr_int;
typedef thrust::device_vector<double>::iterator        d_itr_double;
typedef thrust::device_vector<float>::iterator         d_itr_float;
typedef thrust::device_vector<char>::iterator          d_itr_char;

typedef thrust::tuple< d_itr_int, d_itr_char > 	       d_int_char_tuple;
typedef thrust::zip_iterator< d_int_char_tuple >       d_int_char_zip_itr;


// Testing negate with transform
void example_1() {
	clock_t time;
	unsigned long int VECTOR_SIZE = 2000000;

	thrust::host_vector<int>   h_vec_1(VECTOR_SIZE);
	thrust::device_vector<int> d_vec_1(VECTOR_SIZE);
	thrust::device_vector<int> d_vec_2(VECTOR_SIZE);

	for( size_t i = 0; i < VECTOR_SIZE; i++ ) {
		h_vec_1[i] = i;
	}	

	d_vec_1 = h_vec_1;

	time = clock();
	thrust::transform( d_vec_1.begin(), d_vec_1.end(), d_vec_2.begin(), thrust::negate<int>() );
	time = clock() - time;

	std::cout << "thrust::transform negate<> took " 
		<< time / (double) CLOCKS_PER_SEC << " seconds.\n" << std::endl;

} // example_1


// Testing zip_iterator
void example_2() {
	clock_t time;
	
	unsigned int PAIR_SIZE = 5;
	thrust::device_vector<int>  ID( PAIR_SIZE );
	thrust::device_vector<char> pair( PAIR_SIZE );

	time = clock();

	for( size_t i = 0; i < PAIR_SIZE; i++ ) {
		ID[i] = i;
	}

	pair[0] = 'A';
	pair[1] = 'B';
	pair[2] = 'C';
	pair[3] = 'D';
	pair[4] = 'E';
	
	d_int_char_zip_itr itr_1 = thrust::make_zip_iterator( thrust::make_tuple( ID.begin(), pair.begin() ) );
	d_int_char_zip_itr itr_2 = thrust::make_zip_iterator( thrust::make_tuple( ID.end(), pair.end() ) );

	for( size_t i = 0; i < PAIR_SIZE; i++ ) {
		std::cout << "ID: " << thrust::get<0>( itr_1[i] ) 
			<< "\tChar: " << thrust::get<1>( itr_1[i] ) << std::endl;
	}

	time = clock() - time;
	std::cout << "\nthrust::zip_iterator took " 
		<< time / (double) CLOCKS_PER_SEC << " seconds.\n" << std::endl;

} // example_2



int main() {

	//example_1();
	example_2();

	return EXIT_SUCCESS;
}













