//------------------------------------------------------------------
//-- Hello world example
//-- Control leds by pushing the buttons
//-- This example has been tested on the following boards:
//--   * iCE40-HX1K-EVB Olimex
//------------------------------------------------------------------

module mul(
	input wire clk,
	input wire start,
	input [29:0] a,
	input [29:0] b,
	output [59:0] out,
	output stop,
	output reg sign
);

always @(posedge clk)
	if (start2) sign <= a[30] ^ b[30];


reg run;
always @(posedge clk)
	if (start) run <= 1;
	else if (last) run <= 0;

reg [3:0] counter;
always @(posedge clk)
	if (start|last) counter <= 4'd0;
	else if (run) counter <= counter +1;

reg stop;
always @(posedge clk)
	if (last) stop <= 1;
	else stop <= 0;

wire last;
assign last = (counter == 4'd7);

reg [59:0] out;
always @(posedge clk)
	if (start) out <= 60'd0;
	else if (start2) out <= {out[57:0],2'd0} + mul1[29:28] * mul2;
	else if (run) out <= {out[55:0],4'd0} + mul1[29:26] * mul2;

reg [29:0] mul1;
always @(posedge clk)
	if (start) mul1 <= a;
	else if (start2) mul1 <= {mul1[27:0],2'd0};
	else if (run) mul1 <= {mul1[25:0],4'd0};

reg start2;
always @(posedge clk)
	if (start) start2 <= 1;
	else start2 <= 0;

reg [29:0] b2;
always @(posedge clk)
	if (start2) b2 <= b;

wire [29:0] mul2;
assign mul2 = (start2)? b : b2;

endmodule
