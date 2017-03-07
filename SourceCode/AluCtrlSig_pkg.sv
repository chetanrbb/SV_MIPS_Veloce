`timescale 1ns / 10ps
`ifndef ALU_PKG
`define ALU_PKG

package AluCtrlSig_pkg;

	typedef enum logic [3:0] {
		ADD = 4'd02, 
		SUB = 4'd06, 
		AND = 4'd00, 
		NOR = 4'd12, 
		OR  = 4'd01, 
		SLT = 4'd07, 
		XOR = 4'd13
	} AluOp_t;
	
	enum logic [5:0]{
        LW_op   = 6'b100011,
        ADDI_op  = 6'b001000,
        BEQ_op   = 6'b000100,
        SW_op   = 6'b101011,
        BNE_op  = 6'b000101,
        ADD_op = 6'b000000,
        JMP_op  = 6'b000010
    }opcode_t; 
    
    enum logic [4:0] {
        v0 = 5'd2,
        v1 = 5'd1,
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
