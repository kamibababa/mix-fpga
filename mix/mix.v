// MIX
// The Art of Computer Programming
// Don Knuth

`default_nettype none
module mix(
	input wire reset,
	input wire clk,
	output wire [30:0] a
);
	assign a = RegisterA[30:0];
	//register
	reg [30:0] RegisterA;
	reg [30:0] RegisterX;
	reg [12:0] RegisterI1;
	reg [12:0] RegisterI2;
	reg [12:0] RegisterI3;
	reg [12:0] RegisterI4;
	reg [12:0] RegisterI5;
	reg [12:0] RegisterI6;
	reg [11:0] RegisterJ;
	
	//cycle
	reg cycle;
	always @(posedge clk)
		if (reset) cycle <= 0;
		else cycle <= ~cycle;

	//programm counter
	reg [11:0] pc;
	always @(posedge clk)
		if (reset) pc <= 0;
		else if (cycle) pc <= pc+1;
	

	//memory cells
	reg [30:0] memory[0:4095];
	parameter ROMFILE = "rom.bin";
	initial begin
		$readmemb(ROMFILE,memory);
	end
	reg [30:0] data;
	wire [11:0] address;
		assign address = (cycle==1'b0)? pc : data[29:18];
	always @(posedge clk)
		data <= memory[address];

	//COMMAND
	wire [5:0] command;
	assign command = data[5:0];
	//LDA,LDAN
	reg loadA;
	always @(posedge clk)
		loadA <= cycle & (command==6'd8);
	reg loadAN;
	always @(posedge clk)
		loadAN <= cycle & (command==6'd16);
	always @(posedge clk)
		if (loadA) RegisterA <= fieldLoad;
		else if (loadAN) RegisterA <= {~fieldLoad[30],fieldLoad[29:0]};
	//LD1,LD1N
	reg load1;
	always @(posedge clk)
		load1 <= cycle & (command==6'd9);
	reg load1N;
	always @(posedge clk)
		load1N <= cycle & (command==6'd17);
	always @(posedge clk)
		if (load1) RegisterI1 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load1N) RegisterI1 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LD2
	reg load2;
	always @(posedge clk)
		load2 <= cycle & (command==6'd10);
	reg load2N;
	always @(posedge clk)
		load2N <= cycle & (command==6'd18);
	always @(posedge clk)
		if (load2) RegisterI2 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load2N) RegisterI2 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LD3
	reg load3;
	always @(posedge clk)
		load3 <= cycle & (command==6'd11);
	reg load3N;
	always @(posedge clk)
		load3N <= cycle & (command==6'd19);
	always @(posedge clk)
		if (load3) RegisterI3 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load3N) RegisterI3 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LD4
	reg load4;
	always @(posedge clk)
		load4 <= cycle & (command==6'd12);
	reg load4N;
	always @(posedge clk)
		load4N <= cycle & (command==6'd20);
	always @(posedge clk)
		if (load4) RegisterI4 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load4N) RegisterI4 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LD5
	reg load5;
	always @(posedge clk)
		load5 <= cycle & (command==6'd13);
	reg load5N;
	always @(posedge clk)
		load5N <= cycle & (command==6'd21);
	always @(posedge clk)
		if (load5) RegisterI5 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load5N) RegisterI5 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LD6
	reg load6;
	always @(posedge clk)
		load6 <= cycle & (command==6'd14);
	reg load6N;
	always @(posedge clk)
		load6N <= cycle & (command==6'd22);
	always @(posedge clk)
		if (load6) RegisterI6 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load6N) RegisterI6 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LDX
	reg loadX;
	always @(posedge clk)
		loadX <= cycle & (command==6'd15);
	reg loadXN;
	always @(posedge clk)
		loadXN <= cycle & (command==6'd23);
	always @(posedge clk)
		if (loadX) RegisterX <= fieldLoad;
		else if (loadXN) RegisterX <= {~fieldLoad[30],fieldLoad[29:0]};

	//ST
	reg store;
	always @(posedge clk)
		store <=  cycle & (command[5:3]==3'b011);
	reg [30:0] dataS;
	always @(posedge clk)
		if (cycle & (command[5:3] == 3'b011))
			dataS <= (command[2]?
					(command[1]?
						(command[0]?
							(RegisterX):
							({RegisterI6[12],18'd0,RegisterI6[11:0]})):
						(command[0]?
							({RegisterI5[12],18'd0,RegisterI5[11:0]}):
							({RegisterI4[12],18'd0,RegisterI4[11:0]}))):
					(command[1]?
						(command[0]?
							({RegisterI3[12],18'd0,RegisterI3[11:0]}):
							({RegisterI2[12],18'd0,RegisterI2[11:0]})):
						(command[0]?
							({RegisterI1[12],18'd0,RegisterI1[11:0]}):
							(RegisterA))));
	
	//FIELD
	wire [30:0] fieldLoad;
	field FIELDM(.in(data),.field(f),.out(fieldLoad));
	reg [5:0] f;
	always @(posedge clk)
		if (cycle) f <= data[11:6];
	reg [11:0] addressStore;
	always @(posedge clk)
		addressStore <= data[29:18];	
	wire [30:0] fieldStore;
	fieldS FIELDS(.data(data),.in(dataS),.field(f),.out(fieldStore));
	always @(posedge clk)
		if (store) memory[addressStore] <= fieldStore;

	
endmodule
