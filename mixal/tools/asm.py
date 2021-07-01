#!/usr/bin/python3
import sys

# list of OP-codes and standard field
op_codes={'NOP':(0,0),'ADD':(1,5),'FADD':(1,6),'SUB':(2,5),'FSUB':(2,6),'MUL':(3,5),'FMUL':(3,6),'DIV':(4,5),'FDIV':(4,6),'NUM':(5,0),'CHAR':(5,1),'HLT':(5,2),'SLA':(6,0),'SRA':(6,1),'SLAX':(6,2),'SRAX':(6,3),'SLC':(6,4),'SRC':(6,5),'MOVE':(7,1),'STJ':(32,2),'STZ':(33,5),'JBUS':(34,0),'IOC':(35,0),'IN':(36,0),'OUT':(37,0),'JRED':(38,0),'JMP':(39,0),'JSJ':(39,1),'JOV':(39,2),'JNOV':(39,3),'JL':(39,4),'JE':(39,5),'JG':(39,6),'JGE':(39,7),'JNE':(39,8),'JLE':(39,9)}

# list of Symbols
symbols = {}
futures = []
cons = []
line_number = 0

# command line
if (len(sys.argv)) != 2:
    print("usage: {:s} <asm-file.mixal>".format(sys.argv[0]))
    sys.exit(0)
mixal_file = sys.argv[1]

# mix char codes
def char_code(c):
    char_codes=" ABCDEFGHIxJKLMNOPQRxxSTUVWXYZ0123456789.,()+-*/=$<>@;:'"
    if c in char_codes:
        return char_codes.index(c)
    print('ERROR CHAR CODE:'+c)
    sys.exit(0)

# comment
def is_comment(expr):
    if len(expr)>0 and expr[0]=='*':
        return True
    return False

#special symbols dH dB dF
def specialsymbol(n):
    if len(n)==2 and n[0].isnumeric():
        global line_number
        counter=symbols['*']
        sp = None
        for s in symbols:
            if s.startswith(n[0]+'H'):
                c=symbols[s]
                ln=int(s[3:])
                if n[1]=='B':
                    if ln<line_number:
                        if (sp == None) or (ln>sp):
                            sp=ln
                elif n[1]=='F':
                    if ln>line_number:
                        if (sp == None) or (ln<sp):
                            sp=ln
                else:
                    print("ERROR: SPECIAL SYMBOL")
                    print(n)
                    sys.exit(-1)
        if sp!=None:
            return symbols['{:1d}H@{:04d}'.format(int(n[0]),sp)]
    return None

# atomic expression
def atomic_expression(expr):
    if expr.isnumeric():
        return int(expr)
    if (expr in symbols):
        return symbols[expr]
    sp = specialsymbol(expr)
    if sp != None:
        return sp
    futures.append(expr)
    return 0

# expression
def expression(expr,i):
    token = ''
    value = 0
    binary_operation = lambda x: x
    while i<len(expr):
        c=expr[i]
        cc = char_code(c)
        if cc==47:
            if char_code(expr[i+1])==47:
                i+=1
                cc=49
        if len(token)==0:
            if cc==44:
                binary_operation = lambda x: value + x
            elif cc==45:
                binary_operation = lambda x: value - x 
            elif ((cc > 0 and cc<=39) or cc==46):
                token = c
            else:
                print('ERROR EXPRESSION1')
                sys.exit(-1)
        else:
            if (cc > 0 and cc<=39):
                if (token=='*'):
                    print('ERROR EXPRESSION2')
                    sys.exit(-1)
                token = token + c
            else:
                value = binary_operation(atomic_expression(token))
                token = ''
                if cc==0 or cc==41 or cc==42 or cc==43:
                    return (value,i)
                if cc==44:          # addition
                    binary_operation = lambda x: value + x
                elif cc==45:        # subtraction
                    binary_operation = lambda x: value - x
                elif cc==46:        # multiplikation
                    binary_operation = lambda x: value * x
                elif cc==47:        # division
                    binary_operation = lambda x: value // x
                elif cc==49:        # division
                    binary_operation = lambda x: value * 0o10000000000 // x
                elif cc==54:        # :
                    binary_operation = lambda x: value * 8 + x
                else:
                    print('ERROR EXPRESSION3')
                    sys.exit(-1)
        i+=1

