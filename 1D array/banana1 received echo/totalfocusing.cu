// Dean Makoni
// total focusing method
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
#include </home/MKNDEA002/final_year/src/read.h>
#include <iostream>

using namespace std;

  __constant__ float width =18; // user input - width of the enclosure
  __constant__ float height = 16; // user input - height of the enclosure
  __constant__ int image_width = 64; // user input
  __constant__ int image_height = 64; //  user input
  __constant__ int N = 4;  // number of receivers
  __constant__ int transimitter_pos;
  __constant__ float x; // x cordinate of  transmitter
  __constant__ float y; // y cordinate of the  transmitter
  __constant__ float z;



__global__ void add( unsigned char * arr,unsigned char * arr2) {
   
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  int idy = blockIdx.y * blockDim.y + threadIdx.y;
//  arr2[idy* image_width + idx ] = arr[idy* image_width + idx ] + arr2[idy* image_width + idx ]; 
    arr2[idy* image_width + idx ] = 0;
} 

__global__ void pixelKernel(unsigned char * low_reso, int pixels,float x,float y, float z,int **Ascans)
{
  // width and height are the dimensions of the enclosure. They are not supposed to be confused with the dimensions of the image
  float threadID = threadIdx.x;
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  int idy = blockIdx.y * blockDim.y + threadIdx.y;  ///  ??????????????
  int pixel_width =width/pixels; // in constant memory
  int x_cordinate = idx*pixel_width; // x coordinate of the pixel on the grid
  int y_cordinate = idy*pixel_width; // y coordinate of the pixel on the grid
  float transmitter_distance = sqrt(pow(x -  x_cordinate, 2) +pow(y -  y_cordinate, 2) + pow(height - 0, 2) * 1.0);// distance of transmitter to pixel grid position
  // x and y are coordinates of the receiver
 
  float intensity = 0; // intensity of the pixel where each child is going to add  amplitude of the Ascan 

  //childKernel<<<1,receivers>>>(x,y,transmitter_pos);// number of child kernels are determined by number of receicers
  // use one block here for threads
  // weight the option of using cuda streams
   using namespace std;
   using std::string;
  
  for (int j = 0; j < N; j++){

         int  y1 = 2.5; // for linear configuration
         int  x1 = 0;
          if ( j == 0){
            x1 = 3.1;
          }
          else if (j == 1){
              x1 = 7.3;
          }
          else if (j == 2){
              x1 = 11.5;
          }
          else{
              x1 = 15.7;
            }

  	 //TODO: find the cordinates of the reciever  ???

  	 //TODO: calculate the distance from the receiver to pixel
         int receiver_pos = j+1;
  	 float receiver_distance = sqrt(pow(x1 -  x_cordinate, 2) +pow(y1 -  y_cordinate, 2) + pow(height - 0, 2) * 1.0);// distance of receiver to pixel grid position

  	 // TODO: calculate time of fligtht to the pixel position in microseconds
  	 // Distance formula is 0.034cm/microsecond x time of flight

  	 int time_of_flight = (receiver_distance + transmitter_distance)/0.034;

  	 //TODO: extract the amplitude for the A-scan  at the calculated time of flight
          float amplitude = 0;
        
          // outuput[row*width + col] = sum.
         // N is width, i is row
          Ascans[j*N + transimitter_pos][time_of_flight] = amplitude;  
          intensity = intensity + amplitude;
   	 }
    __syncthreads();
   
  // place the intensity to proper position in low resolution image
   low_reso[idy* image_width + idx ] = intensity;
  // idx = col
  // idy = row
  // image_width = width
}

