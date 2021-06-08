`default_nettype none
module char_tb();

reg clk = 1;
always #0.5 clk = ~clk;

reg [29:0] a=60'o0601111500;
reg start = 0;
//-- Instantiate the unit to test
char CHAR(
	   .clk(clk),
	   .start(start),
           .in(a)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile("char_tb.vcd");
  $dumpvars(0, char_tb);
	#3 start <= 1;
	#2 start <= 0;
	#100
  $finish;
end

endmodule
