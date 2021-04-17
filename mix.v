module num(
	input wire clk,
	input wire start,
	input [59:0] in,
	output [29:0] out,
	output stop
);

wire[59:0] in1;
assign in1 = start? in: in2;

reg [59:0] in2;
always @(posedge clk)
	in2 <= {in1[53:0],6'd0};



wire [29:0] out;
assign out = out1 * 10 + digit;

reg [29:0] out1;
always @(posedge clk)
	if (start|run) out1 <= out;	
	else out1 <= 30'd0;
reg run;
always @(posedge clk)
	if (start) run <=1;
	else if (stop) run <= 0;

wire stop;
assign stop = (pos==8) & run;
wire [3:0] pos1;
assign pos1 = pos+1;
reg [3:0] pos;
always @(posedge clk)
	if (start) pos <=0;
	else if (run) pos <= pos1;
	else pos <=0;
// in1[59:54] 59=2, 58=6, 57=8,      56=4, 55=2, 54=1
wire inis10;
wire inis12;
wire inis14;
wire inis16;
wire inis18;
assign inis10 = (~in1[59]&~in1[58]&~in1[57])|(in1[59]&~in[58]&in[57]);
assign inis12 = (in1[59]&~in1[58]&~in1[57]);
assign inis14 = (~in1[59]&in1[58]&in1[57]);
assign inis16 = (~in1[59]&in1[58]&~in1[57])|(in1[59]&in1[58]&in1[57]);
assign inis18 = (in1[59]&in1[58]&~in1[57])|(~in1[59]&~in1[58]&in1[57]);
wire inis20;
wire inis22;
wire inis24;
wire inis26;
wire inis28;
assign inis20 = ~in1[56]&~in1[55];
assign inis22 = ~in1[56]&in1[55];
assign inis24 = in1[56]&~in1[55];
assign inis26 = in1[56]&in1[55];
assign inis28 = 0;

wire is0;
wire is2;
wire is4;
wire is6;
wire is8;
assign is0 = (inis10&inis20)|(inis12&inis28)|(inis14&inis26)|(inis16&inis24)|(inis18&inis22);
assign is2 = (inis10&inis22)|(inis12&inis20)|(inis14&inis28)|(inis16&inis26)|(inis18&inis28);
assign is4 = (inis10&inis24)|(inis12&inis22)|(inis14&inis20)|(inis16&inis28)|(inis18&inis26);
assign is6 = (inis10&inis26)|(inis12&inis24)|(inis14&inis22)|(inis16&inis20)|(inis18&inis28);
assign is8 = (inis10&inis28)|(inis12&inis26)|(inis14&inis24)|(inis16&inis22)|(inis18&inis20);

wire [3:0] digit;
assign digit = { is8, is4|is6 ,is2|is6 , in1[54]};
endmodule
