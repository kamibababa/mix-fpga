//Field

`default_nettype none
module ld(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [30:0] in,
	input wire [5:0] field,
	output wire [30:0] out
);
	always @(posedge clk)
		if (start) stop <= 1;
		else stop <= 0;
	
	reg [5:0] f;
	always @(posedge clk)
		f <= field;

	wire [30:0] dd5;
	assign dd5 = f[3]?
		(f[4]?
			(f[5]?
				({31'd0}):
				({13'd0,in[17:0]})):
			(f[5]?
				({25'd0,in[5:0]}):
				({1'd0,in[29:0]}))):
		(f[4]?
			(f[5]?
				({31'd0}):
				({7'd0,in[23:0]})):
			(f[5]?
				({19'd0,in[11:0]}):
				(in)));
	wire [30:0] dd4;
	assign dd4 = f[3]?
		(f[4]?
			(f[5]?
				({31'd0}):
				({19'd0,in[17:6]})):
			(f[5]?
				({31'd0}):
				({7'd0,in[29:6]}))):
		(f[4]?
			(f[5]?
				({31'd0}):
				({13'd0,in[23:6]})):
			(f[5]?
				({25'd0,in[11:6]}):
				({in[30],6'd0,in[29:6]})));
	
	wire [30:0] dd3;
	assign dd3 = f[3]?
		(f[4]?
			(f[5]?
				({31'd0}):
				({25'd0,in[17:12]})):
			(f[5]?
				({31'd0}):
				({13'd0,in[29:12]}))):
		(f[4]?
			(f[5]?
				({31'd0}):
				({19'd0,in[23:12]})):
			(f[5]?
				(31'd0):
				({in[30],12'd0,in[29:12]})));
	wire [30:0] dd2;
	assign dd2 = f[3]?
		(f[4]?
			(f[5]?
				({31'd0}):
				(31'd0)):
			(f[5]?
				({31'd0}):
				({19'd0,in[29:18]}))):
		(f[4]?
			(f[5]?
				({31'd0}):
				({25'd0,in[23:18]})):
			(f[5]?
				(31'd0):
				({in[30],18'd0,in[29:18]})));
	wire [30:0] dd1;
	assign dd1 = f[3]?
		(f[4]?
			(f[5]?
				({31'd0}):
				(31'd0)):
			(f[5]?
				({31'd0}):
				({25'd0,in[29:24]}))):
		(f[4]?
			(f[5]?
				({31'd0}):
				(31'd0)):
			(f[5]?
				(31'd0):
				({in[30],24'd0,in[29:24]})));
	wire [30:0] dd0;
	assign dd0 = f[3]?
		(f[4]?
			(f[5]?
				({31'd0}):
				(31'd0)):
			(f[5]?
				({31'd0}):
				({31'd0}))):
		(f[4]?
			(f[5]?
				({31'd0}):
				(31'd0)):
			(f[5]?
				(31'd0):
				({in[30],30'd0})));
	assign out = f[0]?
		(f[1]?
			(f[2]?
				(31'd0):
				(dd3)):
			(f[2]?
				(dd5):
				(dd1))):
		(f[1]?
			(f[2]?
				(31'd0):
				(dd2)):
			(f[2]?
				(dd4):
				(dd0)));
endmodule
