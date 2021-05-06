// HLT - command 5(2)

`default_nettype none

module hlt(
	input wire clk,
	input wire start,
	output out
);
	reg out;
	always @(posedge clk)
		if (start|out) out <= 1;
		else out <= 0;
endmodule
