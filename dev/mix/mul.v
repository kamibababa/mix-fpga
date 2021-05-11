// MUL - command 3

`default_nettype none
module mul(
	input wire clk,
	input wire start,
	input wire [30:0] in1,
	input wire [30:0] in2,
	output [59:0] out,
	output stop,
	output sign
);
	// | start	| 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
	// | start2     | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 
	// | stop       | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 |
	// | run        | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0 |
	// | counter    | 0 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 0 | 0 |
	// | last       | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 |
	// | in1        | a | x | x ...
	// | in2        | x | b	| x ...
	// | sign       |sa |sab|sab ...                    |sab|
	// | out        | x | 0 | ...                       |a*b|
	
	reg start2;
	always @(posedge clk)
		if (start) start2 <= 1'd1;
		else start2 <= 1'd0;
	
	reg stop;	
	always @(posedge clk)
		if (last) stop <= 1'd1;
		else stop <= 1'd0;

	reg run;
	always @(posedge clk)
		if (start) run <= 1'd1;
		else if (last) run <= 1'd0;
	
	reg [3:0] counter;
	always @(posedge clk)
		if (start|last) counter <= 4'd0;
		else if (run) counter <= counter + 4'd1;
	
	wire last;
	assign last = (counter == 4'd7);

	
	// sign of product
	reg sign;
	always @(posedge clk)
		if (start) sign <= in1[30];
		else if (start2) sign <= sign ^ in2[30];


	// a is first factor, and goes in a shifter
	reg [29:0] a;
	always @(posedge clk)
		if (start) a <= in1[29:0];
		else if (start2) a <= {a[27:0],2'd0};
		else if (run) a <= {a[25:0],4'd0};
	
	// b is second factor, available at second cycle (start2)
	reg [29:0] b2;
	always @(posedge clk)
		if (start2) b2 <= in2[29:0];

	wire [29:0] b;
	assign b = (start2)? in2[29:0] : b2;

	// out computes the product
	reg [59:0] out;
	always @(posedge clk)
		if (start) out <= 60'd0;
		else if (start2) out <= {out[57:0],2'd0} + a[29:28] * b;
		else if (run) out <= {out[55:0],4'd0} + a[29:26] * b;

endmodule
