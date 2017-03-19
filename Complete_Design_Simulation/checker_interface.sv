`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chetan B. | Harsh M. | Daksh D.
//			
// 
// Create Date: 03/09/2017 12:19:05 PM
// Design Name: CheckerInterface 
// Module Name: cpu_checker
// Project Name: SV_MIPS 
// Target Devices: Veloce 
// Tool Versions: 
// Description: 	This acts as an interface between the CPU and the Checker module. 
// It is used to tap the signals from the CPU and give it to the Checker. 
// 
// 
//////////////////////////////////////////////////////////////////////////////////


interface ccheck;

    logic [31:0] rs_value,rt_value,rd_value;		// Values of all registers
	logic [31:0] branch_addr, jump_addr, lw_data;	// registers used to store address 

	// This port is used in CPU 
    modport H
    (
        output rs_value,
        output rt_value,
        output rd_value,
		output branch_addr,
		output jump_addr,
		output lw_data
    );
    
	// This port is used in Checker 
    modport M
    (
        input rs_value,
        input rt_value,
        input rd_value,
		input branch_addr,
		input jump_addr,
		input lw_data
    );
    
endinterface: ccheck