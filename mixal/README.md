## Running programs on MIX

### tools
To run MIXAL programs on MIX the following tools found in `tools` are needed:

* `asm.py`: translates the mixal program into numeric representation (.mls).

* `mls2card.py` : translate the machine code (.mls) to punchcard format. The first two cards beeing the loading routine (1.3.1.ex26) and the last card beeing the transfer card.

* `mls2char.py` : translate to character codes, which can directly be read by MIX. (This is only necessary for the card-loading routine written on the first two punch cards).

* `mls2bin.py`: translate the .mls file to binary. This is only necessary for the GO button, which is hardcoded into fpga ROM.

### V1: Upload and run in a screen session
Finally you can connect your PC to MIX with a USB cable and start the  terminal emulator (```screen```):

```
$ screen /dev/ttyUSB0 115200
```

Press the GO button to start MIX. You should see the MIX welcome message:

```
WELCOME TO MIX. 1U = 40NS. U16-U20 TO UART @115200 BAUD (8N1).        
```

If `screen` does not open the terminal try with `sudo screen`. This might happen, when the user is not allowed to acces the device `/dev/ttyUSB0`. Check the user setting of `/dev/ttyUSB0` and add the user to the dialout group `sudo usermod -a -G $USER dialout`.

Within  the screen session you can upload the mixal programs written on punch cards:

```
<ctrl-a> : readreg p p.card
<ctrl-a> : paste p
```



### V2: Upload and run using the Makefile
As an alterntive to `screen` you can send jobs to MIX using a `Makefile`. Every tested program comes in a subfolder with a corresponding \lstinline|Makefile|, which can be used to compile, upload, and run the program on MIX.

* Connect MIX to USB
* Press the GO button
* run the Makefile
* the output is stored in a .out file

```
$ make clean
$ make
```

## Example program 1.3.2P
We will run programm P of chapter 1.3.2 TAOCP (p. 148) on MIX. Programm P computes the first 500 primes and outputs them in a table on the line printer U19.


### p.mixal
The mixal program can be found in `mixal/1.3.2P/p.mixal`. Inpect the file with:

```
$ cd mixal/1.3.2P
$ cat p.mixal
```

```
* EXAMPLE PROGRAM ... TABLE OF PRIMES                                           
*                                                                               
L          EQU  500                                                             
PRINTER    EQU  18                                                              
PRIME      EQU  -1                                                              
BUF0       EQU  2000                                                            
BUF1       EQU  BUF0+25                                                         
           ORIG 3000                                                            
START      IOC  0(PRINTER)                                                      
           LD1  =1-L=                                                           
           LD2  =3=                                                             
2H         INC1 1                                                               
           ST2  PRIME+L,1                                                       
           J1Z  2F                                                              
4H         INC2 2                                                               
           ENT3 2                                                               
6H         ENTA 0                                                               
           ENTX 0,2                                                             
           DIV  PRIME,3                                                         
           JXZ  4B                                                              
           CMPA PRIME,3                                                         
           INC3 1                                                               
           JG   6B                                                              
           JMP  2B                                                              
2H         OUT  TITLE(PRINTER)                                                  
           ENT4 BUF1+10                                                         
           ENT5 -50                                                             
2H         INC5 L+1                                                             
4H         LDA  PRIME,5                                                         
           CHAR                                                                 
           STX  0,4(1:4)                                                        
           DEC4 1                                                               
           DEC5 50                                                              
           J5P  4B                                                              
           OUT  0,4(PRINTER)                                                    
           LD4  24,4                                                            
           J5N  2B                                                              
           HLT                                                                  
* INITIAL CONTENTS OF TABLES AND BUFFERS                                        
           ORIG PRIME+1                                                         
           CON  2                                                               
           ORIG BUF0-5                                                          
TITLE      ALF  FIRST                                                           
           ALF   FIVE                                                           
           ALF   HUND                                                           
           ALF  RED P                                                           
           ALF  RIMES                                                           
           ORIG BUF0+24                                                         
           CON  BUF1+10                                                         
           ORIG BUF1+24                                                         
           CON  BUF0+10                                                         
           END  START                                                           
```

### p.mls
First we translate the mixal programm to binary code. This is done with the translator ```tools/asm.py```

```
$ ../tools/asm.py p.mixal
$ cat p.mls
```

