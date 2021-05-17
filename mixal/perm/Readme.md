## Running program perm on MIX
We will calculate the produkt of permutations according to TAOCP (p. 168) on MIX.

### perm.mixal
The mixal program can be found in `perm.mixal`:

Inpect the file with:
```
cat perm.mixal
```

```
* multiply permutations in cycle form (taopc p. 168)
*
MAXWDS  EQU       1200
PERM    ORIG      *+MAXWDS
ANS     ORIG      *+MAXWDS
OUTBUF  ORIG      *+24
CARDS   EQU       16
PRINTER EQU       18
BEGIN   IN        PERM(CARDS)
        ENT2      0
        LDA       EQUALS
1H      JBUS      *(CARDS)
        CMPA      PERM+15,2
        JE        *+2
        IN        PERM+16,2(CARDS)
        ENT1      OUTBUF
        JBUS      *(PRINTER)
        MOVE      PERM,2(16)
        OUT       OUTBUF(PRINTER)
        JE        1F
        INC2      16
        CMP2      =MAXWDS-16=
        JLE       1B
        HLT       666
1H      INC2      15
        ST2       SIZE
        ENT3      0
2H      LDAN      PERM,3
        CMPA      LPREN(1:5)
        JNE       1F
        STA       PERM,3
        INC3      1
        LDXN      PERM,3
        JXZ       *-2
1H      CMPA      RPREN(1:5)
        JNE       *+2
        STX       PERM,3
        INC3      1
        CMP3      SIZE
        JL        2B
        LDA       LPREN
        ENT1      ANS
OPEN    ENT3      0
1H      LDXN      PERM,3
        JXN       GO
        INC3      1
        CMP3      SIZE
        JL        1B
*
DONE    CMP1      =ANS=
        JNE       *+2
        MOVE      LPREN(2)
        MOVE      =0=
        MOVE      -1,1(22)
        ENT3      0
        OUT       ANS,3(PRINTER)
        INC3      24
        LDX       ANS,3
        JXNZ      *-3
        HLT
*
LPREN   ALF       "    ("
RPREN   ALF       ")    "
EQUALS  ALF       "    ="
*
GO      MOVE      LPREN
        MOVE      PERM,3
        STX       START
SUCC    STX       PERM,3
        INC3      1
        LDXN      PERM,3(1:5)
        JXN       1F
        JMP       *-3
5H      STX       0,1
        INC1      1
        ENT3      0
4H      CMPX      PERM,3(1:5)
        JE        SUCC
1H      INC3      1
        CMP3      SIZE
        JL        4B
        CMPX      START(1:5)
        JNE       5B
CLOSE   MOVE      RPREN
        CMPA      -3,1
        JNE       OPEN
        INC1      -3
        JMP       OPEN
        END       BEGIN
```

### perm.mls
First we translate the mixal programm to binary code. This is done with the GNU library `mixasm`. The option `-l` produces a list file `p.mls`

