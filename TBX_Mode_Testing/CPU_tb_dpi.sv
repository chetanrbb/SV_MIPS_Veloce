

///////////////////////////////////////////////////
// File Name: CPU_tb_dpi.sv
// 
// Author: Chetan
//
// Description: 
// 1. This file will check the CPU model. This module will read the nstruction from the instruction memory and give it to the CPU module for computation. 
// 2. After the computation is done on teh CPU module then the CPU will send a flag to indicate that the operaiton is completed.
// 3. On receiving the operation complete flag it will check if the Instructino read is over or not. 
// 4. If the instruction read is not over then teh result will be sent to the HVL. If the instruction read is over then the operation terminate will be called. 
////////////////////////////////////////////////////////

module CPU_tb_dpi();



endmodule