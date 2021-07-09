## Running program a on MIX
We will calculate the produkt of permutations according to TAOCP (p. 168) on MIX.

### a.mixal
The mixal program can be found in `perm.mixal`:

Inpect the file with:
```
$ cat a.mixal
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

### a.mls
First we translate the mixal programm to binary code. This is done with the GNU library `mixasm`. The option `-l` produces a list file `p.mls`

```
$ ../tools/asm.py perm.mixal
$ cat a.mls
```

```
                     0001 * multiply permutations in cycle form (taopc p. 168)
                     0002 *
                     0003 MAXWDS     EQU  1200 
                     0004 PERM       ORIG *+MAXWDS 
                     0005 ANS        ORIG *+MAXWDS 
                     0006 OUTBUF     ORIG *+24 
                     0007 CARDS      EQU  16 
                     0008 PRINTER    EQU  18 
2424 + 0000 00 16 36 0009 BEGIN      IN   PERM(CARDS) 
2425 + 0000 00 02 50 0010            ENT2 0 
2426 + 2477 00 05 08 0011            LDA  EQUALS 
2427 + 2427 00 16 34 0012 1H@0012    JBUS *(CARDS) 
2428 + 0015 02 05 56 0013            CMPA PERM+15,2 
2429 + 2431 00 05 39 0014            JE   *+2 
2430 + 0016 02 16 36 0015            IN   PERM+16,2(CARDS) 
2431 + 2400 00 02 49 0016            ENT1 OUTBUF 
2432 + 2432 00 18 34 0017            JBUS *(PRINTER) 
2433 + 0000 02 16 07 0018            MOVE PERM,2(16) 
2434 + 2400 00 18 37 0019            OUT  OUTBUF(PRINTER) 
2435 + 2440 00 05 39 0020            JE   1F 
2436 + 0016 00 00 50 0021            INC2 16 
2437 + 2501 00 05 58 0022            CMP2 =MAXWDS-16= 
2438 + 2427 00 09 39 0023            JLE  1B 
2439 + 0666 00 02 05 0024            HLT  666 
2440 + 0015 00 00 50 0025 1H@0025    INC2 15 
2441 + 2502 00 05 26 0026            ST2  SIZE 
2442 + 0000 00 02 51 0027            ENT3 0 
2443 + 0000 03 05 16 0028 2H@0028    LDAN PERM,3 
2444 + 2475 00 13 56 0029            CMPA LPREN(1:5) 
2445 + 2450 00 08 39 0030            JNE  1F 
2446 + 0000 03 05 24 0031            STA  PERM,3 
2447 + 0001 00 00 51 0032            INC3 1 
2448 + 0000 03 05 23 0033            LDXN PERM,3 
2449 + 2447 00 01 47 0034            JXZ  *-2 
2450 + 2476 00 13 56 0035 1H@0035    CMPA RPREN(1:5) 
2451 + 2453 00 08 39 0036            JNE  *+2 
2452 + 0000 03 05 31 0037            STX  PERM,3 
2453 + 0001 00 00 51 0038            INC3 1 
2454 + 2502 00 05 59 0039            CMP3 SIZE 
2455 + 2443 00 04 39 0040            JL   2B 
2456 + 2475 00 05 08 0041            LDA  LPREN 
2457 + 1200 00 02 49 0042            ENT1 ANS 
2458 + 0000 00 02 51 0043 OPEN       ENT3 0 
2459 + 0000 03 05 23 0044 1H@0044    LDXN PERM,3 
2460 + 2478 00 00 47 0045            JXN  GO 
2461 + 0001 00 00 51 0046            INC3 1 
2462 + 2502 00 05 59 0047            CMP3 SIZE 
2463 + 2459 00 04 39 0048            JL   1B 
                     0049 *
