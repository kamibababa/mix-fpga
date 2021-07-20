#!/bin/python3
import sys
import os
import time

t=0
name = sys.argv.pop(0)
card_file=None
cr = ''
for p in sys.argv:
    if p[0:2]=='-r':
        cr='\r'
    elif p[0:2]=='-t':
        t=float(p[2::])
    else:
        card_file = p
        
if card_file==None:
    print("usage: {:s} <asm-file.card> [-t<time>] [-r]".format(name))
    sys.exit(-1)
    
fin = open(card_file,'r')
fin = fin.read().split('\n')

fout = open('/dev/ttyUSB0','w')
for line in fin:
    time.sleep(t)
    print(line,file = fout,end=cr)
    fout.flush()
