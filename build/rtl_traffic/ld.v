
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
// LD(N) - command 8 - 23

`default_nettype none
module ld(
	input wire clk,
	input wire start,
	output reg stop,
	input wire neg,
	input wire [30:0] in,
	input wire [5:0] field,
	output wire [30:0] out
);
	//takes two cycles
	always @(posedge clk)
		if (start) stop <= 1;
		else stop <= 0;
	
	//remember field
	reg [5:0] f;
	always @(posedge clk)
		if (start) f <= field;
	
	//negate
	reg negate;
	always @(posedge clk)
		if (start) negate <= neg;
	
	//field starts with 5:
	wire [30:0] dd5;
	assign dd5 = f[3]?
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,12'd0,in[17:0]})):
			(f[5]?
				({negate,24'd0,in[5:0]}):
				({negate,in[29:0]}))):
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,6'd0,in[23:0]})):
			(f[5]?
				({negate,18'd0,in[11:0]}):
				({negate ^ in[30],in[29:0]})));
			
	//field starts with 4:
	wire [30:0] dd4;
	assign dd4 = f[3]?
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,18'd0,in[17:6]})):
			(f[5]?
				({negate,30'd0}):
				({negate,6'd0,in[29:6]}))):
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,12'd0,in[23:6]})):
			(f[5]?
				({negate,24'd0,in[11:6]}):
				({negate^in[30],6'd0,in[29:6]})));
	
	//field starts with 3:
	wire [30:0] dd3;
	assign dd3 = f[3]?
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,24'd0,in[17:12]})):
			(f[5]?
				({negate,30'd0}):
				({negate,12'd0,in[29:12]}))):
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,18'd0,in[23:12]})):
			(f[5]?
				({negate,30'd0}):
				({negate^in[30],12'd0,in[29:12]})));
	
	//field starts with 2:
	wire [30:0] dd2;
	assign dd2 = f[3]?
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,30'd0})):
			(f[5]?
				({negate,30'd0}):
				({negate,18'd0,in[29:18]}))):
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,24'd0,in[23:18]})):
			(f[5]?
				({negate,30'd0}):
				({negate^in[30],18'd0,in[29:18]})));
	
	//field starts with 1:		
	wire [30:0] dd1;
	assign dd1 = f[3]?
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,30'd0})):
			(f[5]?
				({negate,30'd0}):
				({negate,24'd0,in[29:24]}))):
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,30'd0})):
			(f[5]?
				({negate,30'd0}):
				({negate^in[30],24'd0,in[29:24]})));
	
	//field starts with 0:		
	wire [30:0] dd0;
	assign dd0 = f[3]?
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,30'd0})):
			(f[5]?
				({negate,30'd0}):
				({negate,30'd0}))):
		(f[4]?
			(f[5]?
				({negate,30'd0}):
				({negate,30'd0})):
			(f[5]?
				({negate,30'd0}):
				({negate^in[30],30'd0})));
	
	//take the data according to field
	assign out = f[0]?
		(f[1]?
			(f[2]?
				(31'd0):
				(dd3)):
			(f[2]?
				(dd5):
				(dd1))):
		(f[1]?
			(f[2]?
				(31'd0):  
				(dd2)):   
			(f[2]?
				(dd4):   
				(dd0)));
endmodule
