///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	cpu.sv - CPU top module which integrates all modules
//	ECE 571	| Portland State University
//	Date: 03/18/2017
//	Engineers: 	Chetan Bornarkar
//				Daksh Dhaord
//				Harsh Momaya
//
//	Description: Five stage MIPS CPU and it consists of the following stages:
//				 	1. Fetch 
//				 	2.	Decode
//				 	3. Execute
//				 	4. Memory
//				 	5. Writeback
//
//				CPU module consists of instantiation of the following modules:
//					1. control 			- Generate control signals
//					2. dm	   			- Data memory having 128 locations with each location storing 32 bits
//					3. alu_control		- responsible for generating control signals for ALU
//					4. regm		 		- Register memory
//					5. regr				- Pipeline register
//					6. alu				- This unit performs arithmetic and logical operations.
//					7. AluCtrlSig_pkg	- It is a package unit which consists of typedefs and enums  	 
//
//	 
//	Modifications:
//	1.	Control added to PC with the help of pcEn signal
//	2.	Reset functionality added
//	3.	Extracted internal cpu signals for checker unit with the help of interface.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 10ps
`ifndef DEBUG_CPU_STAGES
`define DEBUG_CPU_STAGES 0
`endif


module cpu 
	(
		input wire clk, reset,
		input logic [31:0] inst,
		output logic [31:0] pc = '0,
		
		//	Interface added to design to extract internal signals of cpu module. 
		ccheck.H B,
		input logic pcEn
	);

	//////////////////////////////////////////////////////////////////////////////////////////////
	//
	//	Internal signals	
	//
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	logic [4:0] wrreg_s5;
	logic regwrite_s5;
	logic flush_s1, flush_s2, flush_s3;
	logic stall_s1_s2;
	logic pcsrc;
	logic jump_s4;
	logic [31:0] baddr_s4;
	logic [31:0] jaddr_s4;
	logic [31:0] fw_data2_s3;
	logic [31:0] fw_data1_s3;
	logic [31:0] alurslt_s4;
	logic [31:0] wrdata_s5;
	logic [1:0] forward_a;
	logic [31:0] alusrc_data2;
	logic [31:0] data1, data2;
	logic [31:0] data1_s3, data2_s3;
    logic [5:0] aluctl;
    logic [5:0] funct;
	logic [31:0] data2_s4;
    logic memread_s4;
    logic memwrite_s4;

	
	//////////////////////////////////////////////////////////////////////////////////////////////
	//
	//	Debugging 
	//
	//////////////////////////////////////////////////////////////////////////////////////////////
	
	initial 
	begin
		if (`DEBUG_CPU_STAGES) 
		begin
			$display("if_pc,    if_instr, id_regrs, id_regrt, ex_alua,  ex_alub,  ex_aluctl, mem_memdata, mem_memread, mem_memwrite, wb_regdata, wb_regwrite");
			$monitor("%x, %x, %x, %x, %x, %x, %x,         %x,    %x,           %x,            %x,   %x",
					pc,				/* if_pc */
					inst,			/* if_instr */
					data1,			/* id_regrs */
					data2,			/* id_regrt */
					data1_s3,		/* data1_s3 */
					alusrc_data2,	/* alusrc_data2 */
					aluctl,			/* ex_aluctl */
					data2_s4,		/* mem_memdata */
					memread_s4,		/* mem_memread */
					memwrite_s4,	/* mem_memwrite */
					wrdata_s5,		/* wb_regdata */
					regwrite_s5		/* wb_regwrite */
				);
		end
	end


	/////////////////////////////////////////////////////////////////////////////////////////////////
	//
	//	Flushing logic
	//
	/////////////////////////////////////////////////////////////////////////////////////////////////
	
	always_comb 
	begin
	    if (reset == 1'b1) begin
		  flush_s1 <= 1'b1;
		  flush_s2 <= 1'b1;
		  flush_s3 <= 1'b1;
		end
		else if (pcsrc | jump_s4) begin
			flush_s1 <= 1'b1;
			flush_s2 <= 1'b1;
			flush_s3 <= 1'b1;
		end
		else begin
		    flush_s1 <= 1'b0;
            flush_s2 <= 1'b0;
            flush_s3 <= 1'b0;
		end
	end

    ////////////////////////////////////////////////////////////////////////////////////////////////
    //
	// stage 1, IF (fetch)
    //
    ////////////////////////////////////////////////////////////////////////////////////////////////


	logic [31:0] jaddr_s3;
	logic [31:0] baddr_s3;
	logic [31:0] pc4;
	
	// Modification: pcEn added to the design
	assign pc4 = pcEn ? (pc + 4): pc;

	always_ff @(posedge clk) begin
	
	// Modification: reset added to the design	
	   if(reset == 1'b1) pc <= '0;
       else if (stall_s1_s2) pc <= pc;
       else if (pcsrc == 1'b1) begin
            if (baddr_s4 == '0) pc <= baddr_s4;
            else pc <= baddr_s4 - 3'd4;
       end
       else if (jump_s4 == 1'b1) begin
            if (jaddr_s4 == '0) pc <= jaddr_s4;
            else pc <= jaddr_s4 - 3'd4; 
       end
       else pc <= pc4;
    end
        
		
	// pass PC + 4 to stage 2
	logic [31:0] pc4_s2;
	regr #(.N(32)) regr_pc4_s2(.clk(clk),
						.hold(stall_s1_s2), .clear(flush_s1),
						.in(pc4), .out(pc4_s2));

	
	// Modification: Signals for checker unit via interface	
	always_ff @(posedge clk)
		begin
			B.jump_addr <= jaddr_s3;
			B.branch_addr <= baddr_s3;
		end
		

	logic [31:0] inst_s2;

						
	regr #(.N(32)) regr_im_s1(.clk(clk),
						.hold(stall_s1_s2), .clear(flush_s1),
						.in(inst), .out(inst_s2));


    /////////////////////////////////////////////////////////////////////////////////
	//
	// stage 2, ID (decode)
	//
    ////////////////////////////////////////////////////////////////////////////////

	
	logic [5:0]  opcode;
	logic [4:0]  rs;
	logic [4:0]  rt;
	logic [4:0]  rd;
	logic [15:0] imm;
	logic [4:0]  shamt;
	logic [31:0] jaddr_s2;
	logic [31:0] seimm;  // sign extended immediate
	assign opcode   = inst_s2[31:26];
	assign rs       = inst_s2[25:21];
	assign rt       = inst_s2[20:16];
	assign rd       = inst_s2[15:11];
	assign imm      = inst_s2[15:0];
	assign shamt    = inst_s2[10:6];
	assign jaddr_s2 = {pc[31:28], inst_s2[25:0], {2{1'b0}}};
	assign seimm 	= {{16{inst_s2[15]}}, inst_s2[15:0]};

	// register memory
	regm regm1(.clk(clk), .read1(rs), .read2(rt),
			.data1(data1), .data2(data2),
			.regwrite(regwrite_s5), .wrreg(wrreg_s5),
			.wrdata(wrdata_s5));

	// pass rs to stage 3 (for forwarding)
	logic [4:0] rs_s3;
	regr #(.N(5)) regr_s2_rs(.clk(clk), .clear(1'b0), .hold(stall_s1_s2),
				.in(rs), .out(rs_s3));

	// transfer register data to stage 3
	regr #(.N(64)) reg_s2_mem(.clk(clk), .clear(flush_s2), .hold(stall_s1_s2),
				.in({data1, data2}),
				.out({data1_s3, data2_s3}));

	// transfer seimm, rt, and rd to stage 3
	logic [31:0] seimm_s3;
	logic [4:0] 	rt_s3;
	logic [4:0] 	rd_s3;
	regr #(.N(32)) reg_s2_seimm(.clk(clk), .clear(flush_s2), .hold(stall_s1_s2),
						.in(seimm), .out(seimm_s3));
	regr #(.N(10)) reg_s2_rt_rd(.clk(clk), .clear(flush_s2), .hold(stall_s1_s2),
						.in({rt, rd}), .out({rt_s3, rd_s3}));

	// transfer PC + 4 to stage 3
	logic [31:0] pc4_s3;
	regr #(.N(32)) reg_pc4_s2(.clk(clk), .clear(1'b0), .hold(stall_s1_s2),
						.in(pc4_s2), .out(pc4_s3));
    
	
    //////////////////////////////////////////////////////////////////////////////////////
	//
	// control (opcode -> ...)
	//
	//////////////////////////////////////////////////////////////////////////////////////
	
	logic		regdst;
	logic		branch_eq_s2;
	logic		branch_ne_s2;
	logic		memread;
	logic		memwrite;
	logic		memtoreg;
	logic [1:0]	aluop;
	logic		regwrite;
	logic		alusrc;
	logic		jump_s2;
	logic [1:0] forward_b;
	
	// control logic
	control ctl1(.opcode(opcode), .regdst(regdst),
				.branch_eq(branch_eq_s2), .branch_ne(branch_ne_s2),
				.memread(memread),
				.memtoreg(memtoreg), .aluop(aluop),
				.memwrite(memwrite), .alusrc(alusrc),
				.regwrite(regwrite), .jump(jump_s2));

	
	logic [31:0] seimm_sl2;
	assign seimm_sl2 = {seimm[29:0], 2'b0};  // shift left 2 bits
	// branch address
	logic [31:0] baddr_s2;
	assign baddr_s2 = seimm_sl2;

	
	// transfer the control signals to stage 3
	logic		regdst_s3;
	logic		memread_s3;
	logic		memwrite_s3;
	logic		memtoreg_s3;
	logic [1:0]	aluop_s3;
	logic		regwrite_s3;
	logic		alusrc_s3;
	
	
	// A bubble is inserted by setting all the control signals
	// to zero (stall_s1_s2).
	regr #(.N(8)) reg_s2_control(.clk(clk), .clear(stall_s1_s2), .hold(1'b0),
			.in({regdst, memread, memwrite,
					memtoreg, aluop, regwrite, alusrc}),
			.out({regdst_s3, memread_s3, memwrite_s3,
					memtoreg_s3, aluop_s3, regwrite_s3, alusrc_s3}));

	logic branch_eq_s3, branch_ne_s3;
	regr #(.N(2)) branch_s2_s3(.clk(clk), .clear(flush_s2), .hold(1'b0),
				.in({branch_eq_s2, branch_ne_s2}),
				.out({branch_eq_s3, branch_ne_s3}));
	
	regr #(.N(32)) baddr_s2_s3(.clk(clk), .clear(flush_s2), .hold(1'b0),
				.in(baddr_s2), .out(baddr_s3));

	logic jump_s3;
	regr #(.N(1)) reg_jump_s3(.clk(clk), .clear(flush_s2), .hold(1'b0),
				.in(jump_s2),
				.out(jump_s3));

	
	regr #(.N(32)) reg_jaddr_s3(.clk(clk), .clear(flush_s2), .hold(1'b0),
				.in(jaddr_s2), .out(jaddr_s3));


    /////////////////////////////////////////////////////////////////////////////////////////////
	//
	// stage 3, EX (execute)
	//
    /////////////////////////////////////////////////////////////////////////////////////////////
	
	
	// pass through some control signals to stage 4
	logic regwrite_s4;
	logic memtoreg_s4;


	regr #(.N(4)) reg_s3(.clk(clk), .clear(flush_s2), .hold(1'b0),
				.in({regwrite_s3, memtoreg_s3, memread_s3,
						memwrite_s3}),
				.out({regwrite_s4, memtoreg_s4, memread_s4,
						memwrite_s4}));

	// ALU
	// second ALU input can come from an immediate value or data
	assign alusrc_data2 = (alusrc_s3) ? seimm_s3 : fw_data2_s3;
	assign funct = seimm_s3[5:0];
	
	// ALU control logic
	alu_control alu_ctl1(.funct(funct), .aluop(aluop_s3), .aluctl(aluctl));
	
	
	logic [31:0] alurslt;
	
	// logic to forward data based on forward control signal
	always_comb
	    if (reset == 1'b1) fw_data1_s3 = '0;
	    else begin
		case (forward_a)
			2'd1: fw_data1_s3 = alurslt_s4;
			2'd2: fw_data1_s3 = wrdata_s5;
		 default: fw_data1_s3 = data1_s3;
		endcase
	   end
	
	// Modification: Signals for checker unit via interface		
	always_ff @(posedge clk) begin
	   B.rs_value <= fw_data1_s3;
	   B.rt_value <= alusrc_data2;
	end
	    	
	logic zero_s3;
	alu alu1(.ctl(aluctl), .a(fw_data1_s3), .b(alusrc_data2), .out(alurslt),
									.zero(zero_s3));
	logic zero_s4;
	regr #(.N(1)) reg_zero_s3_s4(.clk(clk), .clear(1'b0), .hold(1'b0),
					.in(zero_s3), .out(zero_s4));

					
	// pass ALU result and zero to stage 4
	regr #(.N(32)) reg_alurslt(.clk(clk), .clear(flush_s3), .hold(1'b0),
				.in({alurslt}),
				.out({alurslt_s4}));

				
	// pass data2 to stage 4
	always_comb
	    if (reset == 1'b1) fw_data2_s3 = '0;
	    else begin
		case (forward_b)
			2'd1: fw_data2_s3 = alurslt_s4;
			2'd2: fw_data2_s3 = wrdata_s5;
		 default: fw_data2_s3 = data2_s3;
		endcase
		end
		
	regr #(.N(32)) reg_data2_s3(.clk(clk), .clear(flush_s3), .hold(1'b0),
				.in(fw_data2_s3), .out(data2_s4));

	// write register
	logic [4:0]	wrreg;
	logic [4:0]	wrreg_s4;
	assign wrreg = (regdst_s3) ? rd_s3 : rt_s3;
	
	// pass to stage 4
	regr #(.N(5)) reg_wrreg(.clk(clk), .clear(flush_s3), .hold(1'b0),
				.in(wrreg), .out(wrreg_s4));

	logic branch_eq_s4, branch_ne_s4;
	regr #(.N(2)) branch_s3_s4(.clk(clk), .clear(flush_s3), .hold(1'b0),
				.in({branch_eq_s3, branch_ne_s3}),
				.out({branch_eq_s4, branch_ne_s4}));

	
	regr #(.N(32)) baddr_s3_s4(.clk(clk), .clear(flush_s3), .hold(1'b0),
				.in(baddr_s3), .out(baddr_s4));


	regr #(.N(1)) reg_jump_s4(.clk(clk), .clear(flush_s3), .hold(1'b0),
				.in(jump_s3),
				.out(jump_s4));

	
	regr #(.N(32)) reg_jaddr_s4(.clk(clk), .clear(flush_s3), .hold(1'b0),
				.in(jaddr_s3), .out(jaddr_s4));
	
    
    ///////////////////////////////////////////////////////////////////////////////
	//
	// stage 4, MEM (memory)
	//
    //////////////////////////////////////////////////////////////////////////////
	
	
	// pass regwrite and memtoreg to stage 5
	logic memtoreg_s5;
	regr #(.N(2)) reg_regwrite_s4(.clk(clk), .clear(1'b0), .hold(1'b0),
				.in({regwrite_s4, memtoreg_s4}),
				.out({regwrite_s5, memtoreg_s5}));

	// data memory
	logic [31:0] rdata;
	dm dm1(.clk(clk), .addr(alurslt_s4[8:2]), .rd(memread_s4), .wr(memwrite_s4),
			.wdata(data2_s4), .rdata(rdata));
	
	
	// Modification: Signals for checker unit via interface	
	always_ff @(posedge clk) begin
	   B.rd_value <= alurslt;
	   B.lw_data <= rdata;
	end
	
	// pass read data to stage 5
	logic [31:0] rdata_s5;
	regr #(.N(32)) reg_rdata_s4(.clk(clk), .clear(1'b0), .hold(1'b0),
				.in(rdata),
				.out(rdata_s5));

	// pass alurslt to stage 5
	logic [31:0] alurslt_s5;
	regr #(.N(32)) reg_alurslt_s4(.clk(clk), .clear(1'b0), .hold(1'b0),
				.in(alurslt_s4),
				.out(alurslt_s5));

	// pass wrreg to stage 5
	
	regr #(.N(5)) reg_wrreg_s4(.clk(clk), .clear(1'b0), .hold(1'b0),
				.in(wrreg_s4),
				.out(wrreg_s5));

				
	// branch
	always_comb 
	begin
	    if (reset == 1'b1) pcsrc <= 1'b0;
	    else begin
		case (1'b1)
			branch_eq_s4: pcsrc <= zero_s4;
			branch_ne_s4: pcsrc <= ~(zero_s4);
			default: pcsrc <= 1'b0;
		endcase
	   end
	end
	
	
	/////////////////////////////////////////////////////////////////////////////////////////////
	//
	// stage 5, WB (write back)
	//
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	assign wrdata_s5 = (memtoreg_s5 == 1'b1) ? rdata_s5 : alurslt_s5;
	
	always_comb 
	begin
		// If the previous instruction (stage 4) would write,
		// and it is a value we want to read (stage 3), forward it.

		// data1 input to ALU
		if (reset) forward_a <= 2'b00; 
		else if ((regwrite_s4 == 1'b1) && (wrreg_s4 == rs_s3)) begin
			forward_a <= 2'd1;  // stage 4
		end else if ((regwrite_s5 == 1'b1) && (wrreg_s5 == rs_s3)) begin
			forward_a <= 2'd2;  // stage 5
		end else
			forward_a <= 2'd0;  // no forwarding

		// data2 input to ALU
		if ((regwrite_s4 == 1'b1) & (wrreg_s4 == rt_s3)) begin
			forward_b <= 2'd1;  // stage 5
		end else if ((regwrite_s5 == 1'b1) && (wrreg_s5 == rt_s3)) begin
			forward_b <= 2'd2;  // stage 5
		end else
			forward_b <= 2'd0;  // no forwarding
	end

	
	///////////////////////////////////////////////////////////////////////////////////////////////
	//
	//	Stall logic
	//
	///////////////////////////////////////////////////////////////////////////////////////////////
	always_comb 
	begin
		if (reset == 1'b1) stall_s1_s2 = 1'b0;
		else if (memread_s3 == 1'b1 && ((rt == rt_s3) || (rs == rt_s3)) ) 
		begin
			stall_s1_s2 = 1'b1;  // perform a stall
		end 
		else
			stall_s1_s2 = 1'b0;  // no stall
	end

endmodule

