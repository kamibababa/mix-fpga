#!/usr/bin/python
import sys
card=0
l=-1
d=7

print(' O O6 Z O6    I C O4 0 EH A  F F CF 0  E   EU 0 IH G BB   EJ  CA. Z EU   EH E BA\n   EU 2A-H S BB  C U 1AEH 2AEN V  E  ABG  CLU Z EH E BB J B. A  9               ')
#print(' O R6 Z R6    I C R4 0 EH A  F F CF 0  E   EU 0 IH G BB   EJ  CA. Z EU   EH E BA\n   EU 2A-H S BB  C U 1AEH 2AEN V  E  ABG  CLU Z EH E BB J B. A  9               ')
t=''
sa=0
for line in sys.stdin:
    line2 = line.strip()
    line = line2.split()
    if ((len(line)>2) and (line[0]=='***')):
        if (line[1]=='Startadresse:'):
            s=int(line[2])
    if (len(line)>6) and (line[0].isnumeric()):
            if (line[1].isnumeric()):
                m = int(line[1])
                if d==7 or l!=m:
                    card=card+1
                    t="{:05d}".format(card)+str(d)+t
                    t=t+'0'*(80-len(t))
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
                                            wtf = int (t[-1])
                                            if wtf==0:
                                                ppp=' '
                                            else:
                                                ppp=chr(ord('I')+int(t[-1]))
                                            t=t[:-1]+ppp
                                        l=l+1
                                        d=d+1
print('00000'+str(d)+t+('0'*(74-len(t))))
print('TRANS0'+"{:04d}".format(s)+'0'*70)
