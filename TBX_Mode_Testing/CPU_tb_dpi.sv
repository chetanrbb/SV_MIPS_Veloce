

///////////////////////////////////////////////////
// File Name: CPU_tb_dpi.sv
// 
// Author: Chetan
//
// Description: 
// 1. This file will check the CPU model. This module will read the nstruction from the instruction memory and give it to the CPU module for computation. 
// 2. After the computation is done on teh CPU module then the CPU will send a flag to indicate that the operaiton is completed.
// 3. On receiving the operation complete flag it will check if the Instructino read is over or not. 
// 4. If the instruction read is not over then teh result will be sent to the HVL. If the instruction read is over then the operation terminate will be called. 
////////////////////////////////////////////////////////
`timescale 1ns / 10ps
module CPU_tb_dpi;

// Variables
logic clk 		= 0;			// generate the clock for the system
logic resetH 	= 0;			// reset the system 
logic OprDnFlg 	= 0;			// Flag will be set by the CPU module when the operation is over 
int ResultOfOprFlg = 0;		// This flag will indicate if the previous operation was a success or a failure. It will be set by the checker or the CPU module
int PC;
int instr = '0;



// Import the functions from the CPU_tb.cxx file
import "DPI-C" pure function void ResetOpr();
import "DPI-C" pure function int  GetInstrFmMem(int PC);
import "DPI-C" pure function void SendResOfProc(int ResultOfOprFlg);
import "DPI-C" pure function void OperationComplete();


// Variables for Checker module 
//logic InstrOvr = 0;		// Instruction Over flag will be set when the Instruction memory is over 

// Instantiate the module: CPU
cpu CPU_tb(.clk, .reset(resetH), .pc(PC), .inst(instr));		// InstrOvr is not used for now 

// Instantiate the module Checker 
//Checker checker_tb(.clk, .instr, .OprDnFlg);

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
	#20 resetH = 0;		// deactivate the reset signal 
end 

initial 
begin
	@(posedge clk);
	while (resetH) @ (posedge clk);
	ResetOpr();			// call for the reset operation which will display the message on the console
end

always @ (posedge clk)
begin
	if(resetH == 0)		// run the logic when there is no reset 
	begin
		// 1. Read the instruction from the memory 
		// This will read the instruction stored in the instruction memory as per the PC count 
		@(posedge clk);
		instr = GetInstrFmMem(PC);
		$display("%d", instr);
		$display("Done with the getting of the instruction function\n");
		// 2. Wait till the operation from the CPU and the checker is over 
		//while (!OprDnFlg)
		//@ (posedge clk);
			
		// 3. If the Instruction memory is over then call the Operation complete 
		// 	  else if the instruction memory is not over then Send the data to the HVL to be displayed on the console. 
		//if(InstrOvr)	// InstrOvr will be set when the stop instruction is read 
		//begin
		//	OperationComplete();		// Entire operation is over 
		//	$finish;
		//end
		//else
		//begin
			SendResOfProc(ResultOfOprFlg);		// the result will be sent by the Checker/CPU module indicating the operation is over 
			$display("Done with the Sending the result of instruction \n");
		//end
		$finish;
	end

end
endmodule


