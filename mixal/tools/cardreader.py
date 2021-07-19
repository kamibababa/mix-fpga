#!/bin/python3
import sys
import os
import time
if (len(sys.argv)) == 2:
    t=0
elif (len(sys.argv)) == 3:
    t = float(sys.argv[2])
else:
    print("usage: {:s} <asm-file.card> [time]".format(sys.argv[0]))

card_file = sys.argv[1]

fin = open(card_file,'r')
fin = fin.read().split('\n')

fout = open('/dev/ttyUSB0','w')
for line in fin:
    time.sleep(t)
    print(line,file = fout,end='\n\r')
    fout.flush()