```
mixasm perm.mixal -l
cat perm.mls
```
```
*** perm.mixal: Kompilerzusammenfassung ***

-----------------------------------------------------------------
Src     Address  Compiled word           Symbolic rep
-----------------------------------------------------------------
009     02424   + 00 00 00 16 36 	IN	0,0(2:0)
010     02425   + 00 00 00 02 50 	ENT2	0,0
011     02426   + 38 45 00 05 08 	LDA	2477,0
012     02427   + 37 59 00 16 34 	JBUS	2427,0(2:0)
013     02428   + 00 15 02 05 56 	CMPA	15,2
014     02429   + 37 63 00 05 39 	JE	2431,0
015     02430   + 00 16 02 16 36 	IN	16,2(2:0)
016     02431   + 37 32 00 02 49 	ENT1	2400,0
017     02432   + 38 00 00 18 34 	JBUS	2432,0(2:2)
018     02433   + 00 00 02 16 07 	MOVE	0,2(2:0)
019     02434   + 37 32 00 18 37 	OUT	2400,0(2:2)
020     02435   + 38 08 00 05 39 	JE	2440,0
021     02436   + 00 16 00 00 50 	INC2	16,0
022     02437   + 39 05 00 05 58 	CMP2	2501,0
023     02438   + 37 59 00 09 39 	JLE	2427,0
024     02439   + 10 26 00 02 05 	HLT	666,0
025     02440   + 00 15 00 00 50 	INC2	15,0
026     02441   + 39 09 00 05 26 	ST2	2505,0
027     02442   + 00 00 00 02 51 	ENT3	0,0
028     02443   + 00 00 03 05 16 	LDAN	0,3
029     02444   + 38 43 00 13 56 	CMPA	2475,0(1:5)
030     02445   + 38 18 00 08 39 	JNE	2450,0
031     02446   + 00 00 03 05 24 	STA	0,3
032     02447   + 00 01 00 00 51 	INC3	1,0
033     02448   + 00 00 03 05 23 	LDXN	0,3
034     02449   + 38 15 00 01 47 	JXZ	2447,0
035     02450   + 38 44 00 13 56 	CMPA	2476,0(1:5)
036     02451   + 38 21 00 08 39 	JNE	2453,0
037     02452   + 00 00 03 05 31 	STX	0,3
038     02453   + 00 01 00 00 51 	INC3	1,0
039     02454   + 39 09 00 05 59 	CMP3	2505,0
040     02455   + 38 11 00 04 39 	JL	2443,0
041     02456   + 38 43 00 05 08 	LDA	2475,0
042     02457   + 18 48 00 02 49 	ENT1	1200,0
043     02458   + 00 00 00 02 51 	ENT3	0,0
044     02459   + 00 00 03 05 23 	LDXN	0,3
045     02460   + 38 46 00 00 47 	JXN	2478,0
046     02461   + 00 01 00 00 51 	INC3	1,0
047     02462   + 39 09 00 05 59 	CMP3	2505,0
048     02463   + 38 27 00 04 39 	JL	2459,0
050     02464   + 39 06 00 05 57 	CMP1	2502,0
051     02465   + 38 35 00 08 39 	JNE	2467,0
052     02466   + 38 43 00 02 07 	MOVE	2475,0(0:2)
053     02467   + 39 07 00 01 07 	MOVE	2503,0
054     02468   - 00 01 01 22 07 	MOVE	-1,1(2:6)
055     02469   + 00 00 00 02 51 	ENT3	0,0
056     02470   + 18 48 03 18 37 	OUT	1200,3(2:2)
057     02471   + 00 24 00 00 51 	INC3	24,0
058     02472   + 18 48 03 05 15 	LDX	1200,3
059     02473   + 38 38 00 04 47 	JXNZ	2470,0
060     02474   + 00 00 00 02 05 	HLT	0,0
062     02475   + 00 00 00 00 42 	ALF	"    ("
063     02476   + 43 00 00 00 00 	ALF	")    "
064     02477   + 00 00 00 00 48 	ALF	"    ="
066     02478   + 38 43 00 01 07 	MOVE	2475,0
067     02479   + 00 00 03 01 07 	MOVE	0,3
068     02480   + 39 08 00 05 31 	STX	2504,0
069     02481   + 00 00 03 05 31 	STX	0,3
070     02482   + 00 01 00 00 51 	INC3	1,0
071     02483   + 00 00 03 13 23 	LDXN	0,3(1:5)
072     02484   + 38 59 00 00 47 	JXN	2491,0
073     02485   + 38 50 00 00 39 	JMP	2482,0
074     02486   + 00 00 01 05 31 	STX	0,1
075     02487   + 00 01 00 00 49 	INC1	1,0
076     02488   + 00 00 00 02 51 	ENT3	0,0
077     02489   + 00 00 03 13 63 	CMPX	0,3(1:5)
078     02490   + 38 49 00 05 39 	JE	2481,0
079     02491   + 00 01 00 00 51 	INC3	1,0
080     02492   + 39 09 00 05 59 	CMP3	2505,0
081     02493   + 38 57 00 04 39 	JL	2489,0
082     02494   + 39 08 00 13 63 	CMPX	2504,0(1:5)
083     02495   + 38 54 00 08 39 	JNE	2486,0
084     02496   + 38 44 00 01 07 	MOVE	2476,0
085     02497   - 00 03 01 05 56 	CMPA	-3,1
086     02498   + 38 26 00 08 39 	JNE	2458,0
087     02499   - 00 03 00 00 49 	INC1	-3,0
088     02500   + 38 26 00 00 39 	JMP	2458,0
000     02501   + 00 00 00 18 32 	CON	1184
000     02502   + 00 00 00 18 48 	CON	1200
000     02503   + 00 00 00 00 00 	CON	0000
000     02504   + 00 00 00 00 00 	CON	0000
000     02505   + 00 00 00 00 00 	CON	0000
-----------------------------------------------------------------

*** Startadresse:	2424
*** Endadresse:	2501

*** Symboltabelle
SUCC                :  2481
SIZE                :  2505
PRINTER             :  18
DONE                :  2464
START               :  2504
CLOSE               :  2496
CARDS               :  16
EQUALS              :  2477
MAXWDS              :  1200
GO                  :  2478
PERM                :  0
BEGIN               :  2424
LPREN               :  2475
ANS                 :  1200
OUTBUF              :  2400
RPREN               :  2476
OPEN                :  2458

*** Ende der Zusammenfassung ***
```

