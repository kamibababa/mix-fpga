`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 10 ns / 10 ns

module mov_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 100;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;

//-- Leds port
reg start = 0;
reg [11:0] address = 12'd100;
reg [30:0] data[0:200];
initial begin
data[100] = 31'd12345;
data[101] = 31'd1245;
end
reg [5:0] len;

wire load;
reg [30:0] datain;
always @(posedge clk)
	if (load) datain <= data[addresso];
wire [11:0] addresso;
//-- Instantiate the unit to test
mov MOV(
	   .clk(clk),
	   .start(start),
           .addressin(address),
           .addressout(addresso),
	   .len(len),
	   .load(load)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, mov_tb);
	#4 start <= 1;len<=6'd10;
	#2 start <= 0;
	#200 start <=1; len<=0;
	#2 start <= 0;
   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