# opcode
def opcode(op):
    if (op in op_codes):
        return op_codes[op]
    elif (op.startswith('LD')):
        return (8+reg(op[2]),5)
        if (op[3]=='N'):
            opc+=8
    elif (op.startswith('ST')):
        return (24+reg(op[2]),5)
    elif (op.startswith('J')):
        return (40+reg(op[1]),jump(op[2:4]))
    elif (op.startswith('CMP')):
        return (56+reg(op[3]),5)
    elif (op.startswith('ENT')):
        return (48+reg(op[3]),2)
    elif (op.startswith('ENN')):
        return (48+reg(op[3]),3)
    elif (op.startswith('INC')):
        return (48+reg(op[3]),0)
    elif (op.startswith('DEC')):
        return (48+reg(op[3]),1)
    print('ERROR OP')
    sys.exit(-1)

# Register A,1,2,3,4,5,6,X
def reg(r):
    if r=='A':
        return 0
    if r=='X':
        return 7
    n=char_code(r)-char_code('0')
    if (n>0 and n<7):
        return n
    print('ERROR OP')
    sys.exit(-1)

# Jump instruction
def jump(j):
    if j=='N':
        return 0
    if j=='Z':
        return 1
    if j=='P':
        return 2
    if j=='NN':
        return 3
    if j=='NZ':
        return 4
    if j=='NP':
        return 5
    if j=='E':
        return 6
    if j=='O':
        return 7
    print('ERROR OP')
    sys.exit(-1)

# address expression
def a_expr(address,default):
    (c,f) = default
    i=0
    if address[0]==' ':
        (a,p)=(0,0)
    elif address[0]=='=':
        p = address[1:].index('=')
        (a,p)=atomic_expression(address[0:p+1]),p+2
    else:
        (a,p) = expression(address,0)
    if (address[p]==','):
        (i,p) = expression(address,p+1)
    if address[p]=='(':
        (f,p) = expression(address,p+1)
        if address[p]!=')':
            print('ERROR A_EXPRESSION1')
            sys.exit(-1)
        p=p+1
    if (address[p]==' '):
        return (a,i,f,c)
    print('ERROR A_EXPRESSION2'+address[p])
    sys.exit(-1)

# MIX store command
def store(w,x,f):
    f1=f//8
    f2=f%8
    if f1==0:
        f1=1
        sign=(x<0)
        if f2==0:
            f2=1
    else:
        sign=(w<0)
    w='{:010o}'.format(abs(w))
    x='{:010o}'.format(abs(x))
    mw = int(w[0:(f1-1)*2]+x[(f1+4-f2)*2:10]+w[f2*2:10],8)
    if sign:
        return -mw
    return mw

# full MIX word
def w_expr(address):
    w=0
    i=0
    while True:
        (x,i) = expression(address,i)
        if address[i]=='(':
            (f,i) = expression(address,i+1)
            if address[i]==')':
                i=i+1
            else:
                print('ERROR FIELD')
                sys.exit(-1)
        else:
            f = 5
        w=store(w,x,f)
        if address[i]==' ':
            return w
        elif address[i]==',':
            i=i+1
    print('ERROR W-EXPR')
    sys.exit(-1)

# alf makro operation
def alf(address):
    a = char_code(address[0])*64+char_code(address[1])
    i = char_code(address[2])
    f = char_code(address[3])
    c = char_code(address[4])
    return (a,i,f,c)

