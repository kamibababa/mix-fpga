// sub - command 2

`default_nettype none
module sub(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [30:0] in1,
	input wire [30:0] in2,
	output wire [30:0] out,
	output wire overflow
);
	always @(posedge clk)
		if (start) stop <= 1;
		else stop <= 0;
	reg [30:0] a;
	always @(posedge clk)
		if (start) a <= in1;
	wire [30:0] b;
	assign b = in2;
	assign {overflow,out} = a[30]?
			(b[30]?
				(d2[30]?
			      		({2'b01,d1[29:0]}):
					({2'b00,d2[29:0]})):
				({sum[30],1'd1,sum[29:0]})):
			(b[30]?
				({sum[30],1'd0,sum[29:0]}):
				(d1[30]? 
					({2'b01,d2[29:0]}):
					({2'b00,d1[29:0]})));

	wire [30:0] sum;
	assign sum = {1'd0,a[29:0]} + {1'd0,b[29:0]};
	wire [30:0] d1;
	assign d1 = {1'd0,a[29:0]} - {1'd0,b[29:0]};
	wire [30:0] d2;
	assign d2 = {1'd0,b[29:0]} - {1'd0,a[29:0]};

endmodule
