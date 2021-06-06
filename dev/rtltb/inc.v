
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
module inc(
	input wire [30:0] in1,
	input wire [30:0] in2,
	output wire [30:0] out,
	output wire overflow
);
	// let's do the possible additions: sum=a+b, d1=a-b, d2=b-a 
	wire [30:0] sum;
	assign sum = {1'd0,in1[29:0]} + {1'd0,in2[29:0]};
	wire [30:0] d1;
	assign d1 = {1'd0,in1[29:0]} - {1'd0,in2[29:0]};
	wire [30:0] d2;
	assign d2 = {1'd0,in2[29:0]} - {1'd0,in1[29:0]};
	
	// and choose the right one according to the signs of a and b
	assign {overflow,out} = in1[30]?
			(in2[30]?
				({sum[30],1'd1,sum[29:0]}):	//a+b = -(|a|+|b|) = - sum
				(~d1[30]?			//a+b = |b|-|a|		
			      		({2'b01,d1[29:0]}):	//    = - d1
					({2'b00,d2[29:0]}))):	//    = d2
			(in2[30]?
				(d1[30]? 			//a+b = |a|-|b|
					({2'b01,d2[29:0]}):	//    = -d2
					({2'b00,d1[29:0]})): 	//    = d1
				({sum[30],1'd0,sum[29:0]})); 	//a+b = sum

endmodule
