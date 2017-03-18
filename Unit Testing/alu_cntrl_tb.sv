
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company: Portland State University
// Engineer: Daksh Dharod
// 
// Create Date: 03/05/2017 09:16:16 PM
//
// Module Name: Unit Testing: alu_control_tb
//
// Description: The following file is the unit testing for alu control module. The alu opcode is given and the control signals are observed.   
//				For alu opcode = 0, the funct bits are checked and the alu control signals are assigned.
//				The following testbench is a self checking test bench which displays whether for the following opcode and funct bits, the alu_control
//				signals are correct or not. All the possible opcodes and funct bits are given and checked.
// 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module alu_cntrl_tb;

    logic  [5:0] funct;			
	logic  [1:0] aluop;
	logic [3:0] aluctl;
	integer i;
	
	alu_control tb(.*);				// alu_control module is instantiated
	
	// different input test signals are given and compared with its respective output.
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
	
	// For add opcode all funct bits are given as input and its functionality is checked
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
	
	end
	end
	
endmodule
