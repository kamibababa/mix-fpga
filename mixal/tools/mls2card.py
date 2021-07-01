#!/usr/bin/python3
import sys

if (len(sys.argv)) != 2:
    print("usage: {:s} <filename>".format(sys.argv[0]))
    sys.exit(0)
else:
    fin = open(sys.argv[1],"r")
    fout = open(sys.argv[1].split(".")[0]+".card","w")

loadin= open ('../1.3.1.ex26/l.card','r')
for card in loadin:
    print(card,end='',file=fout)
e=''
c=0
data=''
for line in fin:
    if len(line)>0 and line[0]!=' ':
        line=line.strip().split()
        a=int(line[0])
        sign = line[1]=='-'
        w=0
        for i in range(4):
            w=w*64+int(line[i+2])
            ws = '{:010d}'.format(w)
            if sign:
                d=int(ws[9])
                if d==0:
                    ws=ws[0:9]+' '
                else:
                    ws=ws[0:9]+chr(ord('I')+d)
        if c==0:
            l='{:04d}'.format(a)
            data=ws
            c=1
        elif c==7:
            print('     {:1d}{:s}{:s}'.format(c,l,data),file=fout)
            l='{:04d}'.format(a)
            data=ws
            c=1
        elif a==int(l)+c:
            data=data+ws
            c=c+1
        else:
            data=data+(70-len(data))*'0'
            print('     {:1d}{:s}{:s}'.format(c,l,data),file=fout)
            l='{:04d}'.format(a)
            data=ws
            c=1
    elif len(line)>0:
        line=line.strip().split()
        if len(line)==2:
            if line[0]=='TRANS':
                data=data+(70-len(data))*'0'
                print('     {:1d}{:s}{:s}'.format(c,l,data),file=fout)
                t=int(line[1])
                print('TRANS0{:04d}{:070d}'.format(t,0),file=fout)
