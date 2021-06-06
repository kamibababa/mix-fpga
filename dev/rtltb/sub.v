
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
