OBJS =  mix.v add12.v clk.v in.v mul.v fadd.v fmul.v fdiv.v shift.v val.v add.v cmp.v hlt.v jmpr.v num.v st.v dec.v ide.v ld.v tape.v char.v div.v inc.v out.v UartRX.v field.v index.v mov.v UartTX.v


TOOLPREFIX = /opt/oss-cad-suite/bin/

PNRFLAGS = --hx8k --package ct256 --pcf mix.pcf

all:	build upload run

sim:	soc_tb.vcd

build:	hardware.bin

soc_tb.vcd:	$(OBJS) go.bin
	$(TOOLPREFIX)iverilog -o soc_tb.out $(OBJS) soc_tb.v
	./soc_tb.out
	$(TOOLPREFIX)gtkwave soc_tb.vcd soc_tb.gtkw

hardware.bin:	$(OBJS) pll.v mix.pcf go.bin
	$(TOOLPREFIX)yosys -p "synth_ice40 -top mix -json hardware.json" $(OBJS) pll.v
	$(TOOLPREFIX)nextpnr-ice40 $(PNRFLAGS) --json hardware.json --asc hardware.asc
	$(TOOLPREFIX)icepack hardware.asc hardware.bin


upload:	hardware.bin
	$(TOOLPREFIX)iceprogduino -t 
	$(TOOLPREFIX)iceprogduino hardware.bin

run:	
	tio -m INLCRNL /dev/ttyUSB0

clean:
	rm -f *.asc hardware.bin *.json *.vcd *.out

.PHONY: all clean



