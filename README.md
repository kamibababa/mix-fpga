# MIX-fpga

Have you ever heard of Don Knuths (hypothetical) first polyunsaturated computer MIX, the 1009? In this project we will build a binary version of the MIX-Computer as described in "The Art of Computer Programming, Vol. 1" by Donald E. Knuth running on an fpga-board.

![](pics/taocp.jpg)


The presented implementation is based on the fpga development board iCE40HX8K-EVB from the company Olimex Ltd., which has the nice property of being completely open source. The whole project uses only FOSS free and open source hard- and software, so everybody can build their own MIX following the instructions in `build`

![](pics/MIX_real.jpg)


## Inside

The MIX computer is composed of two little boards.
1. iCE40HX8K-EVB, the fpga development board from olimex.com
2. USB-serial adapter. Used to power the board with 5V and to in-/output data over serial interface.

![](pics/MIX_inside.jpg)

### Clock
MIX runs on iCE40HX8K-EVB clocked at 25MHz. The basic unit of time 1u corresponds to 40ns, so according to Knuth it's a relatively high priced machine.


### Character based I/O units
In our MIX implementation all character based I/O units (U16 -- U20) are connected to the USB-connector and can be accessed as serial data streams. You can connect MIX with any PC running a terminal emulator (e.g. screen for linux). The terminal should be set to 115200 baud (8N1). A conversion between ASCII and Knuths character codes is done in hardware according to Knuths specification (see TAOCP p. 128).

![](pics/MIX_usb.jpg)


### The block based I/O unit U8
A block based device is implemented on I/O unit 8. The device acts as a disk with 1000 blocks à 100 words. The data is stored in the SRAM chip found on the iCE40HX8K-EVB board. The speed of read and write operations is exactly 401 $u$ for reading or writing one complete block of data (no JBUS is needed). The data stored to unit U8 can be retrieved also after a reset (Go-Button). But on a full shutdown, when removing power supply (USB connector) data is lost.


### Commands
All commands described in TAOCP Vol. 1 are implemented (s. list) with execution times corresponding to Knuth's specifications. Special care is given to the correct timings. Even the "sofisticated" commands SRC and SLC, which need a modulo 10 computation are executed in the defined timing of two cycles. The system can (easily) be extended in various ways:

1. add more commands:
	* logic operators: AND, OR, XOR, NOT (todo)
	* JrE,JrO jump if Register r is even/odd (done)
	* Floating point arithmetic: FADD, FSUB, FMUL, FDIV (done)
2. add more hardware:
	* add leds to run the traffic light example (done)
	* add block I/O unit (done)

| Command | OP  | Field | Timing |
| --------|-----|-------|--------|
| NOP     | 0   | 0     | 1u     |
| ADD     | 1   | 0:5   | 2u     |
| FADD    | 1   | 6     | 4u     |
| SUB     | 2   | 0:5   | 2u     |
| FSUB    | 2   | 6     | 4u     |
| MUL     | 3   | 0:5   | 10u    |
| FMUL    | 3   | 6     | 9u     |
| DIV     | 4   | 0:5   | 12u    |
| FDIV    | 4   | 6     | 11u    |
| NUM,CHAR| 5   | 0,1   | 10u    |
| HLT     | 5   | 2     | ?      |
| SLA,SRA,SLAX,SRAX,SLC,SRC| 6  | 0-5|  2u     |
| MOVE    | 7   | F     | (1+2F)u|
| LDr     | 8-15| 0:5   | 2u     |
| LDNr    |16-23| 0:5   | 2u     |
| STr     |24-31| 0:5   | 2u     |
| STJ     | 32  | 0:2   | 2u     |
| STZ     | 33  | 0:5   | 2u     |
|JBUS,JRED|34,38| U     | 1u     |
| IOC     | 35  | U     | 1u     |
| IN,OUT  |36,37| U     | (1+T)u |
| JMP,JSJ,JOV,JNOV,JL,JE,JG,JGE,JNE,JLE| 39  |0-9  | 1u   | 
| JrN,JrZ,JrP,JrNN,JrNZ,JrNP,JrE,JrO | 40-47| 0-7 | 1u |
| INCr,DECr,ENTr,ENNr  | 48-53   |0-3     | 1u   |
| CMPr|54-63|0:5          | 2u   |


### The GO button
MIX comes with the "GO button" attached to USB-UART. So after pressing the GO button MIX-programms can be uploaded by sending the "punched cards" to USB-UART.

