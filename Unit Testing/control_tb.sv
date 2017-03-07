`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2017 12:33:46 AM
// Design Name: 
// Module Name: control_tb
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


module control_tb;

    logic	[5:0]	opcode;
	logic			branch_eq, branch_ne;
	logic    [1:0]	aluop;
	logic			memread, memwrite, memtoreg;
	logic			regdst, regwrite, alusrc;
	logic			jump;
	integer i;
		
	control tb(.*);
	
	initial begin
	for (i=0; i<=6 ;i++) begin
	opcode = i;
	#10;
	if(branch_eq == 0 && branch_ne == 0 && aluop == 00 && memread == 1 && memwrite == 0&& memtoreg == 1 && regdst == 0 && regwrite == 1 && alusrc == 1 && jump == 0 ) begin
	   $display("Current Functionality"); 
	end
	else if(branch_eq == 0 && branch_ne == 0 && aluop == 00 && memread == 0 && memwrite == 0 && memtoreg == 0 && regdst == 0 && regwrite == 1 && alusrc == 1 && jump == 0 ) begin
       $display("Current Functionality"); 
    end
        
    else if(branch_eq == 1 && branch_ne == 0 && aluop == 01 && memread == 0 && memwrite == 0&& memtoreg == 0 && regdst == 1 && regwrite == 0 && alusrc == 0 && jump == 0 ) begin
       $display("Current Functionality"); 
    end
    else if(branch_eq == 0 && branch_ne == 0 && aluop == 00 && memread == 0 && memwrite == 1 && memtoreg == 0 && regdst == 1 && regwrite == 0 && alusrc == 1 && jump == 0 ) begin
       $display("Current Functionality"); 
    end
    else if(branch_eq == 0 && branch_ne ==1 && aluop == 01 && memread == 0 && memwrite == 0&& memtoreg == 0 && regdst == 1 && regwrite == 0 && alusrc == 0 && jump == 0 ) begin
       $display("Current Functionality"); 
    end
    else if(branch_eq == 0 && branch_ne == 0  && memread == 0 && memwrite == 0 && memtoreg == 0 && regdst == 1 && regwrite == 1 && alusrc == 0 && jump == 0 ) begin
       $display("Current Functionality"); 
    end
    else if(branch_eq == 0 && branch_ne == 0 && memread == 0 && memwrite == 0 && memtoreg == 0 && regdst == 1 && regwrite == 1 && alusrc == 0 && jump == 1 ) begin
       $display("Current Functionality"); 
    end
	else $display("Error");
	end   
	end
			    
endmodule
