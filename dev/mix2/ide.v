
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
// address transfer operators - command 48 - 55
// field inc(0), dec(1), ent(2), enn(3)

`default_nettype none
module ide(
	input wire [30:0] in,
	input wire [12:0] m,
	output wire [30:0] out,
	output wire overflow,
	input wire [1:0] field
);
	assign {overflow,out} = field[1]?
			(field[0]?
				({1'd0,~m[12],18'd0,m[11:0]}):
				({1'd0, m[12],18'd0,m[11:0]})):
			(field[0]?
				({odec,decr}):
				({oinc,incr}));

	wire [30:0] decr;
	wire [30:0] incr;
	wire odec;
	wire oinc;
	inc INC(.in1(in),.in2({m[12],18'd0,m[11:0]}),.out(incr),.overflow(oinc));
	dec DEC(.in1(in),.in2({m[12],18'd0,m[11:0]}),.out(decr),.overflow(odec));

endmodule