2464 + 2503 00 05 57 0050 DONE       CMP1 =ANS= 
2465 + 2467 00 08 39 0051            JNE  *+2 
2466 + 2475 00 02 07 0052            MOVE LPREN(2) 
2467 + 2504 00 01 07 0053            MOVE =0= 
2468 - 0001 01 22 07 0054            MOVE -1,1(22) 
2469 + 0000 00 02 51 0055            ENT3 0 
2470 + 1200 03 18 37 0056            OUT  ANS,3(PRINTER) 
2471 + 0024 00 00 51 0057            INC3 24 
2472 + 1200 03 05 15 0058            LDX  ANS,3 
2473 + 2470 00 04 47 0059            JXNZ *-3 
2474 + 0000 00 02 05 0060            HLT       
                     0061 *
2475 + 0000 00 00 42 0062 LPREN      ALF      (
2476 + 2752 00 00 00 0063 RPREN      ALF  )    
2477 + 0000 00 00 48 0064 EQUALS     ALF      =
                     0065 *
2478 + 2475 00 01 07 0066 GO         MOVE LPREN 
2479 + 0000 03 01 07 0067            MOVE PERM,3 
2480 + 2505 00 05 31 0068            STX  START 
2481 + 0000 03 05 31 0069 SUCC       STX  PERM,3 
2482 + 0001 00 00 51 0070            INC3 1 
2483 + 0000 03 13 23 0071            LDXN PERM,3(1:5) 
2484 + 2491 00 00 47 0072            JXN  1F 
2485 + 2482 00 00 39 0073            JMP  *-3 
2486 + 0000 01 05 31 0074 5H@0074    STX  0,1 
2487 + 0001 00 00 49 0075            INC1 1 
2488 + 0000 00 02 51 0076            ENT3 0 
2489 + 0000 03 13 63 0077 4H@0077    CMPX PERM,3(1:5) 
2490 + 2481 00 05 39 0078            JE   SUCC 
2491 + 0001 00 00 51 0079 1H@0079    INC3 1 
2492 + 2502 00 05 59 0080            CMP3 SIZE 
2493 + 2489 00 04 39 0081            JL   4B 
2494 + 2505 00 13 63 0082            CMPX START(1:5) 
2495 + 2486 00 08 39 0083            JNE  5B 
2496 + 2476 00 01 07 0084 CLOSE      MOVE RPREN 
2497 - 0003 01 05 56 0085            CMPA -3,1 
2498 + 2458 00 08 39 0086            JNE  OPEN 
2499 - 0003 00 00 49 0087            INC1 -3 
2500 + 2458 00 00 39 0088            JMP  OPEN 
2501 + 0000 00 18 32      =MAXWDS-16 CON  1184
2502 + 0000 00 00 00      SIZE       CON  0
2503 + 0000 00 18 48      =ANS       CON  1200
2504 + 0000 00 00 00      =0         CON  0
2505 + 0000 00 00 00      START      CON  0
                     0089            END  BEGIN 
                                     TRANS 2424
                          * SYMBOL TABLE
                          *          EQU  2501
                          MAXWDS     EQU  1200
                          PERM       EQU  0
                          ANS        EQU  1200
                          OUTBUF     EQU  2400
                          CARDS      EQU  16
                          PRINTER    EQU  18
                          BEGIN      EQU  2424
                          1H@0012    EQU  2427
                          1H@0025    EQU  2440
                          2H@0028    EQU  2443
                          1H@0035    EQU  2450
                          OPEN       EQU  2458
                          1H@0044    EQU  2459
                          DONE       EQU  2464
                          LPREN      EQU  2475
                          RPREN      EQU  2476
                          EQUALS     EQU  2477
                          GO         EQU  2478
                          SUCC       EQU  2481
                          5H@0074    EQU  2486
                          4H@0077    EQU  2489
                          1H@0079    EQU  2491
                          CLOSE      EQU  2496
                          =MAXWDS-16 EQU  2501
                          SIZE       EQU  2502
                          =ANS       EQU  2503
                          =0         EQU  2504
                          START      EQU  2505
```

### a.card

Next we must write the binary code onto punched cards. This can be done with the python script `tools/mls2card.py`.

```
$ ../tools/mls2card.py a.mls
```

The python scripts reads the listing file `perm.mls`, extracts the code and writes it in the file `perm.card`.

Inspect the punchcards

```
cat a.card
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
$ cat a.card a.in > a_in.card
$ cat a_in.card
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
$ screen /dev/ttyUSB0 115200
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
