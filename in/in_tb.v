`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module in_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 100000;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;
reg reset = 1;
reg [6:0] in=7'd65;
reg starttx;
wire rx;
reg start;
wire request;
reg store;
always @(posedge clk)
	if (request&~store ) store <= 1;
	else store <= 0;
UartTX TX(.clk(clk),.tx(rx),.load(starttx),.in(in));
reg [11:0] ain;
//-- Instantiate the unit to test
in IN(
	   .clk(clk),
	   .start(start),
	   .addressin(ain),
	   .reset(reset),
	   .store(store),
	   .request(request),
	   .rx(rx)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, in_tb);
  	#1 ain =12;
  	#3 reset = 0;
	#1 start = 1;
	#1 start = 0;
	#3 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	ain=123;
	#400 start =1;
	#1 start =0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	in = 7'd13;
	#1000 starttx = 1;
	#1 starttx = 0;
	in=7'd10;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	in=7'd65;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	#1000 starttx = 1;
	#1 starttx = 0;
	in=8'd10;
	#1000 starttx = 1;
	#1 starttx = 0;
	#20
   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
