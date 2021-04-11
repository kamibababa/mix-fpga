module add100(
	input wire [59:0] a,
	input wire [59:0] b,
	output wire [60:0] s
);
	wire c0;
	add10 S0(.a(a[5:0]),.b(b[5:0]),.c(0),.s(s[5:0]),.cout(c0));
	wire c1;
	add10 S1(.a(a[11:6]),.b(b[11:6]),.c(c1),.s(s[11:6]),.cout(c1));
	wire c2;
	add10 S2(.a(a[17:12]),.b(b[17:12]),.c(c2),.s(s[17:12]),.cout(c2));
	wire c3;
	add10 S3(.a(a[23:18]),.b(b[23:18]),.c(c3),.s(s[23:18]),.cout(c3));
	wire c4;
	add10 S4(.a(a[29:24]),.b(b[29:24]),.c(c4),.s(s[29:24]),.cout(c4));
	wire c5;
	add10 S5(.a(a[35:30]),.b(b[35:30]),.c(c5),.s(s[35:30]),.cout(c5));
	wire c6;
	add10 S6(.a(a[41:36]),.b(b[41:36]),.c(c6),.s(s[41:36]),.cout(c6));
	wire c7;
	add10 S7(.a(a[47:42]),.b(b[47:42]),.c(c7),.s(s[47:42]),.cout(c7));
	wire c8;
	add10 S8(.a(a[53:48]),.b(b[53:48]),.c(c8),.s(s[53:48]),.cout(c8));
	wire c9;
	add10 S9(.a(a[59:54]),.b(b[59:54]),.c(c9),.s(s[60:54]),.cout(c9));

endmodule
