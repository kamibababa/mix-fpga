`default_nettype none

module mem_tb();

reg clk = 1;
reg reset = 1;
always #1 clk = ~clk;
always @(posedge clk)
	reset <= 0;
reg start;
st ST(
	.clk(clk),
	.start(start),
	.in({1'd0,30'd50}),
	.data({1'd1,30'dx}),
	.field(6'd13)
);


initial begin
  $dumpfile("mem_tb.vcd");
  $dumpvars(0, mem_tb);
  	#2 start <= 1'd1;
	#2 start <= 1'd0;
      	#24
$finish;
end

endmodule
