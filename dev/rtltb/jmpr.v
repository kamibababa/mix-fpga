
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
// jmp - command 39
//

`default_nettype none
module jmpr(
	input wire sel,
	input wire [30:0] in,
	output wire out,
	input wire [2:0] field
);
	wire z;
	assign z = (in[29:0] == 30'd0);
	wire jn;
	assign jn = (field == 3'd0) & ~z & in[30];
	wire jz;
	assign jz = (field == 3'd1) & z;
	wire jp;
	assign jp = (field == 3'd2) & ~z & ~ in[30];
	wire jnn;
	assign jnn = (field == 3'd3) & (z | ~in[30]);
	wire jnz;
	assign jnz = (field == 3'd4) & ~z;
	wire jnp;
	assign jnp = (field == 3'd5) & (z | in[30]) ;
	wire jodd;
	assign jodd = (field == 3'd7) & (in[0]);

	assign out = sel & (jn|jz|jp|jnn|jnz|jnp|jodd);
endmodule
