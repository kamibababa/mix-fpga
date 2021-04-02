//-------------------------------------------------------------------
//-- leds_tb.v
//-- Testbench
//-------------------------------------------------------------------
//-- Michael Schröder
//-- GPL license
//-------------------------------------------------------------------
`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module mul_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 10;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;

//-- Leds port
wire [59:0] out;
reg [29:0] a=792348734;
reg [29:0] b=234234234;
reg start = 0;
//-- Instantiate the unit to test
mul UUT (
	   .clk(clk),
	   .start(start),
           .a(a),
           .b(b),
	   .out(out)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, mul_tb);
	#4 start = 1;
	#3 start = 0;
	#12
   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
