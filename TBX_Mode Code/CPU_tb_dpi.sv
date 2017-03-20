

///////////////////////////////////////////////////
// File Name: CPU_tb_dpi.sv
// 
// Author: Chetan B. | Harsh M. | Daksh Dharod
//
// Description: 
// 1. The PC is issed by the CPU and the request will be given to the instruction memory from this module. 
// 2. This file will check the CPU model. This module will read the instruction from the instruction memory and give it to the CPU module for computation. 
// 3. After the computation is done on teh CPU module then the CPU will send a flag to indicate that the operaiton is completed.
// 4. On receiving the operation complete flag it will check if the Instructino read is over or not. 
// 5. If the instruction read is not over then teh result will be sent to the HVL. If the instruction read is over then the operation terminate will be called. 
//
// All the functions are defined in the testbench.cxx file 
// 
////////////////////////////////////////////////////////
`timescale 1ns / 10ps
module CPU_tb_dpi;

// Variables
logic clk 		= 0;			// generate the clock for the system
logic resetH 	= 0;			// reset the system 
logic OprDnFlg 	;			// Flag will be set by the CPU module when the operation is over 
int ResultOfOprFlg = 0;		// This flag will indicate if the previous operation was a success or a failure. It will be set by the checker or the CPU module
int PC;
int instr = '0;
logic [31:0] cnt = 0;
logic En = '0;
logic [31:0]ClkCntr = 0, FlushCntr = 0;
logic [31:0] ClkCntrDisp = 0;

// Import the functions from the testbench.cxx file
import "DPI-C" pure function void ResetOpr();
import "DPI-C" pure function int  GetInstrFmMem(int PC);
import "DPI-C" pure function void SendResOfProc(int ResultOfOprFlg);
import "DPI-C" pure function void OperationComplete();


// Variables for Checker module 
ccheck inf ();

// Instantiate the module: CPU
cpu CPU_tb(.clk(clk), .reset(resetH), .pcEn(En), .pc(PC), .inst(instr), .B(inf));		// InstrOvr is not used for now 

// Instantiate the module Checker 
check checker_tb(inf, instr, clk, resetH, En, OprDnFlg);

// Initial Conditions
// tbx clkgen
initial
begin
	clk = 0;			// reset the clock to an initial state 
	forever #5ns clk = ~clk;	// generate clock 
end

// Initial block to generate the reset 
//tbx clkgen
initial 
begin
	resetH = 1;			// activate the reset signal 
	#20ns resetH = 0;		// deactivate the reset signal 
end

initial 
begin 
	@ (posedge clk);
	while (resetH) @ (posedge clk);
	ResetOpr();			// call for the reset operation which will display the message on the console
end

// This module will handle the instruction fetch 
// When it gets the instruction from the memory it will pass it to the CPU module. 
//After the instructino is over the result of the instruction will be sent to a functional coverage module.
//If all teh instructions are read then the result will be updated in the functional coverage and the operation
// is terminated. 

always @ (posedge clk)
begin
	ClkCntrDisp <= ClkCntrDisp + 1;
	if(resetH == 0)		// run the logic when there is no reset 
	begin
		En <= 1;
	
		if(En)
		begin
		if(instr != 32'hFFFFFFFF)
		begin
			instr = GetInstrFmMem(PC);	// get instructino from memory 
		end
		
			if(OprDnFlg)		
			begin
				ResultOfOprFlg = 1;		// If the operation of the result was successful then updated the FC 
			end
			else
			begin
				ResultOfOprFlg = 0;		// If the result was not successful then update the error count in the FC
			end
			SendResOfProc(ResultOfOprFlg);		// the result will be sent by the Checker/CPU module indicating the operation is over 
			
			if(instr == 32'hFFFFFFFF) 
			begin
				if(FlushCntr < 3)				//This wil be used to flush the remaining instructions in the pipeline
				begin
					FlushCntr <= FlushCntr + 1;
				end
				else
				begin
					OperationComplete();		// If all the instructions 
					$finish;
				end
			end
			
		end
	end

end
endmodule


