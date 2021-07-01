#!/usr/bin/python3
import sys
symbols={}
opcodes={'NOP ':(0,0),'ADD ':(1,5),'FADD':(1,6),'SUB ':(2,5),'FSUB':(2,6),'MUL ':(3,5),'FMUL':(3,6),'DIV ':(4,5),'FDIV':(4,6),'NUM ':(5,0),'CHAR':(5,1),'HLT ':(5,2),'SLA ':(6,0),'SRA ':(6,1),'SLAX':(6,2),'SRAX':(6,3),'SLC ':(6,4),'SRC ':(6,5),'MOVE':(7,1),'STJ ':(32,2),'STZ ':(33,5),'JBUS':(34,0),'IOC ':(35,0),'IN  ':(36,0),'OUT ':(37,0),'JRED':(38,0),'JMP ':(39,0),'JSJ ':(39,1),'JOV ':(39,2),'JNOV':(39,3),'JL  ':(39,4),'JE  ':(39,5),'JG  ':(39,6),'JGE ':(39,7),'JNE ':(39,8),'JLE ':(39,9)}
future=[]
def code(c):
    knuthchar=" ABCDEFGHIxJKLMNOPQRxxSTUVWXYZ0123456789.,()+-*/=$<>@;:'"
    if c in knuthchar:
        return knuthchar.index(c)
    return -1

def atomic_expression(expr):
    if (expr.isnumeric()):
        return int(expr)
    if expr in symbols:
        return symbols[expr]
    if len(expr)==0:
        return 0
    print('FUTURE'+expr+'|')
    return 0

def w_expression(expr):
    w=0
    t=''
    op=lambda x:w+x
    for c in expr:
        if c==' ':
            return op(atomic_expression(t))
        elif c=='+':
            w=atomic_expression(t)
            t=''
            op=lambda x:w+x
        elif c=='-':
            w=atomic_expression(t)
            t=''
            op=lambda x:w-x
        elif c=='*':
            w=atomic_expression(t)
            t=''
            op=lambda x:w*x
        elif c=='/':
            w=atomic_expression(t)
            t=''
            op=lambda x:w//x
        else:
            t=t+c

def future(f,x):
    #print('Future'+f+str(x))
    return 0

def a_expression(expr):
    w = 0
    t = ''
    f=''
    op=lambda x:x
    if (expr[0]=='='):
        expr=expr[1::]
        f='='+expr.strip()
    while(len(expr)>0):
        c=expr[0]
        expr=expr[1::]
        if (c==' ' or c==',' or c=='(' or c==')'):
            return (op(atomic_expression(t)),c+expr)
        elif c=='+':
            w=op(atomic_expression(t))
            t=''
            op=lambda x:w+x
        elif c==':':
            w=op(atomic_expression(t))
            t=''
            op=lambda x:w*8+x
        elif c=='-':
            w=op(atomic_expression(t))
            t=''
            op=lambda x:w-x
        elif c=='*':
            w=op(atomic_expression(t))
            t=''
            op=lambda x:w*x
        elif c=='/':
            t=''
            op=lambda x:w//x
        elif c=='=':
            w=op(atomic_expression(t))
            t='='
            op=lambda x:future(f,w)
        else:
            t=t+c

def i_expression(expr):
    if expr[0]!=',':
        return (0,expr)
    expr=expr[1::]
    return a_expression(expr)

def f_expression(expr):
    if expr[0]!='(':
        return -1
    expr=expr[1::]
    (f,expr)=a_expression(expr)
    if expr[0]==')':
        return f
    print('wtf'+expr+'|')

def reg(r):
    if r=='A':
        return 0
    if r=='X':
        return 7
    n=code(r)-code('0')
    if (n>0 and n<7):
        return n

def jump(j):
    if j=='N ':
        return 0
    if j=='Z ':
        return 1
    if j=='P ':
        return 2
    if j=='NN':
        return 3
    if j=='NZ':
        return 4
    if j=='NP':
        return 5
    if j=='E ':
        return 6
    if j=='O ':
        return 7

