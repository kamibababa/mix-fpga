module shift(
	input wire clk,
	input wire start,
	input wire [5:0] field,
	input wire [11:0] m,
	input [29:0] ina,
	input [29:0] inx,
	output [29:0] outa,
	output [29:0] outx,
	output stop
);
wire sla1;
assign sla1 = (start & (field == 6'd0));
wire sra1;
assign sra1 = (start & (field == 6'd1));
wire slax1;
assign slax1 = (start & (field == 6'd2));
wire srax1;
assign srax1 = (start & (field == 6'd3));
wire slc1;
assign slc1 = (start & (field == 6'd4));
wire src1;
assign src1 = (start & (field == 6'd5));

reg sla2;
always @(posedge clk)
	sla2 <= sla1;
reg sra2;
always @(posedge clk)
	sra2 <= sra1;
reg slax2;
always @(posedge clk)
	slax2 <= slax1;
reg srax2;
always @(posedge clk)
	srax2 <= srax1;
reg slc2;
always @(posedge clk)
	slc2 <= slc1;
reg src2;
always @(posedge clk)
	src2 <= src1;

reg stop;
always @(posedge clk)
	if (start) stop <= 1;
	else stop <= 0;

wire s1;
assign s1 = (m[0]);

reg s0;
always @(posedge clk)
	if (m[11:1]==11'd0) s0 <= 1;
	else s0 <= 0;
reg s2;
always @(posedge clk)
	if (m[11:1]==11'd1) s2 <= 1;
	else s2 <= 0;
reg s4;
always @(posedge clk)
	if (m[11:1]==11'd2) s4 <= 1;
	else s4 <= 0;
reg s6;
always @(posedge clk)
	if (m[11:1]==11'd3) s6 <= 1;
	else s6 <= 0;
reg s8;
always @(posedge clk)
	if (m[11:1]==11'd4) s8 <= 1;
	else s8 <= 0;


//modulo 10
//stage 1 m[1]=2, m[2]=4, m[3]=8:
wire d10;
wire d12;
wire d14;
wire d16;
wire d18;
assign d10 = (~m[1] &~ m[2] & ~m[3]) | (m[1] & ~m[2] & m[3]);
assign d12 = (m[1] & ~m[2] & ~m[3]) | (~m[1] & m[2] & m[3]);
assign d14 = (~m[1] & m[2] & ~m[3]) | (m[1] & m[2] & m[3]);
assign d16 = (m[1] & m[2] & ~m[3]);
assign d18 = (~m[1] & ~m[2] & m[3]);

//stage 1 m[4]=6, m[5]=2, m[6]=4:
wire d20;
wire d22;
wire d24;
wire d26;
wire d28;
assign d20 = (~m[4]&~m[5]&~m[6])|(m[4]&~m[5]&m[6]);
assign d22 = (~m[4]&m[5]&~m[6])|(m[4]&m[5]&m[6]);
assign d24 = (~m[4]&~m[5]&m[6]);
assign d26 = (m[4]&~m[5]&~m[6])|(~m[4]&m[5]&m[6]);
assign d28 = (m[4]&m[5]&~m[6]);

//stage 1 m[7]=8, m[8]=6, m[9]=2:
wire d30;
wire d32;
wire d34;
wire d36;
wire d38;
assign d30 = (~m[7]&~m[8]&~m[9])|(m[7]&~m[8]&m[9]);
assign d32 = (~m[7]&~m[8]&m[9]);
assign d34 = (m[7]&m[8]&~m[9]);
assign d36 = (~m[7]&m[8]&~m[9])|(m[7]&m[8]&m[9]);
assign d38 = (m[7]&~m[8]&~m[9])|(~m[7]&m[8]&m[9]);

//stage 1 m[10]=4, m[11]=8:
wire d40;
wire d42;
wire d44;
wire d46;
wire d48;
assign d40 = (~m[10]&~m[11]);
assign d42 = (m[10]&m[11]);
assign d44 = (m[10]&~m[11]);
assign d46 = (0);
assign d48 = (~m[10]&m[11]);

//stage 2
wire e10;
wire e12;
wire e14;
wire e16;
wire e18;

assign e10 = (d10 & d20) | (d12&d28) | (d14&d26) | (d16&d24) | (d18&d22);
assign e12 = (d12 & d20) | (d14&d28) | (d16&d26) | (d18&d24) | (d10&d22);
assign e14 = (d14 & d20) | (d16&d28) | (d18&d26) | (d10&d24) | (d12&d22);
assign e16 = (d16 & d20) | (d18&d28) | (d10&d26) | (d12&d24) | (d14&d22);
assign e18 = (d18 & d20) | (d10&d28) | (d12&d26) | (d14&d24) | (d16&d22);

wire e20;
wire e22;
wire e24;
wire e26;
wire e28;

assign e20 = (d30 & d40) | (d32&d48) | (d34&d46) | (d36&d44) | (d38&d42);
assign e22 = (d32 & d40) | (d34&d48) | (d36&d46) | (d38&d44) | (d30&d42);
assign e24 = (d34 & d40) | (d36&d48) | (d38&d46) | (d30&d44) | (d32&d42);
assign e26 = (d36 & d40) | (d38&d48) | (d30&d46) | (d32&d44) | (d34&d42);
assign e28 = (d38 & d40) | (d30&d48) | (d32&d46) | (d34&d44) | (d36&d42);
//stage 3
reg c0;
reg c2;
reg c4;
reg c6;
reg c8;

wire c1;
assign c1 = m[0];
always @(posedge clk)
	c0 <= (e10 & e20) | (e12&e28) | (e14&e26) | (e16&e24) | (e18&e22);
always @(posedge clk)
	c2 <= (e12 & e20) | (e14&e28) | (e16&e26) | (e18&e24) | (e10&e22);
always @(posedge clk)
	c4 <= (e14 & e20) | (e16&e28) | (e18&e26) | (e10&e24) | (e12&e22);
always @(posedge clk)
	c6 <= (e16 & e20) | (e18&e28) | (e10&e26) | (e12&e24) | (e14&e22);
always @(posedge clk)
	c8 <= (e18 & e20) | (e10&e28) | (e12&e26) | (e14&e24) | (e16&e22);


reg[29:0] outa1;
always @(posedge clk)
	if (sla1&s1) outa1 <= {ina[23:0],6'd0}; 
	else if ((sra1|srax1)&s1) outa1 <= {6'd0,ina[29:6]};
	else if ((slax1&s1)|(slc1&c1)) outa1 <= {ina[23:0],inx[29:24]};
	else if (src1&c1) outa1 <= {inx[5:0],ina[29:6]};
	else outa1 <= ina;

reg[29:0] outx1;
always @(posedge clk)
	if (srax1&s1) outx1 <= {ina[5:0],inx[29:6]};
	else if (slax1&s1) outx1 <= {inx[23:0],6'd0};
	else if (slc1&c1) outx1 <= {inx[23:0],ina[29:24]};
	else if (src1&c1) outx1 <= {ina[5:0],inx[29:6]};
	else outx1 <= inx;
	

wire [29:0] outa;
assign outa = 	(sla2)? (s0? outa1: s2? {outa1[17:0],12'd0}: s4? {outa1[5:0],24'd0}: 30'd0):
		(sra2|srax2)? (s0? outa1: s2? {12'd0,outa1[29:12]}: s4? {24'd0,outa1[29:24]}: 30'd0):
		(slax2)? (s0? outa1: s2? {outa1[17:0],outx1[29:18]}: s4? {outa1[5:0],outx1[29:6]}: s6? {outx1[23:0],6'd0}: s8? {outx1[11:0],18'd0}:30'd0):
		((slc2 & c2)|(src2&c8))? {outa1[17:0],outx1[29:18]}:
		((slc2 & c4)|(src2&c6))? {outa1[5:0],outx1[29:6]}:
		((slc2 & c6)|(src2&c4))? {outx1[23:0],outa1[29:24]}:
		((slc2 & c8)|(src2&c2))? {outx1[11:0],outa1[29:12]}:
		outa1;

wire [29:0] outx;
assign outx = 	(slax2)? (s0? outx1: s2? {outx1[17:0],12'd0}: s4? {outx1[5:0],24'd0}:30'd0):
		(srax2)? (s0? outx1: s2? {outa1[11:0],outx1[29:12]}: s4? {outa1[23:0],outx1[29:24]}: s6? {6'd0,outa1[29:6]}: s8? {18'd0,outa1[29:18]}: 30'd0):
		((slc2&c2)|(src2&c8))? {outx1[17:0],outa1[29:18]}:
		((slc2&c4)|(src2&c6))? {outx1[5:0],outa1[29:6]}:
		((slc2&c6)|(src2&c4))? {outa1[23:0],outx1[29:24]}:
		((slc2&c8)|(src2&c2))? {outa1[11:0],outx1[29:12]}:
		outx1;

endmodule
