`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module mix_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 200000;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;
wire rx;
reg button;
//-- Instantiate the unit to test
mix MIX(
	   .clk_in(clk),
	   .rx(rx),
	   .button(button)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, mix_tb);
	#10000 button <= 1;
	#2 button <= 0;
   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
