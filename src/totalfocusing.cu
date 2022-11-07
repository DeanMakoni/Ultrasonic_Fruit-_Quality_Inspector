
#include <assert.h>
#include <iostream>
# include <time.h>
# include <stdlib.h>
# include <stdio.h>
# include <string.h>
# include <math.h>
# include <cuda.h>
# include <ctime>
#include <fstream>
#include <sstream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include </content/read.h>

#define BLOCK_SIZE 16

/*
*********************************************************************
function name: gpu_matrix_mult
description: dot product of two matrix (not only square)
parameters: 
            &a GPU device pointer to a m X n matrix (A)
            &b GPU device pointer to a n X k matrix (B)
            &c GPU device output purpose pointer to a m X k matrix (C) 
            to store the result
Note:
    grid and block should be configured as:
        dim3 dimGrid((k + BLOCK_SIZE - 1) / BLOCK_SIZE, (m + BLOCK_SIZE - 1) / BLOCK_SIZE);
        dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
    further sppedup can be obtained by using shared memory to decrease global memory access times
return: none
*********************************************************************
*/
__constant__ float width =18; // user input - width of the enclosure
__constant__ float height = 19.5; // user input - height of the enclosure
__constant__ int image_width = 64; // user input
__constant__ int image_height = 64;
__constant__ int transimitter_pos;

__global__ void add(int *d_a, int *d_c, int *d_result, int n) 
{
    __shared__ int tile_a[BLOCK_SIZE][BLOCK_SIZE];
    __shared__ int tile_b[BLOCK_SIZE][BLOCK_SIZE];

    int row = blockIdx.y * BLOCK_SIZE + threadIdx.y;
    int col = blockIdx.x * BLOCK_SIZE + threadIdx.x;
    int tmp = 0;
    int idx;
    d_result[row * n + col] = d_result[row * n + col] + d_c[row * n + col];       
}
__global__ void gpu_matrix_mult(int *a,int *b, int *c, int m, int n, int k)
{ 
    int row = blockIdx.y * blockDim.y + threadIdx.y; 
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    int sum = 0;
    if( col < k && row < m) 
    {
        for(int i = 0; i < n; i++) 
        {
            sum += a[row * n + i] * b[i * k + col];
        }
        c[row * k + col] = sum;
    }
} 

/*
*********************************************************************
function name: gpu_square_matrix_mult
description: dot product of two matrix (not only square) in GPU
parameters: 
            &a GPU device pointer to a n X n matrix (A)
            &b GPU device pointer to a n X n matrix (B)
            &c GPU device output purpose pointer to a n X n matrix (C) 
            to store the result
Note:
    grid and block should be configured as:
        dim3 dim_grid((n - 1) / BLOCK_SIZE + 1, (n - 1) / BLOCK_SIZE + 1, 1);
        dim3 dim_block(BLOCK_SIZE, BLOCK_SIZE, 1);
return: none
*********************************************************************
*/
__global__ void total_focusing(int *d_a, int *d_b, int *d_result, int n,int **arrays, int pixels,int x, int y) 
{
    __shared__ int tile_a[BLOCK_SIZE][BLOCK_SIZE];
    __shared__ int tile_b[BLOCK_SIZE][BLOCK_SIZE];

    int row = blockIdx.y * BLOCK_SIZE + threadIdx.y;
    int col = blockIdx.x * BLOCK_SIZE + threadIdx.x;
    int tmp = 0;
    int idx;
    int pixel_width =width/pixels; // in constant memory
    int x_cordinate = col*pixel_width; // x coordinate of the pixel on the grid
    int y_cordinate = row*pixel_width; // y coordinate of the pixel on the grid
    //float transmitter_distance = sqrt(pow(x -  x_cordinate, 2) +pow(y -  y_cordinate, 2) + pow(height - 0, 2) * 1.0);// distance of transmitter to pixel grid position
    float transmitter_distance = sqrt(pow(x -  x_cordinate, 2) +pow(y -  y_cordinate, 2));
    // x and y are coordinates of the receiver
     
    float intensity = 0; // intensity of the pixel where each child is going to add  amplitude of the Ascan
    
    for (int j = 0; j < 8; j++){

         int  y1 = 7.5; // for linear configuration
         int  x1 = 0;
          if ( j == 0){
            //x1 = 3.1;
              x1 = 11;
          }
          else if (j == 1){
              //x1 = 7.3;
              x1 = 12;
          }
          else if (j == 2){
              //x1 = 11.5;
              x1   =12.5;
          }
          else{
              x1 = 15.7;
            }

         //TODO: find the cordinates of the reciever  ???

         //TODO: calculate the distance from the receiver to pixel
         int receiver_pos = j+1;
         //float receiver_distance = sqrt(pow(x1 -  x_cordinate, 2) +pow(y1 -  y_cordinate, 2) + pow(height - 0, 2) * 1.0);// distance of receiver to pixel grid position
         float receiver_distance = sqrt(pow(x1 -  x_cordinate, 2) +pow(y1 -  y_cordinate, 2));
         // TODO: calculate time of fligtht to the pixel position in microseconds
         // Distance formula is 0.034cm/microsecond x time of flight

         int time_of_flight = (receiver_distance + transmitter_distance)/0.034;

         //TODO: extract the amplitude for the A-scan  at the calculated time of flight
          float amplitude = 0;

          // outuput[row*width + col] = sum.
         // N is width, i is row
         amplitude = arrays[j*4 + transimitter_pos][time_of_flight];
         intensity = intensity + amplitude;
         }

      //d_result[row * n + col] = arrays[2][2];
      d_result[row * n + col] = intensity;   
}

