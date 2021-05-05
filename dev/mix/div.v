// DIV - command 4

`default_nettype none

module div(
	input wire clk,
	input wire start,
	output stop,
	input wire [60:0] dividend,
	input wire [30:0] divisor,
	output [29:0] quotient,
	output [29:0] rest,
	output sign,
	output overflow
);
	// | start	| 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 
	// | start2     | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0
	// | stop       | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0
	// | run        | 0 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 0
	// | counter    | 0 | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | 0
	// | last       | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0
	// | dividend   | a | x | x ...
	// | divisor    | x | b	| x ...
	// | sign       |   |sa |sab ...                            |sab|
	// | overflow   |   |   |of |
	// | quotient   | x | 0 | ...                               |a*b|
	// | rest       |   |                   
	
	// module is running
	reg run;
	always @(posedge clk)
		if (start) run <= 1;
		else if (last) run <= 0;

	// module is in cycle 2
	reg start2;
	always @(posedge clk)
		if (start) start2 <= 1;
		else start2 <= 0;

	// count the cycles
	reg [3:0] counter;
	always @(posedge clk)
		if (start|last) counter <= 0;
		else if (run) counter <= counter + 1;
	
	// last cycle is number 9
	wire last;
	assign last = (counter == 4'd9);
	
	// then stop
	reg stop;
	always @(posedge clk)
		if (last) stop <= 1;
		else stop <= 0;
	
	// overflow is determined on cycle 2, when both operands are available
	reg overflow;	
	always @(posedge clk)
		if (start2) overflow <= (dvs[29:0] == 30'd0) | ~i0;
	
	// sign is calculated at cycle 2, when second operand comes into play
	reg sign;
	always @(posedge clk)
		if (start) sign <= dividend[60];
		else if (start2) sign <= sign ^ divisor[30];


	// the divisor comes up on cycle number 2
	reg [29:0] dvs2;
	always @(posedge clk)
		if (start2) dvs2 <= divisor[29:0];
	
	wire [29:0] dvs;
	assign dvs = (start2)? divisor[29:0] : dvs2;
	
	// the dividend comes up at start and will be shifted to left by
	// 3 bits
	reg [63:0] dvd;
	always @(posedge clk)
		if (start) dvd <= {4'd0,dividend[59:0]};
		else if (run) dvd <= {1'd0,rest,dvd[29:0],3'd0};
	
		
	// calculate the possible rests	
	wire [33:0] d1;
	wire [33:0] d2;
	wire [33:0] d3;
	wire [33:0] d4;
	wire [33:0] d5;
	wire [33:0] d6;
	wire [33:0] d7;
	assign d1 = dvd[63:30] - {4'd0,dvs};
	assign d2 = dvd[63:30] - {3'd0,dvs,1'd0};
	assign d3 = dvd[63:30] - ({3'd0,dvs,1'd0}+{4'd0,dvs});
	assign d4 = dvd[63:30] - {2'd0,dvs,2'd0};
	assign d5 = dvd[63:30] - ({2'd0,dvs,2'd0} + {4'd0,dvs});
	assign d6 = dvd[63:30] - ({2'd0,dvs,2'd0} + {3'd0,dvs,1'd0});
	assign d7 = dvd[63:30] - ({2'd0,dvs,2'd0} + {3'd0,dvs,1'd0} + {4'd0,dvs});
	
	// look for the biggest quotient	
	wire i7;
	assign i7 = ~d7[33];
	wire i6;
	assign i6 = ~i7 & ~d6[33];
	wire i5;
	assign i5 = ~(i6|i7) & ~d5[33];
	wire i4;
	assign i4 = ~(i5|i6|i7) & ~d4[33];
	wire i3;
	assign i3 = ~(i4|i5|i6|i7) & ~d3[33];
	wire i2;
	assign i2 = ~(i3|i4|i5|i6|i7) & ~d2[33];
	wire i1;
	assign i1 = ~(i2|i3|i4|i5|i6|i7) & ~d1[33];
	wire i0;
	assign i0 = ~(i1|i2|i3|i4|i5|i6|i7);
	
	// that gives the smallest rest
	wire [29:0] rest;
	assign rest = (i7)? d7[29:0]:
			(i6)? d6[29:0]:
			(i5)? d5[29:0]:
			(i4)? d4[29:0]:
			(i3)? d3[29:0]:
			(i2)? d2[29:0]:
			(i1)? d1[29:0]:
			dvd[59:30];

	// this gives one octal digit of the quotient
	wire [2:0] digit;
	assign digit = {i4|i5|i6|i7,i2|i3|i6|i7,i1|i3|i5|i7}; 
	
	// the digit is then shifted in the quotient
	reg [29:0] quot;
	always @(posedge clk)
		if (start) quot <= 30'd0;
		else if (run) quot <= quotient;

	assign quotient = {quot[26:0],digit};	

endmodule
