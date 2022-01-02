

# Part 1
#############
#...........#
###A#B#C#D###
  #A#B#C#D#
  #########

# Part 2
#############
#...........#
###A#B#C#D###
  #D#C#B#A#
  #D#B#A#C#
  #A#B#C#D#
  #########


class Tunnel:
    """All empty spaces are at a coordinate (row, col) where row is between 0 and 2, 
    and col is between 0 and 10."""
    
    def __init__(self, input = None):
        """Initialises class variables:
            bugState - dict of bugs (e.g. A2) and their coordinate
            cellState - dict of coord - value for all cells in the grid
            moveCostDict - dict bugs (e.g. A2) and their movement cost (per move)
            
           The coordinate system has y-coordinates which start at 0 and work 
           up as you go down the tunnels"""          
            
        if input is None:
            return
            
        self.cellState = {(0, i) : "--" for i in range(11)}
        
        tempState = {}        
        for i in range(len(input)): # Range(Number of burrows)
            column = 2 * (i + 1)
            for row in range(len(input[i])):
                tempState[(row + 1, column)] = input[i][row]
        
        # Want to invert state so that it's a map from "A1", "A2" etc.
        # to coordinates. As the moves progress, the coordinates will 
        # then change, and you can add up the energies.
        
        letters = {"A" : 1, "B" : 10, "C" : 100, "D" : 1000}
        letterCounts = {letter : 1 for letter in letters.keys()}        
        self.moveCostDict = {}
        
        state = {}
        for coordinate,letter in tempState.items():            
            letterIndex = letterCounts[letter]
            letterCounts[letter] += 1
            letterKey = f"{letter}{letterIndex}"
            state[letterKey] = coordinate
            self.moveCostDict[letterKey] = letters[letter]
            self.cellState[coordinate] = letterKey
        
        self.bugState = state
        
        self.bottomRow = max(row for row, _ in self.cellState)
        
        self.acrossOptions = [(0, col) for col in [0, 1, 3, 5, 7, 9, 10]]
        
        self.bugsInFinalPosition = set(bug for bug in self.bugState if self.isInFinalPosition(bug))        
        
        
    def acrossPath(self, start, end):
        """Note: this function returns the path from start (exclusive) to end (inclusive).
        Function can be made much faster by turning it into a yield! function. That way, you 
        avoid traversing the entire route before realising that someone is in the way."""
        path = []        
        
        startRow, startCol = start
        _, endCol = end
        acrossMovement = endCol - startCol
        
        if acrossMovement >= 0:
            xdirection = 1
        else:
            xdirection = -1
        
        # This takes into account the case where there's no horizontal movement
        for i in range(xdirection, acrossMovement + xdirection, xdirection):
            path.append((startRow, startCol + i))
        
        return path
        
    
    def updownPath(self, start, end):
        """Note: this function returns the path from start (exclusive) to end (inclusive).
        Function can be made much faster by turning it into a yield! function. That way, you 
        avoid traversing the entire route before realising that someone is in the way."""
        path = []
        
        startRow, startCol = start
        endRow, _ = end
        downMovement = endRow - startRow
        
        if downMovement >= 0:
            ydirection = 1
        else:
            ydirection = -1
        
        # This takes into account the case where there's no horizontal movement
        for i in range(ydirection, downMovement + ydirection, ydirection):
            path.append((startRow + i, startCol))
        
        return path
        
        
    def path(self, start, end):        
        startRow, startCol = start
        endRow, endCol = end
        
        for up in self.updownPath(start, (0, startCol)):
            yield up
        for across in self.acrossPath((0, startCol), (0, endCol)):
            yield across
        for down in self.updownPath((0, endCol), end):
            yield down        
        
        
    def moveCost(self, start, end):
        """Returns the total cost of the move. If the move is not possible, returns 0."""        
        if self.cellState[end] != "--": # If someone is already there obviously you cannot go.
            return 0
        
        pathLength = 0
        for position in self.path(start, end):
            if self.cellState[position] != "--":
                return 0
            pathLength += 1
        bug = self.cellState[start]
        moveCost = self.moveCostDict[bug]
        return moveCost * pathLength


    def canMoveIntoBurrow(self, bug):
        """Bugs can only move into a burrow if all the bugs in the burrow are 
        of their type."""
        burrow = self.burrowPosition(bug)        
        bugLetter = bug[0]
        
        for row in range(self.bottomRow, 0, -1):
            if self.cellState[(row, burrow)][0] not in [bugLetter, "-"]:
                return False
        
        return True
        
    
    def burrowPosition(self, bug):        
        return {'A' : 2, 'B' : 4, 'C' : 6, 'D' : 8}[bug[0]]
    
    
    def isInFinalPosition(self, bug):
        row, col = self.bugState[bug]
        
        if row == 0:
            return False
        elif col != self.burrowPosition(bug):
            return False
        else:
            for checkRow in range(row + 1, self.bottomRow + 1):
                bugBeneath = self.cellState[(checkRow, col)]
                if bugBeneath == "--": # This should never be triggered as the movement
                                       # code should be clever enough to not put a bug
                                       # into a position which isn't at the bottom of the chain.
                    return False
                elif self.burrowPosition(bugBeneath) != col:
                    return False
                
        return True
        
    
    def moveAlreadyCompleted(self, existingStates, bug, moveFrom, moveTo):
        self.applyMove(bug, moveTo)
        hashVal = self.__hash__()
        self.applyMove(bug, moveFrom)
        return hashVal in existingStates
    
    
    def validMoves(self, existingStates):
        """Can move:
            from within burrows to row
            from burrows direct to other burrows
            from row to burrow
        Moves are returned by a list of (bug, start, end, cost, isFinalMove) quintuples. 
        Each quintuple represents the jump from current state into that future state. 
        """
        moves = []
        for bug, position in self.bugState.items():
            if bug in self.bugsInFinalPosition:
                continue
            
            row, col = position
            targetBurrow = self.burrowPosition(bug)
            canMoveToBurrow = self.canMoveIntoBurrow(bug)
            
            if row == 0 and canMoveToBurrow:
                for targetRow in range(self.bottomRow, 0, -1):
                    cost = self.moveCost(position, (targetRow, targetBurrow))
                    if cost > 0:                        
                        moveFrom, moveTo = position, (targetRow, targetBurrow)
                        #if not self.moveAlreadyCompleted(existingStates, bug, moveFrom, moveTo):
                        moves.append((bug, moveFrom, moveTo, cost, True))
                        break
                    
            elif row == 0 and not canMoveToBurrow:
                continue
            
            elif canMoveToBurrow: # Two cases - move direct into room, or move into a space in the hallway                
                for targetRow in range(self.bottomRow, 0, -1):
                    cost = self.moveCost(position, (targetRow, targetBurrow))
                    if cost > 0:
                        moveFrom, moveTo = position, (targetRow, targetBurrow)
                        #if not self.moveAlreadyCompleted(existingStates, bug, moveFrom, moveTo):
                        moves.append((bug, moveFrom, moveTo, cost, True))
                        break
            
            else:
                for option in self.acrossOptions:                    
                    cost = self.moveCost(position, option)
                    if cost > 0:
                        moveFrom, moveTo = position, option
                        #if not self.moveAlreadyCompleted(existingStates, bug, moveFrom, moveTo):
                        moves.append((bug, moveFrom, moveTo, cost, False))
                        
        return moves

    
    def applyMove(self, bug, moveTo):
        bugPosition = self.bugState[bug]        
        self.bugState[bug] = moveTo
        if self.cellState[moveTo] != "--":
            raise ValueError("Attempting to move bug into an occupied state")
        self.cellState[bugPosition] = "--"
        self.cellState[moveTo] = bug
        
    
    def __repr__(self):
        return str(self)
    
        
    def __str__(self):
        outputString = ""
        
        maxLength = max(row for row, _ in self.cellState)
        
        for row in range(maxLength + 1):
            if row != 0:
                outputString += "\n"
            for col in range(11):
                
                if row == 0:
                    outputString += self.cellState[(row, col)]
                else:
                    if (row, col) in self.cellState:
                        outputString += self.cellState[(row, col)]
                    else:
                        outputString += "  "
        
        return outputString
    
    
    def __hash__(self):
        """ WARNING: not guaranteed to provide a legitimate unique value."""
        return str(self.cellState).__hash__()    

    
    def copy(self):
        newTunnel = Tunnel()
        newTunnel.bugState = self.bugState.copy()
        newTunnel.bottomRow = self.bottomRow         # Never altered
        newTunnel.acrossOptions = self.acrossOptions # Never altered
        newTunnel.cellState = self.cellState.copy()
        newTunnel.moveCostDict = self.moveCostDict.copy()
        newTunnel.bugsInFinalPosition = self.bugsInFinalPosition.copy()
        return newTunnel


