
import Parser

type Register = Char
type RegisterSet = [(Register, Int)]

data Instruction 
    = Set Register Int 
    | Jnz Register Int 
    | Sub Register Int 
    | Mul Register Int 
    
type InstructionSet = [(Instruction, Int)]
type State = (InstructionSet, RegisterSet)
type InstructionNumber = Int -- Zero indexed.

initialRegisterSet :: RegisterSet
initialRegisterSet = zip [a..h] (repeat 0)


getInstruction :: Int -> InstructionSet -> Instruction
getInstruction n instructionSet


getRegister :: Char -> RegisterSet -> Int
getRegister c ((register, n):others) = 
    if c == register then 
        n
    else 
        getRegister c others


getState :: Char -> State -> Int
getState c (_, registerSet) = getRegister c registerSet


updateRegister :: Char -> Int -> RegisterSet -> RegisterSet
updateRegister c m ((register, n):others) =
    if register == c then 
        (register, m) : others 
    else 
        (register, n) : updateRegister c m others 
        
        
updateState :: Char -> Int -> State -> State
updateState c n (instructionSet, registerSet) = 
    (instructionSet, updateRegister c n registerSet)


runInstruction :: InstructionNumber -> State -> (InstructionNumber, State)
runInstruction n state = 
    case thisInstruction of 
        Set register m -> 
            (n + 1, updateState register m state)
        
        Jnz register m -> 
            (if getRegister register == 0 then n + 1 else n + m, state)
        
        Sub register m -> 
            (n + 1, updateState register (getState c state - m))
            
        Mul register m -> 
            (n + 1, updateState register (getState c state * m))
    where
        thisInstruction = instructionSet !! n


