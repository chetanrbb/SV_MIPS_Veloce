
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
static unsigned int Instr_Hex = 0;

FILE *fp = NULL;

static unsigned int instrMem[] = {
0b00000000010000100001000000100010,   
0b00000000011000110001100000100010,
0b00000000011000100100000000100010,
0b00000001001010010100100000100010,
0b00000001011010110101100000100010,
0b00000000011000100101100000100000,
0b00000001100011000110000000010011,
0b00000001101011010110100000010011,
0b00100001100011000000000000100000,
0b00100001101011010000000000010110,
0b00000001100011010111000000100100,
0b00000001101011100111100000100111,
0b00000001101011110001000000100101,
0b00000000011000110001100000100010,
0b00000000010000100001000000100010,
0b00000001011010110101100000100010,
0b00000001100011000110000000100010,
0b00000001000010000100000000100010,
0b00100000010000100000000000001010,
0b00100000011000110000000000010100,
0b00000001001010010100100000100010
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

unsigned char atoh(unsigned char val)
{
	unsigned char res = 0;
	
	if((val >= '0') && (val <= '9'))
		res = val - 0x30;
	else if((val >= 'a') && (val <= 'f'))
		res = (val - 'a') + 10;
	else if((val >= 'A') && (val <= 'F'))
		res = val - 'A' + 10;
	
	return res;
}

unsigned int instr_atoh(char *instr)
{
	unsigned char cnt = 0;
	unsigned int instrHex_t = 0, instrHex = 0;
	
	printf("Instr Read: %s\n", instr);
	for(cnt = 0; cnt < 8; )
	{
		instrHex <<= 8;
		
		instrHex_t = atoh(instr[cnt]);		
		instrHex_t <<= 4;
		instrHex_t |= atoh(instr[cnt+1]);
		
		instrHex |= instrHex_t;
		
		cnt += 2;
	}
	return instrHex;
}

int GetInstrFmMem(int PC)
{
	char instr[35]; 
	static int count = 0;
	int cnt = 0;
	
	
	// If file is not open then open the file 
	if(!fp)
	{
		printf("HVL: Opening file Instruction Memory.. \n");
		fp = fopen("instr_mem", "r");	
			
	}
	
	// FIle is open read the instruciton from it
	while (fgets(instr, 10, fp)) // read a line
	{
		if (count == (PC/4))	// Read the file till the instruction PC is not reached
		{
			Instr_Hex = instr_atoh(instr);
			printf("PC: %x\n", PC);
			printf("Instr: %x\n", Instr_Hex);
			return Instr_Hex;
		}
		else
			count++;
	}
 
	// EOF is reached 
	fclose(fp);
	return 0xFFFFFFFF;
	
	
	if((PC/4) > ((sizeof(instrMem)/4) - 1))
		return 0xFFFFFFFF;
	else
		return instrMem[(PC/4)];
	
	
	
}

void SendResOfProc(int ResultOfOprFlg)
{
	printf("Operation was: %s\n", ResultOfOprFlg?("YES"):("NO"));
	ResultOfOprFlg ? (SuccsCnt++) : (ErrorCnt++);
	printf("SuccessCnt: %d\n", (SuccsCnt-1));
}

void OperationComplete()
{
	printf("The CPU operation is Over....\n");
	printf("Successful Operations: %d, Unsuccessful Operations: %d\n", SuccsCnt, ErrorCnt);
}



