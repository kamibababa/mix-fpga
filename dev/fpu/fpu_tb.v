`default_nettype none

module fpu_tb();

reg clk = 1;
reg reset = 1;
always #1 clk = ~clk;
always @(posedge clk)
	reset <= 0;

reg [30:0] in1;
reg [30:0] in2;

reg start;
fmul FMUL(
	.clk(clk),
	.start(start),
	.in1(in1),
	.in2(in2)
);
fdiv FDIV(
	.clk(clk),
	.start(start),
	.dividend(in1),
	.divisor(in2)
);
fadd FADD(
	.clk(clk),
	.start(start),
	.sub(0),
	.in1(in1),
	.in2(in2)
);
fadd FSUB(
	.clk(clk),
	.start(start),
	.sub(1),
	.in1(in1),
	.in2(in2)
);

initial begin
  $dumpfile("fpu_tb.vcd");
  $dumpvars(0, fpu_tb);
  	#2 start <= 1'd1; in1 <= {1'd0,6'o03,24'o01407701}; in2 <= {1'd0,6'o01,24'o77014000};   //0.5*0.5 = 0.25 
	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd0,6'o17,24'o01267474}; in2 <= {1'd0,6'o22,24'o66736126};   //0o1614132675667050 
	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd1,6'o55,24'o55555555}; in2 <= {1'd1,6'o54,24'o03333333};   //0o1614132675667050 
	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd1,6'o00,24'o03333333}; in2 <= {1'd0,6'o33,24'o05555555};   //0o1614132675667050 
	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd1,6'o00,24'o00000000}; in2 <= {1'd0,6'o33,24'o03333333};   //0o1614132675667050 
	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd1,6'o55,24'o05000000}; in2 <= {1'd1,6'o00,24'o00000000};   //0o1614132675667050 
	#2 start <= 1'd0;
      	#24
$finish;
end

endmodule
