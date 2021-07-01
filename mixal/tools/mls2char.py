#!/usr/bin/python3
import sys

if (len(sys.argv)) != 2:
    print("usage: {:s} <filename>".format(sys.argv[0]))
    sys.exit(0)
else:
    fin = open(sys.argv[1],"r")
    fout = open(sys.argv[1].split(".")[0]+".card","w")


char_codes=" ABCDEFGHIxJKLMNOPQRxxSTUVWXYZ0123456789.,()+-*/=$<>@;:'"

card=''
for line in fin:
    if len(line)>0 and line[0]!=' ':
        line=line.strip().split()
        a=int(line[0])
        sign = line[1]=='-'
        w=0
        for i in range(4):
            w = w*64+int(line[i+2])
        ws = '{:010d}'.format(w)
        if sign:
            print('ERROR SIGN')
            sys.exit(-1)
        c=''
        for i in range(5):
            c=char_codes[w%64]+c
            w=w//64
        card=card+c
while len(card)>0:
    print('{:80s}'.format(card[0:80]),file=fout)
    card=card[80:]