counter=0
for line in sys.stdin:
    sign='+'
    add=0
    ind=0
    fie=0
    opc=0
    ca=counter
    label = line[0:10].strip()
    op = line[11:15]
    expr = line[16:80]
    noheader=False
    if (len(label)>0):
        if (label[0]=='*'):
            noheader=True
        elif (op=='EQU '):
            symbols[label] = w_expression(expr)
            noheader=True
        else:
            symbols[label]=ca
    if (op=='ORIG'):
        noheader=True
        counter = w_expression(expr)
    elif (op=='END '):
        noheader=True
    elif (op=='ALF '):
        add=code(expr[0])*64+code(expr[1])
        ind=code(expr[2])
        fie=code(expr[3])
        opc=code(expr[4])
        counter+=1
    elif (op=='CON '):
        n = w_expression(expr)
        add=n//(64**3)
        n=n-add*(64**3)
        ind=n//64
        n=n-ind*64
        fie=n//64
        opc=n-fie*64
        counter+=1
    elif (op in opcodes):
        (opc,fie)=opcodes[op]
        (add,expr)=a_expression(expr)
        (ind,expr)=i_expression(expr)
        f=f_expression(expr)
        if (f>=0):
            fie=f
        counter+=1
    elif (op.startswith('LD')):
        (opc,fie)=(8+reg(op[2]),5)
        (add,expr)=a_expression(expr)
        (ind,expr)=i_expression(expr)
        f=f_expression(expr)
        if (f>=0):
            fie=f
        if (op[3]=='N'):
            opc+=8
        counter+=1
    elif (op.startswith('ST')):
        (opc,fie)=(24+reg(op[2]),5)
        (add,expr)=a_expression(expr)
        (ind,expr)=i_expression(expr)
        f=f_expression(expr)
        if (f>=0):
            fie=f
        counter+=1
    elif (op.startswith('J')):
        (opc,fie)=(40+reg(op[1]),jump(op[2:4]))
        (add,expr)=a_expression(expr)
        (ind,expr)=i_expression(expr)
        f=f_expression(expr)
        if (f>=0):
            fie=f
        counter+=1
    elif (op.startswith('CMP')):
        (opc,fie)=(45+reg(op[3]),5)
        (add,expr)=a_expression(expr)
        (ind,expr)=i_expression(expr)
        f=f_expression(expr)
        if (f>=0):
            fie=f
        counter+=1
    elif (op.startswith('ENT')):
        (opc,fie)=(48+reg(op[3]),0)
        (add,expr)=a_expression(expr)
        (ind,expr)=i_expression(expr)
        f=f_expression(expr)
        if (f>=0):
            fie=f
        counter+=1
    elif (op.startswith('ENN')):
        (opc,fie)=(48+reg(op[3]),1)
        (add,expr)=a_expression(expr)
        (ind,expr)=i_expression(expr)
        f=f_expression(expr)
        if (f>=0):
            fie=f
        counter+=1
    elif (op.startswith('INC')):
        (opc,fie)=(48+reg(op[3]),2)
        (add,expr)=a_expression(expr)
        (ind,expr)=i_expression(expr)
        f=f_expression(expr)
        if (f>=0):
            fie=f
        counter+=1
    elif (op.startswith('DEC')):
        (opc,fie)=(48+reg(op[3]),3)
        (add,expr)=a_expression(expr)
        (ind,expr)=i_expression(expr)
        f=f_expression(expr)
        if (f>=0):
            fie=f
        counter+=1
    if(noheader):
        print('                      {:s}'.format(line),end='')
    else:
        print('{:04d} {:1s} {:02d} {:02d} {:02d} {:02d} {:02d} {:s}'.format(ca,sign,add//64,add%64,ind,fie,opc,line),end='')
print('                      * SYMBOL TABLE')
for s in symbols:
    print('                      {:10s} EQU  {:d}'.format(s,symbols[s]))
