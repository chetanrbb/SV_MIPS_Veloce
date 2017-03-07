module booth_tb_dpi;

reg       clk;
reg       reset;
int 	  m,r; 
longint   product;
logic 	  load; 
logic     done; 
integer  isMoreData ;


//clock generator
//tbx clkgen
initial
begin
    clk = 0;
    forever
    begin
        #10 clk = ~clk; 
    end
end


//reset generator
//tbx clkgen
initial
begin
    reset = 1;
    #20 reset = 0;
end



// This is the declaration of an imported task
// whose definition is written at c-side and 
// will be called from HDL.

import "DPI-C" task reset_completed ();
import "DPI-C" task GetDataFromSoftware (output bit [31:0] m, output bit [31:0] r, output bit [31:0] isMoreData);
import "DPI-C" task SendDataToSoftware (input bit [31:0] data1);
import "DPI-C" task computation_completed ();


initial begin
    @(posedge clk);
    while(reset) @(posedge clk);
    reset_completed;
end



always @(posedge clk)
begin
    if (!reset)
    begin
	
		while(!done)   //If Multiplier is Busy, wait
		@(posedge clk);
		
        GetDataFromSoftware(m, r, isMoreData); //Get data from software
		
		load <= '1;
		@(posedge clk);
		load <= '0;
		
		while(done)
		@(posedge clk);
		
		while(!done)
		@(posedge clk);
		
		SendDataToSoftware(product);
		
        if (isMoreData == 0)
        begin
           computation_completed;
           $finish();
        end
    end
end

booth_fsm DUT  
  ( .m(m),
    .r(r),
    .clk(clk),
	.load(load),
	.reset(reset),
    .product(product),
    .done(done));


endmodule
