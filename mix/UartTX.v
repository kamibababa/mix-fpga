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
		if (start) shifter <= {2'b10,in,1'b0};
		else if (is288) shifter <= {1'b1,shifter[9:1]};
	assign tx = shifter[0] | ready;

endmodule