/*
*********************************************************************
function name: gpu_matrix_transpose
description: matrix transpose
parameters: 
            &mat_in GPU device pointer to a rows X cols matrix
            &mat_out GPU device output purpose pointer to a cols X rows matrix 
            to store the result
Note:
    grid and block should be configured as:
        dim3 dim_grid((n - 1) / BLOCK_SIZE + 1, (n - 1) / BLOCK_SIZE + 1, 1);
        dim3 dim_block(BLOCK_SIZE, BLOCK_SIZE, 1);
return: none
*********************************************************************

*********************************************************************
function name: cpu_matrix_mult
description: dot product of two matrix (not only square) in CPU, 
             for validating GPU results
parameters: 
            &a CPU host pointer to a m X n matrix (A)
            &b CPU host pointer to a n X k matrix (B)
            &c CPU host output purpose pointer to a m X k matrix (C) 
            to store the result
return: none
*********************************************************************
*/
void cpu_matrix_mult(int *h_a, int *h_b, int *h_result, int m, int n, int k) {
    for (int i = 0; i < m; ++i) 
    {
        for (int j = 0; j < k; ++j) 
        {
            int tmp = 0.0;
            for (int h = 0; h < n; ++h) 
            {
                tmp += h_a[i * n + h] * h_b[h * k + j];
            }
            h_result[i * k + j] = tmp;
        }
    }
}