### perm.card

Next we must write the binary code onto punched cards. This can be done with the python script `tools/mls2card.py`.

```
../../tools/mls2card.py < perm.mls > perm.card
```

The python scripts reads the listing file `perm.mls`, extracts the code and writes it in the file `perm.card`.

Inspect the punchcards

```
cat perm.card
```
Every line holds 80 chars of a card. The first to cards contain the bootloader discussed in exercise 26 in chapter 1.3.1 of TAOCP (see p. 510). The last cards is the so called transfer card, which tells the bootloader to start execution at memory location 2424.

```
 O O6 Z O6    I C O4 0 EH A  F F CF 0  E   EU 0 IH G BB   EJ  CA. Z EU   EH E BA
   EU 2A-H S BB  C U 1AEH 2AEN V  E  ABG  CLU Z EH E BB J B. A  9               
00002724240000001060000000017806493310160636224546000394072806372724230004203556
00003724310629145777063753539400000092230629146789063963171900041943540655622522
00004724380636224103017458803700039322100656671066000000017900000126240648807288
00005724450642253351000001263200002621950000012631064146647906490694320643039783
00006724520000012639000026219506566710990640418087064880672803145729770000000179
00007724590000012631064959287900002621950656671099064461239106558846650646709799
000087246606488065350656146503000026765N0000000179031458627700062915070314585423
00009724730647495983000000013300000000420721420288000000004806488064710000012359
00010724800656408927000001263900002621950000013143065300075106506414470000004447
00011724870000262193000000017900000131830650379623000026219506566710990652476711
0001272494065640947106516905350649068615000079090M0644350503000078648J0644349991
00000525010000001184000000120000000000000000000000000000000000000000000000000000
TRANS024240000000000000000000000000000000000000000000000000000000000000000000000
```

This are the punched cards for the program. Now we add the punched cards for the programm input (the permutations we want to multiply):
```
cat perm.card perm.in > permall.card
cat permall.card
```

The whole deck of punched cards reads:
* First two cards is bootloader
* 12 cards holding the program code
* the transfer card
* two cards holding the input data given to the program

```
 O O6 Z O6    I C O4 0 EH A  F F CF 0  E   EU 0 IH G BB   EJ  CA. Z EU   EH E BA
   EU 2A-H S BB  C U 1AEH 2AEN V  E  ABG  CLU Z EH E BB J B. A  9               
00002724240000001060000000017806493310160636224546000394072806372724230004203556
00003724310629145777063753539400000092230629146789063963171900041943540655622522
00004724380636224103017458803700039322100656671066000000017900000126240648807288
00005724450642253351000001263200002621950000012631064146647906490694320643039783
00006724520000012639000026219506566710990640418087064880672803145729770000000179
00007724590000012631064959287900002621950656671099064461239106558846650646709799
000087246606488065350656146503000026765N0000000179031458627700062915070314585423
00009724730647495983000000013300000000420721420288000000004806488064710000012359
00010724800656408927000001263900002621950000013143065300075106506414470000004447
00011724870000262193000000017900000131830650379623000026219506566710990652476711
0001272494065640947106516905350649068615000079090M0644350503000078648J0644349991
00000525010000001184000000120000000000000000000000000000000000000000000000000000
TRANS024240000000000000000000000000000000000000000000000000000000000000000000000
    (  A    C    F    G  )        (  B    C    D  )        (  A    E    D  )    
    (  F    A    D    E  )        (  B    g    F    a    E  )                  =
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
WELCOME TO MIX. 1U = 40NS. U19 @115200 BAUD (8N1).                    
```

### input the cards to U16
You can send the punch cards to MIX within the screen terminal session.

1. Read cards holdinginto a screen-buffer (called p) 
	```
	<in screen terminal> Ctr-a : readreg p perm_all.card <enter>
	```

2. Send buffer to MIX
	```
	<in screen terminal> Ctrl-a : paste p <enter>
	```

After a few nanoseconds MIX spits out the following table to U19:

```
    (  A    C    F    G  )        (  B    C    D  )        (  A    E    D  )                                            
    (  F    A    D    E  )        (  B    G    F    A    E  )                  =                                        
    (  A    D    G  )        (  C    E    B  )                                                                          

                 
```
