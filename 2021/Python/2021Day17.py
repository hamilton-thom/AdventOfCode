# -*- coding: utf-8 -*-
"""
Created on Fri Dec 17 06:20:38 2021

@author: choes
"""

from functools import lru_cache

input = "target area: x=207..263, y=-115..-63"


maxInitialVelocity = 1

# Work out potential X Velocities

inputXs = (207, 263)
inputYs = (-63, -115)


#x=20..30, y=-10..-5
#inputXs = (20, 30)
#inputYs = (-5, -10)

def isValidXVelocity(velocity, targetXs):
    
    startX, endX = targetXs
    xPosition = 0
    while velocity > 0:
        xPosition += velocity
        velocity -= 1
        if startX <= xPosition and xPosition <= endX:
            return True
    
    return False

validXVelocities = [x for x in range(1000) if isValidXVelocity(x, inputXs)]


@lru_cache
def validXPosition(startVelocity, move):
    """Assumes that only valid startVelocities are provided"""
    xPosition = 0
    left, right = inputXs
    for i in range(move):
        xPosition += startVelocity
        if startVelocity > 0:
            startVelocity -= 1
    
    return xPosition <= right
        

stepsWhenInXRange = set()
for velocity in validXVelocities:
    startX, endX = inputXs
    xPosition = 0
    moveCount = 0
    while velocity > 0:
        xPosition += velocity
        velocity -= 1
        moveCount += 1
        if startX <= xPosition and xPosition <= endX:
            stepsWhenInXRange.add(moveCount)
        
        if xPosition > endX:
            break

# X Value between 1 and 22 => total steps less than 22.
# Y Values

def isValidYValue(velocity, targetYs):
    
    startY, endY = targetYs
    maxPosition = 0
    
    targetMax = []
    
    for xVelocity in validXVelocities:
        step = 0
        yVelocity = velocity
        yPosition = 0
        maxPosition = 0
        
        while validXPosition(xVelocity, step):
            yPosition += yVelocity
            if yPosition > maxPosition:
                maxPosition = yPosition
            yVelocity -= 1
            step += 1        
            if startY >= yPosition and yPosition >= endY:
                targetMax.append((xVelocity, yVelocity, maxPosition))
            if yPosition < endY:
                break
    
    return targetMax
    

def xPosition(velocity, step):
    maxStep = min(step, velocity)
    sumTotal = maxStep * (maxStep + 1) // 2
    return (maxStep + 1) * velocity - sumTotal
    

def yPosition(velocity, step):        
    sumTotal = step * (step + 1) // 2
    return (step + 1) * velocity - sumTotal



potentialYValues = [y for y in range(-200, 200) if len(isValidYValue(y, inputYs)) > 0]

validVelocities = set()

for x in validXVelocities:
    for y in potentialYValues:
        step = 0
        while yPosition(y, step) >= inputYs[1] and xPosition(x, step) <= inputXs[1]:
            if (yPosition(y, step) >= inputYs[1] and yPosition(y, step) <= inputYs[0]):
                if (xPosition(x, step) <= inputXs[1] and xPosition(x, step) >= inputXs[0]):
                    validVelocities.add((x, y))
            step += 1
            