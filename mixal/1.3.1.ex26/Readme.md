## 1.3.1.ex26 Programm l
Program l is the card-loading routine described in TAOCP 1.3.1 exercise 26. The mixal routine has to be translated with the assembler and written to two punched cards in character format.

This can be done with the included `Makefile`.

```
$ make
```

### l.mixal
The mixal program can be found in `l.mixal`:

Inpect the file with:

```
$ cat l.mixal
```

```
* CARD LOADING ROUTINE                                                          
BUFF       EQU  29                                                              
           ORIG 0                                                               
LOC        IN   16(16)                                                          
READ       IN   BUFF(16)                                                        
           LD1  0(0:0)                                                          
           JBUS *(16)                                                           
           LDA  BUFF+1                                                          
N1         SLA  1                                                               
           SRAX 6                                                               
N30        NUM  30                                                              
           STA  LOC                                                             
           LDA  BUFF+1(1:1)                                                     
           SUB  N30(0:2)                                                        
LOOP       LD3  LOC                                                             
           JAZ  0,3                                                             
           STA  BUFF                                                            
           LDA  LOC                                                             
           ADD  N1(0:2)                                                         
           STA  LOC                                                             
           LDA  BUFF+3,1(5:5)                                                   
           SUB  N25(0:2)                                                        
           STA  0,3(0:0)                                                        
           LDA  BUFF+2,1                                                        
           LDX  BUFF+3,1                                                        
N25        NUM  25                                                              
           MOVE 0,1(2)                                                          
           STA  0,3(1:5)                                                        
           LDA  BUFF                                                            
           SUB  N1(0:2)                                                         
           JAP  LOOP                                                            
           JMP  READ                                                            
           END  0                                                               
```

### l.mls
First we translate the mixal programm to binary code. This is done with the assembler `tools/asm.py`.


```
$ ../tools/asm.py l.mixal 
$ cat l.mls
```
```
                     0001 * CARD LOADING ROUTINE
                     0002 BUFF       EQU  29 
                     0003            ORIG 0 
0000 + 0016 00 16 36 0004 LOC        IN   16(16) 
0001 + 0029 00 16 36 0005 READ       IN   BUFF(16) 
0002 + 0000 00 00 09 0006            LD1  0(0:0) 
0003 + 0003 00 16 34 0007            JBUS *(16) 
0004 + 0030 00 05 08 0008            LDA  BUFF+1 
0005 + 0001 00 00 06 0009 N1         SLA  1 
0006 + 0006 00 03 06 0010            SRAX 6 
0007 + 0030 00 00 05 0011 N30        NUM  30 
0008 + 0000 00 05 24 0012            STA  LOC 
0009 + 0030 00 09 08 0013            LDA  BUFF+1(1:1) 
0010 + 0007 00 02 02 0014            SUB  N30(0:2) 
0011 + 0000 00 05 11 0015 LOOP       LD3  LOC 
0012 + 0000 03 01 40 0016            JAZ  0,3 
0013 + 0029 00 05 24 0017            STA  BUFF 
0014 + 0000 00 05 08 0018            LDA  LOC 
0015 + 0005 00 02 01 0019            ADD  N1(0:2) 
0016 + 0000 00 05 24 0020            STA  LOC 
0017 + 0032 01 45 08 0021            LDA  BUFF+3,1(5:5) 
0018 + 0022 00 02 02 0022            SUB  N25(0:2) 
0019 + 0000 03 00 24 0023            STA  0,3(0:0) 
0020 + 0031 01 05 08 0024            LDA  BUFF+2,1 
0021 + 0032 01 05 15 0025            LDX  BUFF+3,1 
0022 + 0025 00 00 05 0026 N25        NUM  25 
0023 + 0000 01 02 07 0027            MOVE 0,1(2) 
0024 + 0000 03 13 24 0028            STA  0,3(1:5) 
0025 + 0029 00 05 08 0029            LDA  BUFF 
0026 + 0005 00 02 02 0030            SUB  N1(0:2) 
0027 + 0011 00 02 40 0031            JAP  LOOP 
0028 + 0001 00 00 39 0032            JMP  READ 
                     0033            END  0 
                                     TRANS 0000
                          * SYMBOL TABLE
                          *          EQU  29
                          BUFF       EQU  29
                          LOC        EQU  0
                          READ       EQU  1
                          N1         EQU  5
                          N30        EQU  7
                          LOOP       EQU  11
                          N25        EQU  22
```

### l.card

Next we must convert the binary code to the char codes of MIX. This can be done with the python script `tools/mls2char.py`.

```
$ ../tools/mls2char.py  l.mls
```

The python scripts reads the listing file `l.mls`, extracts the code and writes it in the file `l.card`.

Inspect the punched cards

```
$ cat l.card
```


```
 O O6 Z O6    I C O4 0 EH A  F F CF 0  E   EU 0 IH G BB   EJ  CA. Z EU   EH E BA
   EU 2A-H S BB  C U 1AEH 2AEN V  E  ABG  CLU Z EH E BB J B. A  9               
```

The output contains the card-loading routine expressed as characters. These characters are stored in location starting at memory address 0000 immediately after pressing the GO button.

The card-loading routine then reads the information cards containing the program to be loaded into memory. The loading routine stops with a jump instruction to the memory location found on the transfer card.
