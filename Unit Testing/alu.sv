//////////////////////////////////////////////////////////////////////////////////
// <alu.sv> - The following file performs the alu operation based on control signals.
// 
// Source: Github
// Modified by: Daksh Dharod (daksh@pdx.edu)
//
// Description: This module will take the inputs of a and b and do the operaiton as per the control signals given to it. 
// 				If the result of the operation is zero then the zero flag is set else the output of the operation is 
// 				given out of the out signal. 
//
// Modifications: The typedef values for different operations are modified to make the checking easy. These changes are only done for unit testing.  
//////////////////////////////////////////////////////////////////////////////////


`ifndef _alu
`define _alu

module alu(
		input  logic	[3:0]	ctl,
		input  logic 	[31:0]	a, b,
		output logic	[31:0]	out,
		output logic 			zero);

	enum logic [3:0] {
		        ADD = 4'd00, 
                SUB = 4'd01, 
                AND = 4'd02, 
                NOR = 4'd03, 
                OR  = 4'd04, 
                SLT = 4'd05, 
                XOR = 4'd06

	} AluOp;
	
	// internal signals	
	logic [31:0] sub_ab;
	logic [31:0] add_ab;
	logic   	 oflow_add;				// consider the overflow of the addition and subtraction to keep the sign same 
	logic 		 oflow_sub;
	logic 		 oflow;
	logic 		 slt;

	assign zero = (0 == out);
	assign sub_ab = a - b;				// add the signal/subtract the signals
	assign add_ab = a + b;

	// Overflow occurs (with 2s complement numbers) when
	// the operands have the same sign, but the sign of the result is
	// different.  The actual sign is the opposite of the result.
	// It is also dependent on whether addition or subtraction is performed.
	
	assign oflow_add = (a[31] == b[31] && add_ab[31] != a[31]) ? 1 : 0;
	assign oflow_sub = (a[31] == b[31] && sub_ab[31] != a[31]) ? 1 : 0;

	assign oflow = (ctl == 4'b0010) ? oflow_add : oflow_sub;

	// set if less than, 2s compliment 32-bit numbers
	assign slt = oflow_sub ? ~(a[31]) : a[31];

	always_comb 
	begin
		unique case (ctl)
			ADD:  out <= add_ab;				// add 
			AND:  out <= a & b;				    // and 
			NOR:  out <= ~(a | b);				// nor 
			OR:   out <= a | b;				    // or 
			SLT:  out <= {{31{1'b0}}, slt};		// slt 
			SUB:  out <= sub_ab;				// sub 
			XOR:  out <= a ^ b;				    // xor 
			default: out <= 0;
		endcase
	end

endmodule

`endif
