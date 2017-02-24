
// call the alu control operation 
// the function parameter will store the operation to be conducted 
// the aluop parameter will decide the opeation to be done directly or to be done from the funciton block 


`ifndef _alu_control
`define _alu_control

`include AluCtrlSig_pkg.h


module alu_control(
		input logic  [5:0] funct,
		input logic  [1:0] aluop,
		output logic [3:0] aluctl);

	import AluCtrlSig_pkg::*;
	
	AluCtrlSig_t AluCtrlSig;
	
	logic [3:0] _funct;

	always_comb 
	begin
		unique case(funct[3:0])
			ADD:  _funct = 4'd2;		// add 
			SUB:  _funct = 4'd6;		// sub 
			OR:   _funct = 4'd1;		// or 
			XOR:  _funct = 4'd13;		// xor 
			NOR:  _funct = 4'd12;		// nor 
			SLT:  _funct = 4'd7;		// slt 
			default: _funct = 4'd0;
		endcase
	end

	always_comb begin
		case(aluop)
			2'd0: aluctl = 4'd2;	/* add */
			2'd1: aluctl = 4'd6;	/* sub */
			2'd2: aluctl = _funct;
			2'd3: aluctl = 4'd2;	/* add */
			default: aluctl = 0;
		endcase
	end

endmodule

`endif
