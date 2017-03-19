
///////////////////////////////////////////////////////////
// FileName: testbench.cxx
//
// Author: Chetan B. | Harsh M. | Daksh D. 
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
#include "stdlib.h"

#define debug 1

static unsigned int InstrMemArr[100];	// store the instruction that are to be computed on the CPU
static unsigned int ErrorCnt = 0;		// counter for the error 
static unsigned int SuccsCnt = 0;		// counter for the success 
static unsigned int Instr_Hex = 0;

FILE *fp = NULL;
FILE *Fc_fp = NULL;

unsigned int InstrArr[5] = {0};
unsigned char rdPtr = 0;
unsigned char wrPtr = 0;
unsigned char sendFlg = 0;


// Functional Coverage:
//
// This will read the instruction which is sent to the processor
// and check if the result of the operaiton is correct or not 
// For the instruction the result of total instructions issued, 
// Success, Errors will be shown. 


// Counters for each instruciton that will be issued by the CPU 
// Counter increments on receiving each instruction 
static unsigned int addCntr = 0, 
					subCntr = 0, 
					andCntr = 0, 
					norCntr = 0, 
					orCntr  = 0, 
					sltCntr = 0, 
					xorCntr = 0;
	
// Counters to keep a count of each instruction was executed successfully or not 	
static unsigned int addCrctResult, 
					addErrResult, 
					subCrctResult, 
					subErrResult, 
					andCrctResult, 
					andErrResult, 
					norCrctResult, 
					norErrResult, 
					orCrctResult, 
					orErrResult, 
					sltCrctResult, 
					sltErrResult, 
					xorCrctResult, 
					xorErrResult;

static unsigned int lwopCntr 	   = 0, 
					lwCrctResult   = 0, 
					lwErrResult    = 0, 
					addiCntr 	   = 0, 
					addiCrctResult = 0, 
					addiErrResult  = 0, 
					beqCntr 	   = 0, 
					beqCrctResult  = 0, 
					beqErrResult   = 0, 
					swopCntr 	   = 0, 
					swopCrctResult = 0, 
					swopErrResult  = 0, 
					bneCntr        = 0, 
					bneCrctResult  = 0, 
					bneErrResult   = 0,
					jopCntr        = 0, 
					jopCrctResult  = 0, 
					jopErrResult   = 0;
	

unsigned int TotalInstrRun = 0;	// Counter for total instructions 

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

		
	// as per the instruction received check if the instruction was executed successfully or not 
	printf("FC: %x, Res: %x", instr, result);
	switch((instr>>26) & 0x3F)	// read the instruction opcode 
	{
	case ADD_op: {
					switch(instr & 0x3F)	// read the funct bits 
					{
					case ADD: {	// ADD instruction received 
								addCntr++;
								(result)?(addCrctResult++):(addErrResult++);
								break;
							  }
					case SUB: {	// SUB instruction received 
								subCntr++;
								(result)?(subCrctResult++):(subErrResult++);
								break;
							  }
					case AND: {	// AND instruction received 
								andCntr++;
								(result)?(andCrctResult++):(andErrResult++);
								break;
							  }
					case NOR: {	// NOR instruction received 
								norCntr++;
								(result)?(norCrctResult++):(norErrResult++);
								break;
							  }
					case OR:  {	// OR instruction received 
								orCntr++;
								result?(orCrctResult++):(orErrResult++);
								break;
							  }
					case SLT: {	// Set less than intsruction received 
								sltCntr++;
								result?(sltCrctResult++):(sltErrResult++);
								break;
							  }
					case XOR: {	// XOR instruction received 
								xorCntr++;
								result?(xorCrctResult++):(xorErrResult++);
								break;
							  }
					}
					break;
				 }
		
	case LW_op: {	// Load instruction received 
					lwopCntr++;
					result?(lwCrctResult++):(lwErrResult++);
					break;
				}
				
	case ADDI_op: {	// ADD immediate instruction received 
					addiCntr++;
					result?(addiCrctResult++):(addiErrResult++);
					break;
				  }
				  
	case BEQ_op: {	// Branch equal instruction received 
					beqCntr++;
					result?(beqCrctResult++):(beqErrResult++);
					break;
				 }
				 
	case SW_op: {	// Store word instruction 
					swopCntr++;
					result?(swopCrctResult++):(swopErrResult++);
					break;
				}
			
	case BNE_op: {	// Branch not equal 
					bneCntr++;
					result?(bneCrctResult++):(bneErrResult++);
					break;
				}
				
	case J_op: {	// Jump 
					jopCntr++;
					result? (jopCrctResult++):(jopErrResult++);
					break;
			   }
	}	
}

// Signal the operation that the reset operation was requested. 
void ResetOpr()
{ 
	printf("The reset signal is asserted \n Resetting .... \n");
	printf("Starting the CPU...\n");
}

// Convert the ASCII to hex value 
unsigned char atoh(unsigned char val)
{
	unsigned char res = 0;
	
	if((val >= '0') && (val <= '9'))		// Check if the number received is inrange of hex value 
		res = val - 0x30;
	else if((val >= 'a') && (val <= 'f'))	
		res = (val - 'a') + 10;
	else if((val >= 'A') && (val <= 'F'))
		res = val - 'A' + 10;
	
	return res;		// send the hex value back 
}

