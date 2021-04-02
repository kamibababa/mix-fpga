//------------------------------------------------------------------
//-- Hello world example
//-- Control leds by pushing the buttons
//-- This example has been tested on the following boards:
//--   * iCE40-HX1K-EVB Olimex
//------------------------------------------------------------------

module mul2(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [29:0] a,
	input wire [29:0] b,
	output wire [59:0] out
	);
assign out = s50[59:0];
reg [31:0] s0;
reg [31:0] s1;
reg [31:0] s2;
reg [31:0] s3;
reg [31:0] s4;
reg [31:0] s5;
reg [31:0] s6;
reg [31:0] s7;
reg [31:0] s8;
reg [31:0] s9;
reg [31:0] s10;
reg [31:0] s11;
reg [31:0] s12;
reg [31:0] s13;
reg [31:0] s14;


always @(posedge clk)
	if (start) s0 <= (b[0]? 
					(b[1]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[1]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s0 <= 32'b0;
always @(posedge clk)
	if (start) s1 <= (b[2]? 
					(b[3]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[3]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s1 <= 32'b0;
always @(posedge clk)
	if (start) s2 <= (b[4]? 
					(b[5]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[5]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s2 <= 32'b0;
always @(posedge clk)
	if (start) s3 <= (b[6]? 
					(b[7]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[7]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s3 <= 32'b0;
always @(posedge clk)
	if (start) s4 <= (b[8]? 
					(b[9]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[9]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s4 <= 32'b0;

always @(posedge clk)
	if (start) s5 <= (b[10]? 
					(b[11]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[11]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s5 <= 32'b0;
always @(posedge clk)
	if (start) s6 <= (b[12]? 
					(b[13]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[13]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s6 <= 32'b0;
always @(posedge clk)
	if (start) s7 <= (b[14]? 
					(b[15]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[15]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s7 <= 32'b0;
always @(posedge clk)
	if (start) s8 <= (b[16]? 
					(b[17]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[17]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s8 <= 32'b0;
always @(posedge clk)
	if (start) s9 <= (b[18]? 
					(b[19]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[19]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s9 <= 32'b0;

always @(posedge clk)
	if (start) s10 <= (b[20]? 
					(b[21]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[21]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s10 <= 32'b0;
always @(posedge clk)
	if (start) s11 <= (b[22]? 
					(b[23]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[23]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s11 <= 32'b0;
always @(posedge clk)
	if (start) s12 <= (b[24]? 
					(b[25]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[25]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s12 <= 32'b0;
always @(posedge clk)
	if (start) s13 <= (b[26]? 
					(b[27]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[27]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s13 <= 32'b0;
always @(posedge clk)
	if (start) s14 <= (b[28]? 
					(b[29]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[29]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s14 <= 32'b0;

//stage2	
reg [34:0] s20;
reg [34:0] s21;
reg [34:0] s22;
reg [34:0] s23;
reg [34:0] s24;
reg [34:0] s25;
reg [34:0] s26;
reg [34:0] s27;

reg stage2;
always @(posedge clk)
	if (start) stage2 <= 1;
	else stage2 <= 0;

always @(posedge clk)
	if (stage2) s20 <= {3'd0 , s0} + {1'd0,s1,2'd0};
	else s20 <= 35'b0;
always @(posedge clk)
	if (stage2) s21 <= {3'd0 , s2} + {1'd0,s3,2'd0};
	else s21 <= 35'b0;
always @(posedge clk)
	if (stage2) s22 <= {3'd0 , s4} + {1'd0,s5,2'd0};
	else s22 <= 35'b0;
always @(posedge clk)
	if (stage2) s23 <= {3'd0 , s6} + {1'd0,s7,2'd0};
	else s23 <= 35'b0;
always @(posedge clk)
	if (stage2) s24 <= {3'd0 , s8} + {1'd0,s9,2'd0};
	else s24 <= 35'b0;
always @(posedge clk)
	if (stage2) s25 <= {3'd0 , s10} + {1'd0,s11,2'd0};
	else s25 <= 35'b0;
always @(posedge clk)
	if (stage2) s26 <= {3'd0 , s12} + {1'd0,s13,2'd0};
	else s26 <= 35'b0;
always @(posedge clk)
	if (stage2) s27 <= {3'd0 , s14};
	else s27 <= 35'b0;
//stage3	
reg [39:0] s30;
reg [39:0] s31;
reg [39:0] s32;
reg [39:0] s33;

reg stage3;
always @(posedge clk)
	if (stage2) stage3 <= 1;
	else stage3 <= 0;

always @(posedge clk)
	if (stage3) s30 <= {5'd0 , s20} + {1'd0,s21,4'd0};
	else s30 <= 40'b0;
always @(posedge clk)
	if (stage3) s31 <= {5'd0 , s22} + {1'd0,s23,4'd0};
	else s31 <= 40'b0;
always @(posedge clk)
	if (stage3) s32 <= {5'd0 , s24} + {1'd0,s25,4'd0};
	else s32 <= 40'b0;
always @(posedge clk)
	if (stage3) s33 <= {5'd0 , s26} + {1'd0,s27,4'd0};
	else s33 <= 40'b0;
//stage4	
reg [48:0] s40;
reg [48:0] s41;

reg stage4;
always @(posedge clk)
	if (stage3) stage4 <= 1;
	else stage4 <= 0;

always @(posedge clk)
	if (stage4) s40 <= {9'd0 , s30} + {1'd0,s31,8'd0};
	else s40 <= 49'b0;
always @(posedge clk)
	if (stage4) s41 <= {9'd0 , s32} + {1'd0,s33,8'd0};
	else s41 <= 49'b0;
//stage5	
reg [65:0] s50;

reg stage5;
always @(posedge clk)
	if (stage4) stage5 <= 1;
	else stage5 <= 0;

always @(posedge clk)
	if (stage5) s50 <= {17'd0 , s40} + {1'd0,s41,16'd0};
	else s50 <= 66'b0;

always @(posedge clk)
	if (stage5) stop <=1;
	else stop <=0;
endmodule
