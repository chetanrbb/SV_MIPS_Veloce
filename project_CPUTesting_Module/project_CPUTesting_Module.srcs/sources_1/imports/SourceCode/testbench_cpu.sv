`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2017 07:01:01 PM
// Design Name: 
// Module Name: testbench_cpu
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

import AluCtrlSig_pkg::*;

module testbench_cpu;

    logic [31:0] inst;
    logic clk = 0;
    logic [31:0] pc, pc4, pc4_s2;
    
    //internal
    logic [31:0] register;
    logic [31:0] inst_s1, inst_s2;
    
    logic [4:0] rs, rt, rs_s3;
    logic [4:0] opcode;
    logic [31:0] data1, data2;
    
    //////////////////////////////////////////
    // DUT
    /////////////////////////////////////////
    cpu dut (.clk(clk), .pc_temp(pc), .inst(inst));
    
    always
        #5 clk = ~clk;
    
    assign register = dut.regm1.mem[1];
    
    assign opcode = dut.opcode;
    assign rt = dut.rt;
    
    assign pc4 = dut.pc4;
    assign pc4_s2 = dut.pc4_s2;
    
    assign inst_s1 = dut.inst;
    assign inst_s2 = dut.inst_s2;
    
    assign rs = dut.rs;
    assign rs_s3 = dut.rs_s3;
    
    assign data1 = dut.data1;
    assign data2 = dut.data2;
    
    // control
    assign control_regwrite = dut.regwrite_s5;
    assign control_wrreg = dut.wrreg_s5;
    //assign control_wrdata = dut.wrdata_s5;    
    
    initial begin
        
        // SUB: Opcode + rs + rt +rd + shamt + funct
        @(posedge clk) inst = {6'd0, v0, v0, v0, 11'd06};
        repeat(8) @(posedge clk);
//        @(posedge clk) instr = {6'd0, 5'd2, 5'd2, 5'd2, 11'd06};
//        repeat(4) @(posedge clk);
//        // ADDI: Opcode + rs + rt + imm 
//        @(posedge clk) instr = {ADDI_op, 5'd1, 5'd1, 16'd10};
//        repeat(4) @(posedge clk);
           
         $stop;
                    
    end    
    
endmodule
