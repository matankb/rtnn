#include <thrust/sort.h>
#include <thrust/device_vector.h>
#include <thrust/sequence.h>
#include <thrust/gather.h>

#include <iostream>

// this can't be in the main cpp file since the file containing cuda kernels to
// be compiled by nvcc needs to have .cu extensions. See here:
// https://github.com/NVIDIA/thrust/issues/614

void sortQueries( thrust::host_vector<unsigned int>* h_vec_key, thrust::host_vector<unsigned int>* h_vec_val, thrust::device_vector<unsigned int>* d_vec_key, thrust::device_vector<unsigned int>* d_vec_val ) {
  thrust::sort_by_key(d_vec_key->begin(), d_vec_key->end(), d_vec_val->begin());

  thrust::copy(d_vec_key->begin(), d_vec_key->end(), h_vec_key->begin());
  thrust::copy(d_vec_val->begin(), d_vec_val->end(), h_vec_val->begin());
}

void sortQueries( thrust::host_vector<unsigned int>* h_vec_key, thrust::host_vector<unsigned int>* h_vec_val, thrust::device_ptr<unsigned int> d_vec_key, thrust::device_vector<unsigned int>* d_vec_val, int N ) {
  thrust::sort_by_key(d_vec_key, d_vec_key+N, d_vec_val->begin());

  thrust::copy(d_vec_val->begin(), d_vec_val->end(), h_vec_val->begin());
}

void sortQueries( thrust::device_ptr<unsigned int> d_vec_key_ptr, thrust::device_vector<unsigned int>* d_vec_val, int N ) {
  thrust::sort_by_key(d_vec_key_ptr, d_vec_key_ptr+N, d_vec_val->begin());
}

void gatherQueries ( thrust::device_vector<unsigned int>* d_vec_val, thrust::device_ptr<float3> d_orig_queries_ptr, thrust::device_ptr<float3> d_reord_queries_ptr ) {
  thrust::gather(d_vec_val->begin(), d_vec_val->end(), d_orig_queries_ptr, d_reord_queries_ptr);
}

