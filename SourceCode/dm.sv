`timescale 1ns / 10ps

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// dm.sv: Data memory of cpu
// ECE 571	|	Portland State University
// Source: https://github.com/jmahler/mips-cpu 	
// Engineer: Daksh Dharod
//			 Harsh Momaya
//			 Chetan Bornarkar
// 
// Create Date: 03/06/2017
//
// Description: 
// 1. Data is asyncronously read from memory.
// 2. Data is writen on clock edge based on address.
// 3. Memory is implemented as unpacked array.
//
// No modifications
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////			

`ifndef _dm
`define _dm

module dm(
		input logic			clk,
		input logic	 [6:0]	addr,
		input logic			rd, wr,
		input logic  [31:0]	wdata,
		output logic [31:0]	rdata);

	reg [31:0] mem [0:127];  // 32-bit memory with 128 entries

    initial
        foreach(mem[i]) mem[i][31:0] = '1; 
	
	assign rdata = wr ? wdata : mem[addr][31:0];  // During a write, avoid the one cycle delay by reading from 'wdata'
	
	
	always_ff @(posedge clk) 
	begin
		if (wr) begin
			mem[addr] <= wdata;
		end
	end

endmodule

`endif