```
                     0001 * EXAMPLE PROGRAM ... TABLE OF PRIMES
                     0002 *
                     0003 L          EQU  500 
                     0004 PRINTER    EQU  18 
                     0005 PRIME      EQU  -1 
                     0006 BUF0       EQU  2000 
                     0007 BUF1       EQU  BUF0+25 
                     0008            ORIG 3000 
3000 + 0000 00 18 35 0009 START      IOC  0(PRINTER) 
3001 + 2050 00 05 09 0010            LD1  =1-L= 
3002 + 2051 00 05 10 0011            LD2  =3= 
3003 + 0001 00 00 49 0012 2H@0012    INC1 1 
3004 + 0499 01 05 26 0013            ST2  PRIME+L,1 
3005 + 3016 00 01 41 0014            J1Z  2F 
3006 + 0002 00 00 50 0015 4H@0015    INC2 2 
3007 + 0002 00 02 51 0016            ENT3 2 
3008 + 0000 00 02 48 0017 6H@0017    ENTA 0 
3009 + 0000 02 02 55 0018            ENTX 0,2 
3010 - 0001 03 05 04 0019            DIV  PRIME,3 
3011 + 3006 00 01 47 0020            JXZ  4B 
3012 - 0001 03 05 56 0021            CMPA PRIME,3 
3013 + 0001 00 00 51 0022            INC3 1 
3014 + 3008 00 06 39 0023            JG   6B 
3015 + 3003 00 00 39 0024            JMP  2B 
3016 + 1995 00 18 37 0025 2H@0025    OUT  TITLE(PRINTER) 
3017 + 2035 00 02 52 0026            ENT4 BUF1+10 
3018 - 0050 00 02 53 0027            ENT5 -50 
3019 + 0501 00 00 53 0028 2H@0028    INC5 L+1 
3020 - 0001 05 05 08 0029 4H@0029    LDA  PRIME,5 
3021 + 0000 00 01 05 0030            CHAR  
3022 + 0000 04 12 31 0031            STX  0,4(1:4) 
3023 + 0001 00 01 52 0032            DEC4 1 
3024 + 0050 00 01 53 0033            DEC5 50 
3025 + 3020 00 02 45 0034            J5P  4B 
3026 + 0000 04 18 37 0035            OUT  0,4(PRINTER) 
3027 + 0024 04 05 12 0036            LD4  24,4 
3028 + 3019 00 00 45 0037            J5N  2B 
3029 + 0000 00 02 05 0038            HLT   
                     0039 * INITIAL CONTENTS OF TABLES AND BUFFERS
                     0040            ORIG PRIME+1 
0000 + 0000 00 00 02 0041            CON  2 
                     0042            ORIG BUF0-5 
1995 + 0393 19 22 23 0043 TITLE      ALF  FIRST
1996 + 0006 09 25 05 0044            ALF   FIVE
1997 + 0008 24 15 04 0045            ALF   HUND
1998 + 1221 04 00 17 0046            ALF  RED P
1999 + 1225 14 05 22 0047            ALF  RIMES
                     0048            ORIG BUF0+24 
2024 + 0000 00 31 51 0049            CON  BUF1+10 
                     0050            ORIG BUF1+24 
2049 + 0000 00 31 26 0051            CON  BUF0+10 
2050 - 0000 00 07 51      =1-L       CON  499
2051 + 0000 00 00 03      =3         CON  3
                     0052            END  START 
                                     TRANS 3000
                          * SYMBOL TABLE
                          *          EQU  2050
                          L          EQU  500
                          PRINTER    EQU  18
                          PRIME      EQU  -1
                          BUF0       EQU  2000
                          BUF1       EQU  2025
                          START      EQU  3000
                          2H@0012    EQU  3003
                          4H@0015    EQU  3006
                          6H@0017    EQU  3008
                          2H@0025    EQU  3016
                          2H@0028    EQU  3019
                          4H@0029    EQU  3020
                          TITLE      EQU  1995
                          =1-L       EQU  2050
                          =3         EQU  2051
```

### p.card

Next we must write the binary code onto punchcards. This can be done with the python script `tools/mls2card.py`. The python scripts reads the listing file `p.mls`, extracts the numeric codes and writes them in the file `p.card` in punched card format.

```
$ ../tools/mls2card.py p.mls 
$ cat p.card
```

Every line holds 80 chars of a punched card. The first two cards contain the bootloader discussed in exercise 26 in chapter 1.3.1 of TAOCP (see p. 510). The last card is the so called transfer card, which tells the bootloader to start execution at memory location 3000.

```
 O O6 Z O6    I C O4 0 EH A  F F CF 0  E   EU 0 IH G BB   EJ  CA. Z EU   EH E BA
   EU 2A-H S BB  C U 1AEH 2AEN V  E  ABG  CLU Z EH E BB J B. A  9               
     730000000001187053739552905376576740000262193013081429807906264090000524338
     73007000052446700000001760000008375000027475O0788004975000027480Q0000262195
     730140788529575078721847105229784690533463220001310738J0131334197000028295K
     730210000000069000001718300002622600013107317079167505300000175730006308172
     230280791412781000000013300000000000000000000000000000000000000000000000000
     100000000000002000000000000000000000000000000000000000000000000000000000000
     519950103101847000161133300021964200320094225032118408600000000000000000000
     120240000002035000000000000000000000000000000000000000000000000000000000000
     320490000002010000000049R00000000030000000000000000000000000000000000000000
TRANS030000000000000000000000000000000000000000000000000000000000000000000000000
```

### go!
Power MIX with USB cable connected to your computer.

Start a screen session with 115200 baud (8N1)
```
$ screen /dev/ttyUSB0 115200
```

Press the "Go button" on MIX

You should see the welcome message on your terminal:

```
WELCOME TO MIX. 1U = 30NS. U19 @115200 BAUD (8N1).                    
```

### Input the cards to U16
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
     3000 0233 0547 0877 1229 1597 1993 2371 2749 3187                                                                  
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
#### Using the Makefile
With the included Makefile the above described steps can be done in one pass:

* Connect MIX to USB
* Press the GO button
* run the Makefile: ```$ make```
* the output is stored in a `p.out` file
