`default_nettype none
module UartTX(
	input wire clk,
	input wire load,
	input wire [5:0] in,
	output wire tx,
	output wire ready
);
	wire [6:0] ascii[55:0];
	assign ascii[0] = 7'd32;
	assign ascii[1] = 7'd65;
	assign ascii[2] = 7'd66;
	assign ascii[3] = 7'd67;
	assign ascii[4] = 7'd68;
	assign ascii[5] = 7'd69;
	assign ascii[6] = 7'd70;
	assign ascii[7] = 7'd71;
	assign ascii[8] = 7'd72;
	assign ascii[9] = 7'd73;
	assign ascii[10] = 7'd10;
	assign ascii[11] = 7'd74;
	assign ascii[12] = 7'd75;
	assign ascii[13] = 7'd76;
	assign ascii[14] = 7'd77;
	assign ascii[15] = 7'd78;
	assign ascii[16] = 7'd79;
	assign ascii[17] = 7'd80;//
	assign ascii[18] = 7'd81;//
	assign ascii[19] = 7'd82;//
	assign ascii[20] = 7'd13;//sigma
	assign ascii[21] = 7'd7;//pi
	assign ascii[22] = 7'd83;
	assign ascii[23] = 7'd84;
	assign ascii[24] = 7'd85;
	assign ascii[25] = 7'd86;
	assign ascii[26] = 7'd87;
	assign ascii[27] = 7'd88;
	assign ascii[28] = 7'd89;
	assign ascii[29] = 7'd90;
	assign ascii[30] = 7'd48;
	assign ascii[31] = 7'd49;
	assign ascii[32] = 7'd50;
	assign ascii[33] = 7'd51;
	assign ascii[34] = 7'd52;
	assign ascii[35] = 7'd53;
	assign ascii[36] = 7'd54;
	assign ascii[37] = 7'd55;
	assign ascii[38] = 7'd56;
	assign ascii[39] = 7'd57;
	assign ascii[40] = 7'd46;
	assign ascii[41] = 7'd44;
	assign ascii[42] = 7'd40;
	assign ascii[43] = 7'd41;
	assign ascii[44] = 7'd43;
	assign ascii[45] = 7'd45;
	assign ascii[46] = 7'd42;
	assign ascii[47] = 7'd47;
	assign ascii[48] = 7'd61;
	assign ascii[49] = 7'd36;
	assign ascii[50] = 7'd60;
	assign ascii[51] = 7'd62;
	assign ascii[52] = 7'd64;
	assign ascii[53] = 7'd59;
	assign ascii[54] = 7'd58;
	assign ascii[55] = 7'd39;
	
	wire start;
	assign start = load & ready;
	assign ready = ~run;
	reg run;
	always @(posedge clk)
		if ((~run & start)|(run & ~stop)) run <= 1'b1;
		else run <= 1'b0;
	
	reg [15:0] baud;
	always @(posedge clk)
		if (start | is288) baud <=0;
		else if (run) baud <= baud +1;
	
	wire is288;
	assign is288 = baud[5] & baud[8];
	
	reg [4:0] bits;
	always @(posedge clk)
		if (start) bits <= 0;
		else if (is288) bits <= bits + 1;
	
	wire stop;
	assign stop = bits[3] & bits[0] & is288;
	
	reg [9:0] shifter;
	always @(posedge clk)
		if (start) shifter <= {2'b10,ascii[in],1'b0};
		else if (is288) shifter <= {1'b1,shifter[9:1]};
	assign tx = shifter[0] | ready;

endmodule
