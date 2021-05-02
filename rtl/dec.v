`default_nettype none
module dec(
	input wire [30:0] in1,
	input wire [30:0] in2,
	output wire [30:0] out,
	output wire overflow
);
	// SUB(a,b) = ADD(a,-b)
	inc INC(.in1(in1),.in2({~in2[30],in2[29:0]}),.out(out),.overflow(overflow));
endmodule
