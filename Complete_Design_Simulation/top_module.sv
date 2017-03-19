`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// testbench_cpu: testbench file to test the complete cpu system. 
// ECE 571: SystemVerilog  |  Portland State University
// Engineer: Chetan	|	Daksh	|  Harsh
// Create Date: 03/10/2017 04:47:09 AM
// Design Name: 
// Module Name: top_module
// Description: 
// This module instantiates the following modules:
// 1. CPU (cpu)
// 2. checker interface (cchek)
// 3. Checker (check) 
//////////////////////////////////////////////////////////////////////////////////


module top_module( input wire clk, reset, pcEn,
                   input logic [31:0] inst,
                   output logic OpDone,
                   output logic [31:0] pc              
    );
  
    
    ccheck inf();
    cpu dut(clk, reset , inst, pc , inf , pcEn);
    check chk(inf , inst, clk, reset, pcEn , OpDone);
    
    
endmodule