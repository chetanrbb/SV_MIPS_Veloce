`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2017 05:46:31 PM
// Design Name: 
// Module Name: dm_tb
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


module dm_tb;

    logic			clk;
    logic	[6:0]	addr;
    logic			rd, wr;
    logic 	[31:0]	wdata;
    logic	[31:0]	rdata;
    integer c;
    integer d=0, e=0,z=0;
    logic [100:0][31:0] x;
  logic [100:0][31:0] y;
  logic [100:0][6:0] q,w;
    dm tb(.*);
    
    initial begin
    clk = 1'b1;
    end
    
    always #5 clk = ~clk;
    
    initial begin
    wr = 1'b1;
    rd = 1'b0;
    addr = 7'd100;
    wdata = 32'd20;
    $display("Write data: %32d",rdata);
    #10;
    wr=1'b0;
    rd=1'b1;
    $display("Read data: %32d",rdata);
    
    
     $display("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
     $display("Exhaustive writting \n"); 
     addr = 7'h00;
     wdata = 32'h0;
     wr = 1'b1; 
     rd = 1'b0;
     for(d=1; d<=101; d++) begin
        addr = addr + 5;
        q[d] = addr;
        wdata = wdata + 10;
        x[d] = wdata;
        #10; 
     end    
   
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
    addr = 7'h0;   
    wr=1'b0;
    rd= 1'b1;                
    $display("--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
    $display("Exhaustive reading from same locations \n");      
    for(e=0; e<=100; e++) begin
        y[e] = rdata;
        addr = addr + 5;
        w[e+1]=addr;
        y[e] = rdata;
        #10;         
    end     
rd= 1'b0;
       
       
       c = $fopen("operations.txt","w");
       $fwrite(c, "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n");
       $fwrite(c,"Exhaustive write and read operations is performed 100 times \n");
       
   // Checking is done if the intended read done at a particular location is same as the data written at that location.  
       
       for( z=1; z<101 ;z++)begin
           if( (x[z]==y[z])&&(q[z]==w[z])) $fwrite(c,"Test: %d \t Write Address: %4h \t Write Value: %4h \t Read Address: %4h \t Read Value: %4h \t Match! \n",z,q[z],x[z],w[z],y[z]);
           else $fwrite(c,"Test: %d \t Write Address: %4h \t Write Value: %4h \t Read Address: %4h \t Read Value: %4h \t Not Match! \n",z,q[z],x[z],w[z],y[z]);;
           end 
       $fclose(c);
       end 
endmodule
