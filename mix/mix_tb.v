//-------------------------------------------------------------------
//-- leds_tb.v
//-- Testbench
//-------------------------------------------------------------------
//-- Michael Schröder
//-- GPL license
//-------------------------------------------------------------------
`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 1ns / 1ns

module mix_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 240;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;
reg reset = 1;
wire [30:0] regA;
//-- Instantiate the unit to test
mix MIX (
	.reset(reset),
	.clk(clk),
	.a(regA)
);


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, mix_tb);
  #3 reset = 0;
   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
