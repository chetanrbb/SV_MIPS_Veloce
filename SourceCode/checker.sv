`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// checker.sv: This module is responsible for verifying the correctness of the operations performed by cpu.
// ECE 571	|	Portland State University
// Source: https://github.com/jmahler/mips-cpu 	
// Engineer: Daksh Dharod
//			 Harsh Momaya
//			 Chetan Bornarkar
// 
// Create Date: 03/06/2017
// 
// Description: The following is the checker module which is a combination of checker and scoreboard.
//				The checker replicates the functionality of cpu. It performs all the operations that
//				cpu does based on opcode and funct bits. The source register values are imported
//				from the cpu through interface. Then depending on opcode, operation is performed on the values
//				received from cpu. The final output value is compared with the destination register value which is
//				also received from the cpu. If the outputs match then, opDone signal(Operation is done) is asserted
//				high for 1 cycle.  The operations are performed only if pcEn( pc enable) signal is high.
//
//				R - type operations: ADD, SUB, OR, NOR, AND, SLT, XOR)
//					 				 The source and destination values are received in 3rd cycle from cpu.
//									 The operation in checker is performed and output is compared in 4th cycle.
//									 Based on results, opDone is asserted high or low.
//
//				I - type operations: ADDI, LW, SW
//									 ADDI works similar to R - type operation except one is a source register and other
//									 one is immediate data.
//									 For load instruction, a data memory is instantiated in checker. Based on address calculated,
//									 the data is loaded and then compared with data loaded value from cpu. Based on results,
//									 opDone is asserted high or low.
//									 For store instructions, the data is stored in data memory and to verify it load is done to make sure 
//									 store operation work properly. 
//									 
//  			J - type operations: BEQ, BNE, J
//									 For branch if equal and branch if not equal, to verify if the operation works properly,
//									 the source register values are compared and the address is compared. 	
//									 Based on results, opDone is asserted high or low.
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// importing the package
import AluCtrlSig_pkg::*;

module check(  
                ccheck.M A,
                input logic [31:0] inst,
                input clk, reset,
                input logic pcEn,
                output logic OpDone                  
            );
     
	 // internal signals
     logic [5:0] opcode,opcode_1,opcode_2, opcode_3, funct,funct_1,funct_2, funct_3;
     logic [4:0] rd, shamt;
     logic [31:0] rd_value2;
     logic [15:0] addr,imm;
     logic [25:0] jaddr;
     logic [31:0] jaddr_1,jaddr_2,jaddr_3, addr_1, addr_2, addr_3, rdata, lw_addr,rdata_1,rdata_2,rdata_3;

     logic [31:0] data1, data2;
     logic [31:0] out_data;
     logic pcEn_1,pcEn_2,pcEn_3,j_flag;
     logic rd_dm,rd_dm_1,rd_dm_2,rd_dm_3;    
     logic [4:0] rs,rt;
     
	 // data memory is instantiated
     dm dm1(.clk(clk), .addr(lw_addr[6:0]), .rd(rd_dm_2),.wr(0), .rdata(rdata),.wdata(0));
      

	 // combinational block which breaks the instruction from the machine code.	

	 
//     logic flag =0;
     logic [31:0] data1, data2;
     logic [31:0] out_data;//,out_data_1,out_data_f;
     logic pcEn_1,pcEn_2,pcEn_3/*, opDone_1,opDone_2*/,j_flag;
     logic rd_dm,rd_dm_1,rd_dm_2,rd_dm_3;
	 
     //////changes
     logic [4:0] rs,rt;
     
//     assign opcode = inst [31:26];
     dm dm1(.clk(clk), .addr(lw_addr[6:0]), .rd(rd_dm_2),.wr(0), .rdata(rdata),.wdata(0));
            

     always_comb begin
	 
        opcode = inst [31:26];
		
        if (reset == 1'b1) begin
            imm     = '1;
            rs      = '1;
            rt      = '1;
            addr    = '1;
            shamt   = '1;
            jaddr   = '1;
        end        
		
        else if (pcEn == 1'b1) begin
             rd_dm = 0;

            unique case (opcode) 
            
                LW_op: begin
                            rs      = inst [25:21];
                            rt      = inst [20:16];
                            addr    = inst [15:0];
							rd_dm 	= 1;
                            shamt   = '1;
                            jaddr   = '1;
                            funct   = '1;
                            imm     = '1;            
                       end
                       
                SW_op: begin
                            rs      = inst [25:21];
                            rt      = inst [20:16];
                            addr    = inst [15:0];
                            shamt   = '1;
                            jaddr   = '1; 
                            imm     = '1;
                       end       
                
                J_op: begin
                             rs     = '1;
                             rt     = '1;
                             shamt  = '1;
                             addr   = '1;
                             jaddr  = inst [25:0]; 
                             imm    = '1;
                             funct  = '1; 
                        end
                        
                BEQ_op: begin
                             rs     = inst [25:21];
                             rt     = inst [20:16];
                             addr   = inst [15:0]; 
                             shamt  = '1;
                             jaddr  = '1;
                             imm    = '1;
                             funct  = '1;
                        end
                
                BNE_op: begin
                             rs     = inst [25:21];
                             rt     = inst [20:16];
                             addr   = inst [15:0]; 
                             shamt  = '1;
                             jaddr  = '1;
                             funct  = '1;
                             imm    = '1;  
                        end        
                
                ADDI_op: begin
                              rs    = inst [25:21];
                              rt    = inst [20:16];
                              imm   = inst [15:0];
                              shamt = '1;
                              jaddr = '1;
                              funct = '1; 
                         end
                         
                ADD_op: begin
                             rs     = inst [25:21];
                             rt     = inst [20:16];          
                             rd     = inst [15:11];
                             shamt  = inst [10:6];
                             funct  = inst [5:0];      
                        end
                 default: begin 
                            rs      = '1;
                            rt      = '1;
                            shamt   = '1;
                            funct   = '1;
                            imm     = '1;
                          end            
            endcase
          end
          
       end
         

		 // For load instruction, load address is calculated based on source value and immediate address
		always_comb begin

			if(opcode_2 == LW_op)
			begin
				lw_addr = A.rd_value + addr_2;
			end

		 end

       
		 // pipelining the signals for timing match
         always_ff @( posedge clk) begin
            if(reset == 1'b1)   begin
                opcode_1 <= '0;
                opcode_2 <= '0;
				opcode_3 <= 0;
            end
            else begin

			$display("rdata in always_chkr: %x",rdata);			// For debugging purpose

			$display("rdata in always_chkr: %x",rdata);

                opcode_1 <= opcode; 
                opcode_3 <= opcode_1;       
				opcode_2 <= opcode_3;
				rd_dm_1 <= rd_dm;
				rd_dm_2 <= rd_dm_1;
				rd_dm_3 <= rd_dm_2;
				rdata_1 <= rdata;
				rdata_2 <= rdata_1;
				rdata_3 <= rdata_2;
            end
        end
       

        // pipelining the signals for timing match
         always_ff @(posedge clk)  begin
            if(reset == 1'b1) begin
                funct_1 <= '0;
                funct_2 <= '0;
                pcEn_1 <= '0;
                pcEn_2 <= '0;
                pcEn_3 <= '0;
                jaddr_1 <= '0;
				jaddr_2 <= '0;
				jaddr_3 <= '0;
				addr_1 <= '0;
				addr_2 <= '0;
				addr_3 <= '0;
            end
            
            else begin
				funct_1 <= funct;
				funct_3 <= funct_1;
				funct_2 <= funct_3;
				pcEn_1 <= pcEn;
				pcEn_3 <= pcEn_1;
				pcEn_2 <= pcEn_3;
				jaddr_1 <= {4'b0000, jaddr,2'b00};					// jump address is calculated
				jaddr_2 <= jaddr_1;
				jaddr_3 <= jaddr_2;
				addr_1 <= {14'd0, addr[15:0] , 2'b00};				// branch address is calculated
				addr_2 <= addr_1;
				addr_3 <= addr_2;
			end
        end
        
		// implementing the reset functionality
        always_ff @(posedge clk)
            begin
                if(reset) rd_value2 <= '0;
                else rd_value2 <= A.rd_value;
            end
                     
        //Combinational block which performs operation based on opcode and source register values received from cpu
		always_comb begin
            if (reset == 1'b1)  begin
                out_data = '1;
                OpDone = 1'b0;
                end
            else if(pcEn_2 == 1) begin
			   // for ADD opcode, funct bits are checked and operation is performed	
               if (opcode_2 == ADD_op) begin
                   if(funct_2 == ADD) out_data = A.rs_value + A.rt_value;
                   else if(funct_2 == AND) out_data = A.rs_value & A.rt_value;
                   else if (funct_2 == SUB) out_data = A.rs_value - A.rt_value;
                   else if (funct_2 == OR) out_data = A.rs_value | A.rt_value;
                   else if (funct_2 == NOR) out_data = ~(A.rs_value | A.rt_value);
                   else if (funct_2 == SLT) out_data = A.rs_value < A.rt_value? 1:0;
                   else if (funct_2 == XOR) out_data = A.rs_value ^ A.rt_value;
                   else out_data = '1;
               end
               
               else if (opcode_2 == ADDI_op ) out_data = A.rt_value + A.rs_value;
               else if (opcode_2 == J_op) begin	
			   $display("A.jump_addr: %x, Jaddr2: %x, Jaddr3: %x", A.jump_addr, jaddr_2, jaddr_3); 		// for debugging purpose
			   
					if(A.jump_addr == jaddr_3)
						out_data = A.rd_value;
					else out_data = '1;
				end		
               else if (opcode_2 == BNE_op) begin 
                    if (( A.rs_value != A.rt_value) && (A.branch_addr == addr_3)) out_data = A.rd_value;                  
               end       
               
               else if (opcode_2 == BEQ_op) begin
                    if (( A.rs_value == A.rt_value) && (A.branch_addr == addr_3)) out_data = A.rd_value;                  
               end       
               
			   else if (opcode_2 == LW_op) begin

					// for debugging purpose
					$display("lw_data in chckr: %x", A.lw_data);
					$display("rdata in chckr: %x", rdata);					

					$display("lw_data in chckr: %x", A.lw_data);
					$display("rdata in chckr: %x", rdata);
					

					$display("lw_address in chckr: %x", lw_addr);
					$display("rd_dm: %x", rd_dm_3);
					if(A.lw_data == rdata) out_data = A.rd_value;
			   end
			   else if(opcode_2 == SW_op) begin
					out_data = A.rd_value;
			   end
			   
               else if (opcode_2 == 6'b111111) out_data = '1; 
               else out_data = '1;
               
			   // checking module - if the computed data is equal to the destination register value, opDone is asserted high
               if (out_data == A.rd_value) OpDone = 1'b1;
               else OpDone = 1'b0;    
               
               end
            else begin
                out_data = '1;
                OpDone = '0;
            end   
			// For debugging purpose
			//$display("OutData: %x, RdVal2: %x", out_data, rd_value2);
			//$display("Rs value %x, Rt value %x, Rd value %x", A.rs_value, A.rt_value, A.rd_value);
			$display("OpDone: %x", OpDone);
			//$display("Opcode: %x, Opcode_1: %x, Opcode_2: %x", opcode, opcode_1, opcode_2);
			//$display("Funct: %x, Funct1: %x, Funct2: %x", funct, funct_1, funct_2);
          end    
                  
endmodule