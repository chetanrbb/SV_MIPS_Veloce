
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2017 09:16:16 PM
// Design Name: 
// Module Name: alu_control_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 2'd0: aluctl <= 4'd2;	/* add */
// 2'd1: aluctl <= 4'd6;    /* sub */
// 2'd2: aluctl <= _funct; 
// 2'd3: aluctl <= 4'd2;    /* add */
//
//	----------------------------------------------------
//
// ADD:  _funct <= 4'd2;		// add 
// SUB:  _funct <= 4'd6;        // sub 
// OR:   _funct <= 4'd1;        // or 
// XOR:  _funct <= 4'd13;        // xor 
// NOR:  _funct <= 4'd12;        // nor 
// SLT:  _funct <= 4'd7;        // slt  
//
//  -----------------------------------------------------
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_cntrl_tb;

    logic  [5:0] funct;
	logic  [1:0] aluop;
	logic [3:0] aluctl;
	integer i;
	
	alu_control tb(.*);
	
	initial begin

	aluop = 2'd0;
	funct = 6'd3;
	#10;
	if(aluop == 0 && aluctl == 4'd2) $display("Correct Functionality");
    else $display("Error");
    
    
    #10;    
    aluop = 2'd1;
    funct = 6'd5;
    #10;
    if(aluctl == 4'd6) $display("Correct Functionality");
    else $display("Error");
    #10;
        
    aluop = 2'd3;
	funct = 6'd1;
	#10;
	if(aluctl == 4'd2) $display("Correct Functionality");
    else $display("Error");
    #10;
   
    for(i=0;i<=6;i++) begin
   
    aluop = 2'd2;
    funct = i;    
    #10;
    if(funct == 0 && aluctl == 2) $display("Correct Functionality");
    else if(funct == 1 && aluctl == 6) $display("Correct Functionality");     
    else if(funct == 2 && aluctl == 0) $display("Correct Functionality");   
    else if(funct == 3 && aluctl == 12) $display("Correct Functionality");   
    else if(funct == 4 && aluctl == 1) $display("Correct Functionality");   
    else if(funct == 5 && aluctl == 7) $display("Correct Functionality");   
    else if(funct == 6 && aluctl == 13) $display("Correct Functionality");   
    else $display("Error");
	
//	#10;
	end
	end
	



endmodule
