## Running program p on MIX
We will run programm p of chapter 1.3.2 TAOCP (p. 148) on MIX. Programm p computes the first 500 primes and outputs them in a table on the line printer U19.


### p.mixal
The mixal program can be found in `p.mixal`:

Inpect the file with:
```
cat p.mixal
```

```
* EXAMPLE PROGRAM ... TABLE OF PRIMES
*
L		EQU		500		The number of primes to find
TERM	EQU		19		Unit number of the line printer
BUF0	EQU		2000	Memory area for BUFFER[0]
BUF1	EQU		BUF0+25	Memory area for BUFFER[1]
PRIME	EQU		BUF1+24
		ORIG	3000
START	IOC		0(TERM)	Skip to new page
		LD1		=1-L=
		LD2		=3=
2H		INC1	1
		ST2		PRIME+L,1
		J1Z		2F
4H		INC2	2
		ENT3	2
6H		ENTA	0
		ENTX	0,2
		DIV		PRIME,3
		JXZ		4B
		CMPA	PRIME,3
		INC3	1
		JG		6B
		JMP		2B
2H		OUT		TITLE(TERM)
		ENT4	BUF1+10
		ENT5	-50
2H		INC5	L+1
4H		LDA		PRIME,5
		CHAR
		STX		0,4(1:4)
		DEC4	1
		DEC5	50
		J5P		4B
		OUT		0,4(TERM)
		LD4		24,4
		J5N		2B
		HLT
* INITIAL CONTENTS OF TABLES AND BUFFERS
		ORIG	PRIME+1
		CON		2
		ORIG	BUF0-5
TITLE	ALF		"FIRST"
		ALF		" FIVE"
		ALF		" HUND"
		ALF		"RED P"
		ALF		"RIMES"
		ORIG	BUF0+24
		CON		BUF1+10
		ORIG	BUF1+24
		CON		BUF0+10
		END		START
```

### p.mls
First we translate the mixal programm to binary code. This is done with the GNU library `mixasm`. The option `-l` produces a list file `p.mls`

```
mixasm p.mixal -l
cat p.mls
```
```

*** p.mixal: Kompilerzusammenfassung ***

-----------------------------------------------------------------
Src     Address  Compiled word           Symbolic rep
-----------------------------------------------------------------
043     01995   + 06 09 19 22 23 	ALF	"FIRST"
044     01996   + 00 06 09 25 05 	ALF	" FIVE"
045     01997   + 00 08 24 15 04 	ALF	" HUND"
046     01998   + 19 05 04 00 17 	ALF	"RED P"
047     01999   + 19 09 14 05 22 	ALF	"RIMES"
049     02024   + 00 00 00 31 51 	CON	2035
051     02049   + 00 00 00 31 26 	CON	2010
000     02050   - 00 00 00 07 51 	CON	1073742323
000     02051   + 00 00 00 00 03 	CON	0003
009     03000   + 00 00 00 19 35 	CON	1251
010     03001   + 32 02 00 05 09 	CON	537395529
011     03002   + 32 03 00 05 10 	CON	537657674
012     03003   + 00 01 00 00 49 	CON	262193
013     03004   + 39 53 01 05 26 	CON	668209498
014     03005   + 47 08 00 01 41 	CON	790626409
015     03006   + 00 02 00 00 50 	CON	524338
016     03007   + 00 02 00 02 51 	CON	524467
017     03008   + 00 00 00 02 48 	CON	0176
018     03009   + 00 00 02 02 55 	CON	8375
019     03010   + 32 01 03 05 04 	CON	537145668
020     03011   + 46 62 00 01 47 	CON	788004975
021     03012   + 32 01 03 05 56 	CON	537145720
022     03013   + 00 01 00 00 51 	CON	262195
023     03014   + 47 00 00 06 39 	CON	788529575
024     03015   + 46 59 00 00 39 	CON	787218471
025     03016   + 31 11 00 19 37 	CON	522978533
026     03017   + 31 51 00 02 52 	CON	533463220
027     03018   - 00 50 00 02 53 	CON	1086849205
028     03019   + 07 53 00 00 53 	CON	131334197
029     03020   + 32 01 05 05 08 	CON	537153864
030     03021   + 00 00 00 01 05 	CON	0069
031     03022   + 00 00 04 12 31 	CON	17183
032     03023   + 00 01 00 01 52 	CON	262260
033     03024   + 00 50 00 01 53 	CON	13107317
034     03025   + 47 12 00 02 45 	CON	791675053
035     03026   + 00 00 04 19 37 	CON	17637
036     03027   + 00 24 04 05 12 	CON	6308172
037     03028   + 47 11 00 00 45 	CON	791412781
038     03029   + 00 00 00 02 05 	CON	0133
-----------------------------------------------------------------

*** Startadresse:	3000
*** Endadresse:	2050

*** Symboltabelle
START               :  3000
BUF0                :  2000
BUF1                :  2025
PRIME               :  2049
TITLE               :  1995
TERM                :  19
L                   :  500

*** Ende der Zusammenfassung ***

```

### p.card

Next we must write the binary code onto punchcards. This can be done with the python script `tools/mls2card.py`.

```
../../tools/mls2card.py p.mls 
```

The python scripts reads the listing file `p.mls`, extracts the code and writes it in the file `p.card`.

**Attention**: I'm using the german locales, so the python scripts looks for the String "*** Startaddresse: 3000" in `p.mls`. Please adjust `mls2card.py` appropriate to your locales.

Inspect the punchcards

