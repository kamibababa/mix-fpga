
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

/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the icepll tool from the IceStorm project.
 * Use at your own risk.
 *
 * Given input frequency:       100.000 MHz
 * Requested output frequency:   25.000 MHz
 * Achieved output frequency:    25.000 MHz
 */

module pll(
	input  clock_in,
	output clock_out,
	output locked
	);

SB_PLL40_CORE #(
		.FEEDBACK_PATH("SIMPLE"),
		.DIVR(4'b0000),		// DIVR =  0
		.DIVF(7'b0000111),	// DIVF =  7
		.DIVQ(3'b101),		// DIVQ =  5
		.FILTER_RANGE(3'b101)	// FILTER_RANGE = 5
	) uut (
		.LOCK(locked),
		.RESETB(1'b1),
		.BYPASS(1'b0),
		.REFERENCECLK(clock_in),
		.PLLOUTGLOBAL(clock_out)
		);

endmodule
