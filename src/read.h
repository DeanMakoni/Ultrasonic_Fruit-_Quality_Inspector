#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXCHAR 1000
using namespace std;


#define MAXCHAR 1000
void read(int array1[],int array2[],int array3[],int array4[],int array5[],int array6[],int array7[],int array8[],int array9[],int array10[],int array11[],int array12[],int array13[],int array14[],int array15[],int array16[]){

    FILE *fp;
    char row[MAXCHAR];

    fp = fopen("small1.csv","r");

    ;
    int lineNumber = 0;
    while (feof(fp) != true)
    {
        fgets(row, MAXCHAR, fp);
        //printf("Row: %s", row);
        if(lineNumber <= 5990){
                 array1[lineNumber] =  std::stoi(row);
                 lineNumber++;
        }
       else if((lineNumber <= 11980) && (lineNumber > 5990)){
                array2[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
       else if((lineNumber <= 17970) && (lineNumber > 11980)){
                array3[lineNumber] =  std::stoi(row);
                lineNumber++;
        }

       else if((lineNumber <= 23960) && (lineNumber > 17970)){
                array4[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else if((lineNumber <= 29950) && (lineNumber > 17970)){
                array5[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else if((lineNumber <= 35940) && (lineNumber > 29950)){
                array6[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else if((lineNumber <= 41930) && (lineNumber > 35940)){
                array7[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else if((lineNumber <= 47920) && (lineNumber > 41930)){
                array8[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else if((lineNumber <= 53910) && (lineNumber > 47920)){
                array9[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else if((lineNumber <= 59990) && (lineNumber > 53910)){
                array10[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else if((lineNumber <= 65890) && (lineNumber > 59990)){
                array11[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else if((lineNumber <= 71880) && (lineNumber > 65980)){
                array12[lineNumber] =  std::stoi(row);
                lineNumber++;
      }
            else if((lineNumber <= 77870) && (lineNumber > 71880)){
                array13[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else if((lineNumber <= 83860) && (lineNumber > 77870)){
                array14[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else if((lineNumber <= 89850) && (lineNumber > 83860)){
                array15[lineNumber] =  std::stoi(row);
                lineNumber++;
        }
      else{
               array16[lineNumber] =  std::stoi(row);
               lineNumber++;
       }
    }

}
