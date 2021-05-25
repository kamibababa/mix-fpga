## Testing U8 on MIX
We will test U8 on MIX. The SRAM chip on the iCE40HX8K-EVB board is used as an external memory accesible as unit U8. Its 512kByte translate to 1000 blocks a 100 words (31 bits). The memory is not persistent. It holds data for the time the board is connected to power supply (over USB) even after pressing the go button (reset)

### write data to disk U8
#### w.mixal
First we will write 3996 randomly filled punched cards into memory (3996 punched cards is the equivalent of 666 data blocks of U8). The mixal program can be found in `w.mixal`:

Inpect the file with:
```
cat w.mixal
```

```
BUFFER	EQU		2000
		ORIG	1000
BEGIN	ENTX		
WRITE	IN		BUFFER(16)
		IN		BUFFER+16(16)
		IN		BUFFER+32(16)
		IN		BUFFER+48(16)
		IN		BUFFER+64(16)
		IN		BUFFER+80(16)
		JBUS	*(16)
		OUT		BUFFER(8)
		INCX	1
		CMPX	MAX
		JL		WRITE
		HLT	
MAX		CON		666
		END		BEGIN
```

#### w.mls
First we translate the mixal programm to binary code. This is done with the GNU library `mixasm`. The option `-l` produces a list file `w.mls`

```
mixasm w.mixal -l
cat w.mls
```
```
*** w.mixal: Kompilerzusammenfassung ***

-----------------------------------------------------------------
Src     Address  Compiled word           Symbolic rep
-----------------------------------------------------------------
004     01000   + 00 00 00 02 55 	ENTX	0,0
005     01001   + 31 16 00 16 36 	IN	2000,0(2:0)
006     01002   + 31 32 00 16 36 	IN	2016,0(2:0)
007     01003   + 31 48 00 16 36 	IN	2032,0(2:0)
008     01004   + 32 00 00 16 36 	IN	2048,0(2:0)
009     01005   + 32 16 00 16 36 	IN	2064,0(2:0)
010     01006   + 32 32 00 16 36 	IN	2080,0(2:0)
011     01007   + 15 47 00 16 34 	JBUS	1007,0(2:0)
012     01008   + 31 16 00 08 37 	OUT	2000,0(1:0)
013     01009   + 00 01 00 00 55 	INCX	1,0
014     01010   + 15 53 00 05 63 	CMPX	1013,0
015     01011   + 15 41 00 04 39 	JL	1001,0
016     01012   + 00 00 00 02 05 	HLT	0,0
017     01013   + 00 00 00 10 26 	CON	0666
-----------------------------------------------------------------

*** Startadresse:	1000
*** Endadresse:	1014

*** Symboltabelle
BEGIN               :  1000
MAX                 :  1013
BUFFER              :  2000
WRITE               :  1001

*** Ende der Zusammenfassung ***
```
#### w.card
Next we must write the binary code onto punchcards. This can be done with the python script `tools/mls2card.py`.

```
../../tools/mls2card.py w.mls
```

The python scripts reads the listing file `w.mls`, extracts the code and writes it in the file `w.card`.

Inspect the punchcards

```
cat w.card
```
Every line holds 80 chars of a card. The first to cards contain the bootloader discussed in exercise 26 in chapter 1.3.1 of TAOCP (see p. 510). The last cards is the so called transfer card, which tells the bootloader to start execution at memory location 1000.

```
 O O6 Z O6    I C O4 0 EH A  F F CF 0  E   EU 0 IH G BB   EJ  CA. Z EU   EH E BA
   EU 2A-H S BB  C U 1AEH 2AEN V  E  ABG  CLU Z EH E BB J B. A  9               
00002710000000000183052428906005284833640532677668053687197205410662760545260580
00000710070263980066052428854900002621990265552255026240643900000001330000000666
TRANS010000000000000000000000000000000000000000000000000000000000000000000000000
```
#### random punched cards
Now we build 3996 random punched cards and add them as input to the program cards.

```
./randcard.py
cat w.card rand.card > wr.card
```

#### go
Power MIX with USB cable connected to your computer.

Start a screen session with 115200 baud (8N1)
```
screen /dev/ttyUSB0 115200
```

Press the "Go button" on MIX

You should see the welcome message on your terminal:

```
WELCOME TO MIX. 1U = 30NS. U19 @115200 BAUD (8N1).                    
```

#### input the cards to U16
You can send the punch cards to MIX within the screen terminal session.

1. Read cards into a screen-buffer (called p) 
	```
	<in screen terminal> Ctr-a : readreg w wr.card <enter>
	```

2. Send buffer to MIX
	```
	<in screen terminal> Ctrl-a : paste w <enter>
	```

