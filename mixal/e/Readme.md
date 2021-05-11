## Running program e on MIX
We will run programm e of exercise 14 in chapter 1.3.2 TAOCP (p. 148) on MIX. Programm e computes the easter dates from 1950 - 2000 and outputs them in a table on the line printer U19.


### e.mixal
The mixal program can be found in `e.mixal`:

Inpect the file with:
```
cat e.mixal
```

```
* DATE OF EASTER
    		JMP			BEGIN
			ORIG		1000
EASTER		STJ			EASTX
			STX 		Y
			ENTA	 	0
			DIV 		=19=
			STX 		GMINUS1(0:2)
			LDA 		Y
			MUL			=1//100+1=
			INCA		61
			STA			CPLUS60(1:2)
			MUL 		=3//4+1=
			STA			XPLUS57(1:2)
CPLUS60		ENTA		*
			MUL			=8//25+1=
GMINUS1		ENT2		*
			ENT1		1,2
			INC2		1,1
			INC2		0,2
			INC2		0,1
			INC2		0,2
			INC2		773,1
XPLUS57		INCA		-*,2
			SRAX		5
			DIV			=30=
			DECX		24
			JXN			4F
			DECX		1
			JXP			2F
			JXN			3F
			DEC1		11
			J1NP		2F
3H			INCX		1
2H			DECX		29
4H			STX			20MINUSN(0:2)
			LDA			Y
			MUL			=1//4+1=
			ADD			Y
			SUB			XPLUS57(1:2)
20MINUSN	ENN1		*
			INCA		67,1
			SRAX		5
			DIV			=7=
			SLAX		5
			DECA		-4,1
			JAN			1F
			DECA		31
			CHAR	
			LDA			MARCH
			JMP			2F
1H			CHAR	
			LDA			APRIL
2H			JBUS		*(18)
			STA			MONTH
			STX			DAY(1:2)
			LDA			Y
			CHAR	
			STX			YEAR
			OUT			ANS(18)
EASTX		JMP			*
MARCH		ALF			"MARCH"
APRIL		ALF			"APRIL"
ANS			ALF 	    "     "
DAY			ALF			"DD   "
MONTH		ALF			"MMMMM"
			ALF 	    ",    "
YEAR		ALF			"YYYYY"
			ORIG		*+20
BEGIN 		ENTX		1950
			ENT6		-50
			JMP			EASTER
			INC6		1
			ENTX		2000,6
			J6NP		EASTER+1
			HLT	
			END			BEGIN


```

### e.mls
First we translate the mixal programm to binary code. This is done with the GNU library `mixasm`. The option `-l` produces a list file `e.mls`

