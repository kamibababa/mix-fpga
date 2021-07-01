#!/usr/bin/python3
import sys

def isChar(c):
    return ord(c) >= ord('A') and ord(c) <= ord('Z')

def isNum(c):
    return ord(c) >= ord('0') and ord(c) <= ord('9')
symbol={}
symbol['2A']=123
for line in sys.stdin:
    val=0
    state=0
    sy=lambda x:int(x)
    op=lambda x,y:x+sy(y)
    aval=''
    for c in line:
        if state == 0:
            if isNum(c):
                aval += c
            if isChar(c):
                aval += c
                sy=lambda x:symbol[x]
            elif c=='+':
                val=op(val,aval)
                aval=''
                op=lambda x,y:x+sy(y)
            elif c=='-':
                val=op(val,aval)
                aval=''
                op = lambda x,y:x-sy(y)
            elif c=='*':
                val=op(val,aval)
                aval=''
                op= lambda x,y:x*sy(y)
            elif c=='/':
                val=op(val,aval)
                aval=''
                op= lambda x,y:x//sy(y)
            elif c==',':
                val=op(val,aval)
                aval=''
                op=lambda x,y:x*64*64*64+int(y)*64
            elif c==' ':
                val=op(val,aval)
                print('value:'+oct(val))
                break
