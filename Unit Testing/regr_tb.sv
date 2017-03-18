`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University
// Engineer: Daksh Dharod
// Create Date: 03/06/2017 06:18:19 PM
// Module Name: regr_tb
// 
// Description: The following testbench generates inputs randomly and the outputs is checked.
// 				
//
// 
//////////////////////////////////////////////////////////////////////////////////


module regr_tb;

    logic  clk;
	logic  clear;
	logic  hold;
	logic  [7:0] in;
	logic [7:0] out;
	integer i;
	
	regr tb(.*);
	initial begin
	clk = 1'b1;
	end
	
	always #5 clk = ~clk;
	
	initial begin
	clear = 1;
	#30;
	clear = 0;
	
	for (i=0;i<10; i++) begin
	   in = $random % 8'hFF; 
	   if (i==5) hold = 1'b1;
	   if (i==8) hold = 1'b0;
	   #10;
	end
	
	end   
	
endmodule
