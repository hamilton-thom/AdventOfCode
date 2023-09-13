
import Data.Set as Set
import Data.Bits as Bits

type Bugs = Set (Int, Int)


data Category 
    = Inside 
    | LeftEdge 
    | RightEdge 
    | TopEdge 
    | BottomEdge 
    | TRCorner
    | TLCorner
    | BRCorner
    | BLCorner


classifyPoint :: (Int, Int) -> Category
classifyPoint (row, col) = 
    case (row, col) of 
        (0, 0) -> TLCorner
        (0, 4) -> TRCorner
        (4, 0) -> BLCorner
        (4, 4) -> BRCorner
        (0, _) -> TopEdge
        (_, 0) -> LeftEdge
        (4, _) -> BottomEdge
        (_, 4) -> RightEdge
        _      -> Inside


adjacentCount :: Bugs -> (Int, Int) -> Int
adjacentCount bugs (r, c) = 
    case classifyPoint (r, c) of 
        Inside     -> (val (r+1) c) + (val (r-1) c) + (val r (c+1)) + (val r (c-1))
        LeftEdge   -> (val (r+1) c) + (val (r-1) c) + (val r (c+1))
        RightEdge  -> (val (r+1) c) + (val (r-1) c) + (val r (c-1))
        TopEdge    -> (val (r+1) c) + (val r (c+1)) + (val r (c-1))
        BottomEdge -> (val (r-1) c) + (val r (c+1)) + (val r (c-1))
        TLCorner   -> (val (r+1) c) + (val r (c+1))
        TRCorner   -> (val (r+1) c) + (val r (c-1))
        BRCorner   -> (val (r-1) c) + (val r (c-1))
        BLCorner   -> (val (r-1) c) + (val r (c+1))
    where
        val row col = if Set.member (row, col) bugs then 1 else 0


between :: Int -> Int -> (Int, Int) -> Bool
between lower upper (x, y) = 
    (lower <= x && x <= upper) && 
    (lower <= y && y <= upper)
    

adjacentElements :: Bugs -> Bugs
adjacentElements bugs = 
    adjacentSet \\ bugs
    where
        allAdjacentElements = [[(r+1, c), (r-1, c), (r, c+1), (r, c-1)] | (r, c) <- elems bugs]
        flatAdjacentElements = Prelude.filter (between 0 4) (concat allAdjacentElements)
        adjacentSet = Set.fromList flatAdjacentElements


nextState :: Bugs -> Bugs
nextState bugs = 
    Set.union (Set.filter existingBugFilter bugs) (Set.filter newBugFilter emptyAdjacentSpaces)    
    where 
        emptyAdjacentSpaces = adjacentElements bugs
        existingBugFilter (r, c) = adjacentCount bugs (r, c) == 1
        newBugFilter (r, c) = adjacentCount bugs (r, c) == 1 || adjacentCount bugs (r, c) == 2        


stateValue :: Bugs -> Int
stateValue bugs = 
    Set.foldl (\v (r,c) -> Bits.setBit v (r * 5 + c)) 0 bugs

initialState :: Bugs
initialState = Set.fromList 
                 [(0, 0), (0, 1), (0, 3), 
                  (1, 0), (1, 2), (1, 3), (1, 4), 
                  (2, 0), (2, 1), 
                  (3, 3), 
                  (4, 0), (4, 2), (4, 3)]

testState :: Bugs 
testState = Set.fromList [(0, 4), (1, 0), (1, 3), (2, 0), (2, 3), (2, 4), (3, 2), (4, 0)]

initialSet = Set.empty

firstRepeat :: Set Int -> Bugs -> Int
firstRepeat set bugs = 
    if Set.member newValue set then 
        newValue
    else
        firstRepeat (Set.insert newValue set) newBugs
    where
        newBugs = nextState bugs
        newValue = stateValue newBugs
        
   




--Set.insert :: Int -> Set Int -> Set Int
--Set.member :: Int -> Set Int -> Bool


