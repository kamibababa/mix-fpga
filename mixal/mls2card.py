#!/usr/bin/python
import sys
card=0
l=-1
d=7
t=''
for line in sys.stdin:
    line2 = line.strip()
    line = line2.split()
    if (len(line)>6) and (line[0].isnumeric()):
            if (line[1].isnumeric()):
                m = int(line[1])
                if d==6 or l!=m:
                    card=card+1
                    t="{:05d}".format(card)+str(d)+t
                    t=t+'0'*(70-len(t))
                    if l>0:
                        print(t)
                    d=0
                    l=m
                    t="{:04d}".format(m)
                if (line[2] in ['+','-']):
                    if (line[2]=='-'):
                        s=1
                    else:
                        s=0
                    if (line[3].isnumeric()):
                        b1=int(line[3])
                        if (line[4].isnumeric()):
                            b2=int(line[4])
                            if (line[5].isnumeric()):
                                b3=int(line[5])
                                if (line[6].isnumeric()):
                                    b4=int(line[6])
                                    if (line[7].isnumeric()):
                                        b5=int(line[7])
                                        code=b5+64*(b4+64*(b3+64*(b2+64*b1)))
                                        t=t+"{:010d}".format(code)
                                        if (s==1):
                                            ppp=chr(ord('I')+int(t[-1]))
                                            t=t[:-1]+ppp
                                        l=l+1
                                        d=d+1
print('LAST '+str(d)+t)
