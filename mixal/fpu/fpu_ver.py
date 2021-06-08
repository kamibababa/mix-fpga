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
    if (n=='     OVER '):
        return ' OVERFLOW    '
    if (n=='0000000000'):
        return 0
    if n[9] in ' ABCDEFGHI':
        if n[9] ==' ':
            n=n[0:9]+'0'
        elif n[9] =='A':
            n=n[0:9]+'1'
        elif n[9] =='B':
            n=n[0:9]+'2'
        elif n[9] =='C':
            n=n[0:9]+'3'
        elif n[9] =='D':
            n=n[0:9]+'4'
        elif n[9] =='E':
            n=n[0:9]+'5'
        elif n[9] =='F':
            n=n[0:9]+'6'
        elif n[9] =='G':
            n=n[0:9]+'7'
        elif n[9] =='H':
            n=n[0:9]+'8'
        elif n[9] =='I':
            n=n[0:9]+'9'
        else:
            print('WTF')
    n=int(n)
    n='0o{:010o}'.format(n)
    e=eval(n[0:4])
    m=eval('0o'+n[4::])
    f = m/0o100000000 * (64**(e-32))
    return f
def toString(x):
    if isinstance(x,str):
        return x
    return '{:.7E}'.format(x)
w=True
for line in fin:
    if (w):
        print(line)
        w=False
    else:
        a=f(line[0:10])
        b=f(line[10:20])
        ad=f(line[20:30])
        su=f(line[30:40])
        mu=f(line[40:50])
        di=f(line[50:60])
        pa=line[60:65]
        print('OUTPUT MIX: '+line[0:10]+' '+line[10:20]+' '+line[20:30]+' '+line[30:40]+' '+line[40:50]+' '+line[50:60])
        print(pa + ' a={:s} b={:s} add={:s} sub={:s} mul={:s} div={:s}'.format(toString(a),toString(b),toString(ad),toString(su),toString(mu),toString(di)))
        print('      accuracy compared to double    ',end='')
        if (ad!=' OVERFLOW    '):
            print('       ({:.8f})'.format(abs(ad/(a+b))),end='')
        else:
            print('                  ',end='')
        if (su!=' OVERFLOW    '):
            print('       ({:.8f})'.format(abs(su/(a-b))),end='')
        else:
            print('                  ',end='')
        if (mu!=' OVERFLOW    '):
            if (a*b==0):
                print('       ({:.8f})'.format(0),end='')
            else:
                print('       ({:.8f})'.format(abs(mu/(a*b))),end='')
        else:
            print('                  ',end='')
        if (di!=' OVERFLOW    '):
            if (a==0 or b==0):
                print('       ({:.8f})'.format(0),end='')
            else:
                print('       ({:.8f})'.format(abs(di/(a/b))),end='\n')
        else:
            print('                  ',end='\n')
        if (pa=='FAIL '):
            print('FAIL {:010o} {:010o}'.format(int(line[0:10]),int(line[10:20])))
