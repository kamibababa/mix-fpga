// FDIV - command 4(6)

`default_nettype none

module fdiv(
	input wire clk,
	input wire start,
	output stop,
	input wire [30:0] dividend,
	input wire [30:0] divisor,
	output [30:0] out,
	output overflow
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
	reg eight;
	always @(posedge clk)
		if (seven) eight <= 1'd1;
		else eight <= 1'd0;
	reg nine;
	always @(posedge clk)
		if (eight) nine <= 1'd1;
		else nine <= 1'd0;
	assign stop = nine;	
	wire calc;
	assign calc=one | two | three | four | five | six | seven | eight | nine ;	

	// overflow is determined on cycle 2, when both operands are available
	reg overflow;	
	always @(posedge clk)
		if (one) overflow <= (dvsm[29:0] == 30'd0) | ~i0;
	
	// sign is calculated at cycle 2, when second operand comes into play
	reg sign;
	always @(posedge clk)
		if (start) sign <= dividend[30];
		else if (one) sign <= sign ^ divisor[30];


	// the divisor comes up on cycle number 2
	reg [23:0] dvs2m;
	always @(posedge clk)
		if (one) dvs2m <= divisor[23:0];
	
	wire [23:0] dvsm;
	assign dvsm = (one)? divisor[23:0] : dvs2m;
	
	// the dividend comes up at start and will be shifted to left by
	// 3 bits
	reg [27:0] dvdm;
	always @(posedge clk)
		if (start) dvdm <= {4'd0,dividend[23:0]};
		else if (calc) dvdm <= {1'd0,rest,3'd0};
	
		
	// calculate the possible rests	
	wire [27:0] d1;
	wire [27:0] d2;
	wire [27:0] d3;
	wire [27:0] d4;
	wire [27:0] d5;
	wire [27:0] d6;
	wire [27:0] d7;
	assign d1 = dvdm - {4'd0,dvsm};
	assign d2 = dvdm - {3'd0,dvsm,1'd0};
	assign d3 = dvdm - ({3'd0,dvsm,1'd0}+{4'd0,dvsm});
	assign d4 = dvdm - {2'd0,dvsm,2'd0};
	assign d5 = dvdm - ({2'd0,dvsm,2'd0} + {4'd0,dvsm});
	assign d6 = dvdm - ({2'd0,dvsm,2'd0} + {3'd0,dvsm,1'd0});
	assign d7 = dvdm - ({2'd0,dvsm,2'd0} + {3'd0,dvsm,1'd0} + {4'd0,dvsm});
	
	// look for the biggest quotient	
	wire i7;
	assign i7 = ~d7[27];
	wire i6;
	assign i6 = ~i7 & ~d6[27];
	wire i5;
	assign i5 = ~(i6|i7) & ~d5[27];
	wire i4;
	assign i4 = ~(i5|i6|i7) & ~d4[27];
	wire i3;
	assign i3 = ~(i4|i5|i6|i7) & ~d3[27];
	wire i2;
	assign i2 = ~(i3|i4|i5|i6|i7) & ~d2[27];
	wire i1;
	assign i1 = ~(i2|i3|i4|i5|i6|i7) & ~d1[27];
	wire i0;
	assign i0 = ~(i1|i2|i3|i4|i5|i6|i7);
	
	// that gives the smallest rest
	wire [23:0] rest;
	assign rest = (i7)? d7[23:0]:
			(i6)? d6[23:0]:
			(i5)? d5[23:0]:
			(i4)? d4[23:0]:
			(i3)? d3[23:0]:
			(i2)? d2[23:0]:
			(i1)? d1[23:0]:
			dvdm;

	// this gives one octal digit of the quotient
	wire [2:0] digit;
	assign digit = {i4|i5|i6|i7,i2|i3|i6|i7,i1|i3|i5|i7}; 
	
	// the digit is then shifted in the quotient
	reg [23:0] quot;
	always @(posedge clk)
		if (start) quot <= 24'd0;
		else if (calc) quot <= out;

	assign out  = {sign,e[5:0],quot[20:0],digit};	

	reg [6:0] e;
	always @(posedge clk)
		if (start) e <= {1'd0,dividend[29:24]};
		else if (one) e <= e - {1'd0,divisor[29:24]} + 7'o040;

endmodule
