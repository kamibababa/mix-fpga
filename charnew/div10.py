#!/usr/bin/python
for a in range(99999999):
    b=a//2 + a//4
    c=b+b//16
    d=c+c//256
    e=d+d//(256*256)
    f=e//8
    r=a-(((f*4)+f)*2)
    if (r>9):
        r=r-10
        f=f+1
    print(a,f,r)
    if (f!=a//10):
        print("error")
