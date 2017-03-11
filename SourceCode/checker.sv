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


//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 


//////////////////////////////////////////////////////////////////////////////////

import AluCtrlSig_pkg::*;

module check(  
                ccheck.M A,
                input logic [31:0] inst,
                input clk,
                input logic pcEn,
                output logic OpDone                  
            );
     
     logic [5:0] opcode,opcode_1,opcode_2,opcode_3,funct,funct_1,funct_2;
     logic [4:0] rd,shamt;
     logic [15:0] addr,imm;
     logic [25:0] jaddr;
     logic [31:0] jaddr_check;
     logic flag =0;
     logic [31:0] data1, data2;
     logic [31:0] out_data;//,out_data_1,out_data_f;
     logic pcEn_1,pcEn_2,pcEn_3, opDone_1,opDone_2,j_flag;
     
     //////changes
     logic [4:0] rs,rt;
            
     always_ff @ (posedge clk) begin
//        rs = '0;
//        rt = '0;
//        shamt = '0;
//        funct = '0;
        if (pcEn == 1'b1) begin
            opcode = inst [31:26];
             
            unique case (opcode) 
            
                LW_op: begin
                        rs   <= inst [25:21];
                        rt   <= inst [20:16];
                        addr   <= inst [15:0];            
                       end
                       
                SW_op: begin
                        rs   <= inst [25:21];
                        rt   <= inst [20:16];
                        addr   <= inst [15:0];            
                       end       
                
                J_op: begin
                         jaddr <= inst [25:0];                        
                        end
                        
                BEQ_op: begin
                         rs   <= inst [25:21];
                         rt   <= inst [20:16];
                         addr   <= inst [15:0]; 
                        end
                
                BNE_op: begin
                         rs   <= inst [25:21];
                         rt   <= inst [20:16];
                         addr   <= inst [15:0]; 
                        end        
                
                ADDI_op: begin
                          rs  <= inst [25:21];
                          rt  <= inst [20:16];
                          imm   <= inst [15:0];  
                         end
                         
                ADD_op: begin
                         rs    <= inst [25:21];
                         rt    <= inst [20:16];          
                         rd      <= inst [15:11];
                         shamt   <= inst [10:6];
                         funct   <= inst [5:0];      
                        end
                 default: begin 
                            rs <= '1;
                            rt <= '1;
                            shamt <= '1;
                            funct <= '1;
                            opcode <= '1;
                          end            
            endcase
          end
          
//         else begin end 
       end
        
//        always_ff @(A.rs_value) begin
//        $display("Rs value %d", A.rs_value);
//        $display("Rt value %d", A.rt_value);
//        $display("Rd value %d", A.rd_value);
//        end
            
       always_ff @( posedge clk) begin
            opcode_1 <= opcode; 
            opcode_3 <= opcode_1;
            opcode_2 <= opcode_3;        
        end
        
        always_ff @(posedge clk)  begin
            funct_1 <= funct;
            funct_2 <= funct_1;
            pcEn_1 <= pcEn;
            pcEn_3 <= pcEn_1;
            pcEn_2 <= pcEn_3;
            opDone_2 <= opDone_1;
            OpDone <= opDone_2;
            jaddr_check <= {4'b0000, jaddr,2'b00};
        end
        
//        ADD = 4'd02, 
//                SUB = 4'd06, 
//                AND = 4'd00, 
//                NOR = 4'd12, 
//                OR  = 4'd01, 
//                SLT = 4'd07, 
//                XOR = 4'd13
        
        
        always_comb begin
            if(pcEn_2 == 1) begin
               if (opcode_2 == ADD_op) begin
                   if(funct_2 == ADD) out_data = A.rs_value + A.rt_value;
                   else if(funct_2 == AND) out_data = A.rs_value & A.rt_value;
                   else if (funct_2 == SUB) out_data = A.rs_value - A.rt_value;
                   else if (funct_2 == OR) out_data= A.rs_value | A.rt_value;
                   else if (funct_2 == NOR) begin 
                        out_data = A.rs_value | A.rt_value;
                        out_data = ~out_data;
                   end
                   else if (funct_2 == SLT) out_data = A.rs_value < A.rt_value? 1:0;
                   else if (funct_2 == XOR) out_data = A.rs_value ^ A.rt_value;
               end
               else if (opcode_2 == ADDI_op ) out_data = A.rt_value + A.rs_value;
               else if (opcode_2 == J_op) out_data = A.rd_value;
               else if (opcode_2 == BNE_op) begin 
                    if ( A.rs_value != A.rt_value) out_data = addr;
                    else out_data <= '1;
               end       
               else if (opcode_2 == BEQ_op) begin
                    if ( A.rs_value == A.rt_value) out_data = addr;
                    else out_data = '1;
               end       
               else if (opcode_2 == 6'b111111) out_data = '1; 
               //else if (opcode_2 == LW_op) if( A.j_address == jaddr_check) j_flag = A.rd_v;
               else out_data = '1;
                   
               end
            end         
//       always_ff @(posedge clk) begin
//          out_data_f <= out_data;
//          //out_data_f <= out_data_1;
//       end      
        
        always @(*) begin
            if (pcEn_2 == 1'b1) begin
                    if (out_data == A.rd_value) opDone_1 = 1'b1;
                    else opDone_1 = 1'b0;
                end                              
            else begin 
                opDone_1 = 1'b0; 
            end
         end   
endmodule
