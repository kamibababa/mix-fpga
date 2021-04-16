`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module out_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 100000;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;
reg reset = 1;
//-- Leds port
reg start = 0;
reg [11:0] ain = 12'd8;
reg load=0;
wire request;
always @(posedge clk)
	if (request) load <=1;
	else load <= 0;
reg [29:0] mem[55:0];
initial begin
mem[12'd8] = 30'o0102030405;
mem[12'd9] = 30'o0607101112;
mem[12'd10] = 30'o0607101112;
mem[12'd50] = 30'o3132333435;
mem[12'd51] = 30'o3637303132;
mem[12'd52] = 30'o3637303132;
end
wire [11:0] aout;
wire [29:0] in;
assign in = mem[aout];
//-- Instantiate the unit to test
out OUT(
	   .clk(clk),
	   .reset(reset),
	   .start(start),
	   .addressin(ain),
	   .addressout(aout),
	   .load(load),
	   .request(request),
	   .in(in)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, out_tb);
  	#1 reset = 0;
	#2 start = 1;
	#1 start = 0;
	#0 ain = 12'd50;
	#6 start = 1;
	#1 start = 0;
	#20
   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
