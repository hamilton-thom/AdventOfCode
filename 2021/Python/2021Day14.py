# -*- coding: utf-8 -*-
"""
Created on Tue Dec 14 07:02:45 2021

@author: choes
"""



input = """FV -> C
CP -> K
FS -> K
VF -> N
HN -> F
FF -> N
SS -> K
VS -> V
BV -> F
HC -> K
BP -> F
OV -> N
BF -> V
VH -> V
PF -> N
FC -> S
CS -> B
FK -> N
VK -> H
FN -> P
SH -> V
CV -> K
HP -> K
HO -> C
NO -> V
CK -> C
VB -> S
OC -> N
NS -> C
NF -> H
SF -> N
NK -> S
NP -> P
OO -> S
NH -> C
BC -> H
KS -> H
PV -> O
KO -> K
OK -> H
OH -> H
BH -> F
NB -> B
FH -> N
HV -> F
BN -> S
ON -> V
CB -> V
CF -> H
FB -> S
KF -> S
PS -> P
OB -> C
NN -> K
KV -> C
BK -> H
SN -> S
NC -> H
PK -> B
PC -> H
KN -> S
VO -> V
FO -> K
CH -> B
PH -> N
SO -> C
KH -> S
HB -> V
HH -> B
BB -> H
SC -> V
HS -> K
SP -> V
KB -> N
VN -> H
HK -> H
KP -> K
OP -> F
CO -> B
VP -> H
OS -> N
OF -> H
KK -> N
CC -> K
BS -> C
VV -> O
CN -> H
PB -> P
BO -> N
SB -> H
FP -> F
SK -> F
PO -> S
KC -> H
VC -> H
NV -> N
HF -> B
PN -> F
SV -> K
PP -> K"""

startString = "PFVKOBSHPSPOOOCOOHBP"


inputSplit = {s.split(" -> ")[0] : s.split(" -> ")[1] for s in input.split("\n")}



def iterate(start):
    end = start[0]
    
    for i in range(len(start)-1):
        nextPair = start[i:i+2]
        end += inputSplit[nextPair]
        end += start[i+1]
    
    return end


part1 = startString
for _ in range(10):
    part1 = iterate(part1)

elementCounts = {}

for i in part1:
    if i in elementCounts:
        elementCounts[i] += 1
    else:
        elementCounts[i] = 1


def startPairs(string):
    output = {}
    
    for i in range(len(string) - 1):
        thisPair = string[i:i+2]
        if thisPair in output:
            output[thisPair] += 1
        else:
            output[thisPair] = 1
    
    return output
    
part2 = startPairs(startString)

def part2Iteration(startDict):
    
    newDict = startDict.copy()
    for pair in startDict:
        newVal = inputSplit[pair]
        
        pair1 = pair[0] + newVal
        pair2 = newVal + pair[1]        
        if pair1 not in newDict:
            newDict[pair1] = 1
        else:
            newDict[pair1] += 1
        
        if pair2 not in newDict:
            newDict[pair2] = 1
        else:
            newDict[pair2] += 1

    return newDict


def minMinusMax(startDict):
    
    elementCounts = {}
    for k, v in startDict.items():
        letter1 = k[0]
        letter2 = k[1]
        
        if letter1 in elementCounts:
            elementCounts[letter1] += v
        else:
            elementCounts[letter1] = v
            
        if letter2 in elementCounts:
            elementCounts[letter2] += v
        else:
            elementCounts[letter2] = v
        
    return elementCounts



part1Again = startPairs(startString)
for _ in range(10):
    print(sum(part1Again.values()))
    part1Again = part2Iteration(part1Again)
    
    
print(minMinusMax(part1Again))














