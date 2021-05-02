// jmp - command 39
//

`default_nettype none
module jmpr(
	input wire sel,
	input wire [30:0] in,
	output wire out,
	input wire [2:0] field
);
	wire z;
	assign z = (in[29:0] == 30'd0);
	wire jn;
	assign jn = (field == 3'd0) & ~z & in[30];
	wire jz;
	assign jz = (field == 3'd1) & z;
	wire jp;
	assign jp = (field == 3'd2) & ~z & ~ in[30];
	wire jnn;
	assign jnn = (field == 3'd3) & (z | ~in[30]);
	wire jnz;
	assign jnz = (field == 3'd4) & ~z;
	wire jnp;
	assign jnp = (field == 3'd5) & (z | in[30]) ;

	assign out = sel & (jn|jz|jp|jnn|jnz|jnp);
endmodule
