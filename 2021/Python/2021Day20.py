# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""


# Inputs from the website:
enhancementInput = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#"

input = """#..#.
#....
##..#
..#..
..###"""

# Inputs from my puzzle:
enhancementInput = "##..#.#...##.####..#..###.#.#.#.#.####.#.##.....#####.##..#..#.#.##.......##.##.#.#...#....#.####..#.##.##....###..##.#####.##....##.#.#.#.#....####...##.#......#.#..##......##..#..###.#..####.###...##.#.##.#..##.##..#.#.#..###..##.####.#.#.#..#.##...#..##...##.#####..##.##..#...#..###.#.#...#..#..##...#.#..........#...#...#.#.#.#..#.###..##....####..#######.##.#.....#.#.###...##...###...#.##.##.##..#......#.###...#.#.#.#...##.#.#.##.#..###.#...##...##.......####.##..#.#....#.#####..#..#####.#.....#....#.#."

input = """.##.#...##..##.#..........#####..#.##..######.##..#....#..#####.#.#####.#..#...#..#####..#.......##.
.#.#.#.#####..##.#.###..#.##.##.......#.####.#............#.#....####..#.#####.##.##.#.###..#..##...
.##.#.#...##....#.#..#...........##.#.#..#####...#..##.###..##.###..........#####..##..##.#.####....
##..####.####.###.......#....#.#####.##...#....###...##...###...#...##..####....####..#####..##..###
...###.##.....#......###.#.###..#..###...#.#..#.#######.##..#..#..#..##.##..#####.#####.###...#.###.
##.###.#....##..####.#..#.###.##.#.##..#...#...###.###.#..#..#.#.###.##.#..###.#.###....###.###.....
#.#.##..#.....#.....##....######...#........#.#.#.#.######..#...##.#.######...#.##########..#.###..#
.##.#...##.#......###..####.##.#...#..##.#.####...##..####..#####..##.###.#.###...#.#.######.#.#####
..#..##..#.#.#...####..###.#..#...#..#.#.#.#.###..####.#...#......#..#..####.#...#.#.#......#...#..#
#...###..#.#.###.#.##.##.#.#.#####....#....#.....#####...#..#..#.#####..##.....#..###.#..###.#..#...
..##.#.#..##.#.#...#...#.#.#..#.#.##....#####....#.##...#..#..#.#....###...##..#.#.##.##.#.......#.#
##.##.#######.###.#..#....#..##..#.###.....#.###..#.#..#....#.#..###.##.#.....#.#.#.##.#...#..##.#..
.....#.#.#.#.####.#..####.#....##.###.###...########.#.#....#..##.#.#####...##....##....#.......#.#.
##..#...#..#.#.####..#.#..####.#####.#####.###..#.#####.#..#...##.######.###.#..#.##.#.#..#..#.####.
#.##.##.#.####...#.#.#.#..####.#.#...###...#.#....##...####.#..#####.#.####.#..#.....###.#..#...#.#.
.#..#.##...####...##.####...###..####.##........#.#.##..#..#.##...#....##.#.#..#.#.###...##.......#.
..#..#..#.###.##...###....#.#..#..##..#...###.###...#..#.....#..#.####.#.#.#.##..###...#....##.#.###
###.##....##.#.##..####.#.###...###.###.#####..##.###.....#.#####....#.##..##.#####.##..###....#....
###..#...###..#....#..#.#...#....###.#.####.##..#.#..#.###..#..#.##.#.#.......#...#....#...###..#.##
#...#.#.#...#.####.##.#.#..#...##.....#..##....#..#.##..##.####.#.#.###..##..#.#.#.###.#.#..####..##
.###..###.##..###..#..#.##..#...#.##.#.......####.#..##.#...#.##..#..........##..####..##.###..###..
###.#.#...###..#...#####.####..#..#######.#.#.###.##.###.#.####.##.#####..###.#####.#...####.##..##.
.##..##..##.#...######.###...#.##.##....##.#...##.#####.#...##..#.#...#.#..#.##.#....##.####.#.##.#.
...####..#...#...####.#.#...#...###..#.##...####.#..######.##.....##..#...#...####.###.#..##.##..#..
#.#####.##.##..#..##.#.####..##.#.#...#..####.##..###.####.##.##...#.#...#.#.#####.####.#.###..#..#.
..#.....#..##..#...#####..##.###..##.#..##..##..####.#..#.####.###...#####.#.###.....#..#.####.#.##.
#####....###..##.#.######.#.##..##.#.#####.##########.#...##...###....###.#.....#.....###.#.#.#.##.#
##.....#.###.###.#.##.########....##.##.###...#######..##..#.#.#..#.##..####..#.###.#.###.#.#......#
..##..#...#.#.#.#.###.#..#####.#.#..#......####..#.###..###...##...##.##..#..#..#.##.#..###..##.#.#.
.#.#..#..###.##.#.#...#.#...##...#.###..#.#.##.#....#..####..#.#.##.#..#...##.#.....##...####.....#.
##.#..##...#..##.####.##....##..#####.###...#..######..#....#..#######..#..#.####.#...##.##..##..#..
..##.#.###....#..#.....#..#.#.#.#........#..##.#.#.......####.##...#.#.##.######..##..#....#.#......
.....#....#.#.##...#..######.###.###.##....##.#.##.###.....#..#.#....#####.#..##.#.....#..#.##....##
##.....#.#...####...##.##.#.##.#.##......#.#########.#.##..##...###.##.#..#....#..##.####..#######..
##...#.########.###.#....#...#..##.##.###....##...#####..##.####..##..#..#####.#..######.####...#.#.
##.####..##.#####..#..###...##.......#...#.###.#.#..#..#....#.#..##.....#.#....####.###...#.#..##.#.
#.#.#.#.###..#.#####.#...##...#.###.##..#.#####.....#...#.#.#..#...##....#...####.####.##.#.....####
..###.##.#......#######..#...##..###.##....#....#.#..###...#..###.#.#...#..##...####.###.###..#.#.##
.#..#.#.##..###########.#.#..#.###.######...###.##..#.###..##.#...#.#...###.#.##.##.#..#..#..#.#...#
.#..#.#..##....#....####.#..##....#.###.####..#.##.#.#..###.#.##.#........##.#...###.#.......##.#...
...###.#.#.##.##.##.....#.#.#..#..#.##.#######...##....#.#......##....##.#.####.####.###.#....##..#.
.#.##..#.##.##.####.....##...#..###.###.###..#..##.####..##...#.###.##..##..#####.#..###....###.##.#
#.###...#####.#..#.####...##.#..#...######.....#.#....##.#.#...##....#...........##.##.##.#...######
##..#..##.....##..#.#..##.##.#..#...####.######.......###..#..##.##..##..##..###..##.##.#.#.....#...
#......###..#####..#######.#.#..#.###..##.#..##.##.##.#..###.###..##.##.....#.#..####.#.##...##..###
.##...#..###..##..#.#####.#####.###...#.........#.##.##.###.#.#.#...###.#..###.##.##.#..#..#...###.#
#.###.###.###.#.###.#.##....##..##.......#....##.###.###.#.###..#..###.#.##.##..#.#...######.####..#
..#####.###.##.#..##.##.#..#.###..#.####....#...##.#.......#.#..##.#.......##.##.#######...######.##
#.##...###..#..##.....#.#.##.#..##...##.#####..#...##...#..#.####.#.##.##.#....##.###.#.##..##..#.#.
..#.###.#.##...#..##.#..####.###..#####.##.####.#.##..####.###..##..#...#.##...#.###....####...####.
.###.....###.#....######.#####..#..#..#.#.#..#..#.###.#........##.###...#...##..#..#...#.....#.###.#
..###.##.#.#####.#..########..##..##.#..###.#.##.#....#.###........#....#...#.#...##.#.##..#..##.##.
###.#.#.#...#..##....#.##....##.#######.#.##.#.##....#....###.#.#.....#.##..###..##..#..##..#.#..##.
.#.##..#.##..##.##.##..#.###.#..##.###.#.###.##......##.#...##.##..##...##.#...##.#..#..#.##..#.##..
####..####.###..#..#####...###.#....###.#...##........#.#...#..#.#.###..####.#.#.######...#..##.#.#.
#...#..#.##..#.#.#.#.#...##.#.##..#...#.###.###.#....##.#..##.#.###..##....#.###.#.##..#..##....#...
#.###.#.##.###.#..#...####.#....#..#.#####.#...#.###.##.##.###.###..#...#.#.####..###..........##.#.
##.##.#.###.#.##.####...###.#.###..###...####..#####.###...#.##...###.##..#.####.#.##...#....##.#.##
#....#..##.##.##......##...##.##..#####...#.##.###.##...##..##..###..#..#..#...###.##.#..#..#.#...##
###.####.....#.#....####..#.##.........#....##.....#....##.#..##.##..####..###.####.#...##....##.##.
#.......###.#..####.##..#..##...#....###...##.......##.....###.######.#..#..##..#....#.###.#..##.###
#.###.##..##..##.##...#.........####..####..#..##...##.#..#..#######.###...#......#.##.####.#..##...
#.####...##.#...#.#.###...##...#....#.##.##.####.#.#....###....#...#........##.##..#.#.####..#.#.#..
.#..###.#..#.....##..#..#.###..###.#.##...#.#.....#...#....#.##.#..#.#...#..#.#..###..#.#...###.....
.####....####....#.#.....#..#.#.##........#..#.####.##.##...#.#.####.#..#.##..##..#...#.#.##...#.#.#
#####.#...####.#.####.#...#..#...#.#.##.#..#...##..#.#...##.###.##.#.###.###.#...#..#.###.##.##...#.
#.#....#.###.##..##.##..##.#...#.###....###....###..#.####.###..#.#.##...#..####....#.####...###.#..
.#...#.###.#.####..#.#####...##...#..##........#....#..#.#.##..##.##.#######.#.#.#.##.#.#.#.##..#...
#....#....#.#.##.##.##..###..###.##..#.##.....###.###......#.#....#..#.##......#.###.#..#.#.#.#..###
#####.#####.##...#.#..#..##.####.#......######..####..##.##.##.#.......#...####..#..###.#..##.#.#.#.
#.##...##..##......###...#.#.##...#.#...#..##.###.#..#.##...#.#.#.##.###.##.#####....#...#.....##..#
..##....##..#..##..##...#..#.##.####.##........###..##.##.#.#.##..#..###...#..#...##.#.##.########.#
#...#.#####.###.#....#....#######.###..#..#.#..##..#.###.#.####.##.#..###..#....###.###....###.#..##
.......###.#.#.#..#.#..###...#.##..#..#...#..#....#..#...#.#####.#...##.#.###.###.#..#.##.#..##.....
....#.##...#.##.#.###..#####..#.######.###...###..##.#.#.##.###.##.####..#..#.....#.......#.######.#
##..####......##...##.#..#..#..#..##.#.#..##..####.#.######.#...##..#..#.##.##..###..#..#.#..#..#...
.##.#..#..##.#.##..#..#.#.#...##.##...##.#.########..##..#...#####.....#.#..###.#.##.##.###..#..#.##
..##...#.#..#.#.##.###..#....#..###...#..##....##.#..######..###.#.#####..#.###.##.###..#####...####
#.#..###.##.#...#..###..#.##.##...####.####.#.....##....###..#..#...####.####.###...#..#.#.#.#.##..#
###..##...#.#..##..#...##..###.#.....#...##.###.#..###...###.####..###.#..#.#...##.....#............
.#####..##...##....######...#..###.#.#......#...######.#..#...###.#...#..####.#......##..#..#.#...#.
.#..####.#.#..###..#.#.##.####..#.#....#.####..##...#..#.#.#..###.........##.#.#####...###...#.#..#.
.#.#....#..####..##..#########.#..#.##..###..#..#...###....##.....####...#..#.##....#######.####.##.
##.#.####..#...#..#.##.#..#....##.####..####..###.#.#...#######.#.###..###.###..#.###.##...##.##..#.
.#####.....##.#....##...##...#.#..####.##..#....##.###.#####.##.#.#.#...#...#.#.#.......##..##.##.#.
.##..#.#.###.#.#.#....##.#...#....#...#...#..#######....##.#.#.#####.#.###..#..#...#......#..#.##..#
...##.....#..#.####.###...#####.#.#....##.#.#.#.#...####.####.#..##.#.##.##.###..##...##.....#...###
####.###..###.####..###.##..#.#####.#...##.#..#.#.##.####.#..####..#..##....####.#....#...#.####.#.#
##....##.#.#.##.###..#####.##..##..#..##..##..#.#..###.##.#####...#..#.##.#.####.####..#...##..#..##
#.#..###..##..#..#..####..#..#.#..#.##...###.#.#.#.#...####.#.#...####.##..#.#.#..#.##..##..##.#....
##.#.####....##..##..####.#######..##....######.##.#....#..#...#.#..#.##.#...#.#.#.#.#..###....#.#.#
.##.###..#.###..##...####.###.#.##.###.#...#..#......######.##.##.##.####.##.##....#.#......####.#.#
#..###.####.#...#.###.###.#..##.###..#.#.#####..#.##.##.#.##.##..###.####...####..#..###...#.##.####
#...............#.##.###...#..#..#.##.##.#.##.#.#...#.#....#..#.######..#..#..##....#.##..#..#..#.##
###.###...#...#..#....##.......#.#..#...##...#....#..######..#.....##.####..#....#...##...######..##
..##..#..##.#.##..###.#...............####...##..##......#...#.....#..#....#.#...#.....##..#####..##
#.....##.#.##.###......###.#.##..###....###..#...#..###.#..#..##...#..#.##...#.#...#..#.....##...#.#
..##....#..#.#.#.####..#.#.#....#.#.#.#.##.#..#.#..#..#.#.##.####......##..#...##..#.#.##..#.....#..
.#..##....###.###..##....#####.#....####....#.#.##..#...#.###.##..#.....##........###.###.####..#.#.
.###.##..#..#...#.#.#######.##.#.#.#.#.###.#.#.#.#......#####.###.#.#.#......#.#..#.#.##..#.##.#.#.#"""



