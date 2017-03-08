`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2017 06:45:54 PM
// Design Name: 
// Module Name: regm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regm_tb;

    logic			clk;
	logic    [4:0]	read1, read2;
	logic    [31:0]	data1, data2;
	logic			regwrite;
	logic	[4:0]	wrreg;
	logic	[31:0]	wrdata;
	integer i,j,k=1,c,l=1;
	logic [31:0][31:0] x;
    logic [31:0][31:0] y;
   

	
	regm tb(.*);
	
	initial begin
	clk = 1'b1;
	end
	
	always #5 clk = ~ clk;
	
	initial begin
	regwrite = 1;
	
	for (i=0; i<32;i++) begin
	wrreg = i;
	wrdata = $urandom % 4'hFFFF;
	if(i==0) x[i] = 0;
    else     x[i] = wrdata;
	#10;
	$display("Writing to register: %d",i);
	end
	
    regwrite = 0;
    read1=0;
    #340;
    if(x[0] == data1) $display("Correct Functionality at reg 0");
    else $display("Error at 0");
    
    #320;
	for (j=0; j<16;j++) begin
	read1 = k;
	read2 = k+1;
	#10;
	if(k == 31 && data1 == x[k]) $display("Correct Functionality at reg%d value is %d",k,data1);
	else if (data1 == x[k] && data2 == x[k+1]) 	$display("Correct Functionality at reg%d value is %d and reg%d value is %d",k,data1,k+1,data2);
	else $display("NO at %d and %d",k,k+1);
	k = k+2; 
	end	
	end
    



endmodule
