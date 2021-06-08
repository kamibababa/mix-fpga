
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

module UartRX(
	input wire clk,
	input wire reset,
	input wire rx,
	output wire [7:0] out,
	output wire stop
);
	reg rx_in;
	always @(posedge clk)
		if (rx) rx_in <= 1;
		else rx_in <= 0;
	
	wire start;
	assign start = ready & (~rx_in);
	reg run;
	wire ready;
	assign ready = ~run;
	always @(posedge clk)
		if (reset|(run & stop)) run <= 0;
		else if (~run & start) run <= 1;
		else run <= run;
	
	reg [15:0] baud;
	wire is144;	//25MHz
	assign is144 = baud[4] & baud[7];
	wire is108;	//24MHz
	assign is108 = baud[2] & baud[3] & baud[5] & baud[6];
	wire is104;	//23.8MHz
	assign is104 = baud[3] & baud[5] & baud[6];
	always @(posedge clk)
		if (reset|is104) baud <= 0;
		else if (run) baud <= baud + 1;

	wire shift;
	assign shift = is104 & ~bits[0];
	reg [15:0] bits;
	always @(posedge clk)
		if (reset|start) bits <= 0;
		else if (is104) bits <= bits + 1;

	assign stop = is104 & bits[4] & bits[1];	
	
	reg [9:0] shifter;
	always @(posedge clk)
		if (reset) shifter <= 0;
		else if (shift) shifter <= {rx_in,shifter[9:1]};
	assign out = shifter[9:2];


endmodule
