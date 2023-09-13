
import Data.Bits as Bits
import Data.List as List
import Data.Sequence as Seq
import Data.Set as Set

-- (2, 2) is never an element of Bugs - 
-- this corresponds to the central grid.

type Bugs = Set (Int, Int)
type Level = Int
type Grid = Seq (Bugs, Level)
data Side = Top | Bottom | Left | Right


-- Grid goes in sequence of levels n, ..., 1,  0, -1, ..., -m

expandGrid :: Grid -> Grid
expandGrid grid = 
    case (Set.size first == 0, Set.size last == 0) of
        (True, True)   -> grid
        (True, False)  -> grid :|> (Set.empty, rightMostLevel - 1)
        (False, True)  -> (Set.empty, leftMostLevel + 1) :<| grid
        (False, False) -> ((Set.empty, leftMostLevel + 1) :<| grid) :|> (Set.empty, rightMostLevel - 1)
    where
        (first, leftMostLevel) :<| _ = grid
        _ :|> (last, rightMostLevel) = grid


mergeGrid :: Grid -> Grid -> Grid
mergeGrid grid1@((bugs1, level1) :<| rem1) grid2@((bugs2, level2) :<| rem2) = 
    if level1 > level2 then
        (bugs1, level1) :<| mergeGrid rem1 grid2
    else if level2 > level1 then
        (bugs2, level2) :<| mergeGrid grid1 rem2
    else 
        (Set.union bugs1 bugs2, level1) :<| mergeGrid rem1 rem2
mergeGrid grid1 Empty = grid1
mergeGrid Empty grid2 = grid2


mergeGridList :: [Grid] -> Grid
mergeGridList = List.foldl' mergeGrid Seq.empty


gridDifference :: Grid -> Grid -> Grid
gridDifference Empty _ = Empty
gridDifference grid Empty = grid
gridDifference grid1@((bugs1, level1) :<| rem1) grid2@((bugs2, level2) :<| rem2) = 
    if level1 > level2 then 
        (bugs1, level1) :<| gridDifference rem1 grid2
    else if level1 < level2 then 
        gridDifference grid1 rem2
    else 
        (bugs1 Set.\\ bugs2, level1) :<| gridDifference rem1 rem2


seek :: Grid -> Level -> Maybe Bugs
seek Empty _ = Nothing
seek ((bugs, level) :<| rem) targetLevel = 
    if level > targetLevel then
        seek rem targetLevel
    else if level < targetLevel then
        Nothing
    else
        Just bugs
        

-- Side refers to side of the Bugs containing the adjacent bug
-- not the originating cell.
adjacentCountBelow :: Maybe Bugs -> Side -> Int
adjacentCountBelow Nothing _ = 0
adjacentCountBelow (Just bugs) side = 
    case side of 
        Top    -> Set.size $ Set.filter (\(r, c) -> r == 0) bugs
        Bottom -> Set.size $ Set.filter (\(r, c) -> r == 4) bugs
        Main.Left   -> Set.size $ Set.filter (\(r, c) -> c == 0) bugs
        Main.Right  -> Set.size $ Set.filter (\(r, c) -> c == 4) bugs


adjacentCountAbove :: Maybe Bugs -> Side -> Int
adjacentCountAbove Nothing _ = 0
adjacentCountAbove (Just bugs) side = 
    case side of 
        Top    -> Set.size $ Set.filter (== (1, 2)) bugs
        Bottom -> Set.size $ Set.filter (== (3, 2)) bugs
        Main.Left   -> Set.size $ Set.filter (== (2, 1)) bugs
        Main.Right  -> Set.size $ Set.filter (== (2, 3)) bugs

