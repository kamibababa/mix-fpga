//------------------------------------------------------------------
//-- Hello world example
//-- Control leds by pushing the buttons
//-- This example has been tested on the following boards:
//--   * iCE40-HX1K-EVB Olimex
//------------------------------------------------------------------

module shift(
	input wire clk,
	input wire start,
	input wire [5:0] field,
	input wire [11:0] m,
	input [30:0] ina,
	input [30:0] inx,
	output [30:0] outa,
	output [30:0] outx,
	output stop
);

reg sla;
always @(posedge clk)
	if (start & (field == 6'd0)) sla <= 1;
	else sla <= 0;

reg sra;
always @(posedge clk)
	if (start & (field == 6'd1)) sra <= 1;
	else sra <= 0;

reg slax;
always @(posedge clk)
	if (start & (field == 6'd2)) slax <= 1;
	else slax <= 0;

reg srax;
always @(posedge clk)
	if (start & (field == 6'd3)) srax <= 1;
	else srax <= 0;

reg slc;
always @(posedge clk)
	if (start & (field == 6'd4)) slc <= 1;
	else slc <= 0;

reg src;
always @(posedge clk)
	if (start & (field == 6'd5)) src <= 1;
	else src <= 0;

reg start2;
always @(posedge clk)
	if (start) start2 <= 1;
	else start2 <= 0;

reg stop;
always @(posedge clk)
	if (start2) stop <= 1;
	else stop <= 0;

reg s0;
always @(posedge clk)
	if (m==11'd0) s0 <= 1;
	else s0 <= 0;
reg s1;
always @(posedge clk)
	if (m==11'd1) s1 <= 1;
	else s1 <= 0;
reg s2;
always @(posedge clk)
	if (m==11'd2) s2 <= 1;
	else s2 <= 0;
reg s3;
always @(posedge clk)
	if (m==11'd3) s3 <= 1;
	else s3 <= 0;
reg s4;
always @(posedge clk)
	if (m==11'd4) s4 <= 1;
	else s4 <= 0;
reg s5;
always @(posedge clk)
	if (m==11'd5) s5 <= 1;
	else s5 <= 0;
reg s6;
always @(posedge clk)
	if (m==11'd6) s6 <= 1;
	else s6 <= 0;
reg s7;
always @(posedge clk)
	if (m==11'd7) s7 <= 1;
	else s7 <= 0;
reg s8;
always @(posedge clk)
	if (m==11'd8) s8 <= 1;
	else s8 <= 0;
reg s9;
always @(posedge clk)
	if (m==11'd9) s9 <= 1;
	else s9 <= 0;
reg [30:0] outa;
always @(posedge clk)
	if (sla) outa <= s0? ina: s1? {ina[30],ina[23:0],6'd0}: s2? {ina[30],ina[17:0],12'd0}: s3? {ina[30],ina[11:0],18'd0}: s4? {ina[30],ina[5:0],24'd0}: {ina[30],30'd0};
	else if (sra) outa <= s0? ina: s1? {ina[30],6'd0,ina[29:6]}: s2? {ina[30],12'd0,ina[29:12]}: s3? {ina[30],18'd0,ina[29:18]}: s4? {ina[30],24'd0,ina[29:24]}: {ina[30],30'd0};
	else if (slax) outa <= s0? ina: s1? {ina[30],ina[23:0],inx[29:24]}: s2? {ina[30],ina[17:0],inx[29:18]}: s3? {ina[30],ina[11:0],inx[29:12]}: s4? {ina[30],ina[5:0],inx[29:6]}: s5? {ina[30],inx[29:0]}: s6? {ina[30],inx[23:0],6'd0}: s7? {ina[30],inx[17:0],12'd0}: s8? {ina[30],inx[11:0],18'd0}: s9? {ina[30],inx[5:0],24'd0}: {ina[30],30'd0};
	else if (srax) outa <= s0? ina: s1? {ina[30],6'd0,ina[29:6]}: s2? {ina[30],12'd0,ina[29:12]}: s3? {ina[30],18'd0,ina[29:18]}: s4? {ina[30],24'd0,ina[29:24]}: {ina[30],30'd0};
	else if (slc) outa <= c1?
		(c2? {ina[30],ina[11:0],inx[29:12]}:
	 	 c4? {ina[30],inx[29:0]}:
	 	 c6? {ina[30],inx[17:0],ina[29:18]}:
	 	 c8? {ina[30],inx[5:0],ina[29:6]}:
	 	 {ina[30],ina[23:0],inx[29:24]}):
		(c2? {ina[30],ina[17:0],inx[29:18]}:
	 	 c4? {ina[30],ina[5:0],inx[29:6]}:
	 	 c6? {ina[30],inx[23:0],ina[29:24]}:
	 	 c8? {ina[30],inx[11:0],ina[29:12]}:
	 	 ina);
	else if (src) outa <= c1?
		(c2? {ina[30],inx[17:0],ina[29:18]}:
	 	 c4? {ina[30],inx[29:0]}:
	 	 c6? {ina[30],ina[11:0],inx[29:12]}:
	 	 c8? {ina[30],ina[23:0],inx[29:24]}:
	 	 {ina[30],inx[5:0],ina[29:6]}):
		(c2? {ina[30],inx[11:0],ina[29:12]}:
	 	 c4? {ina[30],inx[23:0],ina[29:24]}:
	 	 c6? {ina[30],ina[5:0],inx[29:6]}:
	 	 c8? {ina[30],ina[17:0],inx[29:18]}:
	 	 ina);
reg [30:0] outx;
always @(posedge clk)
	if (sla) outx <= inx;
	else if (sra) outx <= inx;
	else if (slax) outx <= s0? inx: s1? {inx[30],inx[23:0],6'd0}: s2? {inx[30],inx[17:0],12'd0}: s3? {inx[30],inx[11:0],18'd0}: s4? {inx[30],inx[5:0],24'd0}: {inx[30],30'd0};
	else if (srax) outx <= s0? inx: s1? {inx[30],ina[5:0],inx[29:6]}: s2? {inx[30],ina[11:0],inx[29:12]}: s3? {inx[30],ina[17:0],inx[29:18]}: s4? {inx[30],ina[23:0],inx[29:24]}: s5? {inx[30],ina[29:0]}: s6? {inx[30],6'd0,ina[29:6]}: s7? {inx[30],12'd0,ina[29:12]}: s8? {inx[30],18'd0,ina[29:18]}: s9? {inx[30],24'd0,ina[29:24]}: {inx[30],30'd0};
	else if (slc) outx <= c1?
		(c2? {inx[30],inx[11:0],ina[29:12]}:
	 	 c4? {inx[30],ina[29:0]}:
	 	 c6? {inx[30],ina[17:0],inx[29:18]}:
	 	 c8? {inx[30],ina[5:0],inx[29:6]}:
	 	 {inx[30],inx[23:0],ina[29:24]}):
		(c2? {inx[30],inx[17:0],ina[29:18]}:
	 	 c4? {inx[30],inx[5:0],ina[29:6]}:
	 	 c6? {inx[30],ina[23:0],inx[29:24]}:
	 	 c8? {inx[30],ina[11:0],inx[29:12]}:
	 	 inx);
	else if (src) outx <= c1?
		(c2? {inx[30],ina[17:0],ina[29:18]}:
	 	 c4? {inx[30],ina[29:0]}:
	 	 c6? {inx[30],inx[11:0],ina[29:12]}:
	 	 c8? {inx[30],inx[23:0],ina[29:24]}:
	 	 {inx[30],ina[5:0],inx[29:6]}):
		(c2? {inx[30],ina[11:0],inx[29:12]}:
	 	 c4? {inx[30],ina[23:0],inx[29:24]}:
	 	 c6? {inx[30],inx[5:0],ina[29:6]}:
	 	 c8? {inx[30],inx[17:0],ina[29:18]}:
	 	 inx);


//4 3 2 1 0
//6 8 4 2 1
wire is02;
wire is04;
wire is06;
wire is08;
assign is02 = (m[1] & ~m[3]);
assign is04 = (m[2] & ~m[4]);
assign is06 = (m[4] & ~m[2]);
assign is08 = (m[3] & ~m[1]);

wire isr00;
wire isr02;
wire isr04;
wire isr06;
wire isr08;
assign isr00 = ~is02 & ~is04 & ~is06 & ~is08;
assign isr02 = (is02 & ~is06 & ~is04) | (is04 & is08);
assign isr04 = (is04 & ~is02 & ~is08) | (is06 & is08);
assign isr06 = (is06 & ~is02 & ~is08) | (is02 & is04);
assign isr08 = (is08 & ~is04 & ~is06) | (is02 & is06);


wire is12;
wire is14;
wire is16;
wire is18;
assign is12 = (m[5] & ~m[7]);
assign is14 = (m[6] & ~m[8]);
assign is16 = (m[8] & ~m[6]);
assign is18 = (m[7] & ~m[5]);

wire isr10;
wire isr12;
wire isr14;
wire isr16;
wire isr18;
assign isr10 = ~is12 & ~is14 & ~is16 & ~is18;
assign isr12 = (is12 & ~is16 & ~is14) | (is14 & is18);
assign isr14 = (is14 & ~is12 & ~is18) | (is16 & is18);
assign isr16 = (is16 & ~is12 & ~is18) | (is12 & is14);
assign isr18 = (is18 & ~is14 & ~is16) | (is12 & is16);


wire is22;
wire is24;
wire is28;

assign is22 = (m[9] & ~m[11]);
assign is24 = m[10];
assign is28 = (m[11] & ~m[9]);

wire isr20;
wire isr22;
wire isr24;
wire isr26;
wire isr28;
assign isr20 = ~is22 & ~is24 & ~is28;
assign isr22 = (is22 & ~is24) | (is24 & is28);
assign isr24 = (is24 & ~is22 & ~is28);
assign isr26 = (is22 & is24);
assign isr28 = (is28 & ~is24);

wire ist0;
wire ist2;
wire ist4;
wire ist6;
wire ist8;

assign ist0 = (isr00 & isr10) | (isr02&isr18) | (isr04&isr16) | (isr06&isr14) | (isr08&isr12);
assign ist2 = (isr02 & isr10) | (isr04&isr18) | (isr06&isr16) | (isr08&isr14) | (isr00&isr12);
assign ist4 = (isr04 & isr10) | (isr06&isr18) | (isr08&isr16) | (isr00&isr14) | (isr02&isr12);
assign ist6 = (isr06 & isr10) | (isr08&isr18) | (isr00&isr16) | (isr02&isr14) | (isr04&isr12);
assign ist8 = (isr08 & isr10) | (isr00&isr18) | (isr02&isr16) | (isr04&isr14) | (isr06&isr12);
reg c1;
reg c0;
reg c2;
reg c4;
reg c6;
reg c8;
always @(posedge clk)
	c1 <= m[0];
always @(posedge clk)
	c0 <= (ist0 & isr20) | (ist2&isr28) | (ist4&isr26) | (ist6&isr24) | (ist8&isr22);
always @(posedge clk)
	c2 <= (ist2 & isr20) | (ist4&isr28) | (ist6&isr26) | (ist8&isr24) | (ist0&isr22);
always @(posedge clk)
	c4 <= (ist4 & isr20) | (ist6&isr28) | (ist8&isr26) | (ist0&isr24) | (ist2&isr22);
always @(posedge clk)
	c6 <= (ist6 & isr20) | (ist8&isr28) | (ist0&isr26) | (ist2&isr24) | (ist4&isr22);
always @(posedge clk)
	c8 <= (ist8 & isr20) | (ist0&isr28) | (ist2&isr26) | (ist4&isr24) | (ist6&isr22);
endmodule
