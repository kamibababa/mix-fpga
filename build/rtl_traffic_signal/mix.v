// MIX - 1009
// Don Knuths computer architecture described in "The Art of Computer Programming"

`default_nettype none
module mix(
	input wire clk_in,
	output wire tx,
	input wire rx,
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

	// reset and clock signals
	wire reset;
	wire clk;
	clk CLK(.in(clk_in),.reset(reset),.out(clk));

	// the go button
	reg go;
	always @(posedge clk)
		if (go) go <= 0;
		else if (reset) go <= 1;

	//fetch execute - cycle
	wire fetch;	// fetch instruction
	assign fetch = (fetch1 & ~outrequest) | fetch2;
	wire fetch1;	// ready for next fetch
	assign fetch1 = go | nop | add2 | sub2 | ld2 | st2 | mul2 | div2 | ide | cmp2 | jmp | jmpr |jmpbus|jbus1| ioc1 | in2 | out2 | mov2 | shift2 | char2|num2;
	reg fetch2;	// fetch after outrequest
	always @(posedge clk)
		if (reset) fetch2 <=0;
		else if (fetch1 & outrequest) fetch2 <= 1;
		else fetch2 <= 0;
	reg execute=0; 	// one clock after a fetch occurred
	always @(posedge clk)
		if (fetch) execute <= 1;
		else execute <= 0;
	

	// programm counter
	wire [11:0] p;	//next instruction
		assign p = (reset)? 0 : (jmpbus|jmprout|jmpout)? addressIndex[11:0] : (fetch2)? npc: pc+1;
	reg [11:0] pc;	//last instruction
	always @(posedge clk)
		if (fetch) pc <= p;
	reg [11:0] npc;	//remember instruction when outrequest
	always @(posedge clk)
		if (reset) npc <=0;
		else if (fetch1 & outrequest) npc <= p;

	// memory cells
	reg [30:0] memory[0:4095];
	parameter ROMFILE = "rom.bin";
	initial begin
		$readmemb(ROMFILE,memory);
	end
	reg [30:0] data;
	always @(posedge clk)
		data <= memory[address];
	wire [11:0] address;
	assign address = (fetch)? p: (outload? addressOut: (movload? movaddress: addressIndex[11:0]));
	always @(posedge clk)
		if (st2) memory[staddress] <= stout;
		else if (movstore) memory[RegisterI1[11:0]] <= data;
		else if (instore) memory[addressIn[11:0]] <= {1'd0,dataIn};
	
	//Register
	reg [30:0] RegisterA;
	always @(posedge clk)
		if (reset) RegisterA <= 31'd0;
		else if (ld2 & rA2) RegisterA <= ldout;
		else if (add2) RegisterA <= addout;
		else if (sub2) RegisterA <= subout;
		else if (mul2) RegisterA <= {mulsign,mulout[59:30]};
		else if (div2) RegisterA <= {divsign,divQ};
		else if (ide & rA) RegisterA <= ideout;
		else if (char2) RegisterA <= {RegisterA[30],charout[59:30]};
		else if (num2) RegisterA <= {RegisterA[30],numout};
		else if (shift2) RegisterA <= {RegisterA[30],shiftaout};
	reg [12:0] RegisterI1;
	always @(posedge clk)
		if (reset) RegisterI1 <= 13'd0;
		else if (ld2 & r12) RegisterI1 <= {ldout[30],ldout[11:0]};
		else if (ide & r1) RegisterI1 <= {ideout[30],ideout[11:0]};
		else if (movstore) RegisterI1 <= RegisterI1 + 1;
	reg [12:0] RegisterI2;
	always @(posedge clk)
		if (reset) RegisterI2 <= 13'd0;
		else if (ld2 & r22) RegisterI2 <= {ldout[30],ldout[11:0]};
		else if (ide & r2) RegisterI2 <= {ideout[30],ideout[11:0]};
	reg [12:0] RegisterI3;
	always @(posedge clk)
		if (reset) RegisterI3 <= 13'd0;
		else if (ld2 & r32) RegisterI3 <= {ldout[30],ldout[11:0]};
		else if (ide & r3) RegisterI3 <= {ideout[30],ideout[11:0]};
	reg [12:0] RegisterI4;
	always @(posedge clk)
		if (reset) RegisterI4 <= 13'd0;
		else if (ld2 & r42) RegisterI4 <= {ldout[30],ldout[11:0]};
		else if (ide & r4) RegisterI4 <= {ideout[30],ideout[11:0]};
	reg [12:0] RegisterI5;
	always @(posedge clk)
		if (reset) RegisterI5 <= 13'd0;
		else if (ld2 & r52) RegisterI5 <= {ldout[30],ldout[11:0]};
		else if (ide & r5) RegisterI5 <= {ideout[30],ideout[11:0]};
	reg [12:0] RegisterI6;
	always @(posedge clk)
		if (reset) RegisterI6 <= 13'd0;
		else if (ld2 & r62) RegisterI6 <= {ldout[30],ldout[11:0]};
		else if (ide & r6) RegisterI6 <= {ideout[30],ideout[11:0]};
	reg [30:0] RegisterX;
	always @(posedge clk)
		if (reset) RegisterX <= 31'd0;
		else if (ld2 & rX2) RegisterX <= ldout;
		else if (ide & rX) RegisterX <= ideout;
		else if (mul2) RegisterX <= {mulsign,mulout[29:0]};
		else if (div2) RegisterX <= {RegisterA[30],divR};
		else if (char2) RegisterX <= {RegisterX[30],charout[29:0]};
		else if (shift2) RegisterX <= {RegisterX[30],shiftxout};
	reg [11:0] RegisterJ;
	always @(posedge clk)
		if (reset) RegisterJ <= 12'd0;
		else if (jmprout) RegisterJ <= pc+1;
		else if (jmpout & ~saveJ) RegisterJ <= pc+1;
	wire rA;
	assign rA = (command[2:0] == 3'd0);
	reg rA2;
	always @(posedge clk)
		rA2 <= rA;
	wire r1;
	assign r1 = (command[2:0] == 3'd1);
	reg r12;
	always @(posedge clk)
		r12 <= r1;
	wire r2;
	assign r2 = (command[2:0] == 3'd2);
	reg r22;
	always @(posedge clk)
		r22 <= r2;
	wire r3;
	assign r3 = (command[2:0] == 3'd3);
	reg r32;
	always @(posedge clk)
		r32 <= r3;
	wire r4;
	assign r4 = (command[2:0] == 3'd4);
	reg r42;
	always @(posedge clk)
		r42 <= r4;
	wire r5;
	assign r5 = (command[2:0] == 3'd5);
	reg r52;
	always @(posedge clk)
		r52 <= r5;
	wire r6;
	assign r6 = (command[2:0] == 3'd6);
	reg r62;
	always @(posedge clk)
		r62 <= r6;
	wire rX;
	assign rX = (command[2:0] == 3'd7);
	reg rX2;
	always @(posedge clk)
		rX2 <= rX;
	
	wire [30:0] rout;
	assign rout = command[2]?
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
						(RegisterA)));
	
	//flags
	reg overflow;
	reg less;
	reg equal;
	reg greater;
	always @(posedge clk)
		if (reset) overflow <= 0;
		else if (button) overflow <= 1;		//the traffic signal button controls the overflow toggle
		else if (add2) overflow <= addof;
		else if (sub2) overflow <= subof;
		else if (ide) overflow <= (rA|rX)? ideout[30] : ideout[12];
	always @(posedge clk)
		if (reset) less <= 0;
		else if (cmp2) less <= cmpl;
	always @(posedge clk)
		if (reset) greater <= 0;
		else if (cmp2) greater <= cmpg;
	always @(posedge clk)
		if (reset) equal <= 1;
		else if (cmp2) equal <= cmpe;

	//Command
	wire [5:0] command;
	assign command = (execute)? data[5:0]:6'd0;

	//field
	wire [5:0] field;
	assign field = data[11:6];
	
	//index
	wire [12:0] addressIndex;
	index INDEX(.in(data[30:18]),.out(addressIndex),.index(data[14:12]),.i1(RegisterI1),.i2(RegisterI2),.i3(RegisterI3),.i4(RegisterI4),.i5(RegisterI5),.i6(RegisterI6));

	//Value
	reg [5:0] field2;
	always @(posedge clk)
		field2 <= field;
	wire [30:0] value;
	val VAL(.in(data),.field(field2),.out(value));

	//command 0 - NOP
	wire nop;
	assign nop = (execute) & (command == 6'd0);
	
	//command 1 - ADD
	wire add1;
	assign add1 = (command == 6'd1);
	wire add2;
	wire [30:0] addout;
	wire addof;
	add ADD(.clk(clk),.start(add1),.stop(add2),.in1(RegisterA),.in2(value),.out(addout),.overflow(addof));	
	
	//command 2 - SUB
	wire sub1;
	assign sub1 = (command == 6'd2);
	wire sub2;
	wire [30:0] subout;
	wire subof;
	sub SUB(.clk(clk),.start(sub1),.stop(sub2),.in1(RegisterA),.in2(value),.out(subout),.overflow(subof));	
	
	//command 3 - MUL
	wire mul1;
	assign mul1 = (command == 6'd3);
	wire mul2;
	wire [59:0] mulout;
	wire mulsign;
	mul MUL(.clk(clk),.start(mul1),.stop(mul2),.in1(RegisterA),.in2(value),.out(mulout),.sign(mulsign));	
	
	//command 4 - DIV
	wire div1;
	assign div1 = (command == 6'd4);
	wire div2;
	wire [29:0] divQ;
	wire [29:0] divR;
	wire divof;
	wire divsign;
	div DIV(.clk(clk),.start(div1),.stop(div2),.divisor(value),.quotient(divQ),.dividend({RegisterA,RegisterX[29:0]}),.overflow(divof),.rest(divR),.sign(divsign));	

	//command 5(0) - NUM
	wire num1;
	assign num1 = (command == 6'd5) & (field == 6'd0);
	wire num2;
	wire [29:0] numout;
	num NUM(.clk(clk),.start(num1),.stop(num2),.in({RegisterA[29:0],RegisterX[29:0]}),.out(numout));
	
	//command 5(1) - CHAR
	wire char1;
	assign char1 = (command == 6'd5) & (field == 6'd1);
	wire char2;
	wire [59:0] charout;
	char CHAR(.clk(clk),.start(char1),.stop(char2),.in(RegisterA[29:0]),.out(charout));
	
	//command 5(2) - HLT
	wire hlt1;
	assign hlt1 = (command ==6'd5) & (field ==6'd2);
	hlt HLT(.clk(clk),.start(hlt1),.out(hlt));
	
	//command 6 - SHIFT
	wire shift1;
	assign shift1 = (command == 6'd6);
	wire shift2;
	wire [29:0] shiftaout;
	wire [29:0] shiftxout;
	shift SHIFT(.clk(clk),.start(shift1),.stop(shift2),.ina(RegisterA[29:0]),.inx(RegisterX[29:0]),.field(field),.m(addressIndex[11:0]),.outa(shiftaout),.outx(shiftxout));

	//command 7 - MOV
	wire mov1;
	assign mov1 = (command == 6'd7);
	wire mov2;
	wire movload;
	wire movstore;
	wire [11:0] movaddress;
	mov MOV(.clk(clk),.start(mov1),.stop(mov2),.len(field),.addressin(addressIndex[11:0]),.addressout(movaddress),.load(movload),.store(movstore));

	//command 8-24 - LD(N)
	wire ld1;
	wire ldn1;
	assign ld1 = (command[5:3] == 3'd1);
	assign ldn1 = (command[5:3] == 3'd2);
	wire ld2;
	wire [30:0] ldout;
	ld LD(.clk(clk),.start(ld1|ldn1),.stop(ld2),.field(field),.neg(ldn1),.in(data),.out(ldout));
	
	//command 24-33 - ST
	wire st1;
	assign st1 = (command[5:3] == 3'd3);
	wire stj1;
	assign stj1 = (command == 6'd32);
	wire stz1;
	assign stz1 = (command == 6'd33);
	wire st2;
	wire [30:0] stin;
	assign stin = (st1)?rout:(stj1? {19'd0,RegisterJ}: 31'd0);
	wire [30:0] stout;
	wire [11:0] staddress;
	st ST(.clk(clk),.addressin(addressIndex[11:0]),.addressout(staddress),.start(st1|stj1|stz1),.stop(st2),.data(data),.field(field),.in(stin),.out(stout));
	//command 34 -JBUS
	wire jbus1;
	assign jbus1 = (command[5:0]==6'd34);
	wire jmpbus;
	assign jmpbus = (jbus1 & busy);

	//command 35 - IOC
	wire ioc1;
	assign ioc1 = (command[5:0] ==6'd35);

	//command 36 - IN
	wire in1;
	assign in1 = (command[5:0] == 6'd36);
	wire in2;
	wire instore;
	assign instore = requestin&(~st2)&(~movstore);
	wire [29:0] dataIn;
	wire [11:0] addressIn;
	wire busy;
	wire busyin;
	assign busy = busyin|busyout;
	wire requestin;
	in IN(.field(field),.busy(busyin),.rx(rx),.clk(clk),.addressin(addressIndex[11:0]),.addressout(addressIn),.store(instore),.reset(reset),.start(in1),.stop(in2),.out(dataIn),.request(requestin));
	
	//command 37 - OUT
	wire out1;
	assign out1 = (command[5:0] == 6'd37);
	wire out2;
	wire outload;
	assign outload = (~movload & outrequest&~execute) | (outrequest & fetch1);
	reg outload2;
	always @(posedge clk)
		if (reset) outload2 <= 0;
		else if (outload) outload2 <= 1;
		else outload2 <= 0;
	wire outrequest;
	wire busyout;
	wire [11:0] addressOut;
	out OUT(.field(field),.busy(busyout),.tx(tx),.clk(clk),.addressin(addressIndex[11:0]),.addressout(addressOut),.request(outrequest),.load(outload2),.reset(reset),.start(out1),.in(data[29:0]),.stop(out2));
	
	//command 39 - JMP
	wire jmp;
	assign jmp = (command[5:0] == 6'd39);
	wire clearof;
	assign clearof = jmp & (field==6'd2 | field==6'd3);
	wire saveJ;
	assign saveJ = (field==6'd1);
	wire jmpout;
	assign jmpout = (jmp)? (field[3]?
					(field[2]?
						(field[1]?
							(field[0]?
								(1'd0):
								(1'd0)):
							(field[0]?
								(1'd0):
								(1'd0))):
						(field[1]?
							(field[0]?
								(1'd0):
								(1'd0)):
							(field[0]?
								(~greater):
								(~equal)))):
					(field[2]?
						(field[1]?
							(field[0]?
								(~less):
								(greater)):
							(field[0]?
								(equal):
								(less))):
						(field[1]?
							(field[0]?
								(~overflow):
								(overflow)):
							(field[0]?
								(1'd1):
								(1'd1)))))
								:1'd0;
	
	//command 40-47 - JMPr
	wire jmpr;
	assign jmpr = (command[5:3] == 3'd5);
	wire jmprout;
	jmpr JMPR(.sel(jmpr),.in(rout),.field(field[2:0]),.out(jmprout));

	//command 48-55 - INC,DEC,ENT,ENN
	wire ide;
	assign ide = (command[5:3] == 3'd6);
	wire [30:0] ideout;
	wire ideof;
	ide IDE(.in(rout),.m(addressIndex),.out(ideout),.overflow(ideof),.field(field[1:0]));
	
	//command 56-63 - CMP
	wire cmp1;
	assign cmp1 = (command[5:3] == 3'd7);
	wire cmp2;
	wire cmpl;
	wire cmpe;
	wire cmpg;
	cmp CMP(.clk(clk),.start(cmp1),.stop(cmp2),.in1(rout),.in2(value),.equal(cmpe),.less(cmpl),.greater(cmpg));	
	
endmodule