/*
*********************************************************************
function name: main
description: test and compare
parameters: 
            none
return: none
*********************************************************************
*/
int main(int argc, char const *argv[])
{
   float p_width = 18; // user input - width of the enclosure
   float p_height = 19.5; // user input - height of the enclosure
   int p_image_width =64; // user input
   int p_image_height =64;
   int pixels =12; // number of image pixel. It must be a multiple of 32
   int p_N = 4; 

    int m, n, k;
    /* Fixed seed for illustration */
    srand(3333);
    printf("please type in m n and k\n");
    scanf("%d %d %d", &m, &n, &k);

    // allocate memory in host RAM, h_cc is used to store CPU result
    int *h_a, *h_b, *h_c, *h_cc;
    cudaMallocHost((void **) &h_a, sizeof(int)*m*n);
    cudaMallocHost((void **) &h_b, sizeof(int)*n*k);
    cudaMallocHost((void **) &h_c, sizeof(int)*m*k);
    cudaMallocHost((void **) &h_cc, sizeof(int)*m*k);

    // random initialize matrix A -low reso
    for (int i = 0; i < m; ++i) {
        for (int j = 0; j < n; ++j) {
            h_a[i * n + j] = 0;
        }
    }

    // random initialize matrix B -high reso
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < k; ++j) {
            h_b[i * k + j] = 0;
        }
    }


    const int N_ARRAYS = 16;
    int *arrayOfArrays[N_ARRAYS];
    int *darrayOfArrays[N_ARRAYS];
    int **d_array;
   // int arr_len[N_ARRAYS] = {3, 2, 3};
    int arr1[3] = {1,2,3};
    //for (int k = 0; k < 16;k++){
      // arrayOfAscans[k] = arr1;
    // }
    
    int array1[70000];
    int array2[70000];
    int array3[70000];
    int array4[70000];
    int array5[70000];
    int array6[70000];
    int array7[70000];
    int array8[70000];
    int array9[70000];
    int array10[70000];
    int array11[70000];
    int array12[70000];
    int array13[70000];
    int array14[70000];
    int array15[700000];
    int array16[80000];

    read(array1,array2,array3,array4,array5,array6,array7,array8,array9,array10,array11,array12,array13,array14,array15,array16);
    arrayOfArrays[0] = array1;
    arrayOfArrays[1] = array2;
    arrayOfArrays[2] = array3;
    arrayOfArrays[3] = array4;
    arrayOfArrays[4] = array5;
    arrayOfArrays[5] = array6;
    arrayOfArrays[6] = array7;
    arrayOfArrays[7] = array8;
    arrayOfArrays[8] = array9;
    arrayOfArrays[9] = array10;
    arrayOfArrays[10] = array11;
    arrayOfArrays[11] = array12;
    arrayOfArrays[12] = array13;
    arrayOfArrays[13] = array14;
    arrayOfArrays[14] = array15;
    arrayOfArrays[15] = array16;
   
    // 1) You have to allocate the pointers to a host memory,
    for(int i = 0; i < N_ARRAYS; i++){
        //2) then allocate device memory for each array
        cudaMalloc(&(darrayOfArrays[i]), 70000* sizeof(int));
        cudaMemcpy(darrayOfArrays[i], arrayOfArrays[i], 70000*sizeof(int), cudaMemcpyHostToDevice); // copy contents of each array to device
    }

    // 4) Allocate the memmory for storing the pointers into the device to *d_array
    cudaMalloc(&d_array, sizeof(int*) * N_ARRAYS);

    // 5) Copy arrayOfArrays to d_array of size sizeof(void*) * N_ARRAYS from Host to device
    cudaMemcpy(d_array, darrayOfArrays, sizeof(int*) * N_ARRAYS, cudaMemcpyHostToDevice);

    float gpu_elapsed_time_ms, cpu_elapsed_time_ms;

    // some events to count the execution time
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // start to count execution time of GPU version
    cudaEventRecord(start, 0);
    // Allocate memory space on the device 
    int *d_a, *d_b, *d_c;
    cudaMalloc((void **) &d_a, sizeof(int)*m*n);
    cudaMalloc((void **) &d_b, sizeof(int)*n*k);
    cudaMalloc((void **) &d_c, sizeof(int)*m*k);

    // copy matrix A and B from host to device memory
    cudaMemcpy(d_a, h_a, sizeof(int)*m*n, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, sizeof(int)*n*k, cudaMemcpyHostToDevice);

    unsigned int grid_rows = (m + BLOCK_SIZE - 1) / BLOCK_SIZE;
    unsigned int grid_cols = (k + BLOCK_SIZE - 1) / BLOCK_SIZE;
    dim3 dimGrid(grid_cols, grid_rows);
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
   
    for (int i = 0; i < 4; i++) {

    int x1 = 0;
    int y1 = 7.5;

      if ( i == 0){
            x1 = 1;
          }
       else if (i == 1){
              x1 = 5.2;
          }
       else if (i == 2){
              x1 = 9.4;
          }
        else{
              x1 = 13.6;
            }
    int transimitter_pos_1 = i; // this variable is used to create the file name to access
    cudaMemcpyToSymbol(transimitter_pos, &transimitter_pos_1, sizeof(int));

    // Launch kernel 
    if(m == n && n == k)
    {
        total_focusing<<<dimGrid, dimBlock>>>(d_a, d_b, d_c, n,d_array,pixels,x1,y1);    
    }
    else
    {
        gpu_matrix_mult<<<dimGrid, dimBlock>>>(d_a, d_c, d_b, m, n, k);    
    }

    add<<<dimGrid,dimBlock>>>(d_a, d_c, d_b,n);

     }

    // Transefr results from device to host 
    //cudaMemcpy(h_c, d_c, sizeof(int)*m*k, cudaMemcpyDeviceToHost);
    cudaMemcpy(h_c, d_b, sizeof(int)*m*k, cudaMemcpyDeviceToHost);
    cudaThreadSynchronize();
    // time counting terminate
    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);

    // compute time elapse on GPU computing
    cudaEventElapsedTime(&gpu_elapsed_time_ms, start, stop);
    printf("Time elapsed on matrix multiplication of %dx%d . %dx%d on GPU: %f ms.\n\n", m, n, n, k, gpu_elapsed_time_ms);
    
     printf("\n");
    // start the CPU version
    cudaEventRecord(start, 0);

    cpu_matrix_mult(h_a, h_b, h_cc, m, n, k);

    cudaEventRecord(stop, 0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&cpu_elapsed_time_ms, start, stop);
    printf("Time elapsed on matrix multiplication of %dx%d . %dx%d on CPU: %f ms.\n\n", m, n, n, k, cpu_elapsed_time_ms);

    // validate results computed by GPU
    int all_ok = 1;

    ofstream image;
    image.open("smoll2.ppm");
    if (image.is_open()){
    // TODO: Place header infor
    image<<"P3" << endl;
    image<<"64 64" <<endl; // size of pixels
    image<<"255"<<endl;
    for (int i = 0; i < m; ++i)
    {
        for (int j = 0; j < k; ++j)
        {
            //printf("[%d][%d]:%d == [%d][%d]:%d, ", i, j, h_cc[i*k + j], i, j, h_c[i*k + j]);
            //printf("%d\t",h_c[i*k + j]);
            //image<<(h_c[i*k + j]*10)%250 <<"  "<<(h_c[i*k + j]*1)%250 << " "<<(h_c[i*k + j]*1)%250<< endl;
            if (h_c[i*k + j]%250 <= 50 )
            {
              image<< 29 <<"  "<< 246<< " "<< 246 << endl;
            }
            
            if ((h_c[i*k + j]%250 <=100) && (h_c[i*k + j]%250 > 50))
            {
              image<< 29 <<"  "<< 246<< " "<< 116 << endl;
            }
            if ((h_c[i*k + j]%250 <=120) && (h_c[i*k + j]%250 > 100))
            {
              image<< 12 <<"  "<< 209<< " "<< 91 << endl;
            }
            if ((h_c[i*k + j]%250 <= 150) && (h_c[i*k + j]%250 > 120))
            {
              image<< 12 <<"  "<< 240<< " "<< 27 << endl;
            }
            if ((h_c[i*k + j]%250 <=180) && (h_c[i*k + j]%250 > 150))
            {
              image<< 218 <<"  "<< 240<< " "<< 12 << endl;
            }
            if ((h_c[i*k + j]%250 <=200) && (h_c[i*k + j]%250 > 180))
            {
              image<< 245 <<"  "<< 237<< " "<< 12 << endl;
            }
            if ((h_c[i*k + j]%250 <=220) && (h_c[i*k + j]%250 > 200))
            {
              image<< 245 <<"  "<< 105<< " "<< 12 << endl;
            }
            if ((h_c[i*k + j]%250 <= 250) && (h_c[i*k + j]%250 > 220))
            {
              image<< 245 <<"  "<< 28<< " "<< 12 << endl;
            }
              
            if(h_cc[i*k + j] != h_c[i*k + j])
            {
                all_ok = 0;
            }
        }
        printf("\n");
    }
   image.close();

    // roughly compute speedup
    if(all_ok)
    {
        printf("all results are correct!!!, speedup = %f\n", cpu_elapsed_time_ms / gpu_elapsed_time_ms);
    }
    else
    {
        printf("incorrect results\n");
    }

    // free memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    cudaFreeHost(h_a);
    cudaFreeHost(h_b);
    cudaFreeHost(h_c);
    cudaFreeHost(h_cc);
    return 0;
}}
