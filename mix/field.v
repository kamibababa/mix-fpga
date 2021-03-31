//Field

`default_nettype none
module field(
	input wire[30:0] in,
	input wire [5:0] field,
	output wire [30:0] out
);
	wire [30:0] dd5;
	assign dd5 = field[3]?
		(field[4]?
			(field[5]?
				({31'd0}):
				({13'd0,in[17:0]})):
			(field[5]?
				({25'd0,in[5:0]}):
				({1'd0,in[29:0]}))):
		(field[4]?
			(field[5]?
				({31'd0}):
				({7'd0,in[23:0]})):
			(field[5]?
				({19'd0,in[11:0]}):
				(in)));
	wire [30:0] dd4;
	assign dd4 = field[3]?
		(field[4]?
			(field[5]?
				({31'd0}):
				({19'd0,in[17:6]})):
			(field[5]?
				({31'd0}):
				({7'd0,in[29:6]}))):
		(field[4]?
			(field[5]?
				({31'd0}):
				({13'd0,in[23:6]})):
			(field[5]?
				({25'd0,in[11:6]}):
				({in[30],6'd0,in[29:6]})));
	
	wire [30:0] dd3;
	assign dd3 = field[3]?
		(field[4]?
			(field[5]?
				({31'd0}):
				({25'd0,in[17:12]})):
			(field[5]?
				({31'd0}):
				({13'd0,in[29:12]}))):
		(field[4]?
			(field[5]?
				({31'd0}):
				({19'd0,in[23:12]})):
			(field[5]?
				(31'd0):
				({in[30],12'd0,in[29:12]})));
	wire [30:0] dd2;
	assign dd2 = field[3]?
		(field[4]?
			(field[5]?
				({31'd0}):
				(31'd0)):
			(field[5]?
				({31'd0}):
				({19'd0,in[29:18]}))):
		(field[4]?
			(field[5]?
				({31'd0}):
				({25'd0,in[23:18]})):
			(field[5]?
				(31'd0):
				({in[30],18'd0,in[29:18]})));
	wire [30:0] dd1;
	assign dd1 = field[3]?
		(field[4]?
			(field[5]?
				({31'd0}):
				(31'd0)):
			(field[5]?
				({31'd0}):
				({25'd0,in[29:24]}))):
		(field[4]?
			(field[5]?
				({31'd0}):
				(31'd0)):
			(field[5]?
				(31'd0):
				({in[30],24'd0,in[29:24]})));
	wire [30:0] dd0;
	assign dd0 = field[3]?
		(field[4]?
			(field[5]?
				({31'd0}):
				(31'd0)):
			(field[5]?
				({31'd0}):
				({31'd0}))):
		(field[4]?
			(field[5]?
				({31'd0}):
				(31'd0)):
			(field[5]?
				(31'd0):
				({in[30],30'd0})));
	assign out = field[0]?
		(field[1]?
			(field[2]?
				(31'd0):
				(dd3)):
			(field[2]?
				(dd5):
				(dd1))):
		(field[1]?
			(field[2]?
				(31'd0):
				(dd2)):
			(field[2]?
				(dd4):
				(dd0)));
endmodule
