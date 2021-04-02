//------------------------------------------------------------------
//-- Hello world example
//-- Control leds by pushing the buttons
//-- This example has been tested on the following boards:
//--   * iCE40-HX1K-EVB Olimex
//------------------------------------------------------------------

module div(
	input wire clk,
	input wire start,
	output stop,
	input wire [29:0] a,
	output reg [29:0] b,
	input wire [59:0] c,
	output wire [29:0] rest
	);
reg [3:0]state=0;
reg run=0;
reg [63:0] cc;
reg [63:0] aa;
wire [63:0] d1;
wire [63:0] d2;
wire [63:0] d3;
wire [63:0] d4;
wire [63:0] d5;
wire [63:0] d6;
wire [63:0] d7;
assign d1 = cc-aa;
assign d2 = cc-aa*2;
assign d3 = cc-aa*3;
assign d4 = cc-aa*4;
assign d5 = cc-aa*5;
assign d6 = cc-aa*6;
assign d7 = cc-aa*7;
wire i7;
assign i7 = ~d7[63];
wire i6;
assign i6 = ~i7 & ~d6[63];
wire i5;
assign i5 = ~(i6|i7) & ~d5[63];
wire i4;
assign i4 = ~(i5|i6|i7) & ~d4[63];
wire i3;
assign i3 = ~(i4|i5|i6|i7) & ~d3[63];
wire i2;
assign i2 = ~(i3|i4|i5|i6|i7) & ~d2[63];
wire i1;
assign i1 = ~(i2|i3|i4|i5|i6|i7) & ~d1[63];
wire i0;
assign i0 = ~(i1|i2|i3|i4|i5|i6|i7);
wire [2:0] dd;
assign dd = {i4|i5|i6|i7,i2|i3|i6|i7,i1|i3|i5|i7}; 

always @(posedge clk)
	if (~run & start) run <= 1;
	else if (state == 10) run <= 0;
reg stop;
always @(posedge clk)
	if (run & (state ==10)) stop <= 1;
	else stop <= 0;
always @(posedge clk)
	if (~run & start) state <=0;
	else if (run) state <= state + 1;

always @(posedge clk)
	if (~run & start) cc <= c;
	else if (run & i7) cc <= d7;
	else if (run & i6) cc <= d6;
	else if (run & i5) cc <= d5;
	else if (run & i4) cc <= d4;
	else if (run & i3) cc <= d3;
	else if (run & i2) cc <= d2;
	else if (run & i1) cc <= d1;
always @(posedge clk)
	if (~run & start) aa <= {a,30'b0};
	else if (run) aa <= aa / 8;
always @(posedge clk)
	if (~run & start) b <= 0;
	else if (run) b <= b*8 | dd ;
assign rest = cc[29:0];
endmodule
