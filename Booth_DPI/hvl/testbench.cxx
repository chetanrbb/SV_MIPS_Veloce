
#include <iostream>
using namespace std;

#include "tbxbindings.h"
#include "svdpi.h"
#include "stdio.h"
 
#define debug 1

static int CountA = -10 ;
static int CountB = -10;
static int multiplicand = 0;
static int multiplier = 0;
static long int value_out = 0;
static int error_count = 0;


int reset_completed()
{
   printf ("\n    RESET signal has been asserted ....");
   printf ("\n    Starting processing ...............\n");
    return 0;
}

int GetDataFromSoftware( svBitVecVal* data1, svBitVecVal* data2, svBitVecVal* isMoreData)
{
    *isMoreData = 1;
    if(CountA <= 10)
	  multiplicand = CountA++;
    
    if(CountA == 0)
    {
    multiplier = CountB++;
    CountA = -10;
    }
    else 
    multiplier = CountB;

	*data1=multiplicand;
	*data2=multiplier; 

  if(CountB == 10)
  *isMoreData = 0; 

  return 0;
}

int SendDataToSoftware( const svBitVecVal* data1)
{
      long int expected_result;
      value_out = *data1;

   	 expected_result = multiplicand * multiplier; 
	   if(value_out != expected_result)
		  {
				error_count ++ ;
		    printf ("\nError: Multiplicand=%0d Multiplier=%0d Expected Result=%0d Obtained Result=%0d",multiplicand,multiplier, expected_result, value_out);
		  }
      
  		if(debug)
		   printf ("\nInfo: Multiplicand=%0d Multiplier=%0d Expected Result=%0d Obtained Result=%0d",multiplicand,multiplier, expected_result, value_out);
      

   

    return 0;
}

int computation_completed()
{
    if (!error_count)
        printf("\nAll tests passed!\n");
    else
        printf("\n%0d Tests Failed :(",error_count);
    return 0;
}

