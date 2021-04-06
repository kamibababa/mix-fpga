// cmp - command 56-63
//
// compares two numbers a[31] and b[31]
// a,b = (sign, 5 bytes) = (sign, 30 bits)
//
// if a > b greater
// if a < b less
// if a == b equal

`default_nettype none
module cmp(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [30:0] in1,
	input wire [30:0] in2,
	output wire greater,
	output wire less,
	output wire equal
);
	always @(posedge clk)
		if (start) stop <= 1;
		else stop <= 0;
	reg [30:0] a;
	always @(posedge clk)
		if (start) a <= in1;
	wire [30:0] b;
	assign b = in2;
	wire [30:0] sub1;
	assign sub1 = a[29:0]-b[29:0];
	wire [30:0] sub2;
	assign sub2 = b[29:0]-a[29:0];
	
	assign equal = (~(sub1[30]|sub2[30])) & ((a[30] & b[30]) | (~a[30] & ~b[30]));
	
	assign greater = a[30]?
				(b[30]?
					(sub1[30]):
					(0)):
				(b[30]?
					(1):
					(sub2[30]));
	
	assign less = a[30]?
				(b[30]?
					(sub2[30]):
					(1)):
				(b[30]?
					(0):
					(sub1[30]));

endmodule
