#!/usr/bin/python3
import sys
import random
c=''
n = int(input('how many punched cards?'))
fout = open('rand.card','w')
def char(i):
    if (i==0):
        return ' '
    if (i<30):
        return str(chr(i+65))
    return ' '
for i in range(n):
    c=''
    for j in range(80):
        c=c+char(random.randint(0,24))
    print(c,file=fout)
