#!/usr/bin/python3
import sys
import random
c=''
def char(i):
    if (i==0):
        return ' '
    if (i<30):
        return str(chr(i+65))
    return ' '
for i in range(6000):
    c=''
    for j in range(80):
        c=c+char(random.randint(0,24))
    print(c)
