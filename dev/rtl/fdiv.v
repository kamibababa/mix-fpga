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
	assign last = count == 4'd9;
	wire one;
	assign one = run & (count==4'd0);
	wire two;
	assign two = run & (count==4'd1);
	
	// sign is calculated at cycle 2, when second operand comes into play
	reg sign;
	always @(posedge clk)
		if (start) sign <= dividend[30];
		else if (one) sign <= sign ^ divisor[30];

	reg zero;
	always @(posedge clk)
		if (start) zero <= dividend[29:0] == 30'd0;

	
	// the divisor comes up on cycle number 2
	reg [23:0] dvsm2;
	always @(posedge clk)
		if (one) dvsm2 <= dvsm;
	
	wire [23:0] dvsm;
	assign dvsm = (one & divisor[23:21]==3'd0)? {divisor[20:0],3'd0} : 
	              one? divisor[23:0]: dvsm2;

      
	reg divzero;
	always @(posedge clk)
		if (one) divzero <= divisor[29:0] == 30'd0;
   	reg leadingnulld;
	always @(posedge clk)
		if (start) leadingnulld <= (dividend[23:21]==3'd0);
      	reg leadingnulls;
	always @(posedge clk)
		if (one) leadingnulls <= (divisor[23:21]==3'd0);


	// the dividend comes up at start and will be shifted to left by
	// 3 bits
	reg [27:0] dvdm;
	always @(posedge clk)
		if (start & dividend[23:21]==3'd0) dvdm <= {4'd0,dividend[20:0],3'd0};
		else if (start) dvdm <= {4'd0,dividend[23:0]};
		else if (run) dvdm <= {1'd0,rest,3'd0};
		
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
			dvdm[23:0];

	// this gives one octal digit of the quotient
	wire [2:0] digit;
	assign digit = {i4|i5|i6|i7,i2|i3|i6|i7,i1|i3|i5|i7}; 
	
	// the digit is then shifted in the quotient
	reg [26:0] quot;
	always @(posedge clk)
		if (start) quot <= 27'd0;
		else if (run) quot <= {quot[23:0],digit};

	reg [6:0] e;
	always @(posedge clk)
		if (start) e <= {1'd0,dividend[29:24]};
		else if (one) e <= e - {1'd0,divisor[29:24]} + 7'o040;
		else if (two & leadingnulls & ~leadingnulld) e <= e + 7'o1;
	
	wire [29:0] mout;
	assign mout = (leadingnulld^leadingnulls)? {3'd0,quot[26:0]}:{quot[26:0],digit};

	//shift
	wire [32:0] mouts;
	wire [6:0] eouts;
	assign mouts = (mout[29:27]==3'd0)? {mout[26:0],6'd0}: {3'd0,mout[29:0]};
	assign eouts = (mout[29:27]==3'd0)? e:e+7'd1;
	
	//round
	wire round;
	assign round = (mouts[8] & ~((mout[7:0]==8'd0) & mouts[1] & rest[23:0]==24'd0)); 
	wire [23:0] moutr;
	assign moutr = round? mouts[32:9]+24'd1:mouts[32:9];

	//of
	assign overflow = eouts[6] | divzero;

	assign out = zero? {sign,30'd0}: {sign,eouts[5:0],moutr};


endmodule
