`timescale 1ns / 10ps
`ifndef _control
`define _control

//`include "AluCtrlSig_pkg.sv"

module control(
		input  logic	[5:0]	opcode,
		output logic			branch_eq, branch_ne,
		output logic    [1:0]	aluop,
		output logic			memread, memwrite, memtoreg,
		output logic			regdst, regwrite, alusrc,
		output logic			jump);

    import AluCtrlSig_pkg::*;
    	
		
	always_comb 
	begin
	
		aluop[1:0]	= 2'b10;
		alusrc		= 1'b0;
		branch_eq	= 1'b0;
		branch_ne	= 1'b0;
		memread		= 1'b0;
		memtoreg	= 1'b0;
		memwrite	= 1'b0;
		regdst		= 1'b1;
		regwrite	= 1'b1;
		jump		= 1'b0;

		unique case (opcode)
			LW_op  :  begin	/* lw */
                         memread  = 1'b1;
                         regdst   = 1'b0;
                         memtoreg = 1'b1;
                         aluop[1] = 1'b0;
                         alusrc   = 1'b1;
                     end
			ADDI_op: begin	/* addi */
                         regdst   = 1'b0;
                         aluop[1] = 1'b0;
                         alusrc   = 1'b1;
                     end
			BEQ_op : begin	/* beq */
                         aluop[0]  = 1'b1;
                         aluop[1]  = 1'b0;
                         branch_eq = 1'b1;
                         regwrite  = 1'b0;
                     end
			SW_op  :  begin	/* sw */
                         memwrite = 1'b1;
                         aluop[1] = 1'b0;
                         alusrc   = 1'b1;
                         regwrite = 1'b0;
                     end
			BNE_op : begin	/* bne */
                         aluop[0]  = 1'b1;
                         aluop[1]  = 1'b0;
                         branch_ne = 1'b1;
                         regwrite  = 1'b0;
                     end
			ADD_op : begin	/* add */
				        aluop[1:0]	= 2'b10;
				     end
			J_op   : begin	/* j jump */
                         jump = 1'b1;
                         end
			default: begin 
			             aluop[1:0]	= 2'b10; 
			         end	 
		endcase
	end
endmodule

`endif
