# -*- coding: utf-8 -*-
"""
Created on Tue Dec 21 07:02:03 2021

@author: hamil
"""

# Player 1 start, player 2 start
input = (8, 9)


class Die():
    def __init__(self):
        self.nextRoll= 1
        self.rollCount = 0
    
    def roll3(self):
        nextRoll = self.nextRoll
        
        if nextRoll < 98:
            answer = (nextRoll + 1)  * 3
            self.nextRoll += 3
        elif nextRoll == 98:
            answer = 3 * 99
            self.nextRoll = 1
        elif nextRoll == 99:
            answer = 99 + 100 + 1
            self.nextRoll = 2
        elif nextRoll == 100:
            answer = 100 + 1 + 2
            self.nextRoll = 3
        
        self.rollCount += 3
        return answer



def game(p1, p2):
    
    p1Score = 0
    p2Score = 0
    
    # Move so do everything mod 10.
    p1 -= 1
    p2 -= 1 
    
    player = 1
    
    die = Die()
    
    while max(p1Score, p2Score) < 1000:
        
        roll = die.roll3()
        if player == 1:            
            p1 = (p1 + roll) % 10
            p1Score += p1 + 1
        else:
            p2 = (p2 + roll) % 10
            p2Score += p2 + 1
                
        player = 1 - player
            
    return (p1Score, p2Score, die)

p1Score, p2Score, die = game(*input)

part1 = die.rollCount * min(p1Score, p2Score)


# List of scores (index of the list is the score amount)
# Value at index i is a dict of {(position, rollNumber): count}
# Dictionaries. As you progress through the game, iterate up.
# At the end of the gane, count the number of cases where p1

def nextPosition(currentPosition, move):
    return (((currentPosition - 1) + move) % 10) + 1


allRolls = [i+j+k for i in range(1,4) for j in range(1, 4) for k in range(1,4)]

rollsDict = {}
for i in allRolls:
    if i in rollsDict:
        rollsDict[i] += 1
    else:
        rollsDict[i] = 1


def computeGame(startPosition, winCondition = 21):
    """Iteratively calculates the paths which lead to a (Position, Move) 
    combination - at the score indicated by the index in the list."""
    # (Position, Move) : Count - index in list is their score
    gameCounts = [{(startPosition, 0) : 1}]
    for _ in range(30):
        gameCounts.append({})
    
    for score in range(winCondition):
        # Progress the current score to all potential eventualities.        
        for (currentPosition, currentMove), count in gameCounts[score].items():
            newMove = currentMove + 1
            for roll, rollCount in rollsDict.items():
                newPosition = nextPosition(currentPosition, roll)
                newScore = score + newPosition
                
                scoreDict = gameCounts[newScore]
                if (newPosition, newMove) in scoreDict:
                    scoreDict[(newPosition, newMove)] += count * rollCount
                else:
                    scoreDict[(newPosition, newMove)] = count * rollCount
    
    return gameCounts


def winLossCounts(game):
    """Calculate counts of positions at each move, and whether 
    they're a win position or a loss (not yet won) position"""
    winCounts = {}
    lossCounts = {}
    for i in range(len(game)):
        thisDict = game[i]
        for (_, move), count in thisDict.items():
            if i >= 21:
                if move in winCounts:
                    winCounts[move] += count
                else:
                    winCounts[move] = count
            else:
                if move in lossCounts:
                    lossCounts[move] += count
                else:
                    lossCounts[move] = count
    return winCounts, lossCounts


def universeCounts(p1, p2):
    """Calculate the count of universes where each player wins.
    Player 1 wins are when player 2 hasn't won in the previous round.
    Player 2 wins when player 1 hasn't won in the current round."""
    game1 = computeGame(p1)
    game2 = computeGame(p2)
    
    winCounts1, lossCounts1 = winLossCounts(game1)
    winCounts2, lossCounts2 = winLossCounts(game2)
    
    p1Universes = 0
    p2Universes = 0
    
    for move, count in winCounts1.items():
        p1Universes += count * lossCounts2[move-1]
    
    for move, count in winCounts2.items():
        p2Universes += count * lossCounts1.get(move, 0)
    
    return p1Universes, p2Universes

# Part 2
# The example given online
universeCounts(4, 8)

# My inputs
universeCounts(8, 9)