```
cat p.card
```
Every line holds 80 chars of a card. The first to cards contain the bootloader discussed in exercise 26 in chapter 1.3.1 of TAOCP (see p. 510). The last cards is the so called transfer card, which tells the bootloader to start execution at memory location 3000.

```
 M R6 Y R6    I C R4 Z EH A  F F CF 0  E   EU Z IH G BB   EJ  CA. Y EU
   EH E BA   EU 1A-H S BB 0ALH 1ALN  ABG V  E  CEU Y EH E BB J B. A  9
0000251995010310184700016113330002196420032009422503211840860000000000
0000312024000000203500000000000000000000000000000000000000000000000000
00004320490000002010000000049R0000000003000000000000000000000000000000
0000563000000000125105373955290537657674000026219306682094980790626409
0000663006000052433800005244670000000176000000837505371456680788004975
0000763012053714572000002621950788529575078721847105229785330533463220
0000863018001310738J01313341970537153864000000006900000171830000262260
0000063024001310731707916750530000017637000630817207914127810000000133
TRANS03000000000000000000000000000000000000000000000000000000000000000
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

1. Read cards into a screen-buffer (called p) 
	```
	<in screen terminal> Ctr-a : readreg p p.card <enter>
	```

2. Send buffer to MIX
	```
	<in screen terminal> Ctrl-a : paste p <enter>
	```

After a few nanoseconds MIX spits out the following table to U19:

```
FIRST FIVE HUNDRED PRIMES                                                 
     0002 0233 0547 0877 1229 1597 1993 2371 2749 3187                    
     0003 0239 0557 0881 1231 1601 1997 2377 2753 3191                    
     0005 0241 0563 0883 1237 1607 1999 2381 2767 3203                    
     0007 0251 0569 0887 1249 1609 2003 2383 2777 3209                    
     0011 0257 0571 0907 1259 1613 2011 2389 2789 3217                    
     0013 0263 0577 0911 1277 1619 2017 2393 2791 3221                    
     0017 0269 0587 0919 1279 1621 2027 2399 2797 3229                    
     0019 0271 0593 0929 1283 1627 2029 2411 2801 3251                    
     0023 0277 0599 0937 1289 1637 2039 2417 2803 3253                    
     0029 0281 0601 0941 1291 1657 2053 2423 2819 3257                    
     0031 0283 0607 0947 1297 1663 2063 2437 2833 3259                    
     0037 0293 0613 0953 1301 1667 2069 2441 2837 3271                    
     0041 0307 0617 0967 1303 1669 2081 2447 2843 3299                    
     0043 0311 0619 0971 1307 1693 2083 2459 2851 3301                    
     0047 0313 0631 0977 1319 1697 2087 2467 2857 3307                    
     0053 0317 0641 0983 1321 1699 2089 2473 2861 3313                    
     0059 0331 0643 0991 1327 1709 2099 2477 2879 3319                    
     0061 0337 0647 0997 1361 1721 2111 2503 2887 3323                    
     0067 0347 0653 1009 1367 1723 2113 2521 2897 3329                    
     0071 0349 0659 1013 1373 1733 2129 2531 2903 3331                    
     0073 0353 0661 1019 1381 1741 2131 2539 2909 3343                    
     0079 0359 0673 1021 1399 1747 2137 2543 2917 3347                    
     0083 0367 0677 1031 1409 1753 2141 2549 2927 3359                    
     0089 0373 0683 1033 1423 1759 2143 2551 2939 3361                    
     0097 0379 0691 1039 1427 1777 2153 2557 2953 3371                    
     0101 0383 0701 1049 1429 1783 2161 2579 2957 3373                    
     0103 0389 0709 1051 1433 1787 2179 2591 2963 3389                    
     0107 0397 0719 1061 1439 1789 2203 2593 2969 3391                    
     0109 0401 0727 1063 1447 1801 2207 2609 2971 3407                    
     0113 0409 0733 1069 1451 1811 2213 2617 2999 3413                    
     0127 0419 0739 1087 1453 1823 2221 2621 3001 3433                    
     0131 0421 0743 1091 1459 1831 2237 2633 3011 3449                    
     0137 0431 0751 1093 1471 1847 2239 2647 3019 3457                    
     0139 0433 0757 1097 1481 1861 2243 2657 3023 3461                    
     0149 0439 0761 1103 1483 1867 2251 2659 3037 3463                    
     0151 0443 0769 1109 1487 1871 2267 2663 3041 3467                    
     0157 0449 0773 1117 1489 1873 2269 2671 3049 3469                    
     0163 0457 0787 1123 1493 1877 2273 2677 3061 3491                    
     0167 0461 0797 1129 1499 1879 2281 2683 3067 3499                    
     0173 0463 0809 1151 1511 1889 2287 2687 3079 3511                    
     0179 0467 0811 1153 1523 1901 2293 2689 3083 3517                    
     0181 0479 0821 1163 1531 1907 2297 2693 3089 3527                    
     0191 0487 0823 1171 1543 1913 2309 2699 3109 3529                    
     0193 0491 0827 1181 1549 1931 2311 2707 3119 3533                    
     0197 0499 0829 1187 1553 1933 2333 2711 3121 3539                    
     0199 0503 0839 1193 1559 1949 2339 2713 3137 3541                    
     0211 0509 0853 1201 1567 1951 2341 2719 3163 3547                    
     0223 0521 0857 1213 1571 1973 2347 2729 3167 3557                    
     0227 0523 0859 1217 1579 1979 2351 2731 3169 3559                    
     0229 0541 0863 1223 1583 1987 2357 2741 3181 3571                    
```
#### Congratulation
You have run your first program on a "real" MIX.