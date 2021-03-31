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
	
	//state
	reg state;
	always @(posedge clk)
		if (reset) state <= 1;
		else if (incpc) state <= 0;
		else state <= state + 1'd1;
	wire cmd;
	assign cmd = (state==0);

	wire incpc;
	assign 	incpc = nop | (state == 1);
	//COMMAND
	wire [5:0] command;
	assign command = {cmd,cmd,cmd,cmd,cmd,cmd} & data[5:0];
	reg [5:0] f;
	always @(posedge clk)
		if (cmd) f <= data[11:6];
	
	//programm counter
	reg [11:0] pc;
	always @(posedge clk)
		if (reset) pc <= 0;
		else if (incpc) pc <= pc+1;

	reg [11:0] oldpc;
	always @(posedge clk)
		if (incpc) oldpc <= pc;
	wire nop;
	assign nop = cmd & (command == 6'd0);

	//memory cells
	reg [30:0] memory[0:4095];
	parameter ROMFILE = "rom.bin";
	initial begin
		$readmemb(ROMFILE,memory);
	end
	reg [30:0] data;
	wire [11:0] address;
	assign address = (incpc)? pc : (offsetS? (data[29:18]-offset):(data[29:18]+offset) );
	wire[11:0] offset;
	assign offset =	data[14]?
				(data[13]?
					(data[12]?
						(12'd0):
						(RegisterI6[11:0])):
					(data[12]?
						(RegisterI5[11:0]):
						(RegisterI4[11:0]))):
				(data[13]?
					(data[12]?
						(RegisterI3[11:0]):
						(RegisterI2[11:0])):
					(data[12]?
						(RegisterI1[11:0]):
						(12'd0)));
	wire offsetS;
	assign offsetS =data[14]?
				(data[13]?
					(data[12]?
						(1'd0):
						(RegisterI6[12])):
					(data[12]?
						(RegisterI5[12]):
						(RegisterI4[12]))):
				(data[13]?
					(data[12]?
						(RegisterI3[12]):
						(RegisterI2[12])):
					(data[12]?
						(RegisterI1[12]):
						(1'd0)));
			
	always @(posedge clk)
		data <= memory[address];

	//LDA,LDAN
	reg loadA;
	always @(posedge clk)
		loadA <= (command==6'd8);
	reg loadAN;
	always @(posedge clk)
		loadAN <= (command==6'd16);
	always @(posedge clk)
		if (loadA) RegisterA <= fieldLoad;
		else if (loadAN) RegisterA <= {~fieldLoad[30],fieldLoad[29:0]};
	//LD1,LD1N
	reg load1;
	always @(posedge clk)
		load1 <= (command==6'd9);
	reg load1N;
	always @(posedge clk)
		load1N <= (command==6'd17);
	always @(posedge clk)
		if (load1) RegisterI1 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load1N) RegisterI1 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LD2
	reg load2;
	always @(posedge clk)
		load2 <= (command==6'd10);
	reg load2N;
	always @(posedge clk)
		load2N <= (command==6'd18);
	always @(posedge clk)
		if (load2) RegisterI2 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load2N) RegisterI2 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LD3
	reg load3;
	always @(posedge clk)
		load3 <= (command==6'd11);
	reg load3N;
	always @(posedge clk)
		load3N <= (command==6'd19);
	always @(posedge clk)
		if (load3) RegisterI3 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load3N) RegisterI3 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LD4
	reg load4;
	always @(posedge clk)
		load4 <= (command==6'd12);
	reg load4N;
	always @(posedge clk)
		load4N <= (command==6'd20);
	always @(posedge clk)
		if (load4) RegisterI4 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load4N) RegisterI4 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LD5
	reg load5;
	always @(posedge clk)
		load5 <= (command==6'd13);
	reg load5N;
	always @(posedge clk)
		load5N <= (command==6'd21);
	always @(posedge clk)
		if (load5) RegisterI5 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load5N) RegisterI5 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LD6
	reg load6;
	always @(posedge clk)
		load6 <= (command==6'd14);
	reg load6N;
	always @(posedge clk)
		load6N <= (command==6'd22);
	always @(posedge clk)
		if (load6) RegisterI6 <= {fieldLoad[30],fieldLoad[11:0]};
		else if (load6N) RegisterI6 <= {~fieldLoad[30],fieldLoad[11:0]};
	//LDX
	reg loadX;
	always @(posedge clk)
		loadX <= (command==6'd15);
	reg loadXN;
	always @(posedge clk)
		loadXN <= (command==6'd23);
	always @(posedge clk)
		if (loadX) RegisterX <= fieldLoad;
		else if (loadXN) RegisterX <= {~fieldLoad[30],fieldLoad[29:0]};

	//ST
	reg store;
	always @(posedge clk)
		store <=  (command[5:3]==3'b011)|(command==6'd32)|(command==6'd33);
	reg [30:0] dataS;
	always @(posedge clk)
		if (command==6'd32) dataS <= {19'd0,RegisterJ};
		else if (command == 6'd33) dataS <=31'd0;
		else if ((command[5:3] == 3'b011))
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
	reg [11:0] addressStore;
	always @(posedge clk)
		addressStore <= address;	
	wire [30:0] fieldStore;
	fieldS FIELDS(.data(data),.in(dataS),.field(f),.out(fieldStore));
	always @(posedge clk)
		if (store) memory[addressStore] <= fieldStore;

	
endmodule
