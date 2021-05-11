// address transfer operators - command 48 - 55
// field inc(0), dec(1), ent(2), enn(3)

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
				({odec,decr}):
				({oinc,incr}));

	wire [30:0] decr;
	wire [30:0] incr;
	wire odec;
	wire oinc;
	inc INC(.in1(in),.in2({m[12],18'd0,m[11:0]}),.out(incr),.overflow(oinc));
	dec DEC(.in1(in),.in2({m[12],18'd0,m[11:0]}),.out(decr),.overflow(odec));

endmodule
