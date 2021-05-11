`default_nettype none
module in(
	input wire clk,
	input wire reset,
	input wire start,
	output wire [29:0] out,
	input wire [11:0] addressin,
	output [11:0] addressout,
	input store,
	output stop,
	input wire rx,
	output request,
	output busy
);
	
	//busy UNIT is working 
	reg busy;
	always @(posedge clk)
		if (reset) busy <= 0;
		else if (~busy & start) busy <= 1;
		else if (nextblock&store & ~start2) busy <= 0;
	
	//start2 UNIT blocks CPU until last block is send
	reg start2;
	always @(posedge clk)
		if (reset) start2 <= 0;
		else if (busy & start) start2 <= 1;
		else if (nextblock&store) start2 <= 0;
	
	//stop CPU can resume
	reg stop;
	always @(posedge clk)
		if (reset) stop <= 0;
		else if (~busy & start) stop <= 1;
		else if (store&nextblock & start2) stop <= 1;
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
		else if (nextblock&store) addressout <= address_next;
		else if (store&request) addressout <= addressout + 1;
	//request store word to CPU
	reg request;
	always @(posedge clk)
		if (reset|store) request <=0;
		else if (nextword) request <= 1;
	
	assign out = word;
	reg crlf;
	always @(posedge clk)
		if (reset|(nextblock&store)) crlf <= 0;
		else if (iscrlf) crlf <= 1;
	wire iscrlf;
	assign iscrlf = ready & (byte8==8'd13);
	wire lastword;
	assign lastword = (wc == 15);

	reg nextblock;
	always @(posedge clk)
		if (reset|store) nextblock <=0;
		else if (nextword & lastword) nextblock <= 1;
	
	wire nextword;
	assign nextword = nextbyte & (bytecount == 4);
	
	wire nextbyte;
	assign nextbyte = (~isctrl& busy & ready)|(~request & crlf);

	wire isctrl;
	assign isctrl = ready & (byte8[7:4]==4'd0);
	
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
		if (reset|(store&request)) word <= 0;
		else if (nextbyte) word <= {word[23:0],bytemix};
	wire [7:0] byte8;
	wire ready;
	UartRX RX(.reset(reset),.rx(rx),.clk(clk),.out(byte8),.stop(ready));
	wire [5:0] bytemix;
	assign bytemix = crlf? 6'd0: byte6[{~byte8[6],byte8[4:0]}];
	wire [5:0] byte6[0:63];
	assign byte6[6'd0] = 6'd52; //@
	assign byte6[6'd1] = 6'd1;
	assign byte6[6'd2] = 6'd2;
	assign byte6[6'd3] = 6'd3;
	assign byte6[6'd4] = 6'd4;
	assign byte6[6'd5] = 6'd5;
	assign byte6[6'd6] = 6'd6;
	assign byte6[6'd7] = 6'd7;
	assign byte6[6'd8] = 6'd8;
	assign byte6[6'd9] = 6'd9;
	assign byte6[6'd10] = 6'd11;
	assign byte6[6'd11] = 6'd12;
	assign byte6[6'd12] = 6'd13;
	assign byte6[6'd13] = 6'd14;
	assign byte6[6'd14] = 6'd15;
	assign byte6[6'd15] = 6'd16;
	assign byte6[6'd16] = 6'd17;
	assign byte6[6'd17] = 6'd18;
	assign byte6[6'd18] = 6'd19;
	assign byte6[6'd19] = 6'd22;
	assign byte6[6'd20] = 6'd23;
	assign byte6[6'd21] = 6'd24;
	assign byte6[6'd22] = 6'd25;
	assign byte6[6'd23] = 6'd26;
	assign byte6[6'd24] = 6'd27;
	assign byte6[6'd25] = 6'd28;
	assign byte6[6'd26] = 6'd29;
	assign byte6[6'd27] = 0;
	assign byte6[6'd28] = 0;
	assign byte6[6'd29] = 0;
	assign byte6[6'd30] = 0;
	assign byte6[6'd31] = 0;
	assign byte6[6'd32] = 6'd0;//space
	assign byte6[6'd33] = 6'd0;
	assign byte6[6'd34] = 6'd0;
	assign byte6[6'd35] = 6'd0;
	assign byte6[6'd36] = 6'd49;//$
	assign byte6[6'd37] = 6'd0;
	assign byte6[6'd38] = 6'd0;
	assign byte6[6'd39] = 6'd55;//'
	assign byte6[6'd40] = 6'd42;//(
	assign byte6[6'd41] = 6'd43;//)
	assign byte6[6'd42] = 6'd46;//*
	assign byte6[6'd43] = 6'd44;//+
	assign byte6[6'd44] = 6'd41;//,
	assign byte6[6'd45] = 6'd45;//-
	assign byte6[6'd46] = 6'd40;//.
	assign byte6[6'd47] = 6'd47;///
	assign byte6[6'd48] = 6'd30;//0
	assign byte6[6'd49] = 6'd31;//1
	assign byte6[6'd50] = 6'd32;//2
	assign byte6[6'd51] = 6'd33;//3
	assign byte6[6'd52] = 6'd34;//4
	assign byte6[6'd53] = 6'd35;//5
	assign byte6[6'd54] = 6'd36;//6
	assign byte6[6'd55] = 6'd37;//7
	assign byte6[6'd56] = 6'd38;//8
	assign byte6[6'd57] = 6'd39;//9
	assign byte6[6'd58] = 6'd54;//:
	assign byte6[6'd59] = 6'd53;//;
	assign byte6[6'd60] = 6'd50;//<
	assign byte6[6'd61] = 6'd48;//=
	assign byte6[6'd62] = 6'd51;//>
	assign byte6[6'd63] = 6'd0;
	endmodule
