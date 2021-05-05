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
