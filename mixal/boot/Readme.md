## The bootloader
We will implement the bootloader proposed in  exercise 26 in chapter 1.3.1 of TAOCP (see p. 510).


### boot.mixal
The mixal program can be found in `boot.mixal`:

Inpect the file with:
```
cat boot.mixal
```

```
* BOOTLOADER - U19

BUFF		EQU		29			Buffer area is 0029-0041
			ORIG	0
LOC			IN		16(16)		Read in second card.
READ		IN		BUFF(16)	Read next card.
			LD1		0(0:0)		rI1 <- 0.
			JBUS	*(16)		Wait for read to finish.
			LDA		BUFF+1		rA <- columns 6-10.
N1			SLA		1
			SRAX	6			rAX <- colums 7-10.
N30			NUM		30
			STA		LOC			LOC <- starting location.
			LDA		BUFF+1(1:1)
			SUB		N30(0:2)
LOOP		LD3		LOC			rI3 <- LOC
			JAZ		0,3			Jump, if transfer card.
			STA		BUFF		BUFF <- count.
			LDA		LOC
			ADD		N1(0:2)
			STA		LOC			LOC <- LOC + 1,
			LDA		BUFF+3,1(5:5)
			SUB		N25(0:2)	rA(0) <- sign
			STA		0,3(0:0)	store sign
			LDA		BUFF+2,1	
			LDX		BUFF+3,1
N25			NUM		25			rA(1:4) <- magnitude.
			MOVE	0,1(2)		rI1 <- rI1 + 2
			STA		0,3(1:5)	Store value (inkl. sign)
			LDA		BUFF
			SUB		N1(0:2)		Decrease the count.
			JAP		LOOP		Repeat until count is zero.
			JMP		READ		Now read a new card.
			END		0
```

### boot.mls
First we translate the mixal programm to binary code. This is done with the GNU library `mixasm`. The option `-l` produces a list file `boot.mls`

```
mixasm p.mixal -l
cat p.mls
```
```
*** boot.mixal: Kompilerzusammenfassung ***

-----------------------------------------------------------------
Src     Address  Compiled word           Symbolic rep
-----------------------------------------------------------------
005     00000   + 00 16 00 16 36 	IN	16,0(2:0)
006     00001   + 00 29 00 16 36 	IN	29,0(2:0)
007     00002   + 00 00 00 00 09 	LD1	0,0(0:0)
008     00003   + 00 03 00 16 34 	JBUS	3,0(2:0)
009     00004   + 00 30 00 05 08 	LDA	30,0
010     00005   + 00 01 00 00 06 	SLA	1,0
011     00006   + 00 06 00 03 06 	SRAX	6,0
012     00007   + 00 30 00 00 05 	NUM	30,0
013     00008   + 00 00 00 05 24 	STA	0,0
014     00009   + 00 30 00 09 08 	LDA	30,0(1:1)
015     00010   + 00 07 00 02 02 	SUB	7,0(0:2)
016     00011   + 00 00 00 05 11 	LD3	0,0
017     00012   + 00 00 03 01 40 	JAZ	0,3
018     00013   + 00 29 00 05 24 	STA	29,0
019     00014   + 00 00 00 05 08 	LDA	0,0
020     00015   + 00 05 00 02 01 	ADD	5,0(0:2)
021     00016   + 00 00 00 05 24 	STA	0,0
022     00017   + 00 32 01 45 08 	LDA	32,1(5:5)
023     00018   + 00 22 00 02 02 	SUB	22,0(0:2)
024     00019   + 00 00 03 00 24 	STA	0,3(0:0)
025     00020   + 00 31 01 05 08 	LDA	31,1
026     00021   + 00 32 01 05 15 	LDX	32,1
027     00022   + 00 25 00 00 05 	NUM	25,0
028     00023   + 00 00 01 02 07 	MOVE	0,1(0:2)
029     00024   + 00 00 03 13 24 	STA	0,3(1:5)
030     00025   + 00 29 00 05 08 	LDA	29,0
031     00026   + 00 05 00 02 02 	SUB	5,0(0:2)
032     00027   + 00 11 00 02 40 	JAP	11,0
033     00028   + 00 01 00 00 39 	JMP	1,0
-----------------------------------------------------------------

*** Startadresse:	0
*** Endadresse:	29

*** Symboltabelle
BUFF                :  29
N30                 :  7
N25                 :  22
LOOP                :  11
N1                  :  5
LOC                 :  0
READ                :  1

*** Ende der Zusammenfassung ***
```

### boot.char

Next we must convert the binary code to the char codes of MIX. This can be done with the python script `tools/mls2char.py`.

```
../../tools/mls2char.py  boot.mls
```

The python scripts reads the listing file `boot.mls`, extracts the code and writes it in the file `boot.char`.

**Attention**: I'm using the german locales, so the python scripts looks for the String "*** Startaddresse: 0" in `boot.mls`. Please adjust `mls2char.py` appropriate to your locales.

Inspect the punchcards

```
cat boot.char
```
The output contain the bootloader expressed as characters. These characters are stored in location starting at memory address 0 immediately after pressing the Go button. They have to be preponed to every upload of programms. We will store the chars in the script `mls2card.py` so that the script will automatically generate the bootloader as first two punchcards.

```
 O O6 Z O6    I C O4 0 EH A  F F CF 0  E   EU 0 IH G BB   EJ  CA. Z EU   EH E BA   EU 2A-H S BB  C U 1AEH 2AEN V  E  ABG  CLU Z EH E BB J B. A  9
```
