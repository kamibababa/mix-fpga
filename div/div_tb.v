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

module div_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 10;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;

//-- Leds port
reg [59:0] out=2098570923875;
reg [29:0] a=837504;
wire [29:0] b;
reg start = 0;
//-- Instantiate the unit to test
div UUT (
	   .clk(clk),
	   .start(start),
           .a(a),
           .b(b),
	   .c(out)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, div_tb);
	#4 start = 1;
	#3 start = 0;
	#12
   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