# constants
def constants():
    for s in futures:
        if not(len(s)==2 and (s[1]=='B' or s[1]=='F')):
            if s not in symbols:
                cons.append(s)
                symbols[s] = symbols['*']
                symbols['*'] = symbols['*']+1
                if s[0]=='=':
                    v=w_expr(s[1:]+' ')
                else:
                    v=0
    return cons

# assembler
def assembler(fin,fout):
    global line_number
    line_number = 0
    next_loc = 0
    for line in fin:
        symbols['*']=next_loc
        line_number+=1
        (a,i,f,c) = (0,0,0,0)
        printcomment=False
        printequ=False
        if is_comment(line):
            line=line.strip()
            printcomment=True
        else:
            spl=line.split()
            if line[0]==' ' or line[0]=='\t':
                spl=['']+spl
            loc = spl[0]
            op = spl[1]
            if len(spl)<3:
                address='     '
            elif op=='ALF':
                address = line[line.index('ALF')+5:line.index('ALF')+10]
            else:
                address = spl[2]+' '
            if len(loc)>0:
                if len(loc)==2 and loc[1]=='H':
                    loc='{:2s}@{:04d}'.format(loc,line_number)
                symbols[loc] = symbols['*']
            if (op=='EQU'):
                symbols[loc] = w_expr(address)
                printequ=True
            elif (op=='ORIG'):
                next_loc = w_expr(address)
                printequ=True
            elif (op=='CON'):
                word = w_expr(address)
                if word < 0:
                    sign = '-'
                    word = -word
                else:
                    sign='+'
                a = word // 0o1000000
                i = (word % 0o1000000 )//0o10000
                f = (word % 0o10000)//0o100
                c = (word % 0o100 )
                next_loc=symbols['*']+1
            elif (op=='ALF'):
                (a,i,f,c) = alf(address)
                next_loc=symbols['*']+1
            elif (op=='END'):
                trans = w_expr(address)
                cons=constants()
                for s in cons:
                    if (s[0]=='='):
                        word = w_expr(s[1:]+' ')
                    else:
                        word=0
                    if word < 0:
                        sign = '-'
                        word = -word
                    else:
                        sign='+'
                    a = word // 0o1000000
                    i = (word% 0o1000000 )//0o10000
                    f = (word% 0o10000)//0o100
                    c = (word%0o100 )
                    print('{:04d} {:s} {:04d} {:02d} {:02d} {:02d}      {:10s} {:4s} {:d}'.format(symbols[s],sign,a,i,f,c,s,'CON',word),file=fout)
                if (len(loc)>0):
                    symbols[loc] = symbols['*']
                print('                     {:04d} {:10s} {:4s} {:s}'.format(line_number,loc,op,address),file=fout)
                return trans
            else:
                (c,f) = opcode(op)
                (a,i,f,c) = a_expr(address,(c,f))
                if (a<0):
                    sign='-'
                    a=-a
                else:
                    sign='+'
                next_loc=symbols['*']+1
        if printcomment:
            print('                     {:04d} {:s}'.format(line_number,line),file=fout)
        elif printequ:
            print('                     {:04d} {:10s} {:4s} {:s}'.format(line_number,loc,op,address),file=fout)
        else:
            print('{:04d} {:s} {:04d} {:02d} {:02d} {:02d} {:04d} {:10s} {:4s} {:s}'.format(symbols['*'],sign,a,i,f,c,line_number,loc,op,address),file=fout)

                 
#print symbol table
def symbol_table(fout):
    print('                          * SYMBOL TABLE',file=fout)
    for s in symbols:
        print('                          {:10s} EQU  {:d}'.format(s,symbols[s]),file=fout)

fin=open(mixal_file,'r')
assembler(fin,None)
fin.close()
fin=open(mixal_file,'r')
fout=open(mixal_file.split('.')[0]+'.mls','w')
trans=assembler(fin,fout)
fin.close()
print('                                     TRANS {:04d}'.format(trans),file=fout)
symbol_table(fout)
fout.close()
