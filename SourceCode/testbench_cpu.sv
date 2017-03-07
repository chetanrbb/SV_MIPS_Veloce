`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
//  testbench_cpu: testbench file to test the complete cpu system. 
//  ECE 571: SystemVerilog  ||  Portland State University
//  Engineer: Chetan B.     ||  Daksh D.    ||  Harsh M.
//  
// Create Date: 03/06/2017 07:01:01 PM
// Design Name: cpu
// Module Name: testbench_cpu
// Project Name: Verification of 5-stage mips processor with static branch predictor 
// Target Devices: Mentor Graphics Veloce 
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
    logic clk = 0, reset = 0;
    logic [31:0] pc;
    
    //internal
    logic [31:0] register;
    logic [31:0] inst_s2, pc4_s2, pc4, data1_s3, data2_s3, pc4_s3;
    logic [31:0] inst_temp;
    logic [4:0] rs_s2, rt_s2, rs_s3, rt_s3;
    logic [4:0] opcode;
    logic [4:0] wrreg_s5;
    logic [31:0] wrdata_s5;
    logic regwrite_s5;
    logic [31:0] data1_s2, data2_s2;
    logic [4:0]  shamt_s2;
    logic [31:0] jaddr_s2;
    logic [31:0] seimm_s2;
    // control signals
    logic		 regdst;
    logic        branch_eq_s2;
    logic        branch_ne_s2;
    logic        memread;
    logic        memwrite;
    logic        memtoreg;
    logic [1:0]  aluop;
    logic        regwrite;
    logic        alusrc;
    logic        jump_s2;
    
    // stage 1 signals
    assign pc4      = dut.pc4;
    assign register = dut.regm1.mem[v0];
    assign inst_temp= dut.inst_temp;
    assign rs_s2    = dut.rs;
    assign opcode   = dut.opcode;
    assign rt_s2    = dut.rt;
    
    // stage 2 signals
    assign inst_s2  = dut.inst_s2;
    assign pc4_s2   = dut.pc4_s2;
    assign shamt_s2 = dut.shamt;
    assign jaddr_s2 = dut.jaddr_s2;
    assign seimm_s2 = dut.seimm;
    assign data1_s2 = dut.data1;
    assign data2_s2 = dut.data2; 
    assign regdst   = dut.regdst;
    assign branch_eq_s2 = dut.branch_eq_s2;
    assign branch_ne_s2 = dut.branch_ne_s2;
    assign memread  = dut.memread;
    assign memwrite = dut.memwrite;
    assign memtoreg = dut.memtoreg;
    assign aluop    = dut.aluop;
    assign regwrite = dut.regwrite;
    assign alusrc   = dut.alusrc;
    assign jump_s2  = dut.jump_s2;
     
    // Stage 3 signals
    assign data1_s3 = dut.data1_s3;
    assign data2_s3 = dut.data2_s3;    
    assign rs_s3    = dut.rs_s3;
    assign rt_s3    = dut.rt_s3;
    assign pc4_s3    = dut.pc4_s3;
    
    // Stafe 5 signals used by regm in stage 2
    assign regwrite_s5 = dut.regwrite_s5;
    assign wrreg_s5    = dut.wrreg_s5;
    assign wrdata_s5   = dut.wrdata_s5; 
    //////////////////////////////////////////
    // DUT
    /////////////////////////////////////////
    cpu dut(.clk(clk), .pc(pc), .inst(inst));
    
    
    //////////////////////////////////////////
    // Clock 
    //////////////////////////////////////////
    always
        #5 clk = ~clk;
    
    initial begin
        
//        @(negedge clk) reset = 1'b1;
        @(negedge clk) reset = 1'b0;               
        repeat(1) @(posedge clk); 
        
        //SUB: Opcode + rs + rt +rd + shamt + funct
//        repeat(2) @(posedge clk);
        @(posedge clk) inst = {6'd0, v0, v0, v0, 11'd06};
//        @(posedge clk) inst = 'z;
//        repeat(5) @(posedge clk);
        @(posedge clk) inst = {6'd0, v1, v1, v1, 11'd06};
//        repeat(5) @(posedge clk);
        // ADDI: Opcode + rs + rt + imm 
        
        @(posedge clk) inst = {ADDI_op, v0, v0, 16'd10};
        @(posedge clk) inst = 'z;
        repeat(5) @(posedge clk);
           
         $stop;
                    
    end    
    
endmodule
