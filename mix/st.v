//Field

`default_nettype none
module st(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [30:0] in,
	input wire [5:0] field,
	output wire [30:0] out
);
	wire [30:0] data;
	assign data = in;
	always @(posedge clk)
		if (start) stop <= 1;
		else stop <= 0;
	reg [5:0] f;
	always @(posedge clk)
		if (start) f <= field;
		else f <= 6'd0;
	wire [30:0] dd5;
	assign dd5 = f[3]?
		(f[4]?
			(f[5]?
				(data):
				({data[30:16],in[17:0]})):
			(f[5]?
				({data[30:6],in[5:0]}):
				({data[30],in[29:0]}))):
		(f[4]?
			(f[5]?
				({data}):
				({data[30:24],in[23:0]})):
			(f[5]?
				({data[30:12],in[11:0]}):
				(in)));
	wire [30:0] dd4;
	assign dd4 = f[3]?
		(f[4]?
			(f[5]?
				({data}):
				({data[30:18],in[11:0],data[5:0]})):
			(f[5]?
				({data}):
				({data[30],in[23:0],data[5:0]}))):
		(f[4]?
			(f[5]?
				({data}):
				({data[30:24],in[17:0],data[5:0]})):
			(f[5]?
				({data[30:12],in[5:0],data[5:0]}):
				({in[30],in[23:0],data[5:0]})));
	
	wire [30:0] dd3;
	assign dd3 = f[3]?
		(f[4]?
			(f[5]?
				({data}):
				({data[30:18],in[5:0],data[11:0]})):
			(f[5]?
				({data}):
				({data[30],in[17:0],data[11:0]}))):
		(f[4]?
			(f[5]?
				({data}):
				({data[30:24],in[11:0],data[11:0]})):
			(f[5]?
				(data):
				({in[30],in[17:0],data[11:0]})));
	wire [30:0] dd2;
	assign dd2 = f[3]?
		(f[4]?
			(f[5]?
				({data}):
				(data)):
			(f[5]?
				({data}):
				({data[30],in[11:0],data[17:0]}))):
		(f[4]?
			(f[5]?
				({data}):
				({data[30:24],in[5:0],data[17:0]})):
			(f[5]?
				(data):
				({in[30],in[11:0],data[17:0]})));
	wire [30:0] dd1;
	assign dd1 = f[3]?
		(f[4]?
			(f[5]?
				({data}):
				(data)):
			(f[5]?
				({data}):
				({data[30],in[5:0],data[23:0]}))):
		(f[4]?
			(f[5]?
				({data}):
				(data)):
			(f[5]?
				(data):
				({in[30],in[5:0],data[23:0]})));
	wire [30:0] dd0;
	assign dd0 = f[3]?
		(f[4]?
			(f[5]?
				({data}):
				(data)):
			(f[5]?
				({data}):
				({data}))):
		(f[4]?
			(f[5]?
				({data}):
				(data)):
			(f[5]?
				(data):
				({in[30],data[29:0]})));
	assign out = f[0]?
		(f[1]?
			(f[2]?
				(data):
				(dd3)):
			(f[2]?
				(dd5):
				(dd1))):
		(f[1]?
			(f[2]?
				(data):
				(dd2)):
			(f[2]?
				(dd4):
				(dd0)));
endmodule
