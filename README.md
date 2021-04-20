# iCE-MIX

Have you ever heard of Don Knuths (hypothetical) first polyunsaturated computer, the 1009? In this project we will build a binary version of the MIX-Computer as described in "The Art of Computer Programming, Vol. 1" by Donald E. Knuth on an fpga-board.

The implementation is called iCE-MIX because it uses the iCE40HX8K fpga from Lattice. We use the development board iCE40HX8K-EVB from the company Olimex. The whole project uses only FOSS free and open source hard- and software.

## Hardware details
iCE-MIX runs on iCE40HX8K-EVB clocked at 33MHz. The basic unit of time 1u corresponds to 30ns, so according to Knuth it's a relatively high priced machine.

iCE-MIX has a terminal connector routet to unit U19. The terminal connector speakts USB-UART @115200 baud and does transloation of Knuth's 6bit character bytes to ASCII in hardware. 

## Implemented commands

All commands are already implemented (s. list) with execution time corresponding to Knuth's specifications (except for DIV, which will be fixed in future revisions).

| OP  | Menmonic | Remarks |
| -   | -   | -  |
| 0   | NOP | ok |
| 1   | ADD | ok | 
| 2   | SUB | ok | 
| 3   | MUL | ok | 
| 4   | DIV | 13 cycles vs. 12 of original MIX | 
| 5(0)   | NUM | ok | 
| 5(1)   | CHAR | ok | 
| 5(2)  | HLT | ok | 
| 6   | SHIFT | ok | 
| 7   | MOVE | ok | 
| 8 - 23   | LD(N) | ok | 
| 24 - 33  | ST | ok | 
| 34(19)   | JBUS(19) | ok (only U19) | 
| 35(19)   | IOC(19) | ok (only U19) | 
| 36(19)   | IN(19) | ok (only U19) | 
| 37(19)   | OUT(19) | ok (only U19) | 
| 38(19)   | JRED(19) | ok (only U19) | 
| 39 - 47   | JMP | ok | 
| 48 - 55   | INC,DEC,ENT,ENN | ok | 
| 56 - 63  | CMP | ok | 

## Test

iCE-MIX has been tested to run the programm p, which computes the first 500 primes and outputs them on unit 19 (UART).

The program runs on fpga and outputs the result on the terminal connector (U19).

The following list has been recorded with `cat /dec/ttyACM0 > prime.out`

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


## How to prepare MIXAL-programms
To run mixal programms on iCE40 you first have to translate the mixal programm to a binary representation:
* cd into the folder mixal `cd mixal`
* compile the MIXAL-programms with `mixasm p.mixal -l`
* translate the list file to binary `./mls2bin.py < p.mls > p.bin`

Now the binary file must be preloaded into memory of iCE-MIX. We will compile the whole verilog project with the included rom file.

* copy binary to mix-folder `cp p.bin ../mix/rom.bin`
* now cd into the mix-folder `cd ../mix`
* run `apio build -v` to syntesize the MIX circuit with memory preloaded with binary file `rom.bin`. Notice the amount of resources used on iCE40:

```
Info: Device utilisation:
Info: 	         ICESTORM_LC:  7188/ 7680    93%
Info: 	        ICESTORM_RAM:    32/   32   100%
Info: 	               SB_IO:     2/  256     0%
Info: 	               SB_GB:     8/    8   100%
Info: 	        ICESTORM_PLL:     1/    2    50%
Info: 	         SB_WARMBOOT:     0/    1     0%
```
* run `apio upload` to upload bitstream file to fpga-board.

Now iCE40-fpga IS a MIX-computer with the programm stored in memory beginning at address 0.

Connect iCE40-fpga to UART and press reset. In your terminal programm you will see the output of MIX on in/out unit 19 (Terminal).
* `screen /dev/ttyACM0`

## Things to come...
* design a case (3D-Printer)
* add GO-button
* write bootloader, that reads programmcode from U19
