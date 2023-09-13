
import Data.List (foldl', sort)

import Parser (parseInstruction, 
               Switch (..), 
               Instruction, 
               getSwitch, 
               rowAffected,
               columnAffected,
               testInstructions)


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


data State = Brightness Int
    deriving Show


unwrapState :: State -> Int
unwrapState (Brightness n) = n


applySwitch :: Switch -> State -> State
applySwitch switch (Brightness n) =
    case switch of
        Toggle -> Brightness (n + 2)
        SwitchOn -> Brightness (n + 1)
        SwitchOff ->  Brightness (max 0 (n - 1))


updateState :: Int -> State -> Instruction -> State
updateState row state instruction =
    if rowAffected row instruction then
        applySwitch (getSwitch instruction) state
    else
        state


filterColumn :: Int -> [Instruction] -> [Instruction]
filterColumn col = filter (columnAffected col)


answerColumn :: Int -> [Instruction] -> Int
answerColumn y instructions = 
    sum . (map unwrapState) $ [foldl' (updateState row) (Brightness 0) filteredInstructions | row <- [0..999]]
    where 
        filteredInstructions = filterColumn y instructions


answer :: [Instruction] -> Int 
answer instructions = sum [answerColumn y instructions | y <- [0..999]]

