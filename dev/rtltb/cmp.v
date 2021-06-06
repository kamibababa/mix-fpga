
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
// cmp - command 56-63
//
// compares two numbers a[31] and b[31]
// a,b = (sign, 5 bytes) = (sign, 30 bits)
//
// if a > b greater
// if a < b less
// if a == b equal

`default_nettype none
module cmp(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [30:0] in1,
	input wire [30:0] in2,
	output wire greater,
	output wire less,
	output wire equal
);
	always @(posedge clk)
		if (start) stop <= 1;
		else stop <= 0;
	reg [30:0] a;
	always @(posedge clk)
		if (start) a <= in1;
	wire [30:0] b;
	assign b = in2;
	wire [30:0] sub1;
	assign sub1 = a[29:0] - b[29:0];
	wire [30:0] sub2;
	assign sub2 = b[29:0] - a[29:0];
	
	assign equal = (~(sub1[30]|sub2[30])) & ((a[30] & b[30]) | (~a[30] & ~b[30]));
	
	assign greater = a[30]?
				(b[30]?
					(sub1[30]):
					(0)):
				(b[30]?
					(1):
					(sub2[30]));
	
	assign less = a[30]?
				(b[30]?
					(sub2[30]):
					(1)):
				(b[30]?
					(0):
					(sub1[30]));

endmodule