import copy

lightSet = set()
for i in range(len(enhancementInput)):
    if enhancementInput[i] == '#':
        lightSet.add(i)

mapRows = input.split("\n")

lightCells = set()

for i in range(len(mapRows)):
    for j in range(len(mapRows[0])):
        thisChar = mapRows[i][j]
        if thisChar == '#':
            lightCells.add((i,j))


class Image:
    """Representation of an image. 
    # correspond with light cells
    . correspond with dark cells
    The image is made up of a central "innerImage" and an infinite
    "outerImage"."""
                                 
    def __init__(self, onCells):
        """onCells expected to be a set containing light cells in the 
        inner image. Image is oriented with coordinates of rows going from
        0 down, and columns going from 0 across. Negative rows/columns 
        are permitted (and will be created as the image grows)."""        
        self.onCells = copy.deepcopy(onCells)
        self.topRow, self.bottomRow, self.leftColumn, self.rightColumn = 0,0,0,0
        self.updateMinMaxes()
        self.outerImage = 0 # All outer image cells start as dark.
            
    def updateMinMaxes(self):                
        for row, column in self.onCells:
            if row < self.topRow:
                self.topRow = row
            if row > self.bottomRow:
                self.bottomRow = row
            if column < self.leftColumn:
                self.leftColumn = column
            if column > self.rightColumn:
                self.rightColumn = column
            
    def searchArea(self):
        return {(row, column) 
                for row in range(self.topRow - 1, self.bottomRow + 2) 
                for column in range(self.leftColumn - 1, self.rightColumn + 2)
               }

    def inInnerImage(self, coord):
        row, column = coord
        return (self.topRow <= row and row <= self.bottomRow) and (self.leftColumn <= column and column <= self.rightColumn)

    def enhancedCoordinate(self, coord):
        row, column = coord
        index = 0
        for i in range(9):
            rowOffset = i // 3 - 1
            columnOffset = i % 3 - 1
            
            thisCoord = row + rowOffset, column + columnOffset              
            
            power = 8 - i
            
            if self.inInnerImage(thisCoord):
                if thisCoord in self.onCells:
                    index += 2 ** power
            else:
                index += self.outerImage * (2 ** power)
        
        return index in lightSet

    def iterate(self):
        newLightCells = set()
        for coord in self.searchArea():
            if self.enhancedCoordinate(coord):
                newLightCells.add(coord)
        self.onCells = newLightCells
        
        self.topRow -= 1
        self.bottomRow += 1
        self.leftColumn -= 1
        self.rightColumn += 1
        
        self.outerImage = 1 - self.outerImage
        return self
            
    def __str__(self):
        rows = self.bottomRow - self.topRow + 1
        columns = self.rightColumn - self.leftColumn + 1
        
        strings = [['.' 
                    for _ in range(self.leftColumn, self.rightColumn + 1)]
                    for _ in range(self.topRow, self.bottomRow + 1)
                  ]
                  
        for (row, column) in self.onCells:
            row = row - self.topRow
            column = column - self.leftColumn
            strings[row][column] = '#'
        
        return "\n".join(["".join(row) for row in strings])
    
    def __repr__(self):
        print(f"On cells: {len(self.onCells)}")
        return str(self)
        
    
    
startMap = Image(lightCells)
for i in range(50):
    print(i)
    startMap.iterate()

len(startMap.onCells)


        

        
        
        
        
        
        
        
        
        
        
        
        
        
        




