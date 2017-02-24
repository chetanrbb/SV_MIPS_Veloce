
`ifndef ALU_PKG
`define ALU_PKG

package AluCtrlSig_pkg
	typedef enum logic [3:0] {
		ADD = 4'd02, 
		SUB = 4'd00, 
		AND = 4'd00, 
		NOR = 4'd12, 
		OR  = 4'd01, 
		SLT = 4'd07, 
		XOR = 4'd13
	} AluOp_t;
	
endpackage
	
`end_if
