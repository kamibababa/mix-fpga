
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

// MOVE - command 7

`default_nettype none
module mov(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [11:0] addressin,
	output reg [11:0] addressout,
	input wire [5:0] len,
	output reg load,
       	output reg store	
);

	//start if len>0
	wire start2;
	assign start2 = start & (len[0]|len[1]|len[2]|len[3]|len[4]|len[5]);
	//run 
	reg run;
	always @(posedge clk)
		if (start2) run <= 1;
		else if (last) run <=0;
	//counter
	reg [5:0] counter;	
	always @(posedge clk)
		if (start2) counter <= len;
		else if (store) counter <= counter - 1;
	//last
	wire last;
	assign last = (counter==6'd1);
	
	//stop signal
	always @(posedge clk)
		if ((last & load)|(start & (len==6'd0))) stop <= 1;
		else stop <= 0;
	//address
	always @(posedge clk)
		if (start2) addressout <= addressin;
		else if (store) addressout <= addressout + 1;
	//load
	always @(posedge clk)
		if (start2|(store & run)) load <= 1;
	       	else load <= 0;
	//store
	always @(posedge clk)
		if (start2) store <= 0;
       		else store <= load;	

endmodule
