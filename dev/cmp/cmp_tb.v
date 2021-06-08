`default_nettype none
module cmp_tb();

reg clk = 1;
always #0.5 clk = ~clk;

reg [30:0] in1;
reg [30:0] in2;
reg start;
//-- Instantiate the unit to test
cmp CMP(.clk(clk),
	.start(start),
	.in1(in1),
	.in2(in2)
);
initial begin

  //-- File were to store the simulation results
  $dumpfile("cmp_tb.vcd");
  $dumpvars(0, cmp_tb);
	#2 start <= 1;in1<=31'o14201013741 ;in2<=31'o14201013741;
	#2 start <= 0;
	#6 start <= 1;in1<=31'o14175403740 ;in2<=31'o14175403740;
	#2 start <= 0;
	#6 start <= 1;in1<=31'o14201764060 ;in2<=31'o14201764060;
	#2 start <= 0;
	#6 start <= 1;in1<=31'o14002004060 ;in2<=31'o14002004060;
	#2 start <= 0;
	#100
  $finish;
end

endmodule
