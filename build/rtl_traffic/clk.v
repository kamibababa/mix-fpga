
/**
 mix-fpga is a fpga implementation of Knuth's MIX computer.
 Copyright (C) 2021 Michael Schröder (mi.schroeder@netcologne.de)

 This programm is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.

 */
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
	pll PLL(.locked(locked),.clock_in(in),.clock_out(clk_out));	
//	SB_PLL40_CORE #(
//		.FEEDBACK_PATH("SIMPLE"),
//		.DIVR(4'b1000),		// DIVR =  8
//		.DIVF(7'b0101111),	// DIVF = 47
//		.DIVQ(3'b100),		// DIVQ =  4
//		.FILTER_RANGE(3'b001)	// FILTER_RANGE = 1
//	) uut (
//		.LOCK(locked),
//		.RESETB(1'b1),
//		.BYPASS(1'b0),
//		.REFERENCECLK(in),
//		.PLLOUTGLOBAL(clk_out)
//		);
	
	SB_GB Clock_Buffer (
		.USER_SIGNAL_TO_GLOBAL_BUFFER (clk_out),
		.GLOBAL_BUFFER_OUTPUT (out)
	);
	SB_GB Reset_Buffer (
		.USER_SIGNAL_TO_GLOBAL_BUFFER (rst3),
		.GLOBAL_BUFFER_OUTPUT (reset)
	);

endmodule
