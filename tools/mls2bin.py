#!/usr/bin/python3
import sys

if (len(sys.argv)) != 2:
    print("usage: {:s} <filename>".format(sys.argv[0]))
    sys.exit(0)
else:
    fin = open(sys.argv[1],"r")
    fout = open(sys.argv[1].split(".")[0]+".bin","w")

l=0
for line in fin:
    line2 = line.strip()
    line = line2.split()
    if (len(line)>6) and (line[0].isnumeric()):
            sc=int(line[0])
            if (line[1].isnumeric()):
                m=int(line[1])
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
                                        code=b5+64*(b4+64*(b3+64*(b2+64*(b1+64*s))))
                                        
                                        while(l<m):
                                            l=l+1
                                            print('0000000000000000000000000000000',file=fout)
                                        print(format(code,'031b'),file=fout)
                                        l=l+1
    #else:
        #print("//"+line2)

