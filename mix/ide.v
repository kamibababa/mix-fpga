// address transfer operators - command 48 - 55

`default_nettype none
module ide(
	input wire [30:0] in,
	input wire [12:0] m,
	output wire [30:0] out,
	output wire overflow,
	input wire [1:0] field
);
	assign {overflow,out} = field[1]?
			(field[0]?
				({1'd0,~m[12],18'd0,m[11:0]}):
				({1'd0, m[12],18'd0,m[11:0]})):
			(field[0]?
				({odec,dec}):
				({oinc,inc}));

	wire [30:0] dec;
	wire [30:0] inc;
	wire odec;
	wire oinc;
	inc INC(.a(in),.b({m[12],18'd0,m[11:0]}),.out(inc),.overflow(oinc));
	dec DEC(.a(in),.b({m[12],18'd0,m[11:0]}),.out(dec),.overflow(odec));

endmodule
