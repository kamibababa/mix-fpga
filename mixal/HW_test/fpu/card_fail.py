#!/bin/python3
import sys
import random

for line in sys.stdin:
    print(line[0:20]+60*'0')
