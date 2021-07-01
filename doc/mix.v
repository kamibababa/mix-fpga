// MIX - 1009
// Don Knuths computer architecture described in "The Art of Computer Programming"

`default_nettype none
module mix(
input wire clk_in,
input wire rx,
output wire tx,
output wire hlt,
input wire button,
output wire dmgreen,
output wire dmamber,
output wire dmred,
output wire bgreen,
output wire bamber,
output wire bred,
output wire dmw,
output wire dmdw,
output wire bw,
output wire bdw

);
assign dmgreen = RegisterX[19:18] == 2'd1;
assign dmamber = RegisterX[19:18] == 2'd2;
assign dmred = RegisterX[19:18] == 2'd3;
assign bgreen = RegisterX[13:12] == 2'd1;
assign bamber = RegisterX[13:12] == 2'd2;
assign bred = RegisterX[13:12] == 2'd3;
assign dmw = RegisterX[7:6] == 2'd1;
assign dmdw = RegisterX[7:6] == 2'd2;
assign bw = RegisterX[1:0] == 2'd1;
assign bdw = RegisterX[1:0] == 2'd2;
