

input = """inp w
mul x 0
add x z
mod x 26
div z 1
add x 12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 7
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 11
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 12
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -3
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 14
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -9
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -7
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 1
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -11
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -4
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 15
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 14
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 12
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 1
add x 11
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 2
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -8
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 13
mul y x
add z y
inp w
mul x 0
add x z
mod x 26
div z 26
add x -10
eql x w
eql x 0
mul y 0
add y 25
mul y x
add y 1
mul z y
mul y 0
add y w
add y 13
mul y x
add z y"""

inputSplit = input.split("\n")

import re
import math
import itertools

class Instruction:
    """state is always assumed to be a dict of {"w", "x", "y", "z"} values"""
    
    def __init__(self, instruction):        
        if instruction[:3] == "inp":
            self.instruction = "inp"
            self.a = instruction[4]
            self.b = ""
            self.b_type = ""
            
            return
        
        self.instruction, self.a, b_temp = re.match("([a-z]{3,3}) ([wxyz]) ([wxyz]|[-]{0,1}[0-9]+)", instruction).groups()     
        
        try:
            self.b = int(b_temp)
            self.b_type = "integer"
        except:
            self.b = b_temp
            self.b_type = "variable"
            
    def __str__(self):
        return f"{self.instruction} {self.a} {self.b}"

    def __repr__(self):
        return str(self)
        
    def process(self, state, input):
        if self.instruction == "inp":
            self.inp(state, input)    
        elif self.instruction == "mod":
            self.mod(state)
        elif self.instruction == "div":
            self.div(state)
        elif self.instruction == "add":
            self.add(state)
        elif self.instruction == "sub":
            self.sub(state)
        elif self.instruction == "mul":
            self.mul(state)
        elif self.instruction == "eql":
            self.eql(state)
        else:
            raise ValueError(f"Unrecognised instruction type {self.instruction}")
            
    
    def inp(self, state, input):
        a = self.a
        state[a] = input
    
    
    def mod(self, state):
        a = state[self.a]
        if self.b_type == "integer":
            b = self.b
        else:
            b = state[self.b]
        
        if a < 0:
            raise ValueError("a is less than zero in mod - should never happen")
        elif b <= 0:
            raise ValueError("b is less than or equal to zero in mod - should never happen")
        
        state[self.a] = a % b
    
    
    def add(self, state):
        a = state[self.a]
        if self.b_type == "integer":
            b = self.b
        else:
            b = state[self.b]
        
        state[self.a] = a + b
    
    
    def mul(self, state):
        a = state[self.a]
        if self.b_type == "integer":
            b = self.b
        else:
            b = state[self.b]
        
        state[self.a] = a * b
    
    
    def eql(self, state):
        a = state[self.a]
        if self.b_type == "integer":
            b = self.b
        else:
            b = state[self.b]
        
        state[self.a] = 1 if a == b else 0
    
    
    def div(self, state):
        a = state[self.a]
        if self.b_type == "integer":
            b = self.b
        else:
            b = state[self.b]
        
        if b == 0:
            raise ValueError("b is zero in division - should never happen")
        
        if a == 0:
            state[self.a] = 0
        elif a * b > 0:
            state[self.a] = math.floor(a / b)
        else:
            state[self.a] = math.ceil(a / b)


instructions = [Instruction(i) for i in inputSplit]
instructionSets = [instructions[18*i:(18*(i+1))] for i in range(14)]

def runCalculation(instructions, inputs, z):
    state = {l : 0 for l in ["w", "x", "y", "z"]}    
    state["z"] = z
    inputIndex = 0
    for instruction in instructions:
        if instruction.instruction == "inp":
            instruction.process(state, inputs[inputIndex])
            inputIndex += 1
        else:
            instruction.process(state, None)
        
    return state

def runInstructionSets(instructions, zs, targetValues):
    inputInstructions = list(filter(lambda i : i.instruction == "inp", instructions))
    inputCount = len(inputInstructions)    
    listOfLists = [range(1, 10) for i in range(inputCount)]    
    inputValues = itertools.product(*listOfLists)    
    
    results = []
    for ws, z in itertools.product(inputValues, zs):        
        try:
            resultCalc = runCalculation(instructions, ws, z)            
            if resultCalc["z"] in targetValues:            
                results.append((ws, z, resultCalc))
        except:            
            continue
    
    return results    


def buildInstructionSet(lst):    
    return sum([instructionSets[i] for i in lst], [])


# Dict from instructionSet to the space of values which are being targeted.
targetValuesByIS = {14 : {0}}

# Dict from instructionSet to a dict of {i : {(w, z) : z}} values which reach a given target.
resultsByIS = {}

for i in range(13, -1, -1):    
    thisInstructionSet = buildInstructionSet([i])    
    targetValues = targetValuesByIS[i + 1]    
    validInputs = runInstructionSets(thisInstructionSet, range(-10000, 10000), targetValues)
    
    targetValues = set()
    resultsDict = {}
    
    for wInputs, zInput, resultState in validInputs:
        zValue = resultState["z"]
        wInput = wInputs[0]
         
        targetValues.add(zInput)
        resultsDict[(wInput, zInput)] = zValue
    
    targetValuesByIS[i] = targetValues
    resultsByIS[i] = resultsDict

# Part 1
maxNumber = []

for i in range(0, 14):
    results = resultsByIS[i]    
    if i > 0:
        results = {k : v for k, v in results.items() if k[1] in priorMaxFilteredItems}
    
    maxDigit = max(k[0] for k in results)
    maxNumber.append(maxDigit)    
    priorMaxFilteredItems = {v for k, v in results.items() if k[0] == maxDigit}

part1 = "".join([str(i) for i in maxNumber])

# Part 2
minNumber = []

for i in range(0, 14):
    results = resultsByIS[i]    
    if i > 0:
        results = {k : v for k, v in results.items() if k[1] in priorMaxFilteredItems}
    
    minDigit = min(k[0] for k in results)
    minNumber.append(minDigit)    
    priorMaxFilteredItems = {v for k, v in results.items() if k[0] == minDigit}

part2 = "".join([str(i) for i in ])
