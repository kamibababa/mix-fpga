
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
//Field

`default_nettype none
module index(
	input wire [2:0] index,
	input wire [12:0] in,
	output wire [12:0] out,
	input wire [12:0] i1,
	input wire [12:0] i2,
	input wire [12:0] i3,
	input wire [12:0] i4,
	input wire [12:0] i5,
	input wire [12:0] i6

);
	wire [12:0] offset;
	assign offset = index[2]?
				(index[1]?
					(index[0]?
						(13'd0):
						(i6)):
					(index[0]?
						(i5):
						(i4))):
				(index[1]?
					(index[0]?
						(i3):
						(i2)):
					(index[0]?
						(i1):
						(13'd0)));
	add12 ADD(.a(in),.b(offset),.out(out));
		
endmodule
