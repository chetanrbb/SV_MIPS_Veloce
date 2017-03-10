`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/09/2017 12:19:05 PM
// Design Name: 
// Module Name: cpu_checker
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


interface ccheck (input logic clk);

    logic [31:0] rs_value,rt_value,rd_value,pc;
    logic [4:0] rs,rt,rd;
    


    modport H
    (
        input rs,
        input rt,
        output rs_value,
        output rt_value,
        output rd_value,
        output pc  
    );
    
    modport M
    (
        input rs_value,
        input rt_value,
        input rd_value, 
        input pc,
        output rs,
        output rt       

    );
endinterface: ccheck
