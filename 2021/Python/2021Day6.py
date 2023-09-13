# -*- coding: utf-8 -*-
"""
Created on Mon Dec  6 07:07:10 2021

@author: choes
"""

input = "2,5,5,3,2,2,5,1,4,5,2,1,5,5,1,2,3,3,4,1,4,1,4,4,2,1,5,5,3,5,4,3,4,1,5,4,1,5,5,5,4,3,1,2,1,5,1,4,4,1,4,1,3,1,1,1,3,1,1,2,1,3,1,1,1,2,3,5,5,3,2,3,3,2,2,1,3,1,3,1,5,5,1,2,3,2,1,1,2,1,2,1,2,2,1,3,5,4,3,3,2,2,3,1,4,2,2,1,3,4,5,4,2,5,4,1,2,1,3,5,3,3,5,4,1,1,5,2,4,4,1,2,2,5,5,3,1,2,4,3,3,1,4,2,5,1,5,1,2,1,1,1,1,3,5,5,1,5,5,1,2,2,1,2,1,2,1,2,1,4,5,1,2,4,3,3,3,1,5,3,2,2,1,4,2,4,2,3,2,5,1,5,1,1,1,3,1,1,3,5,4,2,5,3,2,2,1,4,5,1,3,2,5,1,2,1,4,1,5,5,1,2,2,1,2,4,5,3,3,1,4,4,3,1,4,2,4,4,3,4,1,4,5,3,1,4,2,2,3,4,4,4,1,4,3,1,3,4,5,1,5,4,4,4,5,5,5,2,1,3,4,3,2,5,3,1,3,2,2,3,1,4,5,3,5,5,3,2,3,1,2,5,2,1,3,1,1,1,5,1"

inputNumbers = list(map(lambda x : int(x), input.split(",")))

def nextDay(inputDay):
    newFish = [8] * len(list(filter(lambda x: x == 0, inputDay)))
    reducedFish = list(map(lambda x : 6 if x == 0 else x - 1, inputDay))
    return reducedFish + newFish

# Naive part 1
copyInput = inputNumbers
for i in range(80):
    copyInput= nextDay(copyInput)

# Part 2

countDict = {x:0 for x in range(9)}

for i in inputNumbers:
    countDict[i] += 1
    
def nextDayDict(inputDict):
    newFish = inputDict[0]
    
    for i in range(1, 9):
        inputDict[i-1] = inputDict[i]
    
    inputDict[6] += newFish
    inputDict[8] = newFish
    
    return inputDict

copyInput = countDict.copy()
for i in range(256):
    copyInput= nextDayDict(copyInput)

result = sum(copyInput.values())


