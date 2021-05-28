#!/bin/python3
import sys
import random

if (len(sys.argv)) != 2:
    print("usage: {:s} <n>".format(sys.argv[0]))
    sys.exit(0)
else:
    n = int(sys.argv[1])
    fout = open("rand.card","w")

def rand_op():
    c='0o'
    for i in range(10):
        if (i==0):
            c += str(random.randint(2,4))
        elif (i==1):
            c += str(random.randint(0,7))
        elif (i==3) and (c[4]=='0'):
            c += str(random.randint(1,7))
        else:
            c += str(random.randint(0,7))
    return c

for i in range(n):
    a=rand_op()
    b=rand_op()
    p='0'
    d='0'
    c='{:010d}{:010d}{:010d}{:010d}'.format(eval(a),eval(b),eval(p),eval(d))+40*'0'
    print(c)
