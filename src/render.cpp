/**
Dean Makoni
**/


#include <iostream>
#include <fstream>

using namespace std;

int main(){

 ofstream image;
 image.open("image.ppm");

 if (image.is_open()){
        // TODO: Place header infor
        image<<"P3" << endl;
        image<<"64 64" <<endl; // size of pixels

        #include <iostream>
#include <fstream>

using namespace std;

int main(){

 ofstream image;
 image.open("image.ppm");

 if (image.is_open()){
        // TODO: Place header infor
        image<<"P3" << endl;
        image<<"64 64" <<endl; // size of pixels

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
              image<< 12 <<"  "<< 240<< " "<< 27
 }
    }
        printf("\n");
    }
 image.close();

 return 0;

}
