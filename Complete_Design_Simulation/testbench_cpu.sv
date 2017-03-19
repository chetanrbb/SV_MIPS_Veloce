`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
//  testbench_cpu: testbench file to test the complete cpu system. 
//  ECE 571: SystemVerilog  |  Portland State University
//  Engineer: Chetan	|	Daksh	|  Harsh
//  
// Create Date: 03/06/2017 07:01:01 PM
// Design Name: cpu
// Module Name: testbench_cpu
// Project Name: Verification of 5-stage mips processor with static branch predictor 
// Target Devices: Mentor Graphics Veloce 
// Tool Versions: 
// Description: 
// 1. instantiates the top_module file and drives the followign input signals: 
//		clk, reset, pcEn, OpDone 
// 
// 2. Internal cpu are accessed using dot operator
// 3. All internal signals and buses were viewed on Questa simulator to check
//	  their arrival time and their value.
// 4. $readmemh was used to read a chunck of instructions and was loaded in an array.
// 5. At every pasedge instruction was accessed from the array based on PC value
/////////////////////////////////////////////////////////////////////////////////////

module testbench_cpu;

    logic [31:0] inst;
    logic clk = 0, reset = 0;
    logic [31:0] pc;
    logic [31:0] instr_arr[800];
    logic pcEn, OpDone;
    
    //internal
//    import AluCtrlSig_pkg::*;
        enum logic [4:0] {
            v0 = 5'd2,
            v1 = 5'd3,
            t0 = 5'd8,
            t1 = 5'd9,
            t2 = 5'd10,
            t3 = 5'd11,
            t4 = 5'd12,
            t5 = 5'd13,
            t6 = 5'd14,
            t7 = 5'd15
        } data_reg;  
          
    logic [31:0] register_v1, register_v0, register_t1, register_t0, register_t3, register_t4, register_t5;
    logic [31:0] register_t6, register_t7, register_t2;  
//    logic [31:0] inst_s2, pc4_s2, pc4, data1_s3, data2_s3, pc4_s3;
//    logic [4:0] rs_s2, rt_s2, rs_s3, rt_s3;
//    logic [4:0] opcode;
//    logic [4:0] wrreg_s5;
//    logic [31:0] wrdata_s5;
//    logic regwrite_s5;
//    logic [31:0] data1_s2, data2_s2;
//    logic [4:0]  shamt_s2;
//    logic [31:0] jaddr_s2;
//    logic [31:0] seimm_s2, seimm_s3;
    
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
//    logic [31:0] memory_access;
//    logic [6:0] mem_loc; 
//    logic [31:0] alusrc_data2, fw_data1_s3, alurslt, data2_s4;
    
//    assign mem_loc       = tp.dut.dm1.addr;
//    assign memory_access = tp.dut.dm1.mem[7'd15];
    
    // stage 1 signals
//    assign pc4      = tp.dut.pc4;
    assign register_v0 = tp.dut.regm1.mem[2];
    assign register_v1 = tp.dut.regm1.mem[3];
    assign register_t0 = tp.dut.regm1.mem[8];
    assign register_t1 = tp.dut.regm1.mem[9];
    assign register_t3 = tp.dut.regm1.mem[10];
    assign register_t2 = tp.dut.regm1.mem[11];
    assign register_t4 = tp.dut.regm1.mem[12];
    assign register_t5 = tp.dut.regm1.mem[13];
    assign register_t6 = tp.dut.regm1.mem[14];
    assign register_t7 = tp.dut.regm1.mem[15];
        

//    assign rs_s2    = tp.dut.rs;
//    assign opcode   = tp.dut.opcode;
//    assign rt_s2    = tp.dut.rt;
    
//    // stage 2 signals
//    assign inst_s2  = tp.dut.inst_s2;
//    assign pc4_s2   = tp.dut.pc4_s2;
//    assign shamt_s2 = tp.dut.shamt;
//    assign jaddr_s2 = tp.dut.jaddr_s2;
//    assign seimm_s2 = tp.dut.seimm;
//    assign data1_s2 = tp.dut.data1;
//    assign data2_s2 = tp.dut.data2; 
//    assign regdst   = tp.dut.regdst;
//    assign branch_eq_s2 = tp.dut.branch_eq_s2;
//    assign branch_ne_s2 = tp.dut.branch_ne_s2;
//    assign memread  = tp.dut.memread;
//    assign memwrite = tp.dut.memwrite;
//    assign memtoreg = tp.dut.memtoreg;
//    assign aluop    = tp.dut.aluop;
//    assign regwrite = tp.dut.regwrite;
//    assign alusrc   = tp.dut.alusrc;
//    assign jump_s2  = tp.dut.jump_s2;
     
//    // Stage 3 signals
//    assign data1_s3     = tp.dut.data1_s3;
//    assign data2_s3     = tp.dut.data2_s3;    
//    assign rs_s3        = tp.dut.rs_s3;
//    assign rt_s3        = tp.dut.rt_s3;
//    assign pc4_s3       = tp.dut.pc4_s3;
//    assign regdst_s3    = tp.dut.regdst_s3;
//    assign memread_s3   = tp.dut.memread_s3;
//    assign memwrite_s3  = tp.dut.memwrite_s3;
//    assign memtoreg_s3  = tp.dut.memtoreg_s3;
//    assign aluop_s3     = tp.dut.aluop_s3;
//    assign regwrite_s3  = tp.dut.regwrite_s3;
//    assign alusrc_s3    = tp.dut.alusrc_s3;
//    assign seimm_s3     = tp.dut.seimm_s3;
//    assign alusrc_data2 = tp.dut.alusrc_data2;
//    assign fw_data1_s3  = tp.dut.fw_data1_s3;
//    assign alurslt      = tp.dut.alurslt;
    
//    // Stage 4 signals
//    logic [6:0] AddrToDataMem;
//    logic [31:0] DataMemWriteData, DataMemReadData;
//    logic memwrite_s4, memread_s4;
//    logic [31:0] alurslt_s4;
    
//    assign AddrToDataMem   = tp.dut.alurslt_s4[8:2];
//    assign memwrite_s4     = tp.dut.memwrite_s4;
//    assign memread_s4      = tp.dut.memread_s4;
//    assign DataMemWriteData= tp.dut.data2_s4;
//    assign DataMemReadData = tp.dut.rdata;
    
//    // Stafe 5 signals used by regm in stage 2
//    assign regwrite_s5 = tp.dut.regwrite_s5;
//    assign wrreg_s5    = tp.dut.wrreg_s5;
//    assign wrdata_s5   = tp.dut.wrdata_s5;
    
    
//     logic flush_s1, flush_s2, flush_s3;
//     logic stall_s1_s2;  
//     logic [31:0] out_data;
//     logic [31:0] rd_data;
     
//     assign rd_data = tp.chk.A.rd_value;
//     assign out_data = tp.chk.out_data;
//     assign flush_s1 = tp.dut.flush_s1;
//     assign flush_s2 = tp.dut.flush_s2;
//     assign flush_s3 = tp.dut.flush_s3;
//     assign stall_s1_s2 = tp.dut.stall_s1_s2;    
    //////////////////////////////////////////
    // DUT
    /////////////////////////////////////////
	
    top_module tp (.clk(clk), .reset(reset) , .OpDone(OpDone), .pc(pc) , .inst(inst) , .pcEn(pcEn));
    
    //////////////////////////////////////////
    // Clock 
    //////////////////////////////////////////
    always
        #5 clk = ~clk;
    
        
    initial begin
		$readmemh("instr_mem.txt", instr_arr);
		pcEn = 1'b0;
		repeat(4) @(posedge clk) reset = 1'b1;
		@(posedge clk) reset = 0;
			
		repeat(804) begin
		  @(posedge clk) begin
		      pcEn = 1'b1;
		      if (pc == 0) inst = instr_arr[0];	
		      else inst = instr_arr[pc/4];
		  end
		end 

		repeat(6) @(posedge clk) begin
		  inst = 'z;
		  pcEn = 1'b0;
		end 	
         $stop;
                    
    end    
    
endmodule