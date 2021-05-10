
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
module UartTX(
	input wire clk,
	input wire load,
	input wire [6:0] in,
	output wire tx,
	output wire ready
);
	wire start;
	assign start = load & ready;
	assign ready = ~run;
	reg run;
	always @(posedge clk)
		if ((~run & start)|(run & ~stop)) run <= 1'b1;
		else run <= 1'b0;
	
	reg [15:0] baud;
	always @(posedge clk)
		if (start | is217) baud <=0;
		else if (run) baud <= baud +1;
	
	wire is288;
	assign is288 = baud[5] & baud[8];
	wire is217;
	assign is217 = baud[0] & baud[3] & baud[4] & baud[6] & baud[7];
	
	reg [4:0] bits;
	always @(posedge clk)
		if (start) bits <= 0;
		else if (is217) bits <= bits + 1;
	
	wire stop;
	assign stop = bits[3] & bits[0] & is217;
	
	reg [9:0] shifter;
	always @(posedge clk)
		if (start) shifter <= {2'b10,in,1'b0};
		else if (is217) shifter <= {1'b1,shifter[9:1]};
	assign tx = shifter[0] | ready;

endmodule
