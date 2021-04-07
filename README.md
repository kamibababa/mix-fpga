# MIX-fpga

Stumbled over MIX-computer of D.E. Knuth and want to run MIXAL-code on real hardware?

Implementation of MIX computer as proposed in "The Art of Computer Programming, Vol. 1" by Donald E. Knuth.
Runs on iCE40-fpga using only free and open source hard- and software.

## Hardware
Runs on fpga board iCE40HX8K-EVB from Olimex at 40 MHz.

# Timing
MIX's basic unit of time 1u equals to 25 ns for this implementation. So according to Knuth it's a relatively high priced machine.
## List of commands

| OP  | Menmonic | Remarks |
| -   | -   | -  |
| 0   | NOP | ok |
| 1   | ADD | ok | 
| 2   | SUB | ok | 
| 3   | MUL | 6 cycles vs. 10 of original MIX| 
| 4   | DIV | 13 cycles vs. 12 of original MIX | 
| 5   | NUM | todo | 
| 5   | CHAR | todo | 
| 5   | HLT | todo | 
| 6   | SHIFT | todo | 
| 7   | MOVE | todo | 
| 8 - 23   | LD(N) | ok | 
| 24 - 33  | ST | ok | 
| 34   | JBUS | todo | 
| 35   | IOC | todo | 
| 36   | IN | todo | 
| 37   | OUT | todo | 
| 38   | JRED | todo | 
| 39 - 47   | JMP | ok | 
| 48 - 55   | INC,DEC,ENT,ENN | ok | 
| 56 - 63  | CMP | ok | 

## How to run MIX-programms
* compile the MIXAL-programms to binary
* put binary in `rom.bin`
* run `apio sim` to simulate MIX with preloaded binary
* run `apio build` to syntesize MIX circuit
* run `apio upload` to upload bitstream file to fpga-board. 

## Things to come:
* Implement missing commands (see todo in command list)
* Build a UART and connect to U16/U17 to communitcate to MIX at runtime.