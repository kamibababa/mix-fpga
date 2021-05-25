## Running programs on MIX
### mixasm
To run mixal programs with MIX you first have to translate the mixal programs to machine language. This is done with the GNU tansloator `mixasm` distributed with the mix software package  `mdk`. Append the option `-l` to create a listing file `.mls`.
### tools
To upload the code onto MIX we have to write the listing in a computer readable format. For this you can use the python scripts provided in `tools`:

* `mls2card.py` : translate the machine code (.mls) to punchcard format.
* `mls2char.py` : translate to character codes, which can directly be read by MIX. (This is only necessary for the bootloader written on the first two punch cards).
* `mls2bin.py`: translate the .mls file to binary. This is only necessary for the go-button, which must be uploaded into fpga ROM.

### upload and run
Finally you can connect to MIX with USB using a terminal emulator (screen)
```
screen /dev/ttyUSB0 115200
```
Within  a screen session you can upload the mixal programs written on punch cards:
```
ctr-a : readreg p p.card
ctrl-a : paste p
```


### The following programms have been tested on MIX:

Details can be found in the README.md files found in the subfolders:

* `p`: compute the first 500 primes
* `e`: compute easter dates
* `t`: control traffic signals
* `go`: the go button
* `boot`: the bootloader
