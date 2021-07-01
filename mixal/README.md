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
