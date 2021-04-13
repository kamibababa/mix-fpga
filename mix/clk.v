`default_nettype none
module clk(
	input  wire in,
	output wire out,
	output reset
	);

	wire locked;
	wire clk_out;

	reg rst1;
	always @(posedge out)
		rst1 <=1;
	reg rst2;
	always @(posedge out)
		if (rst1) rst2 <=1;
		else rst2 <=0;
	reg reset;
	always @(posedge out)
		if (rst2) reset <=0;
		else reset <=1;
	
	assign out = in;
endmodule
