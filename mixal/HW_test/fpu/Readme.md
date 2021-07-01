## Implementation of FPU
We will implement fpu as described in TAOCP Vol. 2.
We test the hardware fpu by running a test programm on MIX, which reads 666 testvectors. Each testvector contains two aperands a,b. The MIX programm then calculates the product a*b in hardware and with the floating point assembler routines described in TAOCP Vol 2. Both results are output to tty.

We use card (80 char) as input and tty (70 char) as output. So we won't see corrupted card input due to USB delay.

### progress
Up to now FADD,FSUB and FMUL work! The timings are: 4u, 4u and 9u as required by Knuth (compare TAOCP Vol. 2)

### Testing the FPU

#### fpu_a.mixal, fpu_s.mixal, fpu_m.mixal 
This are the assembler programs to test the hardware fpu. They read testvectors containing two operands a and b. Then they calculate a+b,a-b or a*b twice. First with assembler routine according to Knuth TAOCP Vol. 2. Then with FPU in hardware.

The assembler routines of floating point arithmetic need a special command `JXO`: jump if registerX is odd.
This has been implemented in hardware as command JMP(7).

#### fpu_rand.py
The python script generates testvectors composed of two randomly  generated floating point numbers a and b.

#### prepare input
```
fpu_rand.py 666
mixasm fpu_a.mixal -l
../../tools/mls2card.py fpu_a.mls
cat fpu_a.card rand.card > fpu_a_rand.card
```
#### run the test on MIX

```
cat /dev/ttyUB0 > fpu_a.out
<in other terminal>
cat fpu_a_rand.card > /dev/ttyUSB0
```

#### Verify the output

The python script `fpu_a_ver.py` verifies the output of MIX fpu programs. `PASS: <a> * <b> = <Knuths routine> FPU <result of FPU> <accuracy compared to double precision python>`  

```
./fpu_a_ver.py fpu.out
```

All 666 Vectors passed all tests (FADD,FSUB,FMUL).

```
WELCOME TO MIX. 1U = 40NS. U16-U20 UART @115200 BAUD. U8 1000 BLOCKS  

PASS: 1.8759447E-06 * 3.6056668E-28 = 6.7640314E-34 FPU 6.7640314E-34 0.99999999
PASS: 1.7834705E+03 * 8.2148222E-19 = 1.4650892E-15 FPU 1.4650892E-15 0.99999994
PASS: 5.7147675E-19 * 4.1329526E-19 = 2.3618865E-37 FPU 2.3618865E-37 1.00000009
PASS: 4.7559501E-21 * 1.1379468E-04 = 5.4120177E-25 FPU 5.4120177E-25 0.99999990
PASS: 9.9061203E+04 * 3.2849323E-30 = 3.2540926E-25 FPU 3.2540926E-25 0.99999975
PASS: 1.3381295E-02 * 6.0713204E-16 = 8.1242139E-18 FPU 8.1242139E-18 1.00000013
PASS: 1.6356209E-22 * 4.4763898E+08 = 7.3216769E-14 FPU 7.3216769E-14 1.00000002
PASS: 6.5452131E-03 * 2.6138429E-15 = 1.7108160E-17 FPU 1.7108160E-17 1.00000007
PASS: 1.5293589E+07 * 3.3928755E+03 = 5.1889242E+10 FPU 5.1889242E+10 0.99999998
PASS: 9.4776714E-01 * 2.1717965E+08 = 2.0583571E+08 FPU 2.0583571E+08 0.99999990
PASS: 1.0007590E-01 * 1.8778110E-26 = 1.8792362E-27 FPU 1.8792362E-27 0.99999996
PASS: 1.1125302E-26 * 9.6329599E-31 = 1.0716966E-56 FPU 1.0716966E-56 1.00000062
...

```
