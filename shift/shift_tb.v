`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module shift_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 1000;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;

//-- Leds port
wire [59:0] out;
reg [29:0] a=792348734;
reg [29:0] b=234234234;
reg start = 0;
reg [11:0] m=12'd0;
reg tick=1;
always @(posedge clk)
	if (tick) tick<= 0;
	else tick <= 1;
always @(posedge clk)
	if (~tick) m <= m+1;
//-- Instantiate the unit to test
shift SHIFT(
	   .clk(clk),
	   .start(tick),
           .ina(a),
	   .inx(b),
	   .field(4),
	   .m(m)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, shift_tb);
	#4 start = 1;
	#1 start = 0;
	#12
   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
