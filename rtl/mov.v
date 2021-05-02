//------------------------------------------------------------------
//-- Hello world example
//-- Control leds by pushing the buttons
//-- This example has been tested on the following boards:
//--   * iCE40-HX1K-EVB Olimex
//------------------------------------------------------------------

module mov(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [11:0] addressin,
	output reg [11:0] addressout,
	input wire [5:0] len,
	output reg load,
       	output reg store	
);
wire start2;
assign start2 = start & (len[0]|len[1]|len[2]|len[3]|len[4]|len[5]);
reg run;
always @(posedge clk)
	if (start2) run <= 1;
	else if (counter == 1) run <=0;
reg [5:0] counter;	
always @(posedge clk)
	if (start2) counter <= len;
	else if (store) counter <= counter - 1;
always @(posedge clk)
	if (((counter ==1) & load)|(start & (len==0))) stop <= 1;
	else stop <= 0;
always @(posedge clk)
	if (start2) addressout <= addressin;
	else if (store) addressout <= addressout + 1;

always @(posedge clk)
	if (start2|(store & run)) load <= 1;
       	else load <= 0;
always @(posedge clk)
	if (start2) store <= 0;
       	else store <= load;	
endmodule