-- Main.Left/Right used to avoid conflicts with Prelude.Left/Right
adjacentCount :: Grid -> Level -> (Int, Int) -> Int
adjacentCount grid level (r, c) =
    case (r, c) of 
        (0, 0) -> val 1 0 + val 0 1 + countAbove Top + countAbove Main.Left
        (0, 1) -> val 0 0 + val 1 1 + val 0 2 + countAbove Top
        (0, 2) -> val 0 1 + val 1 2 + val 0 3 + countAbove Top
        (0, 3) -> val 0 2 + val 1 3 + val 0 4 + countAbove Top
        (0, 4) -> val 0 3 + val 1 4 + countAbove Top + countAbove Main.Right
        
        (1, 0) -> val 0 0 + val 1 1 + val 2 0 + countAbove Main.Left
        (1, 1) -> countCorners (1, 1)
        (1, 2) -> val 0 2 + val 1 1 + val 1 3 + countBelow Top
        (1, 3) -> countCorners (1, 3)
        (1, 4) -> val 0 4 + val 1 3 + val 2 4 + countAbove Main.Right
        
        (2, 0) -> val 1 0 + val 2 1 + val 3 0 + countAbove Main.Left
        (2, 1) -> val 2 0 + val 1 1 + val 3 1 + countBelow Main.Left
        (2, 2) -> 0 -- This cell never contains a value - it always contains the grid below
        (2, 3) -> val 1 3 + val 2 4 + val 3 3 + countBelow Main.Right
        (2, 4) -> val 2 3 + val 1 4 + val 3 4 + countAbove Main.Right
        
        (3, 0) -> val 2 0 + val 3 1 + val 4 0 + countAbove Main.Left
        (3, 1) -> countCorners (3, 1)
        (3, 2) -> val 3 1 + val 4 2 + val 3 3 + countBelow Bottom
        (3, 3) -> countCorners (3, 3)
        (3, 4) -> val 3 3 + val 2 4 + val 4 4 + countAbove Main.Right
        
        (4, 0) -> val 3 0 + val 4 1 + countAbove Main.Left + countAbove Bottom
        (4, 1) -> val 4 0 + val 3 1 + val 4 2 + countAbove Bottom
        (4, 2) -> val 4 1 + val 3 2 + val 4 3 + countAbove Bottom
        (4, 3) -> val 4 2 + val 3 3 + val 4 4 + countAbove Bottom
        (4, 4) -> val 4 3 + val 3 4 + countAbove Main.Right + countAbove Bottom
    where
        countAbove = adjacentCountAbove (seek grid (level + 1))
        countBelow = adjacentCountBelow (seek grid (level - 1))
        maybeThisLevel = seek grid level
        
        val row col = 
            case maybeThisLevel of 
                Nothing -> 0
                Just bugs -> if Set.member (row, col) bugs then 1 else 0
                
        countCorners (x, y) = val (x+1) y + val (x-1) y + val x (y+1) + val x (y-1)


-- These cells are used to construct adjacent cells - they are from
-- the perspective of the level below, for example Top corresponds 
-- to the adjacent cell that would be connected to cells on the top-row
-- of the level below.
adjacentAboveTop :: Level -> Grid
adjacentAboveTop level = Seq.singleton (Set.singleton (1, 2), level)

adjacentAboveBottom :: Level -> Grid
adjacentAboveBottom level = Seq.singleton (Set.singleton (3, 2), level)

adjacentAboveLeft :: Level -> Grid
adjacentAboveLeft level = Seq.singleton (Set.singleton (2, 1), level)

adjacentAboveRight :: Level -> Grid
adjacentAboveRight level = Seq.singleton (Set.singleton (2, 3), level)

adjacentBelowTop :: Level -> Grid
adjacentBelowTop level = Seq.singleton (Set.fromList [(0, i) | i <- [0..4]], level)
        
adjacentBelowBottom :: Level -> Grid
adjacentBelowBottom level = Seq.singleton (Set.fromList [(4, i) | i <- [0..4]], level)
        
adjacentBelowLeft :: Level -> Grid
adjacentBelowLeft level = Seq.singleton (Set.fromList [(i, 0) | i <- [0..4]], level)
        
adjacentBelowRight :: Level -> Grid
adjacentBelowRight level = Seq.singleton (Set.fromList [(i, 4) | i <- [0..4]], level)

