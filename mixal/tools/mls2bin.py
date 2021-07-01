#!/usr/bin/python3
import sys

if (len(sys.argv)) != 2:
    print("usage: {:s} <filename>".format(sys.argv[0]))
    sys.exit(0)
else:
    fin = open(sys.argv[1],"r")
    fout = open(sys.argv[1].split(".")[0]+".bin","w")


mem=[0]*4096
for line in fin:
    if len(line)>0 and line[0]!=' ':
        line=line.strip().split()
        a = int(line[0])
        sign = line[1]=='-'
        w=0
        for i in range(4):
            w=w*64+int(line[i+2])
        if sign:
            w=w+0o10000000000
        mem[a]=w
for a in range(4096):
    print('{:031b}'.format(mem[a]),file=fout)
