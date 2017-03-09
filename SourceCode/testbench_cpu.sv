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
    logic [31:0] register_v1, register_v0, register_t1, register_t0;
    logic [31:0] inst_s2, pc4_s2, pc4, data1_s3, data2_s3, pc4_s3;
//    logic [31:0] inst_temp;
    logic [4:0] rs_s2, rt_s2, rs_s3, rt_s3;
    logic [4:0] opcode;
    logic [4:0] wrreg_s5;
    logic [31:0] wrdata_s5;
    logic regwrite_s5;
    logic [31:0] data1_s2, data2_s2;
    logic [4:0]  shamt_s2;
    logic [31:0] jaddr_s2;
    logic [31:0] seimm_s2, seimm_s3;
    
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
    logic		regdst_s3;
    logic        memread_s3;
    logic        memwrite_s3;
    logic        memtoreg_s3;
    logic [1:0]    aluop_s3;
    logic        regwrite_s3;
    logic        alusrc_s3;
    logic [31:0] memory_access;
    logic [6:0] mem_loc; 
    logic [31:0] alusrc_data2, fw_data1_s3, alurslt, data2_s4;
    
    assign mem_loc       = dut.dm1.addr;
    assign memory_access = dut.dm1.mem[7'd15];
    
    // stage 1 signals
    assign pc4      = dut.pc4;
    assign register_v0 = dut.regm1.mem[v0];
    assign register_v1 = dut.regm1.mem[v1];
    assign register_t0 = dut.regm1.mem[t0];
    assign register_t1 = dut.regm1.mem[t1];
    
//    assign inst_temp= dut.inst_temp;
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
    assign data1_s3     = dut.data1_s3;
    assign data2_s3     = dut.data2_s3;    
    assign rs_s3        = dut.rs_s3;
    assign rt_s3        = dut.rt_s3;
    assign pc4_s3       = dut.pc4_s3;
    assign regdst_s3    = dut.regdst_s3;
    assign memread_s3   = dut.memread_s3;
    assign memwrite_s3  = dut.memwrite_s3;
    assign memtoreg_s3  = dut.memtoreg_s3;
    assign aluop_s3     = dut.aluop_s3;
    assign regwrite_s3  = dut.regwrite_s3;
    assign alusrc_s3    = dut.alusrc_s3;
    assign seimm_s3     = dut.seimm_s3;
    assign alusrc_data2 = dut.alusrc_data2;
    assign fw_data1_s3  = dut.fw_data1_s3;
    assign alurslt      = dut.alurslt;
    
    // Stage 4 signals
    logic [6:0] AddrToDataMem;
    logic [31:0] DataMemWriteData, DataMemReadData;
    logic memwrite_s4, memread_s4;
    logic [31:0] alurslt_s4;
    
    assign AddrToDataMem   = dut.alurslt_s4[8:2];
    assign memwrite_s4     = dut.memwrite_s4;
    assign memread_s4      = dut.memread_s4;
    assign DataMemWriteData= dut.data2_s4;
    assign DataMemReadData = dut.rdata;
    
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
//        @(negedge clk) reset = 1'b0;               
//        repeat(1) @(posedge clk); 
        
        //SUB: Opcode + rs + rt +rd + shamt + funct
//        repeat(2) @(posedge clk);
        @(posedge clk) inst = {6'd0, v0, v0, v0, 11'd06};
//        @(posedge clk) inst = 'z;
//        repeat(5) @(posedge clk);
        @(posedge clk) inst = {6'd0, v1, v1, v1, 11'd06};
//        repeat(5) @(posedge clk);
        // ADDI: Opcode + rs + rt + imm 
        
        // Insert value 20 into register v0
        @(posedge clk) inst = {ADDI_op, v0, v0, 16'd10};
        // Insert value 20 into register v1 
        @(posedge clk) inst = {ADDI_op, v1, v1,16'd20};
        //t0 = v0 - v1 
        @(posedge clk) inst = {6'd0, v1, v0, t0, 11'd6};
        // Clear t1 register
        @(posedge clk) inst = {6'd0, t1, t1, t1, 11'd06};
        //
        //  Eg.: sw $2, 32($1)  ; I-type, rt_s2 = $2, rs_s2 = $1, memread_s2 = 0
        //  sw $rt, offset($rs)
        //  rt = t0, rs = t1
        @(posedge clk) inst = {SW_op, t1, t0, 16'h0003C};
        // Clear t3 register
//        @(posedge clk) inst = {6'd0, t3, t3, t3, 11'd06};
        //  lw  $1, 16($3)  ; I-type, rt_s3 = $1, memread_s3 = 1
        @(posedge clk) inst = {LW_op, t1, v1, 16'h0003C};
        @(posedge clk) inst = 'z; 
        repeat(5) @(posedge clk);
           
         $stop;
                    
    end    
    
endmodule