```
mixasm p.mixal -l
cat p.mls
```
```
*** e.mixal: Kompilerzusammenfassung ***

-----------------------------------------------------------------
Src     Address  Compiled word           Symbolic rep
-----------------------------------------------------------------
002     00000   + 16 61 00 00 39 	JMP	1085,0
004     01000   + 16 33 00 02 32 	STJ	1057,0
005     01001   + 17 11 00 05 31 	STX	1099,0
006     01002   + 00 00 00 02 48 	ENTA	0,0
007     01003   + 17 08 00 05 04 	DIV	1096,0
008     01004   + 15 53 00 02 31 	STX	1013,0(0:2)
009     01005   + 17 11 00 05 08 	LDA	1099,0
010     01006   + 17 09 00 05 03 	MUL	1097,0
011     01007   + 00 61 00 00 48 	INCA	61,0
012     01008   + 15 51 00 10 24 	STA	1011,0(1:2)
013     01009   + 17 10 00 05 03 	MUL	1098,0
014     01010   + 15 60 00 10 24 	STA	1020,0(1:2)
015     01011   + 15 51 00 02 48 	ENTA	1011,0
016     01012   + 17 04 00 05 03 	MUL	1092,0
017     01013   + 15 53 00 02 50 	ENT2	1013,0
018     01014   + 00 01 02 02 49 	ENT1	1,2
019     01015   + 00 01 01 00 50 	INC2	1,1
020     01016   + 00 00 02 00 50 	INC2	0,2
021     01017   + 00 00 01 00 50 	INC2	0,1
022     01018   + 00 00 02 00 50 	INC2	0,2
023     01019   + 12 05 01 00 50 	INC2	773,1
024     01020   - 15 60 02 00 48 	INCA	-1020,2
025     01021   + 00 05 00 03 06 	SRAX	5,0
026     01022   + 17 05 00 05 04 	DIV	1093,0
027     01023   + 00 24 00 01 55 	DECX	24,0
028     01024   + 16 08 00 00 47 	JXN	1032,0
029     01025   + 00 01 00 01 55 	DECX	1,0
030     01026   + 16 07 00 02 47 	JXP	1031,0
031     01027   + 16 06 00 00 47 	JXN	1030,0
032     01028   + 00 11 00 01 49 	DEC1	11,0
033     01029   + 16 07 00 05 41 	J1NP	1031,0
034     01030   + 00 01 00 00 55 	INCX	1,0
035     01031   + 00 29 00 01 55 	DECX	29,0
036     01032   + 16 13 00 02 31 	STX	1037,0(0:2)
037     01033   + 17 11 00 05 08 	LDA	1099,0
038     01034   + 17 06 00 05 03 	MUL	1094,0
039     01035   + 17 11 00 05 01 	ADD	1099,0
040     01036   + 15 60 00 10 02 	SUB	1020,0(1:2)
041     01037   + 16 13 00 03 49 	ENN1	1037,0
042     01038   + 01 03 01 00 48 	INCA	67,1
043     01039   + 00 05 00 03 06 	SRAX	5,0
044     01040   + 17 07 00 05 04 	DIV	1095,0
045     01041   + 00 05 00 02 06 	SLAX	5,0
046     01042   - 00 04 01 01 48 	DECA	-4,1
047     01043   + 16 24 00 00 40 	JAN	1048,0
048     01044   + 00 31 00 01 48 	DECA	31,0
049     01045   + 00 00 00 01 05 	CHAR	0,0
050     01046   + 16 34 00 05 08 	LDA	1058,0
051     01047   + 16 26 00 00 39 	JMP	1050,0
052     01048   + 00 00 00 01 05 	CHAR	0,0
053     01049   + 16 35 00 05 08 	LDA	1059,0
054     01050   + 16 26 00 18 34 	JBUS	1050,0(2:2)
055     01051   + 16 38 00 05 24 	STA	1062,0
056     01052   + 16 37 00 10 31 	STX	1061,0(1:2)
057     01053   + 17 11 00 05 08 	LDA	1099,0
058     01054   + 00 00 00 01 05 	CHAR	0,0
059     01055   + 16 40 00 05 31 	STX	1064,0
060     01056   + 16 36 00 18 37 	OUT	1060,0(2:2)
061     01057   + 16 33 00 00 39 	JMP	1057,0
062     01058   + 14 01 19 03 08 	ALF	"MARCH"
063     01059   + 01 17 19 09 13 	ALF	"APRIL"
064     01060   + 00 00 00 00 00 	ALF	"     "
065     01061   + 04 04 00 00 00 	ALF	"DD   "
066     01062   + 14 14 14 14 14 	ALF	"MMMMM"
067     01063   + 41 00 00 00 00 	ALF	",    "
068     01064   + 28 28 28 28 28 	ALF	"YYYYY"
070     01085   + 30 30 00 02 55 	ENTX	1950,0
071     01086   - 00 50 00 02 54 	ENT6	-50,0
072     01087   + 15 40 00 00 39 	JMP	1000,0
073     01088   + 00 01 00 00 54 	INC6	1,0
074     01089   + 31 16 06 02 55 	ENTX	2000,6
075     01090   + 15 41 00 05 46 	J6NP	1001,0
076     01091   + 00 00 00 02 05 	HLT	0,0
000     01092   + 20 30 46 05 08 	CON	343597384
000     01093   + 00 00 00 00 30 	CON	0030
000     01094   + 16 00 00 00 01 	CON	268435457
000     01095   + 00 00 00 00 07 	CON	0007
000     01096   + 00 00 00 00 19 	CON	0019
000     01097   + 00 40 61 28 11 	CON	10737419
000     01098   + 48 00 00 00 01 	CON	805306369
000     01099   + 00 00 00 00 00 	CON	0000
-----------------------------------------------------------------

*** Startadresse:	1085
*** Endadresse:	1092

*** Symboltabelle
MARCH               :  1058
20MINUSN            :  1037
Y                   :  1099
APRIL               :  1059
MONTH               :  1062
XPLUS57             :  1020
EASTER              :  1000
BEGIN               :  1085
GMINUS1             :  1013
EASTX               :  1057
ANS                 :  1060
CPLUS60             :  1011
YEAR                :  1064
DAY                 :  1061

*** Ende der Zusammenfassung ***
```

