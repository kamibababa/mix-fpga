// FADD - command 1(6)

`default_nettype none
module fadd(
	input wire clk,
	input wire start,
	input wire sub,
	input wire [30:0] in1,
	input wire [30:0] in2,
	output [30:0] out,
	output stop,
	output wire overflow
);
	reg subtract;
	always @(posedge clk)
		if (start) subtract <= sub;

	reg one;
	always @(posedge clk)
		if (start) one <= 1;
		else one <= 0;
	reg two;
	always @(posedge clk)
		if (one) two <= 1;
		else two <= 0;
	reg three;
	always @(posedge clk)
		if (two) three <= 1;
		else three <= 0;
	assign stop = three;
	// find bigger
	wire [6:0] e1m2;
	assign e1m2 = {1'd0,ae} - {1'd0,in2[29:24]};
	wire [6:0] e2m1;
	assign e2m1 = {1'd0,in2[29:24]} - {1'd0,ae};
	wire [24:0] m1m2;
	assign m1m2 = {1'd0,am} - {1'd0,in2[23:0]};
	wire [24:0] m2m1;
	assign m2m1 = {1'd0,in2[23:0]} - {1'd0,am};
	wire g1;
	assign g1 = e2m1[6] | ~e1m2[6] & ~e2m1[6] & m2m1[24]; 
	wire g2;
	assign g2 = e1m2[6] | ~e1m2[6] & ~e2m1[6] & m1m2[24]; 
	wire eq;
	assign eq = ~e1m2[6] & ~ e2m1[6] & ~ m1m2[24] & ~m2m1[24];

	// a is first factor, and goes in a shifter
	reg [23:0] am;
	always @(posedge clk)
		if (start) am <= in1[23:0];
		else if (one & g2) am <= in2[23:0];

	reg [5:0] ae;
	always @(posedge clk)
		if (start) ae <= in1[29:24];
		else if (one & g2) ae <= in2[29:24];

	// b is second factor, available at second cycle (start2)
	reg [54:0] calc;
	always @(posedge clk)
		if (one) calc <= {1'd0,shifted};
		else if (two & op) calc <= {1'd0,am,30'd0} - {1'd0,shifted};
		else if (two & ~op) calc <= {1'd0,am,30'd0} + {1'd0,shifted};

	wire shift0;
	assign shift0 = (diff == 6'd0);
	wire shift1;
	assign shift1 = (diff == 6'd1);
	wire shift2;
	assign shift2 = (diff == 6'd2);
	wire shift3;
	assign shift3 = (diff == 6'd3);
	wire shift4;
	assign shift4 = (diff == 6'd4);
	wire shift5;
	assign shift5 = (diff == 6'd5);

	reg [23:0] bm;
	always @(posedge clk)
		if (one & g2) bm <= am;
		else if (one & ~g2) bm <= in2[23:0];

	wire [53:0] shifted;
	assign shifted = shift0? {bm,30'd0}:
			 shift1? {6'd0,bm,24'd0}:
			 shift2? {12'd0,bm,18'd0}:
			 shift3? {18'd0,bm,12'd0}:
			 shift4? {24'd0,bm,6'd0}:
			 shift5? {30'd0,bm}:
			 {54'd0};

	reg [5:0] diff;
	always @(posedge clk)
		if (one & g2) diff <= e2m1[5:0];
		else if (one) diff <= e1m2[5:0];

	reg sign;
	always @(posedge clk)
		if (start) sign <= in1[30];
		else if (one & g2) sign <= in2[30]^subtract;
	
	reg op;
	always @(posedge clk)
		if (start) op <= in1[30];
		else if (one) op <= op ^ in2[30]^subtract;

	//extra shift?
	wire sm1;
	wire s1;
	wire s2;
	wire s3;
	wire s4;
	wire s5;
	assign sm1 = calc[54];
	assign s1 = calc[53:48]==6'd0;
	assign s2 = s1 & calc[47:42]==6'd0;
	assign s3 = s2 & calc[41:36]==6'd0;
	assign s4 = s3 & calc[35:30]==6'd0;
	assign s5 = s4 & calc[29:24]==6'd0;


	wire [6:0] es;
	assign es = sm1? {1'd0, ae}+7'd1: 
		    s5? {1'd0,ae}-7'd5:
		    s4? {1'd0,ae}-7'd4:
		    s3? {1'd0,ae}-7'd3:
		    s2? {1'd0,ae}-7'd2:
		    s1? {1'd0,ae}-7'd1:
		    {1'd0,ae};

	wire [53:0] ms;
	assign ms = sm1? {6'd1,calc[53:6]}:
		    s5? {calc[23:0],30'd0}:
		    s4? {calc[29:0],24'd0}:
		    s3? {calc[35:0],18'd0}:
		    s2? {calc[41:0],12'd0}:
		    s1? {calc[47:0],6'd0}:
		    {calc[53:0]};


	wire round;
	assign round = ms[29] & ~((ms[28:0]==29'd0)&ms[30]);
	wire [24:0] mr;
	assign mr = {1'd0,ms[53:30]} + {24'd0,round};
	wire [6:0] er; 
	assign er = es + {6'd0,mr[24]};
	wire [23:0] mp;
	assign mp = mr[24]? {5'd0,mr[24:6]}: {mr[23:0]};
	// pack
	wire zero;
	assign zero = (mp[23:0]==24'd0);
	assign out = {sign,zero? 6'd0 : er[5:0],mp};
	assign overflow = ~zero & er[6];
endmodule
