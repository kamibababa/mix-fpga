`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module num_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 1000;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;

//-- Leds port
reg [59:0] in=60'o00010203040506071011;
reg start = 0;
//-- Instantiate the unit to test
num NUM(
	   .clk(clk),
	   .start(start),
           .in(in)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, num_tb);
	#4 start = 1;
	#1 start = 0;
	#12
   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
