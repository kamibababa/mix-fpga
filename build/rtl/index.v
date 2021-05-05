//Field

`default_nettype none
module index(
	input wire [2:0] index,
	input wire [12:0] in,
	output wire [12:0] out,
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
						(13'd0):
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
	add12 ADD(.a(in),.b(offset),.out(out));
		
endmodule
