//Field

`default_nettype none
module index(
	input wire [2:0] index,
	input wire [12:0] in,
	output wire [11:0] out,
	input wire [12:0] i1,
	input wire [12:0] i2,
	input wire [12:0] i3,
	input wire [12:0] i4,
	input wire [12:0] i5,
	input wire [12:0] i6

);
	wire [12:0] offset;
	assign offset = index[2]?
				(index[1]?
					(index[0]?
						(12'd0):
						(i6)):
					(index[0]?
						(i5):
						(i4))):
				(index[1]?
					(index[0]?
						(i3):
						(i2)):
					(index[0]?
						(i1):
						(13'd0)));

	assign out = in[12]?
			(offset[12]?
				(12'd4000):
				(offset[11:0] - in[11:0])):
			(offset[12]?
				(in[11:0] - offset[11:0]):
				(in[11:0] + offset[11:0]));

endmodule
