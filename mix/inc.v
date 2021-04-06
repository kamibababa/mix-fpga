// add - command 1

`default_nettype none
module inc(
	input wire [30:0] a,
	input wire [30:0] b,
	output wire [30:0] out,
	output wire overflow
);
	assign {overflow,out} = a[30]?
			(b[30]?
				({sum[30],1'd1,sum[29:0]}):
				(d2[30]?
			      		({2'b01,d1[29:0]}):
					({2'b00,d2[29:0]}))):
			(b[30]?
				(d1[30]? 
					({2'b01,d2[29:0]}):
					({2'b00,d1[29:0]})):
				({sum[30],1'd0,sum[29:0]}));

	wire [30:0] sum;
	assign sum = {1'd0,a[29:0]} + {1'd0,b[29:0]};
	wire [30:0] d1;
	assign d1 = {1'd0,a[29:0]} - {1'd0,b[29:0]};
	wire [30:0] d2;
	assign d2 = {1'd0,b[29:0]} - {1'd0,a[29:0]};

endmodule
