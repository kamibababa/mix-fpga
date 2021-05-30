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
	wire stop;
	assign stop = last;
	reg run;
	always @(posedge clk)
		if (start) run <= 1;
		else if (last) run <= 0;
	
	reg [3:0] count;
	always @(posedge clk)
		if (start|last) count <= 4'd0;
		else if (run) count <= count + 1;
	wire last;
	assign last = count == 4'd7;
	wire one;
	assign one = run & (count==4'd0);
	// sign of product
	reg sign;
	always @(posedge clk)
		if (start) sign <= in1[30];
		else if (one) sign <= sign ^ in2[30];


	// a is first factor, and goes in a shifter
	reg [23:0] a;
	always @(posedge clk)
		if (start) a <= in1[23:0];
		else if (run) a <= {a[20:0],3'd0};

	// b is second factor, available at second cycle (start2)
	reg [23:0] b2;
	always @(posedge clk)
		if (one) b2 <= in2[23:0];

	wire [23:0] b;
	assign b = (one)? in2[23:0] : b2;

	// out computes the product
	wire [47:0] prod;
	assign prod = {oldprod[44:0],3'd0} + a[23:21] * b[23:0];
	reg [47:0] oldprod;
	always @(posedge clk)
		if (start) oldprod <= 48'd0;
		else if (run) oldprod <= prod;
	reg [6:0] expo;
	always @(posedge clk)
		if (start) expo <= {1'd0,in1[29:24]};
		else if (one) expo <= expo + {1'd0,in2[29:24]}-7'o040;
	
	//shift
	wire shift;
	assign shift = last & (prod[47:42]==6'd0);
	wire [6:0] es;
	wire [47:0] ms;
	assign ms = shift? {prod[41:0],6'd0}: prod;
	assign es = expo - {6'd0,shift};

	//round
	wire round;
	assign round = last & ms[23] & ~((ms[22:0]==23'd0)&~ms[24]);
	wire [24:0] mr;
	assign mr = {1'd0,ms[47:24]}+{24'd0,round};
	wire [6:0] er;
	assign er = es - {6'd0,mr[24]};
	wire [23:0] mp;
	assign mp = mr[24]? {5'd0,mr[24:6]}: {mr[23:0]};
	// pack
	assign out = {sign,er[5:0],mp};
	assign overflow = last & er[6];
endmodule
