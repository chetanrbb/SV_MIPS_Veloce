
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
FILE *Fc_fp = NULL;




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


//////////////////////////////////////////////////////
// File Type: Functional Coverage
// 
//
// This will read the instruction which is sent to the processor
// and check if the result of the operaiton is correct or not 
// For the instruction the result of total instructions issued, 
// Success, Errors will be shown. 
//////////////////////////////////////////////////////
static unsigned int addCntr = 0, subCntr = 0, andCntr = 0, norCntr = 0, orCntr = 0, sltCntr = 0, xorCntr = 0;
	
static unsigned int addCrctResult, addErrResult, subCrctResult, subErrResult, andCrctResult, andErrResult, norCrctResult, norErrResult, orCrctResult, orErrResult, sltCrctResult, sltErrResult, xorCrctResult, xorErrResult;

static unsigned int lwopCntr = 0, lwCrctResult = 0, lwErrResult = 0, addiCntr = 0, addiCrctResult = 0, addiErrResult = 0, beqCntr = 0, beqCrctResult = 0, beqErrResult = 0, swopCntr = 0, swopCrctResult = 0, swopErrResult = 0, bneCntr = 0, bneCrctResult = 0, bneErrResult = 0,jopCntr = 0, jopCrctResult = 0, jopErrResult = 0;
	


void FunctionalCoverage(int instr, int result)
{
typedef	enum
{
	ADD = 0x20,
	SUB = 0x22,
	AND = 0x24,
	NOR = 0x27,
	OR = 0x25,
	SLT = 0x2A,
	XOR = 0x13
}AluOp_t;

typedef enum 
{
	ADD_op = 0,
	LW_op  = 0x23,
	ADDI_op = 0x08,
	BEQ_op = 0x04,
	SW_op = 0x2B,
	BNE_op = 0x05,
	J_op = 0x02
}opcode_t;

    
	
	
	switch((instr>>24) & 0x3F)	// read the instruction opcode 
	{
	case ADD_op: {
					switch(instr & 0x3F)	// read the funct bits 
					{
					case ADD: {
								addCntr++;
								(result)?(addCrctResult++):(addErrResult++);
								break;
							  }
					case SUB: {
								subCntr++;
								(result)?(subCrctResult++):(subErrResult++);
								break;
							  }
					case AND: {
								andCntr++;
								(result)?(andCrctResult++):(andErrResult++);
								break;
							  }
					case NOR: {
								norCntr++;
								(result)?(norCrctResult++):(norErrResult++);
								break;
							  }
					case OR:  {
								orCntr++;
								result?(orCrctResult++):(orErrResult++);
								break;
							  }
					case SLT: {
								sltCntr++;
								result?(sltCrctResult++):(sltErrResult++);
								break;
							  }
					case XOR: {
								xorCntr++;
								result?(xorCrctResult++):(xorErrResult++);
								break;
							  }
					}
					break;
				 }
		
	case LW_op: {
					lwopCntr++;
					result?(lwCrctResult++):(lwErrResult++);
					break;
				}
				
	case ADDI_op: {
					addiCntr++;
					result?(addiCrctResult++):(addiErrResult++);
					break;
				  }
				  
	case BEQ_op: {
					beqCntr++;
					result?(beqCrctResult++):(beqErrResult++);
					break;
				 }
				 
	case SW_op: {
					swopCntr++;
					result?(swopCrctResult++):(swopErrResult++);
					break;
				}
			
	case BNE_op: {
					bneCntr++;
					result?(bneCrctResult++):(bneErrResult++);
					break;
				}
				
	case J_op: {
					jopCntr++;
					result? (jopCrctResult++):(jopErrResult++);
					break;
			   }
	}
	
}


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
	
	printf("PC Rec: %x\n", PC);
	// If file is not open then open the file 
	if(!fp)
	{
		printf("HVL: Opening file Instruction Memory.. \n");
		fp = fopen("instr_mem", "r");	
			
	} 
	
	if((PC/4) < count)
	{
		fseek(fp, 0, SEEK_SET);
		count = 0;
	}
	// FIle is open read the instruciton from it
	while (fgets(instr, 11, fp)) // read a line
	{			
		if (count++ == (PC/4))	// Read the file till the instruction PC is not reached
		{
			Instr_Hex = instr_atoh(instr);
			printf("PC Cnt: %d\n", (PC/4)+1);
			printf("PC: %x\n", PC);
			printf("Instr: %x\n", Instr_Hex);
			return Instr_Hex;
		}
		else 
		{		
			//count++;
			printf("CounterInc: %d\n", count); 	
		}
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
	printf("SuccessCnt: %d\n", (SuccsCnt)?(SuccsCnt-1):(0));
	FunctionalCoverage(Instr_Hex, ResultOfOprFlg);
}

void OperationComplete()
{
	char fcfp_arr[60] = {0};
	
	printf("The CPU operation is Over....\n");
	printf("Successful Operations: %d, Unsuccessful Operations: %d\n", SuccsCnt, ErrorCnt);
	
	if(!Fc_fp)
	{
		printf("HVL: Opening file Instruction Memory.. \n");
		Fc_fp = fopen("FunctionalCoverage", "a");	
	}
	
	fputs("The functional coverage file contains the following information\n", Fc_fp);
	
	sprintf(fcfp_arr, "ADD: Total: %d, Correct : %d, Error: %d\n", addCntr, addCrctResult, addErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "SUB: Total: %d, Correct : %d, Error: %d\n", subCntr, subCrctResult, subErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "AND: Total: %d, Correct : %d, Error: %d\n", andCntr, andCrctResult, andErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "XOR: Total: %d, Correct : %d, Error: %d\n", xorCntr, xorCrctResult, xorErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "NOR: Total: %d, Correct : %d, Error: %d\n", norCntr, norCrctResult, norErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "OR: Total: %d, Correct : %d, Error: %d\n", orCntr, orCrctResult, orErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "SLT: Total: %d, Correct : %d, Error: %d\n", sltCntr, sltCrctResult, sltErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "LW: Total: %d, Correct : %d, Error: %d\n", lwopCntr, lwCrctResult, lwErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "ADDI: Total: %d, Correct : %d, Error: %d\n", addiCntr, addiCrctResult, addiErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "BEQ: Total: %d, Correct : %d, Error: %d\n", beqCntr, beqCrctResult, beqErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "SW: Total: %d, Correct : %d, Error: %d\n", swopCntr, swopCrctResult, swopErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "BNE: Total: %d, Correct : %d, Error: %d\n", bneCntr, bneCrctResult, bneErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "JMP: Total: %d, Correct : %d, Error: %d\n", jopCntr, jopCrctResult, jopErrResult);
	fputs(fcfp_arr, Fc_fp);

	fclose(Fc_fp);
}


