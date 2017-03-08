//------------------------------------------------------------------
//   Mentor Graphics, Corp.
//
//   (C) Copyright, Mentor Graphics, Corp. 2003-2004
//   All Rights Reserved
//   Licensed Materials - Property of Mentor Graphics, Corp.
//
//   No part of this file may be reproduced, stored in a retrieval system,
//   or transmitted in any form or by any means --- electronic, mechanical,
//   photocopying, recording, or otherwise --- without prior written permission
//   of Mentor Graphics, Corp.
//
//   WARRANTY:
//   Use all material in this file at your own risk.  Mentor Graphics, Corp.
//   makes no claims about any material contained in this file.
//------------------------------------------------------------------

module dut(out, out_avl,           // outputs
           in1, in2, in_avl,       // inputs
           optype,                 // action
           clk, reset);            // clk/reset

// input variables
input         clk;
input         reset;
input         in_avl;
input [31:0]  in1;
input [31:0]  in2;
input [1 :0]  optype;

// output variables
output [31:0] out;
reg    [31:0] out;
output        out_avl;
reg           out_avl;

// local variables
integer       rem_val;
reg           in_process;

localparam ADD = 0;
localparam SUB = 1;
localparam FACTORIAL = 2;
localparam NONE = 3;

always @(posedge clk or negedge reset)
begin
    if (reset == 0)
    begin
        out = 0;
        out_avl = 0;
        rem_val = 0;
        in_process = 0;
    end
    else
    begin
        out_avl = 0;
        if (in_avl)
        begin
           out = 1;
           in_process = 1;
           rem_val = in1;
        end
        if (in_process)
        begin
           case (optype)
           ADD :
              begin
                 out = in1 + in2;
                 out_avl = 1;
                 in_process = 0;
              end
           SUB :
              begin
                 out = in1 - in2;
                 out_avl = 1;
                 in_process = 0;
              end
           FACTORIAL :
              begin
                 out = out * rem_val;
                 rem_val = rem_val - 1;
                 if (rem_val == 0)
                 begin
                    out_avl = 1;
                    in_process = 0;
                 end
              end
           endcase
        end
    end
end


endmodule
