module add10(
	input wire [5:0] a,
	input wire [5:0] b,
	input wire c,
	output wire [6:0] s,
	output wire cout
);

	assign s[0] = (a[0] & b[0]) | (a[1] & b[4]) | (a[2] & b[3])| (a[3] & b[2]) | (a[4] & b[1]);
	assign s[1] = (a[0] & b[1]) | (a[1] & b[0]) | (a[2] & b[4])| (a[3] & b[3]) | (a[4] & b[2]);
	assign s[2] = (a[0] & b[2]) | (a[1] & b[1]) | (a[2] & b[0])| (a[3] & b[4]) | (a[4] & b[3]);
	assign s[3] = (a[0] & b[3]) | (a[1] & b[2]) | (a[2] & b[1])| (a[3] & b[0]) | (a[4] & b[4]);
	assign s[4] = (a[0] & b[4]) | (a[1] & b[3]) | (a[2] & b[2])| (a[3] & b[1]) | (a[4] & b[0]);
	wire hand;
	assign hand = (a[1] & b[4]) | (a[2] & (b[3]|b[4])) | (a[3] & (b[2]|b[3]|b[4])) | (a[4] & (b[1]|b[2]|b[3]|b[4]));
	assign s[5] = (a[5] & b[5] & hand) | (a[5] & ~b[5] & ~hand) | (~a[5] & b[5] & ~hand) | (~a[5] & ~b[5] & hand);
	assign cout = (a[5] & b[5]) | (a[5] & hand) | (b[5] & hand);
	
endmodule