int main(void)
{ 
   
   float p_width = 16.5; // user input - width of the enclosure
   float p_height = 16; // user input - height of the enclosure
   int p_image_width =64; // user input
   int p_image_height =64;
   int pixels =64; // number of image pixel. It must be a multiple of 32
   int p_N = 4; // number of transimitters user input 
  
 // printf("dean");
  cudaMemcpyToSymbol(width, &p_width, sizeof(float));
  cudaMemcpyToSymbol(height, &p_height, sizeof(float));
  cudaMemcpyToSymbol(image_width, &p_image_width, sizeof(int));
  cudaMemcpyToSymbol(image_height, &p_image_height, sizeof(float));
  cudaMemcpyToSymbol(N,&p_N, sizeof(int));

  unsigned char * high_reso; // high resolution image 
  unsigned char * high_reso_device; // high resolution device in device memory  copy it to high reso imeage after all the updates
  
  int ImageSize = sizeof ( unsigned char ) *64 * 64 ;
  cudaMalloc (( void **) & high_reso_device, ImageSize );
  high_reso = ( unsigned char *) malloc ( ImageSize ); // allocate image a host memory
  /** 
    Populate the Ascan  array. By copying Ascan array in data directory.
    Basically making an array of arrays. 
   **/
    const int N_ARRAYS = 16;
    int *arrayOfAscans[N_ARRAYS];  // arrayOfArrays
    int *darrayOfAscans[N_ARRAYS]; 
    int **d_array;
   // int arr_len[N_ARRAYS] = {3, 2, 3};
  //  int arr1[3] = {1,2,3};

    int array1[7000];
    int array2[7000];
    int array3[7000];
    int array4[7000];
    int array5[7000];
    int array6[7000];
    int array7[7000];
    int array8[7000];
    int array9[7000];
    int array10[7000];
    int array11[7000];
    int array12[7000];
    int array13[7000];
    int array14[7000];
    int array15[7000];
    int array16[7000];

    read(array1,array2,array3,array4,array5,array6,array7,array8,array9,array10,array11,array12,array13,array14,array15,array16);
    arrayOfAscans[0] = array1;
    arrayOfAscans[1] = array2;
    arrayOfAscans[2] = array3;
    arrayOfAscans[3] = array4;
    arrayOfAscans[4] = array5;
    arrayOfAscans[5] = array6;
    arrayOfAscans[6] = array7;
    arrayOfAscans[7] = array8;
    arrayOfAscans[8] = array9;
    arrayOfAscans[9] = array10;
    arrayOfAscans[10] = array11;
    arrayOfAscans[11] = array12;
    arrayOfAscans[12] = array13;
    arrayOfAscans[13] = array14;
    arrayOfAscans[14] = array15;
    arrayOfAscans[15] = array16;
         
   // printf("dean2");
   // for (int k = 0; k < 20;k++){
   //	 printf("%d", array1[k]);
     //    printf( "\n" );
   //  }
   
   // allocating pointers to host memory 
   for(int i = 0; i < N_ARRAYS; i++){
        //Allocating device memory for each array
        cudaMalloc(&(darrayOfAscans[i]), 1000000 * sizeof(float));
        cudaMemcpy(darrayOfAscans[i], arrayOfAscans[i], 1000000*sizeof(float), cudaMemcpyHostToDevice); // copy contents of each array to device
    }   
  //Allocating the memmory for storing the pointers into the device to *d_array
  cudaMalloc(&d_array, sizeof(float*) * N_ARRAYS);
  
  //Copy arrayOfAscans to d_array of size sizeof(void*) * N_ARRAYS from Host to device
    cudaMemcpy(d_array, darrayOfAscans, sizeof(float*) * N_ARRAYS, cudaMemcpyHostToDevice);

/** iterate through all the receivers to get low resolution images
 First step is to calculate  the transmitter position
 receiver coordinates are supposd to be kept in constant memory - constant memory is designed for faster parallel data access 
 first[B step copy high resolution image to device memory
 after every iteration the iterations adds its intensities to high resolution image
 copy the image to host after all the iterations.
 **/

  int x1 = 0;
  int y1 = 2.5;
  for (int i = 0; i < p_N; i++) {

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

    unsigned char * low_reso_device = NULL; // low resolution image on device
    cudaMalloc (( void **) & low_reso_device , ImageSize );
    
    //TODO: launch parent kernel

    pixelKernel<<<pixels/32,pixels>>>(low_reso_device,pixels,x1,y1,16,d_array); // pixels dived by 32 gives the number of blocks
    cudaDeviceSynchronize();
    //printf("dean4");
   //TODO: launch a kernel that adds the results of high_reso _device and low_reso_device
    add<<<pixels/32, pixels>>>(low_reso_device,high_reso_device);
    cudaDeviceSynchronize();
    cudaFree(low_reso_device);
  }

 // TODO ;Copy the high_reso_device to high_reso on the CPU
  cudaMemcpy ( high_reso, high_reso_device, ImageSize ,cudaMemcpyDeviceToHost );

 // TODO: Print the high resolution  image on CPU
    

    // ofstream image;
    // image.open("test3.ppm");
     // if (image.is_open()){
     // TODO: Place header infor
    // image<<"P3" << endl;
    // image<<"64 64" <<endl; // size of pixels
    // image<<"255"<<endl;
    for(int i=0;i<64;i++)
    {
      printf("\n");
      for(int j=0;j <64; j++){
          printf("%d\t", high_reso[i* 64 + j]);
           //image<<(high_reso[i* 64 + j]*10)%4096 <<"  "<<(high_reso[i* 64 + j]*3)%4096 << " "<<(high_reso[i* 64 + j]*5)%4096<< endl;
          // image<< i*2 << " " << i << " "<< i << endl;
     }
    // printf("\n");
     }
 // }
  // image.close();
  //TODO:  Free memory

  cudaFree(high_reso_device);

    for(int i = 0; i < N_ARRAYS; i++){
        cudaFree(darrayOfAscans[i]); //host not device memory
        //TODO: check error
    }
    cudaFree(d_array);
    // free(arrayOfArrays);
    //printf("%s\n", cudaGetErrorString(cudaGetLastError()));  
    //printf("dean5");
  return 0;
}
