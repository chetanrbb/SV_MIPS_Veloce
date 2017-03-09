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


//    logic [31:0] inst_s2, pc4_s2, pc4, data1_s3, data2_s3, pc4_s3;
//    logic [31:0] inst_temp;
//    logic [4:0] rs_s2, rt_s2, rs_s3, rt_s3;
//    logic [4:0] opcode;
//    logic [4:0] wrreg_s5;
//    logic [31:0] wrdata_s5;
//    logic regwrite_s5;
//    logic [31:0] data1_s2, data2_s2;
//    logic [4:0]  shamt_s2;
//    logic [31:0] jaddr_s2;
//    logic [31:0] seimm_s2;
    
    // control signals
//    logic		 regdst;
//    logic        branch_eq_s2;
//    logic        branch_ne_s2;
//    logic        memread;
//    logic        memwrite;
//    logic        memtoreg;
//    logic [1:0]  aluop;
//    logic        regwrite;
//    logic        alusrc;
//    logic        jump_s2;
//    logic		regdst_s3;
//    logic        memread_s3;
//    logic        memwrite_s3;
//    logic        memtoreg_s3;
//    logic [1:0]    aluop_s3;
//    logic        regwrite_s3;
//    logic        alusrc_s3;

//------------------------------------------------

//    assign inst_temp= dut.inst_temp;
//    assign rs_s2    = dut.rs;
//    assign opcode   = dut.opcode;
//    assign rt_s2    = dut.rt;
    
    // stage 2 signals
//    assign inst_s2  = dut.inst_s2;
//    assign pc4_s2   = dut.pc4_s2;
//    assign shamt_s2 = dut.shamt;
//    assign jaddr_s2 = dut.jaddr_s2;
//    assign seimm_s2 = dut.seimm;
//    assign data1_s2 = dut.data1;
//    assign data2_s2 = dut.data2; 
//    assign regdst   = dut.regdst;
//    assign branch_eq_s2 = dut.branch_eq_s2;
//    assign branch_ne_s2 = dut.branch_ne_s2;
//    assign memread  = dut.memread;
//    assign memwrite = dut.memwrite;
//    assign memtoreg = dut.memtoreg;
//    assign aluop    = dut.aluop;
//    assign regwrite = dut.regwrite;
//    assign alusrc   = dut.alusrc;
//    assign jump_s2  = dut.jump_s2;
     
    // Stage 3 signals
//    assign data1_s3     = dut.data1_s3;
//    assign data2_s3     = dut.data2_s3;    
//    assign rs_s3        = dut.rs_s3;
//    assign rt_s3        = dut.rt_s3;
//    assign pc4_s3       = dut.pc4_s3;
//    assign regdst_s3    = dut.regdst_s3;
//    assign memread_s3   = dut.memread_s3;
//    assign memwrite_s3  = dut.memwrite_s3;
//    assign memtoreg_s3  = dut.memtoreg_s3;
//    assign aluop_s3     = dut.aluop_s3;
//    assign regwrite_s3  = dut.regwrite_s3;
//    assign alusrc_s3    = dut.alusrc_s3;
    
    // Stafe 5 signals used by regm in stage 2
//    assign regwrite_s5 = dut.regwrite_s5;
//    assign wrreg_s5    = dut.wrreg_s5;
//    assign wrdata_s5   = dut.wrdata_s5; 


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
    logic [31:0]  register_v0,register_v1;
//    logic [31:0] register_t0, register_t1,register_t2,register_t3,register_t4,register_t5,register_t6,register_t7;

    
    // stage 1 signals
//    assign pc4      = dut.pc4;
    assign register_v0 = dut.regm1.mem[v0];
    assign register_v1 = dut.regm1.mem[v1];
    assign register_t0 = dut.regm1.mem[t0];
    assign register_t1 = dut.regm1.mem[t1];
    assign register_t2 = dut.regm1.mem[t2];
    assign register_t3 = dut.regm1.mem[t3];
    assign register_t4 = dut.regm1.mem[t4];
    assign register_t5 = dut.regm1.mem[t5];
    assign register_t6 = dut.regm1.mem[t6];
    assign register_t7 = dut.regm1.mem[t7];

    
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
        
        // clearing all registers
        //SUB: Opcode + rs + rt +rd + shamt + funct
        @(posedge clk) inst = {6'd0, v0, v0, v0, 11'd06};
        @(posedge clk) inst = {6'd0, v1, v1, v1, 11'd06};
        @(posedge clk) inst = {6'd0, t0, t0, t0, 11'd06};
        @(posedge clk) inst = {6'd0, t1, t1, t1, 11'd06};
        @(posedge clk) inst = {6'd0, t2, t2, t2, 11'd06};
        @(posedge clk) inst = {6'd0, t3, t3, t3, 11'd06};
        @(posedge clk) inst = {6'd0, t4, t4, t4, 11'd06};
        @(posedge clk) inst = {6'd0, t5, t5, t5, 11'd06};
        @(posedge clk) inst = {6'd0, t6, t6, t6, 11'd06};
        @(posedge clk) inst = {6'd0, t7, t7, t7, 11'd06};
        

        // ADDI: Opcode + rs + rt + imm    v0->10   v1->22       
        @(posedge clk) inst = {ADDI_op, v0, v0, 16'd10};
        @(posedge clk) inst = {ADDI_op, v1, v1, 16'd22};
        
        // ADD operation //t0 -> 'd32
        @(posedge clk) inst = {ADD_op, v0, v1, t0, 11'd02};
        
        // SUB opeartion // t1 -> 'd22
        @(posedge clk) inst = {ADD_op, t0, v0, t1, 11'd06};
        
        // AND operation // t2 -> 'd00  
        @(posedge clk) inst = {ADD_op, t0, t1, t2, 11'd00};
        
        // NOR operation // t3 -> 'hffffffe9
        @(posedge clk) inst = {ADD_op, t1, t2, t3, 11'd12};
        
        // OR operation // t4 -> 'hffffffff
        @(posedge clk) inst = {ADD_op, t1, t3, t4, 11'd01};
        
        // XOR operation // t5 -> 'd22
        @(posedge clk) inst = {ADD_op, t4, t3, t5, 11'd13};
        
        // SLT operation // t6 -> 1
        @(posedge clk) inst = {ADD_op, t1, t0, t6, 11'd07};
                       
//        // JUMP operation // PC -> 'd16
//        @(posedge clk) inst = {JMP_op, 26'd4};
        
        // SUB operation // v0 -> 'd0
        @(posedge clk) inst = {ADD_op, v0, v0, v0, 11'd06};
        
        // SUB operation // v1 -> 'd0
        @(posedge clk) inst = {ADD_op, v1, v1, v1, 11'd06};
        
        repeat(5) @(posedge clk);
        
        //BEQ operation // PC -> 
        @(posedge clk) inst = {BEQ_op, v0,t1, 16'd8};
        
        //BNEQ operation // PC -> 
        @(posedge clk) inst = {BNE_op, v0,t1, 16'd8};
        
        //@(posedge clk) inst = 'z;
        //repeat(5) @(posedge clk);
           
         
                    
    end    
    
endmodule
