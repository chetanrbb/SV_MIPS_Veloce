`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2017 07:20:58 PM
// Design Name: 
// Module Name: tb_alu
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
// ADD = 4'd00, 
// SUB = 4'd01, 
// AND = 4'd02, 
// NOR = 4'd03, 
// OR  = 4'd04, 
// SLT = 4'd05, 
// XOR = 4'd06
//
//
//////////////////////////////////////////////////////////////////////////////////


module tb_alu;

    logic	[3:0]	ctl;
    logic 	[31:0]	a, b;
    logic	[31:0]	out;
    logic 			zero;
    integer i;
    logic clk;
    alu tb(.*);
    
    initial begin
    clk = 0;
    end
    
    always #5 clk = ~clk;
    
    initial begin
    
    for (i=0; i<=50;i++) begin
        
//        @(posedge clk) a = 32'b1111;b = 32'b1011;
        
        a = $random % 32'hFFFF;
        b = $random % 32'hFFFF;
        ctl = $urandom_range(0,6);
        #10;
        if (ctl == 'd0) $display("Test number: %d Input1: %32d Input2: %32d Output of ADD: %32d Zero: %d",i,a,b,out,zero);
        else if (ctl == 'd1) $display("Test number: %d Input1: %32d Input2: %32d Output of SUB: %32d Zero: %d",i,a,b,out,zero);
        else if (ctl == 'd2) $display("Test number: %d Input1: %32d Input2: %32d Output of AND: %32d Zero: %d",i,a,b,out,zero);
        else if (ctl == 'd3) $display("Test number: %d Input1: %32d Input2: %32d Output of NOR: %32d Zero: %d",i,a,b,out,zero);
        else if (ctl == 'd4) $display("Test number: %d Input1: %32d Input2: %32d Output of OR: %32d Zero: %d",i,a,b,out,zero);
        else if (ctl == 'd5) $display("Test number: %d Input1: %32d Input2: %32d Output of SLT: %32d Zero: %d",i,a,b,out,zero);
        else if (ctl == 'd6) $display("Test number: %d Input1: %32d Input2: %32d Output of XOR: %32d Zero: %d",i,a,b,out,zero);
        else $display("Error");
        
    end
    
    end  

endmodule
