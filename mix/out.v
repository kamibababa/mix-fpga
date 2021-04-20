`default_nettype none
module out(
	input wire clk,
	input wire reset,
	input wire start,
	input wire [29:0] in,
	input wire [11:0] addressin,
	output [11:0] addressout,
	output stop,
	input wire load,
	output wire tx,
	output request,
	output busy
);
	
	//busy UNIT is working 
	reg busy;
	always @(posedge clk)
		if (reset) busy <= 0;
		else if (~busy & start) busy <= 1;
		else if (nextblock & ~start2) busy <= 0;
	//start2 UNIT blocks CPU until last block is send
	reg start2;
	always @(posedge clk)
		if (reset) start2 <= 0;
		else if (busy & start) start2 <= 1;
		else if (nextblock) start2 <= 0;
	//stop CPU can resume
	reg stop;
	always @(posedge clk)
		if (reset) stop <= 0;
		else if (~busy & start) stop <= 1;
		else if (nextblock & start2) stop <= 1;
		else stop <= 0;
	//next block
	reg [11:0] address_next;
	always @(posedge clk)
		if (reset) address_next <= 0;
		else if (start & busy) address_next <= addressin;
	//next address to request
	reg [11:0] addressout;
	always @(posedge clk)
		if (reset) addressout <= 0;
		else if (~busy & start) addressout <= addressin;
		else if (nextblock) addressout <= address_next;
		else if (nextword) addressout <= addressout + 1;
	//request next word from CPU
	reg request;
	always @(posedge clk)
		if (reset|(load&request)) request <= 0;
		else if (nextword | (~busy & start)) request <= 1;

	wire crlf;
	assign crlf = (wc == 13);

	wire nextblock;
	assign nextblock = nextword & crlf;	
	
	wire nextword;
	assign nextword = (~crlf) & (bytecount == 5) | crlf & (bytecount==7);
	
	wire nextbyte;
	assign nextbyte = (run & ready);

	reg run;
	always @(posedge clk)
		if (reset|~busy) run <= 0;
		else if (request & load) run <= 1;
		else if (nextword) run <= 0;
	
	reg [3:0] wc;
	always @(posedge clk)
		if (reset|nextblock) wc <= 0;
		else if (nextword) wc <= wc + 1;
	
	reg [3:0] bytecount;
	always @(posedge clk)
		if (reset|nextword) bytecount <= 0;
		else if (nextbyte) bytecount <= bytecount +1;
	
	
	reg [29:0] word;
	always @(posedge clk)
		if (reset) word <= 0;
		else if (load&request) word <= in;

	wire [5:0] nbyte;
	assign nbyte = (bytecount==0)? word[29:24]: (bytecount==1)? word[23:18]: (bytecount==2)? word[17:12]: (bytecount==3)? word[11:6]: word[5:0];
	
	wire [6:0] ascii[0:55];
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
	wire [7:0] byte8;
	assign byte8 = (bytecount==5)? 7'd13: (bytecount==6)? 7'd10: ascii[nbyte];
		
	wire ready;
	UartTX TX(.tx(tx),.clk(clk),.load(nextbyte),.in(byte8),.ready(ready));
endmodule
