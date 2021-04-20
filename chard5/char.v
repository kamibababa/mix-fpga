// CHAR - command 5()

`default_nettype none

module char(
	input wire clk,
	input wire start,
	output wire stop,
	input wire [29:0] in,
	output [59:0] out
);

reg run;
always @(posedge clk)
	if (start) run <= 1;
	else if (stop) run <= 0;

assign stop = (counter == 4'd8);
reg [3:0] counter;
always @(posedge clk)
	if (start|stop) counter <= 0;
	else if (run&~stop) counter <= counter +1;
	else counter <= 0;
wire [29:0] in2;
assign in2 = (start)? in: in1;

reg [29:0] in1;
always @(posedge clk)
	if (start|run) in1 <= q;
wire [59:0] out;
assign out = {digit[5:0],out1[59:6]};
wire [5:0] digit;
assign digit = { r2|r3|r4|r5|r6|r7|r8|r9,
	         r0|r1,
		 r0|r1,
		 r0|r1|r6|r7|r8|r9,
		 r0|r1|r4|r5|r8|r9,
		 r1|r3|r5|r7|r9
		 };//32 16 8 4 2 1 
reg [59:0] out1;
always @(posedge clk)
	if (start) out1 <= {digit[5:0],54'd0};
	else if (run) out1 <= out;
wire [29:0] q;
wire [4:0] rr;
wire qq;
div10 div(.in(in2),.out(q),.q(qq),.r(rr));

wire r0;
assign r0 = rr[0] &~qq; 
wire r1;
assign r1 = rr[1] &~qq; 
wire r2;
assign r2 = rr[2] &~qq; 
wire r3;
assign r3 = rr[3] &~qq; 
wire r4;
assign r4 = rr[4] &~qq; 
wire r5;
assign r5 = rr[0] &qq; 
wire r6;
assign r6 = rr[1] &qq; 
wire r7;
assign r7 = rr[2] &qq; 
wire r8;
assign r8 = rr[3] &qq; 
wire r9;
assign r9 = rr[4] &qq; 


endmodule
