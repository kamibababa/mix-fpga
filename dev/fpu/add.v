// ADD - command 1

`default_nettype none
module add(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [30:0] in1,
	input wire [30:0] in2,
	output wire [30:0] out,
	output wire overflow
);
	// takes two cylces
	always @(posedge clk)
		if (start) stop <= 1;
		else stop <= 0;

	// summand1 must be cached at first cycle
	reg [30:0] a;
	always @(posedge clk)
		if (start) a <= in1;
	
	// summand2 is available at second cycle
	wire [30:0] b;
	assign b = in2;

	// let's do the possible additions: sum=a+b, d1=a-b, d2=b-a 
	wire [30:0] sum;
	assign sum = {1'd0,a[29:0]} + {1'd0,b[29:0]};
	wire [30:0] d1;
	assign d1 = {1'd0,a[29:0]} - {1'd0,b[29:0]};
	wire [30:0] d2;
	assign d2 = {1'd0,b[29:0]} - {1'd0,a[29:0]};
	
	// and choose the right one according to the signs of a and b
	assign {overflow,out} = a[30]?
			(b[30]?
				({sum[30],1'd1,sum[29:0]}):	//a+b = -(|a|+|b|) = - sum
				(~d1[30]?			//a+b = |b|-|a|		
			      		({2'b01,d1[29:0]}):	//    = - d1
					({2'b00,d2[29:0]}))):	//    = d2
			(b[30]?
				(d1[30]? 			//a+b = |a|-|b|
					({2'b01,d2[29:0]}):	//    = -d2
					({2'b00,d1[29:0]})): 	//    = d1
				({sum[30],1'd0,sum[29:0]})); 	//a+b = sum

endmodule
