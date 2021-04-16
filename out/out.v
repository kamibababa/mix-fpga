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
	output request
);

	reg busy;
	always @(posedge clk)
		if (reset) busy <= 0;
		else if (~busy & start) busy <= 1;
		else if (next & ~start2) busy <= 0;
	
	reg start2;
	always @(posedge clk)
		if (reset) start2 <= 0;
		else if (busy & start) start2 <= 1;
		else if (next) start2 <= 0;

	reg stop;
	always @(posedge clk)
		if (reset) stop <= 0;
		else if (~busy & start) stop <= 1;
		else if (next & start2) stop <= 1;
		else stop <= 0;

	reg [11:0] address_next;
	always @(posedge clk)
		if (reset) address_next <= 0;
		else if (start & busy) address_next <= addressin;

	reg [11:0] addressout;
	always @(posedge clk)
		if (reset) addressout <= 0;
		else if (~busy & start) addressout <= addressin;
		else if (busy & next) addressout <= address_next;
		else if (busy & load&request) addressout <= addressout + 1;


	reg [3:0] state;
	always @(posedge clk)
		if (reset|next) state <= 0;
		else if (busy&load&request) state <= state + 1;

	reg next;
	always @(posedge clk)
		if (reset) next <= 0;
		else if ((state==2) & load&request) next <= 1;	//10 words
		else next <= 0;

	reg request;
	always @(posedge clk)
		if (reset) request <= 0;
		else if (load) request <= 0;
		else if (~busy & start) request <= 1;
		else if (busy & (counter == 4'd5)) request <= 1;

	
	reg [3:0] counter;
	always @(posedge clk)
		if (reset) counter <= 0;
		else if (~run & (load & request)) counter <= 0;
		else if (run & ready) counter <= counter +1;
	reg run;
	always @(posedge clk)
		if (reset) run <= 0;
		else if (load & request) run <= 1;
		else if (counter == 4'd5) run <= 0;

	reg [29:0] word;
	always @(posedge clk)
		if (reset) word <= 0;
		else if (load & request) word <= in;

	wire [5:0] byte1;
	assign byte1 = (counter==0)? word[29:24]: (counter==1)? word[23:18]: (counter==2)? word[17:12]: (counter==3)? word[11:6]: word[5:0];
	
	wire ready;
	UartTX TX(.tx(tx),.clk(clk),.load((run & (load&request)) | (run&ready)),.in(byte1),.ready(ready));
endmodule
