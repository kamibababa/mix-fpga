`default_nettype none
module sram( 
    	input reset,
	input clk,				// external clock 100 MHz	
	input [9:0] block,
	output reg [17:0] sram_addr,		// SRAM Address 18 Bit = 256K
	inout [15:0] sram_data,			// SRAM Data 16 Bit
	output wire sram_wen,			// SRAM write_enable_not
	output wire sram_oen,			// SRAM output_enable_not
	output wire sram_cen, 			// SRAM chip_enable_not
	input wire startW,
	input wire startR,
	input wire [11:0] mix_addr_in,
	output reg [11:0] mix_addr_out,
	input wire [30:0] mix_data_in,
	output reg [30:0] mix_data_out,
	output reg mix_read,
	output reg mix_write,
	output wire stop
);
	assign stop = last;
	reg start2;
	always @(posedge clk)
		if (startW) start2 <=1;
		else start2 <= 0;
	reg startR2;
	always @(posedge clk)
		if (startR) startR2 <=1;
		else startR2 <= 0;


	always @(posedge clk)
		if (startW|startR) sram_addr <= {block,8'd0};
		else if (~start2& ~startR2 & count[0]) sram_addr <= sram_addr + 1;

	always @(posedge clk)
		if (startW|startR) mix_addr_out <= mix_addr_in;
		else if (write &  count ==2'd2) mix_addr_out <= mix_addr_out + 1;
		else if (read &  count ==2'd3) mix_addr_out <= mix_addr_out + 1;

	always @(posedge clk)
		if (startW | (write & (count ==2'd2))) mix_read <= 1;
		else mix_read <= 0;
	always @(posedge clk)
		if ((read & (count ==2'd2))) mix_write <= 1;
		else mix_write <= 0;
	
	assign dataW = (count ==2'd0)? mix_data_in[15:0] : datan;

	reg [15:0] datah;
	always @(posedge clk)
		if (count==2'd0) datah <= {1'd0,mix_data_in[30:16]};
	reg [15:0] datan;
	always @(posedge clk)
		if (count==2'd0) datan <= dataW;
		else if (count==2'd1) datan <= datah;
	
	wire last;
	assign last = (sram_addr[7:0] == 8'd199) & (count == 2'd3);

	always @(posedge clk)
		if (read & (count==2'd0)) mix_data_out <= {15'd0,sram_data};
		else if (read & (count==2'd2)) mix_data_out <= {sram_data[14:0],mix_data_out[15:0]};


	reg [1:0] count=0;
	always @(posedge clk)
		if (startW|startR) count <= 2'd0;
		else if (write|read) count <= count + 1;

	reg sram_we;
	assign sram_wen = ~ sram_we;
	always @(posedge clk)
		if (reset) sram_we <= 0;
		else if (write & ~count[0]) sram_we <= 1;
		else sram_we <= 0;
	reg sram_oe;
	assign sram_oen = ~sram_oe;
	always @(posedge clk)
		if (reset) sram_oe <= 0;
		else if (startR2) sram_oe <= 1;
		else if (last) sram_oe <= 0;
	reg sram_ce;
	assign sram_cen=~sram_ce;
	always @(posedge clk)
		if (reset) sram_ce <= 0;
		else if (start2|startR2) sram_ce <= 1;
		else if (last) sram_ce <= 0;
	reg read;
	always @(posedge clk)
		if (reset) read <= 0;
		else if (startR2) read <= 1;
		else if (last) read <= 0;

	reg write;
	always @(posedge clk)
		if (reset) write <= 0;
		else if (start2) write <= 1;
		else if (last) write <= 0;
	wire [15:0] dataW;
	assign sram_data = (write)? dataW: 16'bzzzzzzzzzzzzzzzz;
	
endmodule
