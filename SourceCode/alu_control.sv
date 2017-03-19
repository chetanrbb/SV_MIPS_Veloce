`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Daksh Dharod
//			 Harsh Momaya
//			 Chetan Bornarkar
// 
// Create Date: 03/06/2017 08:38:17 PM
//
// Source: Github
//
// Module Name: alu_control.sv - this file generates control signals for alu module.
//
// Description: alu_control calls the alu control operation. The function parameter will store the operation to be conducted.
//				The aluop parameter will decide the opeation to be done directly or to be done from the funciton block 
//
//////////////////////////////////////////////////////////////////////////////////



`ifndef _alu_control
`define _alu_control

module alu_control(
		input logic  [5:0] funct,
		input logic  [1:0] aluop,
		output logic [5:0] aluctl);
	
	// importing the alu package
	import AluCtrlSig_pkg::*;

	// creating instance of AluOp_t
	AluOp_t AluCtrlSig;
	
	logic [5:0] _funct;
	
	// For add opcode, the funct bits are checked and the based on that control signals are generated.
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
	
	// Based on alu opcode, the control signals are generated.
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
