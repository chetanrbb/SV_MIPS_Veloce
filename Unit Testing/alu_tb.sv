`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University
// Engineer: Daksh Dharod
// 
// Create Date: 03/05/2017 07:20:58 PM
// Module Name: alu_tb
// Description: The following module provides various inputs randomly generated using random functions.
// 				Also the control signals are randomly varied with different input combinations. 
//				The outputs and the zero flag is displayed.
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
	
	// alu module is instantiated
    alu tb(.*);
    
    initial begin
    clk = 0;
    end
    
    always #5 clk = ~clk;
    
    initial begin
    
	// randomly genrated inputs along with control signals are provided and output is displayed
    for (i=0; i<=50;i++) begin
        
        
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
