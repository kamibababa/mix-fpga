#!/usr/bin/python3
import sys
import random

if (len(sys.argv)) != 2:
    print("usage: {:s} <n>".format(sys.argv[0]))
    sys.exit(0)
else:
    n = int(sys.argv[1])
    fout = open("rand.card","w")

b=" ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.;()+-*/=$<>@;:'"
c=''

def rand_char():
    x = random.randint(0,len(b)-1)
    return b[x]

for i in range(n):
    c=''
    for j in range(80):
        c = c + rand_char()
    print(c,file=fout)
