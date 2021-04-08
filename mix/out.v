`default_nettype none
module out(
	input wire clk,
	input wire reset,
	input wire start,
	input wire [29:0] in,
	input wire [11:0] addressin,
	output wire [11:0] addressout,
	output wire stop,
	output wire load,
	output wire tx
);
	reg load0;
	always @(posedge clk)
		if (start) load0 <= 1;
		else load0 <= 0;
		
	reg load1;
	always @(posedge clk)
		if (load0) load1 <= 1;
		else load1 <= 0;
	
	reg load2;
	always @(posedge clk)
		if (load1) load2 <= 1;
		else load2 <= 0;
	assign load = start | load0 | load1;
	assign stop = load2;
	
	assign addressout = start? addressin:address;
	reg [11:0] address;
	always @(posedge clk)
		if (start) address <= addressin+1;
		else if (load0|load1) address <= address+1;

	reg [29:0] data0;
	reg [29:0] data1;
	reg [29:0] data2;
	always @(posedge clk)
		if (load0) data0 <= in;
	always @(posedge clk)
		if (load1) data1 <= in;
	always @(posedge clk)
		if (load2) data2 <= in;
	

	reg send0;
	always @(posedge clk)
		if (reset) send0 <= 0;
		else if (load0) send0 <=1;
		else if (next & byte4) send0 <= 0;
	reg send1;
	always @(posedge clk)
		if (reset) send1 <= 0;
		else if (next & byte4) send1 <= send0;
	reg send2;
	always @(posedge clk)
		if (reset) send2 <= 0;
		else if (next & byte4) send2 <= send1;
	wire send;
	assign send = send0|send1|send2;

	reg byte0;
	always @(posedge clk)
		if (reset) byte0 <= 0;
		else if (load0) byte0 <= 1;
		else if (next) byte0 <= byte4;
	reg byte1;
	always @(posedge clk)
		if (reset) byte1 <= 0;
		else if (next) byte1 <= byte0;
	reg byte2;
	always @(posedge clk)
		if (reset) byte2 <= 0;
		else if (next) byte2 <= byte1;
	reg byte3;
	always @(posedge clk)
		if (reset) byte3 <= 0;
		else if (next) byte3 <= byte2;
	reg byte4;
	always @(posedge clk)
		if (reset) byte4 <= 0;
		else if (next) byte4 <= byte3;

	wire [29:0] word;
	assign word = send0? data0 : (send1? data1 : (send2? data2 : 30'd0));
	wire [5:0] byt;
	assign byt = byte0? word[29:24] : (byte1? word[23:18] : (byte2? word[17:12] : (byte3? word[11:6]: (byte4? word[5:0]: 6'd0))));

	wire next;
	assign next= load0 | (send & ready);
	wire ready;
	UartTX TX(.tx(tx),.clk(clk),.in(byt),.load((send & (load0|ready))),.ready(ready));

endmodule
