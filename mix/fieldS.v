//Field

`default_nettype none
module fieldS(
	input wire [30:0] in,
	input wire [30:0] data,
	input wire [5:0] field,
	output wire [30:0] out
);
	wire [30:0] dd5;
	assign dd5 = field[3]?
		(field[4]?
			(field[5]?
				(data):
				({data[30:16],in[17:0]})):
			(field[5]?
				({data[30:6],in[5:0]}):
				({data[30],in[29:0]}))):
		(field[4]?
			(field[5]?
				({data}):
				({data[30:24],in[23:0]})):
			(field[5]?
				({data[30:12],in[11:0]}):
				(in)));
	wire [30:0] dd4;
	assign dd4 = field[3]?
		(field[4]?
			(field[5]?
				({data}):
				({data[30:18],in[11:0],data[5:0]})):
			(field[5]?
				({data}):
				({data[30],in[23:0],data[5:0]}))):
		(field[4]?
			(field[5]?
				({data}):
				({data[30:24],in[17:0],data[5:0]})):
			(field[5]?
				({data[30:12],in[5:0],data[5:0]}):
				({in[30],in[23:0],data[5:0]})));
	
	wire [30:0] dd3;
	assign dd3 = field[3]?
		(field[4]?
			(field[5]?
				({data}):
				({data[30:18],in[5:0],data[11:0]})):
			(field[5]?
				({data}):
				({data[30],in[17:0],data[11:0]}))):
		(field[4]?
			(field[5]?
				({data}):
				({data[30:24],in[11:0],data[11:0]})):
			(field[5]?
				(data):
				({in[30],in[17:0],data[11:0]})));
	wire [30:0] dd2;
	assign dd2 = field[3]?
		(field[4]?
			(field[5]?
				({data}):
				(data)):
			(field[5]?
				({data}):
				({data[30],in[11:0],data[17:0]}))):
		(field[4]?
			(field[5]?
				({data}):
				({data[30:24],in[5:0],data[17:0]})):
			(field[5]?
				(data):
				({in[30],in[11:0],data[17:0]})));
	wire [30:0] dd1;
	assign dd1 = field[3]?
		(field[4]?
			(field[5]?
				({data}):
				(data)):
			(field[5]?
				({data}):
				({data[30],in[5:0],data[23:0]}))):
		(field[4]?
			(field[5]?
				({data}):
				(data)):
			(field[5]?
				(data):
				({in[30],in[5:0],data[23:0]})));
	wire [30:0] dd0;
	assign dd0 = field[3]?
		(field[4]?
			(field[5]?
				({data}):
				(data)):
			(field[5]?
				({data}):
				({data}))):
		(field[4]?
			(field[5]?
				({data}):
				(data)):
			(field[5]?
				(data):
				({in[30],data[29:0]})));
	assign out = field[0]?
		(field[1]?
			(field[2]?
				(data):
				(dd3)):
			(field[2]?
				(dd5):
				(dd1))):
		(field[1]?
			(field[2]?
				(data):
				(dd2)):
			(field[2]?
				(dd4):
				(dd0)));
endmodule
