`default_nettype none
module inc(
	input wire [30:0] in1,
	input wire [30:0] in2,
	output wire [30:0] out,
	output wire overflow
);
	// let's do the possible additions: sum=a+b, d1=a-b, d2=b-a 
	wire [30:0] sum;
	assign sum = {1'd0,in1[29:0]} + {1'd0,in2[29:0]};
	wire [30:0] d1;
	assign d1 = {1'd0,in1[29:0]} - {1'd0,in2[29:0]};
	wire [30:0] d2;
	assign d2 = {1'd0,in2[29:0]} - {1'd0,in1[29:0]};
	
	// and choose the right one according to the signs of a and b
	assign {overflow,out} = in1[30]?
			(in2[30]?
				({sum[30],1'd1,sum[29:0]}):	//a+b = -(|a|+|b|) = - sum
				(~d1[30]?			//a+b = |b|-|a|		
			      		({2'b01,d1[29:0]}):	//    = - d1
					({2'b00,d2[29:0]}))):	//    = d2
			(in2[30]?
				(d1[30]? 			//a+b = |a|-|b|
					({2'b01,d2[29:0]}):	//    = -d2
					({2'b00,d1[29:0]})): 	//    = d1
				({sum[30],1'd0,sum[29:0]})); 	//a+b = sum

endmodule
