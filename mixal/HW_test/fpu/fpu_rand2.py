#!/bin/python3
import sys
import random
re=['00','01','02','03','40','41','42','43','75','76','77']
rm=['00','01','40','77']
if (len(sys.argv)) != 2:
    print("usage: {:s} <n>".format(sys.argv[0]))
    sys.exit(0)
else:
    n = int(sys.argv[1])
    fout = open("rand.card","w")

def rand_op():
    c='0o'
    c += re[random.randint(0,8)]
    for i in range(4):
        c += rm[random.randint(0,3)]
    if ((c[2]=='0' and c[3]=='0') or (c[4]=='0' and c[5]=='0')):
        return '0o0000000000'
    return c

for i in range(n):
    a=rand_op()
    b=rand_op()
    p='0'
    d='0'
    c='{:010d}{:010d}{:010d}{:010d}'.format(eval(a),eval(b),eval(p),eval(d))+40*'0'
    print(c)
