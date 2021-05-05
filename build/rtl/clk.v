`default_nettype none

module clk(
	input  wire in,
	output wire out,
	output wire reset
	);

	wire locked;
	wire clk_out;

	reg rst1;
	always @(posedge out)
		if (locked) rst1 <=1;
		else rst1 <=0;
	reg rst2;
	always @(posedge out)
		if (rst1) rst2 <=1;
		else rst2 <=0;
	reg rst3;
	always @(posedge out)
		if (rst2) rst3 <=0;
		else rst3 <=1;
	
	/* verilator lint_off PINMISSING */
	SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.DIVR(4'b1000),		// DIVR =  8
		.DIVF(7'b0101111),	// DIVF = 47
		.DIVQ(3'b100),		// DIVQ =  4
		.FILTER_RANGE(3'b001)	// FILTER_RANGE = 1
	) uut (
		.LOCK(locked),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(in),
		.PLLOUTGLOBAL(clk_out)
		);
	
	SB_GB Clock_Buffer (
		.USER_SIGNAL_TO_GLOBAL_BUFFER (clk_out),
		.GLOBAL_BUFFER_OUTPUT (out)
	);
	SB_GB Reset_Buffer (
		.USER_SIGNAL_TO_GLOBAL_BUFFER (rst3),
		.GLOBAL_BUFFER_OUTPUT (reset)
	);

endmodule