def cleanState(tunnel, state, moveSets):
    """Resets the state of the tunnel to be at the next valid position. This 
    involves rolling back moves which led to no-where - which is un-doing moves
    on the tunnel, removing their costs, and re-setting the finalMoveCounts.
    The return value is the cost, finalMoveCount tally after the reset."""    
    if len(moveSets) == 0:
        return
    while len(moveSets[-1]) == 0:
        moveSets.pop()        
        rollbackMove(tunnel, state, moveSets)
        if len(moveSets) == 0:        
            break
        

def makeMove(tunnel, state, move):
    bug, start, end, cost, isFinalMove = move
    
    tunnel.applyMove(bug, end)
    state["cost"] += cost
    state["route"].append(move)    
    if isFinalMove:
        state["bugHomeCount"] += 1
        tunnel.bugsInFinalPosition.add(bug)


def rollbackMove(tunnel, state, moveSets):
    # Special case when you're rolling back the final move.    
    if len(state["route"]) == 0:
        return
    move = state["route"].pop()
    bug, start, end, cost, isFinalMove = move
    
    tunnel.applyMove(bug, start)
    state["cost"] -= cost    
    if isFinalMove:
        state["bugHomeCount"] -= 1
        tunnel.bugsInFinalPosition.remove(bug)
        
    cleanState(tunnel, state, moveSets)


