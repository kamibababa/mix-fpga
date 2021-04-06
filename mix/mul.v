// mul - command 3
//
// out[60] = a[30]*b[30]
`default_nettype none
module mul(
	input wire clk,
	input wire start,
	output reg stop,
	input wire [30:0] a,
	input wire [30:0] b,
	output reg [59:0] out,
	output reg sign
);

reg stage1;
always @(posedge clk)
	if (start) stage1 <= 1;
	else stage1 <= 0;
always @(posedge clk)
	if (stage1) sign <= a[30] ^ b[30];

//stage 1
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
	if (stage1) s0 <= (b[0]? 
					(b[1]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[1]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s0 <= 32'b0;
always @(posedge clk)
	if (stage1) s1 <= (b[2]? 
					(b[3]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[3]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s1 <= 32'b0;
always @(posedge clk)
	if (stage1) s2 <= (b[4]? 
					(b[5]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[5]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s2 <= 32'b0;
always @(posedge clk)
	if (stage1) s3 <= (b[6]? 
					(b[7]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[7]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s3 <= 32'b0;
always @(posedge clk)
	if (stage1) s4 <= (b[8]? 
					(b[9]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[9]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s4 <= 32'b0;

always @(posedge clk)
	if (stage1) s5 <= (b[10]? 
					(b[11]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[11]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s5 <= 32'b0;
always @(posedge clk)
	if (stage1) s6 <= (b[12]? 
					(b[13]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[13]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s6 <= 32'b0;
always @(posedge clk)
	if (stage1) s7 <= (b[14]? 
					(b[15]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[15]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s7 <= 32'b0;
always @(posedge clk)
	if (stage1) s8 <= (b[16]? 
					(b[17]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[17]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s8 <= 32'b0;
always @(posedge clk)
	if (stage1) s9 <= (b[18]? 
					(b[19]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[19]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s9 <= 32'b0;

always @(posedge clk)
	if (stage1) s10 <= (b[20]? 
					(b[21]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[21]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s10 <= 32'b0;
always @(posedge clk)
	if (stage1) s11 <= (b[22]? 
					(b[23]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[23]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s11 <= 32'b0;
always @(posedge clk)
	if (stage1) s12 <= (b[24]? 
					(b[25]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[25]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s12 <= 32'b0;
always @(posedge clk)
	if (stage1) s13 <= (b[26]? 
					(b[27]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[27]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s13 <= 32'b0;
always @(posedge clk)
	if (stage1) s14 <= (b[28]? 
					(b[29]?
						({2'b0,a[29:0]}+{1'b0,a[29:0],1'b0}):
						({2'b0,a[29:0]})):
					(b[29]?
						({1'b0,a[29:0],1'b0}):
						(32'b0)));
	else s14 <= 32'b0;

//stag2	
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
	if (stage1) stage2 <= 1;
	else stage2 <= 0;

always @(posedge clk)
	if (stage2) s20 <= {2'd0 , s0} + {s1,2'd0};
	else s20 <= 35'b0;
always @(posedge clk)
	if (stage2) s21 <= {2'd0 , s2} + {s3,2'd0};
	else s21 <= 35'b0;
always @(posedge clk)
	if (stage2) s22 <= {2'd0 , s4} + {s5,2'd0};
	else s22 <= 35'b0;
always @(posedge clk)
	if (stage2) s23 <= {2'd0 , s6} + {s7,2'd0};
	else s23 <= 35'b0;
always @(posedge clk)
	if (stage2) s24 <= {2'd0 , s8} + {s9,2'd0};
	else s24 <= 35'b0;
always @(posedge clk)
	if (stage2) s25 <= {2'd0 , s10} + {s11,2'd0};
	else s25 <= 35'b0;
always @(posedge clk)
	if (stage2) s26 <= {2'd0 , s12} + {s13,2'd0};
	else s26 <= 35'b0;
always @(posedge clk)
	if (stage2) s27 <= {2'd0 , s14};
	else s27 <= 35'b0;

//stage3	
reg [37:0] s30;
reg [37:0] s31;
reg [37:0] s32;
reg [37:0] s33;

reg stage3;
always @(posedge clk)
	if (stage2) stage3 <= 1;
	else stage3 <= 0;

always @(posedge clk)
	if (stage3) s30 <= {4'd0 , s20} + {s21,4'd0};
	else s30 <= 38'b0;
always @(posedge clk)
	if (stage3) s31 <= {4'd0 , s22} + {s23,4'd0};
	else s31 <= 38'b0;
always @(posedge clk)
	if (stage3) s32 <= {4'd0 , s24} + {s25,4'd0};
	else s32 <= 38'b0;
always @(posedge clk)
	if (stage3) s33 <= {4'd0 , s26} + {s27,4'd0};
	else s33 <= 38'b0;
//stage4	
reg [46:0] s40;
reg [46:0] s41;

reg stage4;
always @(posedge clk)
	if (stage3) stage4 <= 1;
	else stage4 <= 0;

always @(posedge clk)
	if (stage4) s40 <= {8'd0 , s30} + {s31,8'd0};
	else s40 <= 47'b0;
always @(posedge clk)
	if (stage4) s41 <= {8'd0 , s32} + {s33,8'd0};
	else s41 <= 47'b0;

//stage5	
reg stage5;
always @(posedge clk)
	if (stage4) stage5 <= 1;
	else stage5 <= 0;

always @(posedge clk)
	if (stage5) out <= {16'd0 , s40} + {s41,16'd0};
	else out <= 60'b0;

always @(posedge clk)
	if (stage5) stop <=1;
	else stop <=0;

endmodule
