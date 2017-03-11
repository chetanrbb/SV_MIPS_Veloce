`timescale 1ns / 10ps
// call the alu control operation 
// the function parameter will store the operation to be conducted 
// the aluop parameter will decide the opeation to be done directly or to be done from the funciton block 


`ifndef _alu_control
`define _alu_control

module alu_control(
		input logic  [5:0] funct,
		input logic  [1:0] aluop,
		output logic [5:0] aluctl);

	import AluCtrlSig_pkg::*;

	
	AluOp_t AluCtrlSig;
	
	logic [5:0] _funct;

	always_comb 
	begin
		unique case(funct[5:0])
			ADD:  _funct <= 6'h20;		// add 
			SUB:  _funct <= 6'h22;		// sub 
			OR:   _funct <= 6'h25;		// or 
			XOR:  _funct <= 6'h13;		// xor 
			NOR:  _funct <= 6'h27;		// nor 
			SLT:  _funct <= 6'h2A;		// slt 
			default: _funct <= 6'h24;    // And
		endcase
	end

	always_comb begin
		case(aluop)
			2'd0: aluctl <= 6'h20;	/* add */
			2'd1: aluctl <= 6'h22;	/* sub */
			2'd2: aluctl <= _funct;
			2'd3: aluctl <= 6'h20;	/* add */
			default: aluctl <= 0;
		endcase
	end

endmodule

`endif
