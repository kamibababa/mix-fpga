// FMUL - command 3

`default_nettype none
module fmul(
	input wire clk,
	input wire start,
	input wire [30:0] in1,
	input wire [30:0] in2,
	output [30:0] out,
	output stop,
	output wire overflow
);
	reg one;
	always @(posedge clk)
		if (start) one <= 1'd1;
		else one <= 1'd0;
	reg two;
	always @(posedge clk)
		if (one) two <= 1'd1;
		else two <= 1'd0;
	reg three;
	always @(posedge clk)
		if (two) three <= 1'd1;
		else three <= 1'd0;
	reg four;
	always @(posedge clk)
		if (three) four <= 1'd1;
		else four <= 1'd0;
	reg five;
	always @(posedge clk)
		if (four) five <= 1'd1;
		else five <= 1'd0;
	reg six;
	always @(posedge clk)
		if (five) six <= 1'd1;
		else six <= 1'd0;
	reg seven;
	always @(posedge clk)
		if (six) seven <= 1'd1;
		else seven <= 1'd0;
	assign stop = seven;	
	// sign of product
	reg sign;
	always @(posedge clk)
		if (start) sign <= in1[30];
		else if (one) sign <= sign ^ in2[30];


	// a is first factor, and goes in a shifter
	reg [23:0] a;
	always @(posedge clk)
		if (start) a <= in1[23:0];
		else if (one|two|three|four|five) a <= {a[19:0],4'd0};

	wire calc;
	assign calc = one | two | three | four | five | six;
	// b is second factor, available at second cycle (start2)
	reg [23:0] b2;
	always @(posedge clk)
		if (one) b2 <= in2[23:0];

	wire [23:0] b;
	assign b = (one)? in2[23:0] : b2;

	// out computes the product
	reg [47:0] prod;
	always @(posedge clk)
		if (start) prod <= 48'd0;
		else if (calc) prod <= {prod[43:0],4'd0} + a[23:20] * b[23:0];
	reg [6:0] expo;
	always @(posedge clk)
		if (start) expo <= {1'd0,in1[29:24]};
		else if (one) expo <= expo + {1'd0,in2[29:24]} - 7'o040;
		else expo <= expo;
	//shift

	wire shift;
	assign shift = seven & (prod[47:42]==6'd0);
	wire [6:0] es;
	wire [47:0] ms;
	assign ms = shift? {prod[41:0],6'd0}: prod;
	assign es = expo + {6'd0,shift};

	//round
	wire round;
	assign round = seven & ms[23] & ~((ms[22:0]==23'd0)&~ms[24]);
	wire [24:0] mr;
	assign mr = {1'd0,ms[47:24]}+{24'd0,round};
	wire [6:0] er;
	assign er = es + {6'd0,mr[24]};
	wire [23:0] mp;
	assign mp = mr[24]? {5'd0,mr[24:6]}: {mr[23:0]};
	// pack
	assign out = {sign,er[5:0],mp};
	assign overflow = er[6];
endmodule