def optimumRoute(input):
    tunnel = Tunnel(input)    
    
    bugCount = 0
    for bug in tunnel.bugState:
        if not tunnel.isInFinalPosition(bug):
            bugCount += 1
            
    print("Trying to move ", bugCount, " bugs into position.")
    
    state = {"route"          : [],
             "cost"           : 0,
             "bugHomeCount"   : 0,
             "minRoute"       : [],
             "minCost"        : 10**10,
             "bugCount"       : bugCount,
             "routeSet"       : set()             
             }
    
    moveSets = []
    moveSets.append(tunnel.validMoves(state["routeSet"]))

    # potentialMoves holds a list of lists. Each sub-list is the valid moves from a
    # given state. When all potential avenues are exhausted, the sub-list will be empty
    # and we un-do the move that resulted in getting to that state. We then un-do all
    # previous moves where necessary, which can trigger removing several sub-lists.
    # The last sub-list is guaranteed to be non-empty at the start of the loop.
    
    count = 0
    maxDepth = 0
    while len(moveSets) > 0: # 64 = bad, 63 = good state
        count += 1
        if count % 1000000 == 0:
            print(count, len(moveSets), maxDepth, state["cost"], state["minCost"])
            print(tunnel)
            maxDepth = 0
        maxDepth = max(maxDepth, len(moveSets))
        thisMoveSet = moveSets[-1]
        nextMove = thisMoveSet.pop()
        makeMove(tunnel, state, nextMove)        
        
        #print(tunnel)        
        
        if state["cost"] >= state["minCost"]:            
            rollbackMove(tunnel, state, moveSets)
            continue
                
        if state["bugHomeCount"] == bugCount:            
            state["minRoute"] = state["route"].copy()
            state["minCost"] = state["cost"]            
            rollbackMove(tunnel, state, moveSets)
            print("New min cost: ", state["minCost"])            
            continue
                    
        newMoves = tunnel.validMoves(state["routeSet"])        
        
        # Not at the end, stuck in an unmoveable position, or you're in a position that you've been in before.        
        if len(newMoves) == 0:            
            rollbackMove(tunnel, state, moveSets)                        
            continue
        else:
            #state["routeSet"].add(tunnel.__hash__())
            moveSets.append(newMoves)
           
    return moveSets, tunnel, state


part1Input = ("DD", "CC", "AB", "BA")
part2Input = ("DDDD", "CCBC", "ABAB", "BACA")    

websitePart2 = ("BDDA", "CCBD", "BBAC", "DACA")

moveSets, tunnel, state = optimumRoute(part1Input)

testCase = optimumRoute(websitePart2)
part2 = optimumRoute(part2Input)