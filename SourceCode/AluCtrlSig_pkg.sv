`timescale 1ns / 10ps
`ifndef ALU_PKG
`define ALU_PKG

package AluCtrlSig_pkg;

	typedef enum logic [5:0] {
		ADD = 6'h20, 
		SUB = 6'h22, 
		AND = 6'h24, 
		NOR = 6'h27, 
		OR  = 6'h25, 
		SLT = 6'h2A, 
		XOR = 6'h13
	} AluOp_t;
	
	enum logic [5:0]{
        LW_op   = 6'b100011,
        ADDI_op  = 6'b001000,
        BEQ_op   = 6'b000100,
        SW_op   = 6'b101011,
        BNE_op  = 6'b000101,
        ADD_op = 6'b000000,
        J_op  = 6'b000010
    }opcode_t; 
    
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
    
endpackage
	
`endif
