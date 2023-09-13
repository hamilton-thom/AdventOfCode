

import Parser (parseInstruction, Switch (..), Instruction, getSwitch, isAffected, testInstructions)


inputFile :: String
inputFile = "Puzzle.txt"


instructionText :: IO [String]
instructionText = fmap lines (readFile inputFile)


validateInstructions :: [Maybe Instruction] -> Maybe [Instruction]
validateInstructions [] = Just []
validateInstructions (m:ms) =
    case (m, validateInstructions ms) of
        (Nothing, _) -> Nothing
        (_, Nothing) -> Nothing
        (Just x, Just xs) -> Just (x:xs)


instructions :: IO (Maybe [Instruction])
instructions =
    do instructionStrings <- instructionText
       return (validateInstructions (map parseInstruction instructionStrings))


getAnswer :: IO Int
getAnswer =
    do baseInstructions <- instructions
       case baseInstructions of
            Just ins -> return (answer (reverse ins))
            Nothing -> return (-1)


data State = On | Off | Toggled | Untoggled
    deriving Show
data ResultState = Certain State | Current State
    deriving Show


stateMap :: (State -> State) -> ResultState -> ResultState
stateMap f resultState =
    case resultState of
        Certain _ -> resultState
        Current state -> Current (f state)


applySwitch :: Switch -> ResultState -> ResultState
applySwitch switch (Certain state) = Certain state
applySwitch switch (Current state) =
    case (switch, state) of
        (Toggle, Toggled) -> Current Untoggled
        (SwitchOn, Toggled) -> Certain Off
        (SwitchOff, Toggled) ->  Certain On

        (Toggle, Untoggled) -> Current Toggled
        (SwitchOn, Untoggled) -> Certain On
        (SwitchOff, Untoggled) -> Certain Off

        (_, _) -> Current state


updateState :: (Int, Int) -> Instruction -> ResultState -> ResultState
updateState _        _           (Certain state) = Certain state
updateState location instruction resultState     =
    if isAffected instruction location then
        applySwitch switch resultState
    else
        resultState
    where
        switch = getSwitch instruction


runUpdate :: (Int, Int) -> ResultState -> [Instruction] -> ResultState
runUpdate _ (Certain state) _       = Certain state
runUpdate p (Current Toggled) []    = Certain On
runUpdate p (Current Untoggled) [] = Certain Off
runUpdate p (Current state) (i:is)  = runUpdate p (updateState p i (Current state)) is


stateValue :: ResultState -> Int
stateValue (Certain On) = 1
stateValue _            = 0


answer :: [Instruction] -> Int
answer reversedInstructions =
        sum (map stateValue [determineState (x, y) |  x <- [0..999], y <- [0..999]])
    where
        determineState (x, y) = runUpdate (x, y) (Current Untoggled) reversedInstructions


