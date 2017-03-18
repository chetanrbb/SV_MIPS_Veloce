`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2017 08:38:17 PM
// Design Name: 
// Module Name: checker
// Project Name: 
// Target Devices: 
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

module check(  
                ccheck.M A,
                input logic [31:0] inst,
                input clk, reset,
                input logic pcEn,
                output logic OpDone                  
            );
     
     logic [5:0] opcode,opcode_1,opcode_2, opcode_3, funct,funct_1,funct_2, funct_3;
     logic [4:0] rd, shamt;
     logic [31:0] rd_value2;
     logic [15:0] addr,imm;
     logic [25:0] jaddr;
     logic [31:0] jaddr_check;
//     logic flag =0;
     logic [31:0] data1, data2;
     logic [31:0] out_data;//,out_data_1,out_data_f;
     logic pcEn_1,pcEn_2,pcEn_3/*, opDone_1,opDone_2*/,j_flag;
     
     //////changes
     logic [4:0] rs,rt;
     
//     assign opcode = inst [31:26];
     
            
     always_comb begin
//        rs = '0;
//        rt = '0;
//        shamt = '0;
//        funct = '0;
        opcode = inst [31:26];
        if (reset == 1'b1) begin
//            opcode  <= '1;
            imm     = '1;
            rs      = '1;
            rt      = '1;
            addr    = '1;
            shamt   = '1;
            jaddr   = '1;
        end        
        else if (pcEn == 1'b1) begin
             
            unique case (opcode) 
            
                LW_op: begin
                            rs      = inst [25:21];
                            rt      = inst [20:16];
                            addr    = inst [15:0];
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
          
//         else begin end 
       end
          
       
       always_ff @( posedge clk) begin
            if(reset == 1'b1)   begin
                opcode_1 <= '0;
                opcode_2 <= '0;
				opcode_3 <= 0;
            end
            else begin
                opcode_1 <= opcode; 
                opcode_3 <= opcode_1;       
				opcode_2 <= opcode_3;
            end
        end
       

        
        always_ff @(posedge clk)  begin
            if(reset == 1'b1) begin
                funct_1 <= '0;
                funct_2 <= '0;
                pcEn_1 <= '0;
                pcEn_2 <= '0;
                pcEn_3 <= '0;
//                opDone_2 <= '0;
                jaddr_check <= '0;
//                OpDone <= '0;
            end
            
            else begin
            funct_1 <= funct;
            funct_3 <= funct_1;
			funct_2 <= funct_3;
            pcEn_1 <= pcEn;
            pcEn_3 <= pcEn_1;
            pcEn_2 <= pcEn_3;
            jaddr_check <= {4'b0000, jaddr,2'b00};
            end
        end
        
        always_ff @(posedge clk)
            begin
                if(reset) rd_value2 <= '0;
                else rd_value2 <= A.rd_value;
            end
                     
        //always_ff @(posedge clk) begin
		always_comb begin
            if (reset == 1'b1)  begin
                out_data = '1;
                OpDone = 1'b0;
                end
            else if(pcEn_2 == 1) begin
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
               else if (opcode_2 == J_op) out_data = A.rd_value;
               else if (opcode_2 == BNE_op) begin 
                    if ( A.rs_value != A.rt_value) out_data = addr;
                    //else out_data = '0;
               end       
               
               else if (opcode_2 == BEQ_op) begin
                    if ( A.rs_value == A.rt_value) out_data = addr;
                    //else out_data = '0;
               end       
               
               else if (opcode_2 == 6'b111111) out_data = '1; 
               //else if (opcode_2 == LW_op) if( A.j_address == jaddr_check) j_flag = A.rd_v;
               else out_data = '1;
               
               if (out_data == A.rd_value) OpDone = 1'b1;
               else OpDone = 1'b0;    
               
               end
            else begin
                out_data = '1;
                OpDone = '0;
            end   
			//$display("OutData: %x, RdVal2: %x", out_data, rd_value2);
			//$display("Rs value %x, Rt value %x, Rd value %x", A.rs_value, A.rt_value, A.rd_value);
			$display("OpDone: %x", OpDone);
			//$display("Opcode: %x, Opcode_1: %x, Opcode_2: %x", opcode, opcode_1, opcode_2);
			//$display("Funct: %x, Funct1: %x, Funct2: %x", funct, funct_1, funct_2);
          end    
                  
endmodule