### Toast
MIX comes in a nice case with formfactor of a slice of toast, so your complete MIX computer system will easily fit into your lunch box. The case can be printed with a 3D printer. Design files can be found in the directory `build/toast`.

![](pics/MIX_gpio.jpg)

## Verify
MIX has been verified with the following programms.

* 1.3.2p table first 500 primes
* 1.3.2e easter dates
* 1.3.3a product of permutation
* 1.3.1 go button
* 1.3.2 traffic lights
* fpu test
* coins
* test disk
* echo

### Example 1: Program p
Compute the first 500 primes
	
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
			
### Example 2: Program t
MIX can control the traffic signal of the corner del Mar Avenue/Berkeley Avenue. MIX is NOT a simulatin/emulation. It's real hardware. So you can drive the LEDs with the output of RegisterX. Input is done with a push button, which directly connects to the overflow toggle.

![](pics/MIX_traffic.jpg)

### Example 3: FPU test

The FPU test consists of a mixal programm, which calculates floating point arithmetic (a+b,a-b,a*b,a/b) in two modes. Mode 1: using Knuth's floating point routines written in mixal as described in TAOCP Vol. 2. Mode 2: using hardware FPU implemented in fpga by the author. The test is considerd as PASS, when both calculations yield equal results.

The floating point unit of MIX passed all 666 test vectors. A small python script `fpu_ver.py` translates the test output into a human readable form:

```
PASS  a=4.6262671E+34 b=1.7221547E+43 add=1.7221547E+43 sub=1.7221547E+43 mul= OVERFLOW     div=2.6863241E-09
PASS  a=2.5752075E+05 b=9.2271205E+44 add=9.2271205E+44 sub=9.2271205E+44 mul=2.3761750E+50 div=2.7909101E-40
PASS  a=2.6534631E+03 b=1.5976225E-39 add=2.6534631E+03 sub=2.6534631E+03 mul=4.2392327E-36 div=1.6608823E+42
PASS  a=9.0378624E+24 b=5.0501368E+20 add=9.0383673E+24 sub=9.0373574E+24 mul=4.5642428E+45 div=1.7896266E+04
PASS  a=6.9119667E-16 b=1.2909244E+45 add=1.2909244E+45 sub=1.2909244E+45 mul=8.9228276E+29 div= OVERFLOW    
PASS  a=2.3828292E+46 b=1.9916564E-59 add=2.3828292E+46 sub=2.3828292E+46 mul=4.7457784E-13 div= OVERFLOW    
PASS  a=6.5266299E+37 b=3.8120098E-47 add=6.5266299E+37 sub=6.5266299E+37 mul=2.4879583E-09 div= OVERFLOW    
PASS  a=3.8722704E+48 b=1.0729227E-06 add=3.8722704E+48 sub=3.8722704E+48 mul=4.1546470E+42 div=3.6090848E+54
PASS  a=6.2388017E-07 b=1.7556096E-42 add=6.2388017E-07 sub=6.2388017E-07 mul=1.0952900E-48 div=3.5536382E+35
PASS  a=3.2433888E-24 b=5.7628567E+20 add=5.7628567E+20 sub=5.7628567E+20 mul=1.8691188E-03 div=5.6280914E-45
PASS  a=1.4488148E-17 b=4.5634270E-01 add=4.5634270E-01 sub=4.5634270E-01 mul=6.6115620E-18 div=3.1748393E-17
PASS  a=4.2651094E+03 b=5.7188816E+55 add=5.7188816E+55 sub=5.7188816E+55 mul= OVERFLOW     div=7.4579483E-53
PASS  a=5.0304785E+02 b=8.3459865E-40 add=5.0304785E+02 sub=5.0304785E+02 mul=4.1984306E-37 div=6.0274242E+41
PASS  a=1.1925260E-29 b=2.0343117E-24 add=2.0343236E-24 sub=2.0342999E-24 mul=2.4259698E-53 div=5.8620644E-06
...
```

## need help?
In case you find encounter an issue with MIX`:

* don't panic
* send an email to mi.schroeder@netcologne.de


## related links

* [The Art of Computer Programming](https://www-cs-faculty.stanford.edu/~knuth/taocp.html): Donald Knuth's homepage

* [The Art of FPGAs: MIX-FPGA](https://www.hackster.io/news/the-art-of-fpgas-mix-fpga-edc1a7e47939): Article of Whitney Knitter on hackster.io
