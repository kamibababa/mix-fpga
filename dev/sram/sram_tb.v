`default_nettype none
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module sram_tb();

//-- Simulation time: 1us (10 * 100ns)
parameter DURATION = 100000;

//-- Clock signal. It is not used in this simulation
reg clk = 0;
always #0.5 clk = ~clk;
reg reset = 1;
reg startW=0;
reg startR=0;
wire [11:0] mix_addr_out;
reg [30:0] mix_data;
wire mix_read;
reg [31:0] data[100];
always @(posedge clk)
	if (mix_read) mix_data <= data[mix_addr_out];
	else mix_data <=0;

initial begin
	data[0] = 32'd5555555555;
	data[1] = 32'd5555555555;
	data[2] = 32'd5555555555;
	data[3] = 32'd5555555555;
	data[4] = 32'd5555555555;
	data[5] = 32'd55555;
	data[6] = 32'd55555;
	data[7] = 32'd55555;
	data[8] = 32'd55555;
	data[9] = 32'd55555;
	data[10] = 32'd66666;

end

//-- Instantiate the unit to test
sram SRAM(
	   .clk(clk),
	   .reset(reset),
	   .startW(startW),
	   .startR(startR),
	   .block(10'd555),
	   .mix_read(mix_read),
	   .mix_addr_out(mix_addr_out),
	   .mix_data_in(mix_data),
	   .mix_addr_in(12'd0)
         );


initial begin

  //-- File were to store the simulation results
  $dumpfile(`DUMPSTR(`VCD_OUTPUT));
  $dumpvars(0, sram_tb);
  	#3 reset <= 0;
	#1 startW <= 1;
	#1 startW <= 0;
	#50 startR <= 1;
	#1 startR <= 0;
   #(DURATION) $display("End of simulation");
  $finish;
end

endmodule
