`default_nettype none
module special_tb();

reg clk = 1;
always #0.5 clk = ~clk;

reg [59:0] in1;
reg [29:0] in2;
reg start;
//-- Instantiate the unit to test
num NUM(.clk(clk),
	.start(start),
	.in(in1)
);
char CHAR(
	   .clk(clk),
	   .start(start),
           .in(in2)
         );

hlt HLT(
	.clk(clk),
	.start(start)
);


initial begin

  //-- File were to store the simulation results
  $dumpfile("special_tb.vcd");
  $dumpvars(0, special_tb);
	#2 start <= 1;in1<=60'o001213141516172021 ;in2<=60'o7777777777;
	#2 start <= 0;
	#100
  $finish;
end

endmodule
