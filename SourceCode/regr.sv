`timescale 1ns / 10ps
// File Name: regr.sv 
// Original Source: https://github.com/jmahler/mips-cpu
// Modified by: Chetan B. | Harsh M. | Daksh D.
//
// Description: 
// regr - register of data that can be held or cleared
//
// The regr (register) module can be used to store data in the current
// cylcle so it will be output on the next cycle.  Signals are also
// provided to hold the data or clear it.  The hold and clear signals
// are both synchronous with the clock.
//

`ifndef _regr
`define _regr

module regr #(parameter N = 1)
(
	input logic  clk,
	input logic  clear,
	input logic  hold,
	input logic  [N-1:0] in,
	output logic [N-1:0] out);	

	
	always_ff @(posedge clk) 
	begin
		if (clear)				// clear the array 
			out <= {N{1'b0}};
		else if (hold)			// store the data for one clock cycle 
			out <= out;
		else	
			out <= in;			// read the data in the memory 
	end
endmodule

`endif
