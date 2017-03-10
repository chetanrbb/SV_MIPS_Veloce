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
                input logic pcEn,
                output logic OpDone                  
            );
     
     logic [5:0] opcode,opcode_1,opcode_2,funct,funct_1,funct_2;
     logic [4:0] rd,shamt;
     logic [15:0] addr,imm;
     logic [25:0] jaddr;
     logic flag =0;
     logic [31:0] data1, data2;
     logic [31:0] out_data,out_data_1,out_data_f;
            
     always_ff @ (posedge A.clk) begin
//        A.rs = '0;
//        A.rt = '0;
//        shamt = '0;
//        funct = '0;
        if (pcEn == 1'b1) begin
            opcode = inst [31:26];
             
            unique case (opcode) 
            
                LW_op: begin
                        A.rs   = inst [25:21];
                        A.rt   = inst [20:16];
                        addr   = inst [15:0];            
                       end
                       
                SW_op: begin
                        A.rs   = inst [25:21];
                        A.rt   = inst [20:16];
                        addr   = inst [15:0];            
                       end       
                
                J_op: begin
                         jaddr = inst [25:0];
                        end
                        
                BEQ_op: begin
                         A.rs   = inst [25:21];
                         A.rt   = inst [20:16];
                         addr   = inst [15:0]; 
                        end
                
                BNE_op: begin
                         A.rs   = inst [25:21];
                         A.rt   = inst [20:16];
                         addr   = inst [15:0]; 
                        end        
                
                ADDI_op: begin
                          A.rs  = inst [25:21];
                          A.rt  = inst [20:16];
                          imm   = inst [15:0];  
                         end
                         
                ADD_op: begin
                         A.rs    = inst [25:21];
                         A.rt    = inst [20:16];          
                         rd      = inst [15:11];
                         shamt   = inst [10:6];
                         funct   = inst [5:0];      
                        end
                 default: begin 
                            A.rs = '0;
                            A.rt = '0;
                            shamt = '0;
                            funct = '0;
                          end            
            endcase
          end
          
         else begin end 
       end
        
//        always_ff @(A.rs_value) begin
//        $display("Rs value %d", A.rs_value);
//        $display("Rt value %d", A.rt_value);
//        $display("Rd value %d", A.rd_value);
//        end
            
       always_ff @( A.rs_value) begin
            opcode_1 <= opcode;         
        end
        
        always_ff @(posedge A.clk)  begin
            funct_1 <= funct;
            funct_2 <= funct_1;
        end
        
//        ADD = 4'd02, 
//                SUB = 4'd06, 
//                AND = 4'd00, 
//                NOR = 4'd12, 
//                OR  = 4'd01, 
//                SLT = 4'd07, 
//                XOR = 4'd13
        
        
        always_comb begin
            if(pcEn == 1) begin
               if (opcode_1 == ADD_op) begin
                   if(funct_2 == 'd2) out_data = A.rs_value + A.rt_value;
                   else if(funct_2 == 'd0) out_data = A.rs_value & A.rt_value;
                   else if (funct_2 == 06) out_data = A.rs_value - A.rt_value;
                   else if (funct_2 == 'd1) out_data= A.rs_value | A.rt_value;
                   else if (funct_2 == 'd12) begin out_data = A.rs_value | A.rt_value;
                                                out_data = ~out_data;
                                          end
                   else if (funct_2 == 'd7) out_data = A.rs_value < A.rt_value? 1:0;
                   else if (funct_2 == 'd13) out_data = A.rs_value ^ A.rt_value;
               end
               else if (opcode_1 == ADDI_op ) out_data = A.rt_value + A.rs_value;
               else if (opcode_1 == J_op) out_data = jaddr;
               else if (opcode_1 == BNE_op) if ( A.rs != A.rt) out_data = addr;  
               else if (opcode_1 == BEQ_op) if ( A.rs == A.rt) out_data = addr;  
    //           else if (opcode_1 == LW_op)
               else out_data = out_data;
                   
    //               end
            end  
            else begin end
        end        
//       always_ff @(posedge A.clk) begin
//          out_data_f <= out_data;
//          //out_data_f <= out_data_1;
//       end      
        
        always begin
            if (pcEn == 1'b1) begin
                OpDone = 1'b0;
                @(posedge A.clk);
                @(posedge A.clk);
                @(posedge A.clk) begin
                    if (out_data == A.rd_value) OpDone = 1'b1;
                    else OpDone = 1'b0;
                end
                @(posedge A.clk) OpDone = 1'b0;
                @(posedge A.clk);     
            end
            else begin 
                OpDone = 1'b0; 
            end
         end   
endmodule
