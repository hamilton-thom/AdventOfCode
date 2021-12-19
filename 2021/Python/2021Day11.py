# -*- coding: utf-8 -*-
"""
Created on Sat Dec 11 06:33:00 2021

@author: choes
"""


input = """6318185732
1122687135
5173237676
8754362612
5718474666
8443654137
1247634346
1446514585
6717288267
1727871228"""


import numpy as np

inputEnergy = np.array([[int(n) for n in line] for line in input.split("\n")])

adjacentStartPoints = [(i, j) for i in [-1, 0, 1] for j in [-1, 0, 1] if i != 0 or j != 0]    

def getAdjacentCells(row, column):
    return [(row + x, column + y) for (x, y) in adjacentStartPoints if (row + x) >= 0 and (row + x) <= 9 and (column + y) >= 0 and (column + y) <= 9]

flashCount = 0

def runFlash(input):
    flashingCells = []
    for row in range(len(input)):
        for column in range(len(input[0])):
            if input[row, column] > 9:
                flashingCells.append((row, column))
    
    input[input > 9] = 0
    
    for (row, column) in flashingCells:
        for (adjR, adjC) in getAdjacentCells(row, column):
            if input[adjR, adjC] > 0:
                input[adjR, adjC] += 1
    
    return len(flashingCells)


def runCycle(input):
    input += 1
    
    flashCount = 0
    
    while True:
        thisFlashCount = runFlash(input)
        if thisFlashCount > 0:
            flashCount += thisFlashCount
        else:
            break
    
    return flashCount

totalFlashCount = 0

for _ in range(100):
    print(inputEnergy)
    totalFlashCount += runCycle(inputEnergy)    
    print(totalFlashCount)


# Reset:
    
inputEnergy = np.array([[int(n) for n in line] for line in input.split("\n")])

step = 0
while np.max(inputEnergy) > 0:
    runCycle(inputEnergy)    
    step += 1
    
print (step)