#!/bin/python3
import sys
import random

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
        p=f(a)*f(b)
        if (d!=c):
            print("ErroR")
            print(line)
            print(oct(a))
            print(oct(b))
            print(oct(c))
            print(oct(d))
            print(line)
            print('{:f} * {:f} = {:f} FPU {:0.7f}'.format(f(a),f(b),f(c),f(d)))
        else:
            print('PASS: {:.7E} * {:.7E} = {:.7E} FPU {:.7E} {:.8f}'.format(f(a),f(b),f(c),f(d),f(d)/p))
            if (f(d)/p>4):
                print(line)
                print(oct(a))
                print(oct(b))
                print(oct(c))
                print(oct(d))
        #print('{:0.7f}'.format((f(a)/f(b))/f(d)))
