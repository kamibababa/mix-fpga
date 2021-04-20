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
	wire is144;
	assign is144 = baud[4] & baud[7];
	always @(posedge clk)
		if (reset|is144) baud <= 0;
		else if (run) baud <= baud + 1;

	wire shift;
	assign shift = is144 & ~bits[0];
	reg [15:0] bits;
	always @(posedge clk)
		if (reset|start) bits <= 0;
		else if (is144) bits <= bits + 1;

	assign stop = is144 & bits[4] & bits[1];	
	
	reg [9:0] shifter;
	always @(posedge clk)
		if (reset) shifter <= 0;
		else if (shift) shifter <= {rx_in,shifter[9:1]};
	assign out = shifter[9:2];


endmodule