This will take a while!


### read the cards from disk U8

Now we will try to retrieve the data.
#### r.mixal
`r.mixal` will read the disk U8 and output the data to USB-serial.

Inpect the file with:
```
cat r.mixal
```

```
BUFFER	EQU	2000
	ORIG	1000
BEGIN 	ENTX 	0
READ	IN	BUFFER(8)
	OUT	BUFFER(17)
	OUT	BUFFER+16(17)
	OUT	BUFFER+32(17)
	OUT	BUFFER+48(17)
	OUT	BUFFER+64(17)
	OUT	BUFFER+80(17)
	JBUS	*(17)
	INCX	1
	CMPX	MAX
	JL	READ
	HLT
MAX	CON	666
	END	BEGIN

```

#### r.mls
First we translate the mixal programm to binary code. This is done with the GNU library `mixasm`. The option `-l` produces a list file `w.mls`

```
mixasm r.mixal -l
cat r.mls
```
```
*** r.mixal: Kompilerzusammenfassung ***

-----------------------------------------------------------------
Src     Address  Compiled word           Symbolic rep
-----------------------------------------------------------------
004     01000   + 00 00 00 02 55 	ENTX	0,0
005     01001   + 31 16 00 08 36 	IN	2000,0(1:0)
006     01002   + 31 16 00 17 37 	OUT	2000,0(2:1)
007     01003   + 31 32 00 17 37 	OUT	2016,0(2:1)
008     01004   + 31 48 00 17 37 	OUT	2032,0(2:1)
009     01005   + 32 00 00 17 37 	OUT	2048,0(2:1)
010     01006   + 32 16 00 17 37 	OUT	2064,0(2:1)
011     01007   + 32 32 00 17 37 	OUT	2080,0(2:1)
012     01008   + 15 48 00 17 34 	JBUS	1008,0(2:1)
013     01009   + 00 01 00 00 55 	INCX	1,0
014     01010   + 15 53 00 05 63 	CMPX	1013,0
015     01011   + 15 41 00 04 39 	JL	1001,0
016     01012   + 00 00 00 02 05 	HLT	0,0
017     01013   + 00 00 00 10 26 	CON	0666
-----------------------------------------------------------------

*** Startadresse:	1000
*** Endadresse:	1014

*** Symboltabelle
BEGIN               :  1000
MAX                 :  1013
BUFFER              :  2000
READ                :  1001

*** Ende der Zusammenfassung ***
```
#### r.card
Next we must write the binary code onto punchcards. This can be done with the python script `tools/mls2card.py`.

```
../../tools/mls2card.py < r.mls > r.card
```

The python scripts reads the listing file `w.mls`, extracts the code and writes it in the file `r.card`.

Inspect the punchcards

```
cat r.card
```
Every line holds 80 chars of a card. The first to cards contain the bootloader discussed in exercise 26 in chapter 1.3.1 of TAOCP (see p. 510). The last cards is the so called transfer card, which tells the bootloader to start execution at memory location 1000.

```
 O O6 Z O6    I C O4 0 EH A  F F CF 0  E   EU 0 IH G BB   EJ  CA. Z EU   EH E BA
   EU 2A-H S BB  C U 1AEH 2AEN V  E  ABG  CLU Z EH E BB J B. A  9               
00002710000000000183052428854805242891250528483429053267773305368720370541066341
00000710070545260645026424227400002621990265552255026240643900000001330000000666
TRANS010000000000000000000000000000000000000000000000000000000000000000000000000
```

#### go second time
Use the old screen session or start a new one.
```
screen /dev/ttyUSB0 115200
```

Press the "Go button" on MIX

You should see the welcome message on your terminal (again)

```
WELCOME TO MIX. 1U = 30NS. U19 @115200 BAUD (8N1).                    
```

#### input the r.card to U16
You can send the punch cards to MIX within the screen terminal session.

1. Read cards into a screen-buffer (called r) 
	```
	<in screen terminal> Ctr-a : readreg r r.card <enter>
	```

2. Send buffer to MIX
	```
	<in screen terminal> Ctrl-a : paste r <enter>
	```

This will take a while! But you should see the retreived random punched cards.

### check memory
To check memory you could retrieve the cards by piping them into a new file:

```
cat /dev/ttyUSB0 > mem.out
```

Then check with diff the integrity. Option -w ommites the whitespaces is good because, the terminal generates extra carriage returns (char13) which will be missed in the rand.card file. (At least on *ix computers). 
```
diff -w mem.out rand.card
```
will output
```
1d0
< WELCOME TO MIX. 1U = 40NS. U16-U20 UART @115200 BAUD. U8 1000 BLOCKS  
```
