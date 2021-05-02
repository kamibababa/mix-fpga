// CHAR - command 5()

`default_nettype none

module char(
	input wire clk,
	input wire start,
	output stop,
	input wire [29:0] in,
	output [59:0] out
);

reg run=0;
always @(posedge clk)
	if (start) run <= 1;
	else if (last) run <= 0;
wire last;
assign last = (counter == 4'd7);
reg stop;
always @(posedge clk)
	if (last) stop <= 1;
	else stop <= 0;

reg [3:0] counter;
always @(posedge clk)
	if (start|last) counter <= 0;
	else if (run) counter <= counter +1;
wire [29:0] in2;
assign in2 = (start)? in: in1;
wire [29:0] q1;
assign q1 = {1'd0,in2[29:1]}+{2'd0,in2[29:2]};

wire [29:0] q2;
assign q2 = q1 + {4'd0,q1[29:4]};

wire [29:0] q3;
assign q3 = q2+{8'd0,q2[29:8]};
wire [29:0] q4;
assign q4 = q3+{16'd0,q3[29:16]};

wire [29:0] q5;
assign q5 = {3'd0,q4[29:3]};

wire [29:0] r1;
assign r1 = in2 - ({q5[26:0],3'd0}+{q5[28:0],1'd0});

wire [29:0] q;
assign q = (r1[3]&(r1[1]|r1[2]))? q5+1: q5;
wire [5:0] r;
assign r = (r1[3]&(r1[1]|r1[2]))? r1[5:0] - 6'd10: r1[5:0];
reg [29:0] in1;
always @(posedge clk)
	if (start|run) in1 <= q;
wire [59:0] out;
assign out = {digit[5:0],out1[59:6]};
wire [5:0] digit;
assign digit = r+6'd30;
reg [59:0] out1;
always @(posedge clk)
	if (start) out1 <= {digit[5:0],54'd0};
	else if (run) out1 <= out;

endmodule
