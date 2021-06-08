
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
// todo num can produce Overflow!!!!!!!!!!!!!!!!!!!!

// NUM - command 5(0)
`default_nettype none
module num(
	input wire clk,
	input wire start,
	input [59:0] in,
	output [29:0] out,
	output stop
);
	//run	
	reg run;
	always @(posedge clk)
		if (start) run <=1;
		else if (last) run <= 0;
	//counter counts cycles	
	reg [3:0] pos;
	always @(posedge clk)
		if (start|last) pos <=0;
		else if (run) pos <= pos + 1;
	//last cycle
	wire last;
	assign last = (pos==4'd7);
	
	//stop signal
	reg stop;
	always @(posedge clk)
		if (last) stop <= 1;
		else stop <= 0;

	// input	
	wire[59:0] in1;
	assign in1 = start? in: in2;

	reg [59:0] in2;
	always @(posedge clk)
		in2 <= {in1[53:0],6'd0};

	//compute the output signal: shift left and append one digit
	wire [29:0] out;
	assign out = {out1[28:0],1'd0} + {out1[26:0],3'd0} + {26'd0,digit};

	reg [29:0] out1;
	always @(posedge clk)
		if (start) out1 <= {26'd0,digit};
		else if (run) out1 <= out;	

	// compute digit from 6 MSB of in1 12/13   001100
	// in1[59:54] 59=2, 58=6, 57=8, 56=4, 55=2, 54=1
	wire inis10;
	wire inis12;
	wire inis14;
	wire inis16;
	wire inis18;
	assign inis10 = (~in1[59]&~in1[58]&~in1[57])|(in1[59]&~in[58]&in[57]);
	assign inis12 = (in1[59]&~in1[58]&~in1[57]);
	assign inis14 = (~in1[59]&in1[58]&in1[57]);
	assign inis16 = (~in1[59]&in1[58]&~in1[57])|(in1[59]&in1[58]&in1[57]);
	assign inis18 = (in1[59]&in1[58]&~in1[57])|(~in1[59]&~in1[58]&in1[57]);
	wire inis20;
	wire inis22;
	wire inis24;
	wire inis26;
	wire inis28;
	assign inis20 = ~in1[56]&~in1[55];
	assign inis22 = ~in1[56]&in1[55];
	assign inis24 = in1[56]&~in1[55];
	assign inis26 = in1[56]&in1[55];
	assign inis28 = 0;
	wire is0;
	wire is2;
	wire is4;
	wire is6;
	wire is8;
	assign is0 = (inis10&inis20)|(inis12&inis28)|(inis14&inis26)|(inis16&inis24)|(inis18&inis22);
	assign is2 = (inis10&inis22)|(inis12&inis20)|(inis14&inis28)|(inis16&inis26)|(inis18&inis24);
	assign is4 = (inis10&inis24)|(inis12&inis22)|(inis14&inis20)|(inis16&inis28)|(inis18&inis26);
	assign is6 = (inis10&inis26)|(inis12&inis24)|(inis14&inis22)|(inis16&inis20)|(inis18&inis28);
	assign is8 = (inis10&inis28)|(inis12&inis26)|(inis14&inis24)|(inis16&inis22)|(inis18&inis20);
	//and here we have the next digit	
	wire [3:0] digit;
	assign digit = { is8, is4|is6 ,is2|is6 , in1[54]};
			
endmodule
