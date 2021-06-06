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


//12 bit adder

`default_nettype none
module add12(
	input wire [12:0] a,
	input wire [12:0] b,
	output wire [12:0] out
);

	assign out = a[12]?				
			(b[12]?					
				({1'd1,sum[11:0]}):		// a+b = -(|a| + |b|)
				(~d1[12]?			// a+b = |b| - |a|
			      		({1'b1,d1[11:0]}):	//     = - (|a|-|b|) 
					({1'b0,d2[11:0]}))):	//     = + (|b|-|a|)
			(b[12]?					//     
				(~d1[12]? 			// a+b = |a| - |b|	
					({1'b0,d1[11:0]}):	//     = 
					({1'b1,d2[11:0]})):     //     = 
				({1'd0,sum[11:0]}));

	wire [12:0] sum;
	assign sum = {1'd0,a[11:0]} + {1'd0,b[11:0]};
	wire [12:0] d1;
	assign d1 = {1'd0,a[11:0]} - {1'd0,b[11:0]};
	wire [12:0] d2;
	assign d2 = {1'd0,b[11:0]} - {1'd0,a[11:0]};

endmodule
