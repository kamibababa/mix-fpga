// ST - command 24 - 31

`default_nettype none
module st(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [11:0] addressin,
	output reg [11:0] addressout,
	input wire [30:0] data,
	input wire [30:0] in,
	input wire [5:0] field,
	output wire [30:0] out
);
	//new data
	reg [30:0] nnew;
	always @(posedge clk)
		if (start) nnew <= in;
	//takes two cycles
	always @(posedge clk)
		if (start) stop <= 1;
		else stop <= 0;
	//remember field
	reg [5:0] f;
	always @(posedge clk)
		if (start) f <= field;
		else f <= 6'd0;
	//remember address to store
	always @(posedge clk)
		if (start) addressout <= addressin;
	
	//field starts with 5:
	wire [30:0] dd5;
	assign dd5 = f[3]?
		(f[4]?
			(f[5]?
				(data):
				({data[30:18],nnew[17:0]})):
			(f[5]?
				({data[30:6],nnew[5:0]}):
				({data[30],nnew[29:0]}))):
		(f[4]?
			(f[5]?
				({data}):
				({data[30:24],nnew[23:0]})):
			(f[5]?
				({data[30:12],nnew[11:0]}):
				(nnew)));
	//field starts with 4:
	wire [30:0] dd4;
	assign dd4 = f[3]?
		(f[4]?
			(f[5]?
				({data}):
				({data[30:18],nnew[11:0],data[5:0]})):
			(f[5]?
				({data}):
				({data[30],nnew[23:0],data[5:0]}))):
		(f[4]?
			(f[5]?
				({data}):
				({data[30:24],nnew[17:0],data[5:0]})):
			(f[5]?
				({data[30:12],nnew[5:0],data[5:0]}):
				({nnew[30],nnew[23:0],data[5:0]})));
	
	//field starts with 3:
	wire [30:0] dd3;
	assign dd3 = f[3]?
		(f[4]?
			(f[5]?
				({data}):
				({data[30:18],nnew[5:0],data[11:0]})):
			(f[5]?
				({data}):
				({data[30],nnew[17:0],data[11:0]}))):
		(f[4]?
			(f[5]?
				({data}):
				({data[30:24],nnew[11:0],data[11:0]})):
			(f[5]?
				(data):
				({nnew[30],nnew[17:0],data[11:0]})));
	//field starts with 2:
	wire [30:0] dd2;
	assign dd2 = f[3]?
		(f[4]?
			(f[5]?
				({data}):
				(data)):
			(f[5]?
				({data}):
				({data[30],nnew[11:0],data[17:0]}))):
		(f[4]?
			(f[5]?
				({data}):
				({data[30:24],nnew[5:0],data[17:0]})):
			(f[5]?
				(data):
				({nnew[30],nnew[11:0],data[17:0]})));
	//field starts with 1:
	wire [30:0] dd1;
	assign dd1 = f[3]?
		(f[4]?
			(f[5]?
				({data}):
				(data)):
			(f[5]?
				({data}):
				({data[30],nnew[5:0],data[23:0]}))):
		(f[4]?
			(f[5]?
				({data}):
				(data)):
			(f[5]?
				(data):
				({nnew[30],nnew[5:0],data[23:0]})));
	//field starts with 0:
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
				({nnew[30],data[29:0]})));
	//select the desired field
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