// Convert the instruction received to hex value from ASCII value 
unsigned int instr_atoh(char *instr)
{
	unsigned char cnt = 0;
	unsigned int instrHex_t = 0, instrHex = 0;
	
	for(cnt = 0; cnt < 8; )
	{
		instrHex <<= 8;
		
		instrHex_t = atoh(instr[cnt]);		// Read the first byte of instruction 
		instrHex_t <<= 4;
		instrHex_t |= atoh(instr[cnt+1]);	// Read the second byte of instruction 
		
		instrHex |= instrHex_t;		// Convert two bytes of instruction of ASCII hex form into one hex value 
		
		cnt += 2;
	}
	return instrHex;
}


// This function will be called by the CPU module 
// This will read the instruction present in the "instr" file 
// Unfortunately .txt file is not supported in the Veloce 
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
	
	if((PC/4) < count)				// case when the jump/branch instruciton goes backwards 
	{
		fseek(fp, 0, SEEK_SET);		// Go to start location of the file then count to the instruction reqeusted after branch 
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
			InstrArr[wrPtr++] = Instr_Hex;
			if(wrPtr >= 5)	// all array is full 
			{
				wrPtr = 0;
				sendFlg = 1;
			}
			return Instr_Hex;
		}
		else 
		{		
			printf("CounterInc: %d\n", count); 	
		}
	}
 
	// EOF is reached 
	fclose(fp);
	return 0xFFFFFFFF;
	
}

// Function Name: SendResOfProc 
// Parameters: ResultOfOprFlg
// Return: void 
// Description: This function will check if the instruction executed was succesfull or not 
// 				If the instruction was successfull then the counter is incremented else the 
//				error counter is incremented. 
//				In any case the result is updated in the Function coverage report file 
void SendResOfProc(int ResultOfOprFlg)
{
	TotalInstrRun++;
	printf("Operation was: %s\n", ResultOfOprFlg?("YES"):("NO"));
	ResultOfOprFlg ? (SuccsCnt++) : (ErrorCnt++);
	printf("SuccessCnt: %d\n", (SuccsCnt)?(SuccsCnt-1):(0));
	if(sendFlg)		// flag is set when the first 4 instruction result is ignored. 
	// This is done because the 1st instruction output will be available after the 5 clock edge  
	{
		FunctionalCoverage(InstrArr[rdPtr++], ResultOfOprFlg);		// store the resutl in the file 
		if(rdPtr >= 5)
			rdPtr = 0;
	}
}


// Function Name: OperationComplete
// Parameters: void
// Return: void 
// Description: This will execute when all the instruction are read from teh instruction memory file.
//				Once all the instructions are read the result of the functional coverage is updated 
//
void OperationComplete()
{
	char fcfp_arr[60] = {0};
	
	printf("The CPU operation is Over....\n");
	printf("Successful Operations: %d, Unsuccessful Operations: %d\n", SuccsCnt, ErrorCnt);
	
	// Function coverage report generate
	// Open the file if not opened 
	if(!Fc_fp)
	{
		printf("HVL: Opening file Instruction Memory.. \n");
		Fc_fp = fopen("FunctionalCoverage", "a");	
	}
	
	// Display the result in the file 
	fputs("\n---------------------------------------------------------------\n", Fc_fp);
	
	fputs("The functional coverage file contains the following information\n", Fc_fp);
	
	sprintf(fcfp_arr, "ADD:  Total: %d, \tCorrect : %d, \tError: %d\n", addCntr, addCrctResult, addErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "SUB:  Total: %d, \tCorrect : %d, \tError: %d\n", subCntr, subCrctResult, subErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "AND:  Total: %d, \tCorrect : %d, \tError: %d\n", andCntr, andCrctResult, andErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "XOR:  Total: %d, \tCorrect : %d, \tError: %d\n", xorCntr, xorCrctResult, xorErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "NOR:  Total: %d, \tCorrect : %d, \tError: %d\n", norCntr, norCrctResult, norErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "OR:   Total: %d, \tCorrect : %d, \tError: %d\n", orCntr, orCrctResult, orErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "SLT:  Total: %d, \tCorrect : %d, \tError: %d\n", sltCntr, sltCrctResult, sltErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "LW:   Total: %d, \tCorrect : %d, \tError: %d\n", lwopCntr, lwCrctResult, lwErrResult); 
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "ADDI: Total: %d, \tCorrect : %d, \tError: %d\n", addiCntr, addiCrctResult, addiErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "BEQ:  Total: %d, \tCorrect : %d, \tError: %d\n", beqCntr, beqCrctResult, beqErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "SW:   Total: %d, \tCorrect : %d, \tError: %d\n", swopCntr, swopCrctResult, swopErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "BNE:  Total: %d, \tCorrect : %d, \tError: %d\n", bneCntr, bneCrctResult, bneErrResult);
	fputs(fcfp_arr, Fc_fp);
	
	sprintf(fcfp_arr, "JMP:  Total: %d, \tCorrect : %d, \tError: %d\n", jopCntr, jopCrctResult, jopErrResult);
	fputs(fcfp_arr, Fc_fp);

	sprintf(fcfp_arr, "Total Operations: %d, Successful: %d, Error: %d\n",TotalInstrRun, SuccsCnt, ErrorCnt);
	fputs(fcfp_arr, Fc_fp);
	
	fputs("---------------------------------------------------------------\n", Fc_fp);
	fclose(Fc_fp);		// close the file 
}


