`default_nettype none

module div10(
	input wire [29:0] in,
	output wire [29:0] out,
	output q,
	output wire[4:0] r
);
assign out[29]=0;
wire [4:0] r0;
div5 DIV0(.in({5'd1,in[29]}),.q(out[28]),.r(r0));
wire [4:0] r1;
div5 DIV1(.in({r0,in[28]}),.q(out[27]),.r(r1));
wire [4:0] r2;
div5 DIV2(.in({r1,in[27]}),.q(out[26]),.r(r2));
wire [4:0] r3;
div5 DIV3(.in({r2,in[26]}),.q(out[25]),.r(r3));
wire [4:0] r4;
div5 DIV4(.in({r3,in[25]}),.q(out[24]),.r(r4));
wire [4:0] r5;
div5 DIV5(.in({r4,in[24]}),.q(out[23]),.r(r5));
wire [4:0] r6;
div5 DIV6(.in({r5,in[23]}),.q(out[22]),.r(r6));
wire [4:0] r7;
div5 DIV7(.in({r6,in[22]}),.q(out[21]),.r(r7));
wire [4:0] r8;
div5 DIV8(.in({r7,in[21]}),.q(out[20]),.r(r8));
wire [4:0] r9;
div5 DIV9(.in({r8,in[20]}),.q(out[19]),.r(r9));
wire [4:0] r10;
div5 DIV10(.in({r9,in[19]}),.q(out[18]),.r(r10));
wire [4:0] r11;
div5 DIV11(.in({r10,in[18]}),.q(out[17]),.r(r11));
wire [4:0] r12;
div5 DIV12(.in({r11,in[17]}),.q(out[16]),.r(r12));
wire [4:0] r13;
div5 DIV13(.in({r12,in[16]}),.q(out[15]),.r(r13));
wire [4:0] r14;
div5 DIV14(.in({r13,in[15]}),.q(out[14]),.r(r14));
wire [4:0] r15;
div5 DIV15(.in({r14,in[14]}),.q(out[13]),.r(r15));
wire [4:0] r16;
div5 DIV16(.in({r15,in[13]}),.q(out[12]),.r(r16));
wire [4:0] r17;
div5 DIV17(.in({r16,in[12]}),.q(out[11]),.r(r17));
wire [4:0] r18;
div5 DIV18(.in({r17,in[11]}),.q(out[10]),.r(r18));
wire [4:0] r19;
div5 DIV19(.in({r18,in[10]}),.q(out[9]),.r(r19));
wire [4:0] r20;
div5 DIV20(.in({r19,in[9]}),.q(out[8]),.r(r20));
wire [4:0] r21;
div5 DIV21(.in({r20,in[8]}),.q(out[7]),.r(r21));
wire [4:0] r22;
div5 DIV22(.in({r21,in[7]}),.q(out[6]),.r(r22));
wire [4:0] r23;
div5 DIV23(.in({r22,in[6]}),.q(out[5]),.r(r23));
wire [4:0] r24;
div5 DIV24(.in({r23,in[5]}),.q(out[4]),.r(r24));
wire [4:0] r25;
div5 DIV25(.in({r24,in[4]}),.q(out[3]),.r(r25));
wire [4:0] r26;
div5 DIV26(.in({r25,in[3]}),.q(out[2]),.r(r26));
wire [4:0] r27;
div5 DIV27(.in({r26,in[2]}),.q(out[1]),.r(r27));
wire [4:0] r28;
div5 DIV28(.in({r27,in[1]}),.q(out[0]),.r(r28));


div5 DIV29(.in({r28,in[0]}),.q(q),.r(r));



endmodule
