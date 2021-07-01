#!/usr/bin/python3
import sys

if (len(sys.argv)) != 2:
    print("usage: {:s} <asm-file.mixal>".format(sys.argv[0]))
    sys.exit(0)
mixal_file = sys.argv[1]

fin = open(mixal_file,'r')
fin = fin.read().split('\n')

fout = open(mixal_file.split('.')[0]+'.trim','w')
for line in fin:
    if len(line)>0:
        token=line.split()
        if line[0]=='*':
            line='{:80s}'.format(line)
        else:
            if line[0]==' ' or line[0]=='\t':
                token=[' ']+token
            while len(token)<3:
                token+=' '
            if token[1]=='ALF':
                i=line.index('ALF')
                token[2]=line[i+5:i+10]
            line='{:10s} {:4s} {:64s}'.format(token[0],token[1],token[2])
        print(line,file=fout)
