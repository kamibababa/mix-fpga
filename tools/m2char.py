#!/usr/bin/python3
import sys
def charcode(a):
    if (a==0):
        return ' '
    if (a<10):
        return chr(ord('A')+(a-1))
    if (a==10):
        return '#'
    if (a<20):
        return chr(ord('I')+(a-10))
    if (a==20):
        return '#'
    if (a==21):
        return '#'
    if (a<30):
        return chr(ord('Q')+(a-20))
    if (a<40):
        return chr(ord('0')+(a-30))
    if (a==40):
        return '.'
    if (a==41):
        return ','
    if (a==42):
        return '('
    if (a==43):
        return ')'
    if (a==44):
        return '+'
    if (a==45):
        return '-'
    if (a==46):
        return '*'
    if (a==47):
        return '/'
    return '#'



for line in sys.stdin:
    line2 = line.strip()
    line = line2.split()
    if (len(line)>6) and (line[0].isnumeric()):
            if (line[1].isnumeric()):
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
                                        print(charcode(b1)+charcode(b2)+charcode(b3)+charcode(b4)+charcode(b5),end='')
