# iCE-MIX

Have you ever heard of Don Knuths first polyunsaturated machine, the 1009? In this project we will implement the MIX-Computer as proposed in "The Art of Computer Programming, Vol. 1" by Donald E. Knuth on an fpga-board.

The implementation is called iCE-MIX because it uses the iCE40HX8K fpga from Lattice. We use the development board iCE40HX8K-EVB from the company Olimex. The whole project uses only FOSS free and open source hard- and software.

## Hardware details
MIX runs on iCE40HX8K-EVB clocked at 33MHz. The basic unit of time 1u corresponds to 30ns, so according to Knuth it's a relatively high prices machine.

iCE-MIX is a binary version of MIX-computer.

iCE-MIX connects to USB-UART at 116200 baud, which is routed to U19 IN/OUT unit. The UART-connector translates Knuths 6bit character bytes to ASCII. 

## Implemented commands

Most commands are already implemented (s. list).

| OP  | Menmonic | Remarks |
| -   | -   | -  |
| 0   | NOP | ok |
| 1   | ADD | ok | 
| 2   | SUB | ok | 
| 3   | MUL | 6 cycles vs. 10 of original MIX| 
| 4   | DIV | 13 cycles vs. 12 of original MIX | 
| 5   | NUM | todo | 
| 5   | CHAR | ok | 
| 5   | HLT | ok | 
| 6   | SHIFT | todo | 
| 7   | MOVE | todo | 
| 8 - 23   | LD(N) | ok | 
| 24 - 33  | ST | ok | 
| 34   | JBUS | todo | 
| 35   | IOC | todo | 
| 36   | IN | todo | 
| 37   | OUT | ok | 
| 38   | JRED | todo | 
| 39 - 47   | JMP | ok | 
| 48 - 55   | INC,DEC,ENT,ENN | ok | 
| 56 - 63  | CMP | ok | 

## Test

iCE-MIX has been tested to run the programm p, which computes the first 500 primes and outputs them on unit 19 (UART).

## How to prepare MIXAL-programms
To run mixal programms on iCE40 you first have to translate the mixal programm to a binary representation:
* cd into the folder mixal `cd mixal`
* compile the MIXAL-programms with `mixasm p.mixal -l`
* translate the list file to binary `./mls2bin.py < p.mls > p.bin`

Now the binary file must be preloaded into memory of iCE-MIX. We will compile the whole verilog project with the included rom file.
* copy binary to mix-folder `cp p.bin ../mix/rom.bin`
* now cd into the mix-folder `cd ../mix`
* run `apio build -v` to syntesize MIX circuit with preloaded rom.
* run `apio upload` to upload bitstream file to fpga-board.

Now iCE40-fpga holds a MIX-computer with the programm stored in memory beginning at address 0.

Connect iCE40-fpga to UART and press reset. In your terminal programm you will see the output of MIX on in/out unit 19 (Terminal).
* `screen /dev/ttyACM0`
* press reset! and lock at your output:
```
FIRST FIVE HUNDRED PRIMES
     0002    ...
     0003    ...
     0005    ...
```

## Things that have to be fixed
* Implement missing commands (see todo in command list)
* Build a UART-RX and connect to communitcate to MIX at runtime.