-- This function takes a grid of 1 element, and creates a new three element
-- grid, containing all of the mapped values.
adjacentElements :: Level -> (Int, Int) -> Grid
adjacentElements level (r, c) = 
    case (r, c) of 
        (0, 0) -> mergeGridList [buildMiniGrid [(1, 0), (0, 1)], aboveTop, aboveLeft]
        (0, 1) -> mergeGridList [buildMiniGrid [(0, 0), (1, 1), (0, 2)], aboveTop]
        (0, 2) -> mergeGridList [buildMiniGrid [(0, 1), (1, 2), (0, 3)], aboveTop]
        (0, 3) -> mergeGridList [buildMiniGrid [(0, 2), (1, 3), (0, 4)], aboveTop]
        (0, 4) -> mergeGridList [buildMiniGrid [(0, 3), (1, 4)], aboveTop, aboveRight]
        
        (1, 0) -> mergeGridList [buildMiniGrid [(0, 0), (1, 1), (2, 0)], aboveLeft]
        (1, 1) -> cornerCells (1, 1)
        (1, 2) -> mergeGridList [buildMiniGrid [(0, 2), (1, 1), (1, 3)], belowTop]
        (1, 3) -> cornerCells (1, 3)
        (1, 4) -> mergeGridList [buildMiniGrid [(0, 4), (1, 3), (2, 4)], aboveRight]
        
        (2, 0) -> mergeGridList [buildMiniGrid [(1, 0), (2, 1), (3, 0)], aboveLeft]
        (2, 1) -> mergeGridList [buildMiniGrid [(2, 0), (1, 1), (3, 1)], belowLeft]
      --(2, 2) -> case never encountered.
        (2, 3) -> mergeGridList [buildMiniGrid [(1, 3), (2, 4), (3, 3)], belowRight]
        (2, 4) -> mergeGridList [buildMiniGrid [(2, 3), (1, 4), (3, 4)], aboveRight]
        
        (3, 0) -> mergeGridList [buildMiniGrid [(2, 0), (3, 1), (4, 0)], aboveLeft]
        (3, 1) -> cornerCells (3, 1)
        (3, 2) -> mergeGridList [buildMiniGrid [(3, 1), (4, 2), (3, 3)], belowBottom]
        (3, 3) -> cornerCells (3, 3)
        (3, 4) -> mergeGridList [buildMiniGrid [(3, 3), (2, 4), (4, 4)], aboveRight]
        
        (4, 0) -> mergeGridList [buildMiniGrid [(3, 0), (4, 1)], aboveLeft, aboveBottom]
        (4, 1) -> mergeGridList [buildMiniGrid [(4, 0), (3, 1), (4, 2)], aboveBottom]
        (4, 2) -> mergeGridList [buildMiniGrid [(4, 1), (3, 2), (4, 3)], aboveBottom]
        (4, 3) -> mergeGridList [buildMiniGrid [(4, 2), (3, 3), (4, 4)], aboveBottom]
        (4, 4) -> mergeGridList [buildMiniGrid [(4, 3), (3, 4)], aboveRight, aboveBottom]
    where
        buildMiniGrid lsVals = Seq.singleton (Set.fromList lsVals, level)        
                
        aboveTop = adjacentAboveTop (level + 1)
        aboveBottom = adjacentAboveBottom (level + 1)
        aboveLeft = adjacentAboveLeft (level + 1) 
        aboveRight = adjacentAboveRight (level + 1)
        belowTop = adjacentBelowTop (level - 1)
        belowBottom = adjacentBelowBottom (level - 1)
        belowLeft = adjacentBelowLeft (level - 1)
        belowRight = adjacentBelowRight (level - 1)
        
        cornerCells (row, col) = 
            buildMiniGrid 
                [(row + 1, col), (row - 1, col), 
                 (row, col + 1), (row, col - 1)
                ]


seqToList :: Seq a -> [a]
seqToList (x :<| rem) = x : seqToList rem
seqToList Empty       = []


adjacentGrid :: (Bugs, Level) -> Grid
adjacentGrid (bugs, level) = 
    mergeGridList gridList
    where
        bugList = Set.elems bugs
        gridList = fmap (adjacentElements level) bugList        


adjacentElementsGrid :: Grid -> Grid
adjacentElementsGrid grid = 
    mergeGridList adjacentGridList
    where
        gridAsList = seqToList grid
        adjacentGridList = fmap adjacentGrid gridAsList
        

-- Now - given a state (Grid) we can calculate the list of adjacent elements
--       and we can calculate the number of neighbours that exist.
-- We can take the existing bug set - calculate the number of neighbours for 
-- each one - then put them together as bugs which continue living
-- And add to that the adjacent bug set - where we've calculated how many 
-- neighbours each element has, and only kept those that will survive.


nextState :: Grid -> Grid
nextState grid = 
    mergeGrid survivingBugs newBugs
    where
        expandedGrid = expandGrid grid
        survivingBugs = fmap (\(bugs, level) -> (Set.filter (\(i, j) -> adjacentCount expandedGrid level (i, j) == 1) bugs, level)) expandedGrid
        adjacentBugs = adjacentElementsGrid expandedGrid
        adjacentBugsExclExisting = gridDifference adjacentBugs expandedGrid
        newBugs = fmap (\(bugs, level) -> (Set.filter (\(i, j) -> adjacentCount expandedGrid level (i, j) `elem` [1, 2]) bugs, level)) adjacentBugsExclExisting


stateValue :: Grid -> Int
stateValue bugs = 
    sum $ seqToList bugCountSequence
    where
        bugCountSequence = fmap (\(set, _) -> Set.size set) bugs    


initialState :: Bugs
initialState = Set.fromList 
                 [(0, 0), (0, 1), (0, 3), 
                  (1, 0), (1, 2), (1, 3), (1, 4), 
                  (2, 0), (2, 1), 
                  (3, 3), 
                  (4, 0), (4, 2), (4, 3)]


buildInitialState :: Bugs -> Grid
buildInitialState bugs = Seq.singleton (bugs, 0)

testState :: Bugs 
testState = Set.fromList [(0, 4), (1, 0), (1, 3), (2, 0), (2, 3), (2, 4), (3, 2), (4, 0)]

initialGrid = buildInitialState initialState

testGrid = buildInitialState testState

stateAfterN :: Grid -> Int -> Grid
stateAfterN grid n | n <= 0    = grid
                   | otherwise = stateAfterN (nextState grid) (n - 1)
                   
                   
displayStateToN :: Grid -> Int -> [(Int, Int, Int)]
displayStateToN state n = 
    if n < 0 then
        []
    else
       (stateValue state, Seq.length state, n) : displayStateToN (nextState state) (n-1)
                   
                   
                   
                   
                   
