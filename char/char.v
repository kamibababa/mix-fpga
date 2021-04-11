// CHAR - command 5()

`default_nettype none

module char(
	input wire clk,
	input wire start,
	output wire stop,
	input wire [29:0] in1,
	output reg [59:0] out
);
reg [29:0] in;
always @(posedge clk)
	if (start) in <= in1;
	else if (run) in <= in - dd;
wire [29:0] dd;
assign dd = i9? f9: i8? f8: i7? f7: i6? f6: i5? f5: i4? f4: i3? f3: i2? f2: i1? f1: 30'd0;

reg [3:0] state;
always @(posedge clk)
	if (start) state <=0;
	else if (run) state <= state + 1;

reg run;
always @(posedge clk)
	if (start) run <= 1;
	else if (stop) run <= 0;

assign stop = (state==10);


wire i9;
assign i9 = in >= f9;
wire i8;
assign i8 = in >= f8;
wire i7;
assign i7 = in >= f7;
wire i6;
assign i6 = in >= f6;
wire i5;
assign i5 = in >= f5;
wire i4;
assign i4 = in >= f4;
wire i3;
assign i3 = in >= f3;
wire i2;
assign i2 = in >= f2;
wire i1;
assign i1 = in >= f1;

always @(posedge clk)
	if (start) out <= 0;
	else if (run) out <= {out[53:0],d};

wire [5:0] d;
	assign d = i9? 6'd9 : i8? 6'd8: i7? 6'd7:
		i6? 6'd6: i5? 6'd5: i4? 6'd4:
		i3? 6'd3: i2? 6'd2: i1? 6'd1: 6'd0;

wire [29:0] f9;
assign f9 = state[3]?
		(state[2]?
			(30'd0):
			(state[1]?
				(30'd0):
				(state[0]?
					(30'd9):
					(30'd90)))):
		(state[2]?
			(state[1]?
				(state[0]?
					(30'd900):
					(30'd9000)):
				(state[0]?
					(30'd90000):
					(30'd900000))):
			(state[1]?
				(state[0]?
					(30'd9000000):
					(30'd90000000)):
				(state[0]?
					(30'd900000000):
					(30'd9000000000))));
wire [29:0] f8;
assign f8 = state[3]?
		(state[2]?
			(30'd0):
			(state[1]?
				(30'd0):
				(state[0]?
					(30'd8):
					(30'd80)))):
		(state[2]?
			(state[1]?
				(state[0]?
					(30'd800):
					(30'd8000)):
				(state[0]?
					(30'd80000):
					(30'd800000))):
			(state[1]?
				(state[0]?
					(30'd8000000):
					(30'd80000000)):
				(state[0]?
					(30'd800000000):
					(30'd8000000000))));
wire [29:0] f7;
assign f7 = state[3]?
		(state[2]?
			(30'd0):
			(state[1]?
				(30'd0):
				(state[0]?
					(30'd7):
					(30'd70)))):
		(state[2]?
			(state[1]?
				(state[0]?
					(30'd700):
					(30'd7000)):
				(state[0]?
					(30'd70000):
					(30'd700000))):
			(state[1]?
				(state[0]?
					(30'd7000000):
					(30'd70000000)):
				(state[0]?
					(30'd700000000):
					(30'd7000000000))));
wire [29:0] f6;
assign f6 = state[3]?
		(state[2]?
			(30'd0):
			(state[1]?
				(30'd0):
				(state[0]?
					(30'd6):
					(30'd60)))):
		(state[2]?
			(state[1]?
				(state[0]?
					(30'd600):
					(30'd6000)):
				(state[0]?
					(30'd60000):
					(30'd600000))):
			(state[1]?
				(state[0]?
					(30'd6000000):
					(30'd60000000)):
				(state[0]?
					(30'd600000000):
					(30'd6000000000))));
wire [29:0] f5;
assign f5 = state[3]?
		(state[2]?
			(30'd0):
			(state[1]?
				(30'd0):
				(state[0]?
					(30'd5):
					(30'd50)))):
		(state[2]?
			(state[1]?
				(state[0]?
					(30'd500):
					(30'd5000)):
				(state[0]?
					(30'd50000):
					(30'd500000))):
			(state[1]?
				(state[0]?
					(30'd5000000):
					(30'd50000000)):
				(state[0]?
					(30'd500000000):
					(30'd5000000000))));
wire [29:0] f4;
assign f4 = state[3]?
		(state[2]?
			(30'd0):
			(state[1]?
				(30'd0):
				(state[0]?
					(30'd4):
					(30'd40)))):
		(state[2]?
			(state[1]?
				(state[0]?
					(30'd400):
					(30'd4000)):
				(state[0]?
					(30'd40000):
					(30'd400000))):
			(state[1]?
				(state[0]?
					(30'd4000000):
					(30'd40000000)):
				(state[0]?
					(30'd400000000):
					(30'd4000000000))));
wire [29:0] f3;
assign f3 = state[3]?
		(state[2]?
			(30'd0):
			(state[1]?
				(30'd0):
				(state[0]?
					(30'd3):
					(30'd30)))):
		(state[2]?
			(state[1]?
				(state[0]?
					(30'd300):
					(30'd3000)):
				(state[0]?
					(30'd30000):
					(30'd300000))):
			(state[1]?
				(state[0]?
					(30'd3000000):
					(30'd30000000)):
				(state[0]?
					(30'd300000000):
					(30'd3000000000))));
wire [29:0] f2;
assign f2 = state[3]?
		(state[2]?
			(30'd0):
			(state[1]?
				(30'd0):
				(state[0]?
					(30'd2):
					(30'd20)))):
		(state[2]?
			(state[1]?
				(state[0]?
					(30'd200):
					(30'd2000)):
				(state[0]?
					(30'd20000):
					(30'd200000))):
			(state[1]?
				(state[0]?
					(30'd2000000):
					(30'd20000000)):
				(state[0]?
					(30'd200000000):
					(30'd2000000000))));
wire [29:0] f1;
assign f1 = state[3]?
		(state[2]?
			(30'd0):
			(state[1]?
				(30'd0):
				(state[0]?
					(30'd1):
					(30'd10)))):
		(state[2]?
			(state[1]?
				(state[0]?
					(30'd100):
					(30'd1000)):
				(state[0]?
					(30'd10000):
					(30'd100000))):
			(state[1]?
				(state[0]?
					(30'd1000000):
					(30'd10000000)):
				(state[0]?
					(30'd100000000):
					(30'd1000000000))));
endmodule
