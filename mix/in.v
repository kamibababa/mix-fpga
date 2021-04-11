`default_nettype none
module in(
	input wire clk,
	input wire reset,
	input wire start,
	output wire [29:0] out,
	input wire [11:0] addressin,
	output wire [11:0] addressout,
	output wire stop,
	output wire store,
	input wire rx
);

	reg store0;
	always @(posedge clk)
		if (start) store0 <= 1;
		else store0 <= 0;
		
	reg store1;
	always @(posedge clk)
		if (store0) store1 <= 1;
		else store1 <= 0;
	
	reg store2;
	always @(posedge clk)
		if (store1) store2 <= 1;
		else store2 <= 0;
	assign store = start | store0 | store1;
	assign stop = store2;
	
	assign addressout = start? addressin:address;
	reg [11:0] address;
	always @(posedge clk)
		if (start) address <= addressin+1;
		else if (store0|store1) address <= address+1;

	reg [29:0] data0 = {6'd1,6'd3,6'd5,6'd7,6'd9};
	reg [29:0] data1 = {6'd1,6'd4,6'd6,6'd8,6'd11};
	reg [29:0] data2 = {6'd30,6'd32,6'd34,6'd36,6'd38};

	assign out = store0? data1 : (store1? data2 : data0);	


endmodule
