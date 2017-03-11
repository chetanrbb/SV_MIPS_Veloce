
///////////////////////////////////////////////////////////
// FileName: testbench.cxx
//
// Author: Chetan
// 
// Description: This file is a HVL for the CPU module. 
// It sends the instruction s to the CPU module and then reads the 
// result of the operation from the CPU module. It checks if the reset 
// operation is required or not. If the operation is over i.e. the instruction 
// memory is over then the terminate program is also called from this file.
/////////////////////////////////////////////////////////////

#include <iostream>
using namespace std;

#include "cpuTest.h"
#include "svdpi.h"
#include "stdio.h"
#include "stdlib.h"

#define debug 1

static unsigned int InstrMemArr[100];	// store the instruction that are to be computed on the CPU
static unsigned int ErrorCnt = 0;		// counter for the error 
static unsigned int SuccsCnt = 0;		// counter for the success 
static unsigned int Instr_bin = 0;

static unsigned int instrMem[] = {
0b00000000010000100001000000100010,
0b00000000011000110001100000100010,
0b00000001001010010100100000100010,
0b00000001010010100101000000100010,
0b00000001011010110101100000100010,
0b00000001100011000110000000100010,
0b00000001101011010110100000100010,
0b00000001110011100111000000100010,
0b00000001111011110111100000100010
};

/*static unsigned int instrMem[20] = {0x00421022,
									0x00631822,
									0x2042000A,
									0x20630014,
									0x00624022,
									0x00421022,
									0x00631822,
									0x2042000A,
									0x20630014,
									0x00624022
									};
*/

void ResetOpr()
{ 
	printf("The reset signal is asserted \n Resetting .... \n");
	printf("Starting the CPU...\n");
}


int GetInstrFmMem(int PC)
{
	char instr[35]; 
	char *p = instr;
	int count = 0;
	int cnt = 0;
	
	//for(cnt = 0; instrMem[cnt] != 0; cnt++);
	printf("Total Instructions: %d\n", sizeof(instrMem)/4);
	printf("PC: %x\n", PC);
	printf("Instr: %x", instrMem[(PC/4)]);
	if((PC/4) > ((sizeof(instrMem)/4) - 1))
		return 0xFFFFFFFF;
	else
		return instrMem[(PC/4)];
	
	/*
	FILE *fp;
	fp = fopen("instr_mem.txt", "a");	
	
	if(fp == 0)
        printf("ERROR: instr_mem.txt file could not open\n");
	else
	{
		//while (fgets(&instr[0], sizeof(instr), fp) != NULL) // read a line 
		while (fgets(p, 35, fp)) // read a line
		{
			if (count == (PC/4))	// Read the file till the instruction PC is not reached
			{
				//Instr_bin = atoi(instr);
				return 110;
				//return Instr_bin;
			}
			else
				count++;
		}
     
		// EOF is reached 
		fclose(fp);
		return 0xFFFFFFFF;
	}
	return 100;
	*/
	//return 0;
}

void SendResOfProc(int ResultOfOprFlg)
{
	printf("Operation was: %s\n", ResultOfOprFlg?("YES"):("NO"));
	ResultOfOprFlg ? (SuccsCnt++) : (ErrorCnt++);
}

void OperationComplete()
{
	printf("The CPU operation is Over....\n");
	printf("Successful Operations: %d, Unsuccessful Operations: %d\n", SuccsCnt, ErrorCnt);
}



