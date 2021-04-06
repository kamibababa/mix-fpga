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
wire [11:0] pc;
wire [30:0] regA;
wire [30:0] regX;
wire [11:0] regJ;
wire [12:0] regI1;
wire [12:0] regI2;
wire [12:0] regI3;
wire [12:0] regI4;
wire [12:0] regI5;
wire [12:0] regI6;
//-- Instantiate the unit to test
mix MIX (
	.reset(reset),
	.clk(clk),
	.pc(pc),
	.RegisterA(regA)
//	.RegisterX(regX)
	//.RegisterJ(regJ),
	//.RegisterI1(regI1),
	//.RegisterI2(regI2),
	//.RegisterI3(regI3),
//	.RegisterI4(regI4),
//	.RegisterI5(regI5),
//	.RegisterI6(regI6)
);

initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, mix_tb);
  	#2 reset = 0;
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
	#2 $display("| %d | %o | %o | %o | ",pc,regA,regX,regJ);
   	#(DURATION) $display("End of simulation");
  $finish;
end

endmodule
