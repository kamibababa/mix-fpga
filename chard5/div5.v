`default_nettype none

module div5(
	input wire [5:0] in, //8,6,4,2,0,1
	output wire q,
	output wire [4:0] r//4,3,2,1,0
);

assign q = (in[3]&in[0]) | in[4] | in[5];
assign r = {(in[5]&in[0])|(in[3]&~in[0]),
	(in[2]&in[0])|(in[5]&~in[0]),
	(in[2]&~in[0])|(in[4]&in[0]),
      	(in[1]&in[0])|(in[4]&~in[0]),
	(in[1]&~in[0])|(in[3]&in[0])};

endmodule