### e.card

Next we must write the binary code onto punchcards. This can be done with the python script `tools/mls2card.py`.

```
../../tools/mls2card.py < e.mls > e.card
```

The python scripts reads the listing file `e.mls`, extracts the code and writes it in the file `e.card`.

**Attention**: I'm using the german locales, so the python scripts looks for the String "*** Startaddresse: 1085" in `p.mls`. Please adjust `mls2card.py` appropriate to your locales.

Inspect the punchcards

```
cat e.card
```
Every line holds 80 chars of a card. The first to cards contain the bootloader discussed in exercise 26 in chapter 1.3.1 of TAOCP (see p. 510). The last cards is the so called transfer card, which tells the bootloader to start execution at memory location 1085.

```
 O O6 Z O6    I C O4 0 EH A  F F CF 0  E   EU 0 IH G BB   EJ  CA. Z EU   EH E BA
   EU 2A-H S BB  C U 1AEH 2AEN V  E  ABG  CLU Z EH E BB J B. A  9               
00002100000284426279000000000000000000000000000000000000000000000000000000000000
00003710000277086368028809660700000001760287310148026555203102880965840287572291
00004710070015990832026502824802878344350267387544026502776002862615710265552050
0000571014000027051300002662900000008242000000414600000082420202641458026739512 
00006710210001310918028652371600062915750270532655000026226302702706390270008367
00007710280002883697027027082500002621990007602295027184348702880965840286785859
00008710350288096577026738752202718435690017567792000131091802870480040001310854
0000971042000105278M027472695200081265760000000069027734868002752512390000000069
00010710490277610824027525238602783972720278135455028809658400000000690278921567
00011710560277873829027708624702352211920021312077000000000000681574400238609294
00012210630687865856047721858800000000000000000000000000000000000000000000000000
00013710850511180983001310738K02621440390000262198052431275902624065100000000133
00014710920343597384000000003002684354570000000007000000001900107374190805306369
00000110990000000000000000000000000000000000000000000000000000000000000000000000
TRANS010850000000000000000000000000000000000000000000000000000000000000000000000
```

### go
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

### input the cards to U16
You can send the punch cards to MIX within the screen terminal session.

1. Read cards into a screen-buffer (called e) 
	```
	<in screen terminal> Ctr-a : readreg e e.card <enter>
	```

2. Send buffer to MIX
	```
	<in screen terminal> Ctrl-a : paste e <enter>
	```

and MIX spits out the following table to U19:

```
     09   APRIL,    01950                                             
     25   MARCH,    01951                                             
     13   APRIL,    01952                                             
     05   APRIL,    01953                                             
     18   APRIL,    01954                                             
     10   APRIL,    01955                                             
     01   APRIL,    01956                                             
     21   APRIL,    01957                                             
     06   APRIL,    01958                                             
     29   MARCH,    01959                                             
     17   APRIL,    01960                                             
     02   APRIL,    01961                                             
     22   APRIL,    01962                                             
     14   APRIL,    01963                                             
     29   MARCH,    01964                                             
     18   APRIL,    01965                                             
     10   APRIL,    01966                                             
     26   MARCH,    01967                                             
     14   APRIL,    01968                                             
     06   APRIL,    01969                                             
     29   MARCH,    01970                                             
     11   APRIL,    01971                                             
     02   APRIL,    01972                                             
     22   APRIL,    01973                                             
     14   APRIL,    01974                                             
     30   MARCH,    01975                                             
     18   APRIL,    01976                                             
     10   APRIL,    01977                                             
     26   MARCH,    01978                                             
     15   APRIL,    01979                                             
     06   APRIL,    01980                                             
     19   APRIL,    01981                                             
     11   APRIL,    01982                                             
     03   APRIL,    01983                                             
     22   APRIL,    01984                                             
     07   APRIL,    01985                                             
     30   MARCH,    01986                                             
     19   APRIL,    01987                                             
     03   APRIL,    01988                                             
     26   MARCH,    01989                                             
     15   APRIL,    01990                                             
     31   MARCH,    01991                                             
     19   APRIL,    01992                                             
     11   APRIL,    01993                                             
     03   APRIL,    01994                                             
     16   APRIL,    01995                                             
     07   APRIL,    01996                                             
     30   MARCH,    01997                                             
     12   APRIL,    01998                                             
     04   APRIL,    01999                                             
     23   APRIL,    02000  
```
#### Congratulation
You have computed the easter dates on a "real" MIX.