//------------------------------------------------------------------
//-- Hello world example
//-- Control leds by pushing the buttons
//-- This example has been tested on the following boards:
//--   * iCE40-HX1K-EVB Olimex
//------------------------------------------------------------------

module mul(
	input wire clk,
	input wire start,
	input wire  [29:0] a,
	input wire [29:0] b,
	output reg [59:0] c
	);
reg [29:0] bb;
reg [3:0]state=0;
reg run=0;

always @(posedge clk)
	if (~run & start) run <= 1;
	else if (state == 9) run <= 0;

always @(posedge clk)
	if (~run & start) state <=0;
	else if (run) state <= state + 1;
always @(posedge clk)
	if (~run & start) c <= 0;
	else if (run) c <= 8*c + bb[29:27] * a;

always @(posedge clk)
	if (~run & start) bb <= b;
	else if (run) bb <= bb * 8;


endmodule
