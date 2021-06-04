#!/bin/python3
import sys
import random
import numpy as np

def arr32(a):
    return np.float32(a)

def add32(a1, a2):
    return np.add(a1, a2, dtype=np.float32)

def sub32(a1, a2):
    return np.subtract(a1, a2, dtype=np.float32)

def mul32(a1, a2):
    return np.multiply(a1, a2, dtype=np.float32)

def div32(a1, a2):
    return np.divide(a1, a2, dtype=np.float32)

if (len(sys.argv)) != 2:
    print("usage: {:s} <filename>".format(sys.argv[0]))
    sys.exit(0)
else:
    fin = sys.argv[1]
    fin = open(fin,"r")

def f(n):
    n='0o{:010o}'.format(n)
    e=eval(n[0:4])
    m=eval('0o'+n[4::])
    f = m/0o100000000 * (64**(e-32))
    return f
w=True
for line in fin:
    if (w):
        print(line)
        w=False
    else:
        a=int(line[0:10])
        b=int(line[10:20])
        c=int(line[20:30])
        d=int(line[30:40])
        o1=line[40:45]
        o2=line[45:50]
        p=f(a)-f(b)
        if (d==c):
            print('PASS: {:.7E} * {:.7E} = KNUTH {:.7E} FPU {:.7E} PYHTON {:.7E} ACC {:.7f}'.format(f(a),f(b),f(c),f(d),p,f(c)/p))
        else:
            print('FAIL: {:.7E} * {:.7E} = KNUTH {:.7E} FPU {:.7E} PYHTON {:.7E} ACC {:.12f} {:.12f}'.format(f(a),f(b),f(c),f(d),p,f(c)/p,f(d)/p))
            print(line)
            print('{:10o} {:10o} {:10o} {:10o}'.format(a,b,c,d))
