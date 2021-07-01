#!/usr/bin/python3
import sys

symbols={}
opcodes={'NOP ':(0,0),'ADD ':(1,5),'FADD':(1,6),'SUB ':(2,5),'FSUB':(2,6),'MUL ':(3,5),'FMUL':(3,6),'DIV ':(4,5),'FDIV':(4,6),'NUM ':(5,0),'CHAR':(5,1),'HLT ':(5,2),'SLA ':(6,0),'SRA ':(6,1),'SLAX':(6,2),'SRAX':(6,3),'SLC ':(6,4),'SRC ':(6,5),'MOVE':(7,1),'STJ ':(32,2),'STZ ':(33,5),'JBUS':(34,0),'IOC ':(35,0),'IN  ':(36,0),'OUT ':(37,0),'JRED':(38,0),'JMP ':(39,0),'JSJ ':(39,1),'JOV ':(39,2),'JNOV':(39,3),'JL  ':(39,4),'JE  ':(39,5),'JG  ':(39,6),'JGE ':(39,7),'JNE ':(39,8),'JLE ':(39,9)}
future=[]
const={}
def code(c):
    knuthchar=" ABCDEFGHIxJKLMNOPQRxxSTUVWXYZ0123456789.,()+-*/=$<>@;:'"
    if c in knuthchar:
        return knuthchar.index(c)
    print('KNUTHCHAR'+c)
    sys.exit(-1)

def atomic_expression(expr):
    if (expr.isnumeric()):
        return int(expr)
    if expr in symbols:
        return symbols[expr]
    if len(expr)==0:
        return 0
    print('FUTURE'+expr+'|')
    return 0

def expression(expr,ww):
    w = 0
    t = ''
    op = lambda x:field(atomic_expression(x))
    if ww:
        field=lambda x:x
    else:
        field = lambda x:x*64*64*64
    while len(expr)>0:
        c = expr[0]
        if (c==' ' or c==')' or c=='='):
            return op(t)
        elif (code(c)<=40):
            t=t+c
        else:
            w = op(t)
            t = ''
            if c=='+':
                op=lambda x:w+field(atomic_expression(x))
            elif c=='-':
                op = lambda x:w-field(atomic_expression(x))
            elif c=='*' and len(t)!=0:
                op = lambda x:w*field(atomic_expression(x))
            elif c=='*' and len(t)==0:
                t=str(counter)
            elif c=='/' and len(t)!=0:
                op=lambda x:w//field(atomic_expression(x))
            elif c=='/' and len(t)==0:
                op=lambda x:w%field(atominc_expression(x))
            elif c==',':
                field = lambda x:x*64*64
            elif c=='(':
                field = lambda x:x*64
        expr=expr[1::]

def future(f,x):
    #print('Future'+f+str(x))
    return 0
def opcode(op):
    if (op in opcodes):
        return opcodes[op]
    elif (op.startswith('LD')):
        return (8+reg(op[2]),5)
        if (op[3]=='N'):
            opc+=8
    elif (op.startswith('ST')):
        return (24+reg(op[2]),5)
    elif (op.startswith('J')):
        return (40+reg(op[1]),jump(op[2:4]))
    elif (op.startswith('CMP')):
        return (45+reg(op[3]),5)
    elif (op.startswith('ENT')):
        return (48+reg(op[3]),0)
    elif (op.startswith('ENN')):
        return (48+reg(op[3]),1)
    elif (op.startswith('INC')):
        return (48+reg(op[3]),2)
    elif (op.startswith('DEC')):
        return (48+reg(op[3]),3)
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
def passa():
    global counter
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
                symbols[label] = expression(expr,True)
                noheader=True
            else:
                if len(label)==2 and label[1]=='H':
                    label=label+' '+str(ca)
                symbols[label]=ca
        if (op=='ORIG'):
            noheader=True
            counter= expression(expr,True)
        elif (op=='END '):
            noheader=True
        elif (op=='ALF '):
            add=code(expr[0])*64+code(expr[1])
            ind=code(expr[2])
            fie=code(expr[3])
            opc=code(expr[4])
            counter+=1
        elif (op=='CON '):
            n= expression(expr,True)
            add=n//(64**3)
            n=n-add*(64**3)
            ind=n//64
            n=n-ind*64
            fie=n//64
            opc=n-fie*64
            counter+=1
        elif opcode(op):
            (opc,fie)=opcode(op)
            if expr[0]=='=':
                s=expr[0:10]
                wval = expression(expr[1::],True)
                const[s]=wval
            else:
                wword = expression(expr,False)
            if wword<0:
                sign='-'
                wword=-wword
            add=wword//(64*64*64)
            wword=wword-add*64*64*64
            ind=wword//(64*64)
            wword=wword-ind*64*64
            fie=wword//64
            counter+=1
        if(noheader):
            print('                      {:s}'.format(line),end='')
        else:
            print('{:04d} {:1s} {:02d} {:02d} {:02d} {:02d} {:02d} {:s}'.format(ca,sign,add//64,add%64,ind,fie,opc,line),end='')
passa()
constants=[]
for c in const:
        line = '{:10s} CON  {:d} \n'.format(c,const[c])
        ca=counter
        n = const[c]
        if n<0:
            sign='-'
            n=-n
        else:
            sign='+'
        add=n//(64**3)
        n=n-add*(64**3)
        ind=n//64
        n=n-ind*64
        fie=n//64
        opc=n-fie*64
        counter+=1
        symbols[c]=ca
        print('{:04d} {:1s} {:02d} {:02d} {:02d} {:02d} {:02d} {:s}'.format(ca,sign,add//64,add%64,ind,fie,opc,line),end='')
print('                      * SYMBOL TABLE')
for s in symbols:
    print('                      {:10s} EQU  {:d}'.format(s,symbols[s]))
