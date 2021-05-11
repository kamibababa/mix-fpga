// SUB - command 2

`default_nettype none
module sub(
	input wire clk,
	input wire start,
	output wire stop,
	input wire [30:0] in1,
	input wire [30:0] in2,
	output wire [30:0] out,
	output wire overflow
);
	// SUB(a,b) = ADD(a,-b)
	add ADD(.clk(clk),.start(start),.stop(stop),.in1(in1),.in2({~in2[30],in2[29:0]}),.out(out),.overflow(overflow));
endmodule
