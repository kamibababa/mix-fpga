## The Go button
We will implement the code needed by the go button proposed in  exercise 26 in chapter 1.3.1 of TAOCP (see p. 510).


### go.mixal
The mixal program can be found in `go.mixal`. It starts at location 4000 (which is implemented in fpga but not used by MIX). The programm spits out the welcome message. The JMP instruction at memory cell 4095 will jmp to location 0 and storing a +0000 in the J-Register, because beeing a binary version with 12 bit programmcounter the next execution address without the jmp instruction would equally yield 4095 + 1 = 0000.

Inpect the file with:
```
cat go.mixal
```

```
		ORIG 	4000
		JMP		START
TITLE	ALF		"WELCO"
		ALF		"ME TO"
		ALF		" MIX."
		ALF		" 1U ="
		ALF		" 30NS"
		ALF		". U19"
		ALF		" @115"
		ALF		"200 B"
		ALF		"AUD ("
		ALF		"8N1)."
		ALF		"     "
		ALF		"     "
		ALF		"     "
		ALF		"     "
		ORIG	4091
START	OUT 	TITLE(19)
WAIT1	JBUS	WAIT1(19)
NEXT	IN		0(16)
WAIT	JBUS	WAIT(16)
		JMP	0	
		END	START

```

### boot.mls
First we translate the mixal programm to binary code. This is done with the GNU library `mixasm`. The option `-l` produces a list file `boot.mls`

```
mixasm go.mixal -l
cat go.mls
```
```
*** go.mixal: Kompilerzusammenfassung ***

-----------------------------------------------------------------
Src     Address  Compiled word           Symbolic rep
-----------------------------------------------------------------
002     04000   + 63 59 00 00 39 	JMP	4091,0
003     04001   + 26 05 13 03 16 	ALF	"WELCO"
004     04002   + 14 05 00 23 16 	ALF	"ME TO"
005     04003   + 00 14 09 27 40 	ALF	" MIX."
006     04004   + 00 31 24 00 48 	ALF	" 1U ="
007     04005   + 00 33 30 15 22 	ALF	" 30NS"
008     04006   + 40 00 24 31 39 	ALF	". U19"
009     04007   + 00 52 31 31 35 	ALF	" @115"
010     04008   + 32 30 30 00 02 	ALF	"200 B"
011     04009   + 01 24 04 00 42 	ALF	"AUD ("
012     04010   + 38 15 31 43 40 	ALF	"8N1)."
013     04011   + 00 00 00 00 00 	ALF	"     "
014     04012   + 00 00 00 00 00 	ALF	"     "
015     04013   + 00 00 00 00 00 	ALF	"     "
016     04014   + 00 00 00 00 00 	ALF	"     "
018     04091   + 62 33 00 19 37 	OUT	4001,0(2:3)
019     04092   + 63 60 00 19 34 	JBUS	4092,0(2:3)
020     04093   + 00 00 00 16 36 	IN	0,0(2:0)
021     04094   + 63 62 00 16 34 	JBUS	4094,0(2:0)
022     04095   + 00 00 00 00 39 	JMP	0,0
-----------------------------------------------------------------

*** Startadresse:	4091
*** Endadresse:	0

*** Symboltabelle
NEXT                :  4093
WAIT1               :  4092
START               :  4091
WAIT                :  4094
TITLE               :  4001

*** Ende der Zusammenfassung ***
```

### go.bin

Next we must translate the binary code into a binary format readable by the fpga toolchain. This can be done with the python script `tools/mls2bin.py`.

```
../../tools/mls2bin.py < go.mls > go.bin
```

The python scripts reads the listing file `go.mls`, extracts the code and writes it in the file `go.bin`.

Inspect the binary file `go.bin`

```
cat go.bin
```
The output contain the program code expressed as binary numbers. These binary numbers can be flashed to the iCE40HX8K-EVB board, so it's stored permanently in the MIX computer. At every reset (press Go button) the code will be executed. The first 4000 zero lines translate to NOP instructions. At the end you find the sequence IN(16),JBUS,JMP...
```
0000000000000000000000000000000
0000000000000000000000000000000
0000000000000000000000000000000
...
...
0000000000000000000000000000000
0111110100001000000010011100101
0111111111100000000010011100010
0000000000000000000010000100100
0111111111110000000010000100010
0000000000000000000000000100111
```
### rebuild and flash to iCE40HX8K-EVB

* Copy the binary file into the directory `rtl`, where the fpga description files are.

	```
	cp go.bin ../../rtl/rom.bin
	```

* Rebuild the fpga project and upload. `apio clean` is needed, because otherwise the the preloaded memory will not be updated.
	```
	apio clean
	apio build -v
	apio upload
	```
	
	Tipp: change the welcome message to ensure the new rom file has been uploaded.
	