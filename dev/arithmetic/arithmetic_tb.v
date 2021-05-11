`default_nettype none

module arithmetic_tb();

reg clk = 1;
reg reset = 1;
always #1 clk = ~clk;
always @(posedge clk)
	reset <= 0;

reg [30:0] in1;
reg [30:0] in2;
reg [60:0] dvd;
reg [30:0] dvs;

reg start;
reg [12:0] a;
reg [12:0] b;
add ADD(
	   .clk(clk),
	   .start(start),
           .in1(in1),
           .in2(in2)
         );
sub SUB(
	   .clk(clk),
	   .start(start),
           .in1(in1),
           .in2(in2)
         );

mul MUL(
	.clk(clk),
	.start(start),
	.in1(in1),
	.in2(in2)
);

div DIV(
	.clk(clk),
	.start(start),
	.dividend(dvd),
	.divisor(dvs)
);

add12 ADD12(.a(a),.b(b));
dec DEC(.in1(in1),.in2(in2));
inc INC(.in1(in1),.in2(in2));

initial begin
  $dumpfile("arithmetic_tb.vcd");
  $dumpvars(0, arithmetic_tb);
  	#2 start <= 1'd1; in1 <= {1'd0,30'd123}; in2 <= {1'd0,30'd123}; dvd <= {1'd0,60'd50}; dvs <= {1'd0,30'd17};a <= {1'd0,12'd16};b<={1'd0,12'd3};
	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd0,30'd123}; in2 <= {1'd1,30'd123}; dvd <= {1'd0,60'd50}; dvs <= {1'd1,30'd17};a <= {1'd1,12'd16};b<={1'd0,12'd3};

	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd1,30'd123}; in2 <= {1'd0,30'd123}; dvd <= {1'd1,60'd50}; dvs <= {1'd0,30'd17};a <= {1'd0,12'd16};b<={1'd1,12'd3};

	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd1,30'd123}; in2 <= {1'd1,30'd123}; dvd <= {1'd1,60'd50}; dvs <= {1'd1,30'd17};a <= {1'd1,12'd16};b<={1'd1,12'd3};

	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd0,30'o7777777777}; in2 <= {1'd0,30'o1}; dvd <= {1'd0,60'o77777777767777777777}; dvs <= {1'd0,30'o7777777777};a <= {1'd1,12'd3};b<={1'd0,12'd3};

	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd0,30'o7777777777}; in2 <= {1'd0,30'o1}; dvd <= {1'd0,60'o77777777777777777777}; dvs <= {1'd0,30'd0};a <= {1'd0,12'd3};b<={1'd1,12'd3};

	#2 start <= 1'd0;
      	#24
  	#2 start <= 1'd1; in1 <= {1'd0,30'o7777777777}; in2 <= {1'd0,30'o1}; dvd <= {1'd0,60'o11234567012345670123}; dvs <= {1'd0,30'o1234567012};
	#2 start <= 1'd0;
      	#24

$finish;
end

endmodule
