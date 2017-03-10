
///////////////////////////////////////////////////////////
// FileName: testbench.cxx
//
// Author: Chetan
// 
// Description: This file is a HVL for the CPU module. 
// It sends the instructions to the CPU module and then reads the 
// result of the operation from the CPU module. It checks if the reset 
// operation is required or not. If the operation is over i.e. the instruction 
// memory is over then the terminate program is also called from this file.
/////////////////////////////////////////////////////////////

#include <iostream>
using namespace std;

#include "cpuTest.h"
#include "svdpi.h"
#include "stdio.h"

#define debug 1

static unsigned int InstrMemArr[100];	// store the instruction that are to be computed on the CPU
static unsigned int ErrorCnt = 0;		// counter for the error 
static unsigned int SuccsCnt = 0;		// counter for the success 

void ResetOpr()
{
	printf("The reset signal is asserted \n Resetting .... \n");
	printf("Starting the CPU...\n");
}

int GetInstrFmMem(int PC)
{
	//return (InstrMemArr[(PC)/4]);		// send the instruction stored in the memory 
	return 100;
}

void SendResOfProc(int ResultOfOprFlg)
{
	printf("Operation was: %s", ResultOfOprFlg?("YES"):("NO"));
	ResultOfOprFlg ? (SuccsCnt++) : (ErrorCnt++);
}

void OperationComplete()
{
	printf("The CPU operation is Over....\n");
	printf("Successful Operations: %d, Unsuccessful Operations: %d\n", SuccsCnt, ErrorCnt);
}



