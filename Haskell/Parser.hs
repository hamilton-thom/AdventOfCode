
module Parser (
    parseInstruction,
    Instruction,
    Switch (..),
    getSwitch,
    isAffected) 
    where

import Data.Char (isDigit, isAlpha, isSpace, digitToInt)

import Control.Applicative

newtype Parser a = P (String -> (Maybe a, String))


parse :: Parser a -> String -> (Maybe a, String)
parse (P f) string = f string


instance Functor Parser where
    fmap f p = 
        P (\s -> 
            let (x, rem) = parse p s in
            (fmap f x, rem)
           )


instance Applicative Parser where
    pure x = P (\s -> (Just x, s))
    f <*> x = 
        P (\s -> 
            let (mf, rem1) = parse f s
                (mx, rem2) = parse x rem1
            in
            case mf of 
                Just f  -> (fmap f mx, rem2)
                Nothing -> (Nothing, rem2)
           )


instance Alternative Parser where
    empty   = P (\s -> (Nothing, s))
    f <|> g = 
        P (\s ->
            case parse f s of 
            (Nothing, _) -> parse g s
            _            -> parse f s
          )


instance Monad Parser where
    return = pure
    mx >>= f = 
        P (\s -> 
            case parse mx s of
                (Just x, rem) -> parse (f x) rem
                (Nothing, rem) -> (Nothing, rem)
          )


char :: Char -> Parser Char
char c =
    P (\s -> 
        case s of 
            (x:xs) -> 
                if x == c then 
                    (Just c, xs)
                else
                    (Nothing, xs)
            []     -> (Nothing, [])
      )


string :: String -> Parser String
string []     = pure ""
string (x:xs) = (:) <$> char x <*> string xs
    

bool :: (Char -> Bool) -> Parser Char
bool p = 
    P (\s -> 
        case s of 
            []     -> (Nothing, "")
            (x:xs) -> if p x then (Just x, xs) else (Nothing, xs)
      )


space :: Parser Char
space = 
    do s <- bool isSpace
       return s


spaces :: Parser String
spaces = many space


digit :: Parser Int
digit = 
    do d <- bool isDigit
       return (digitToInt d)


listToInt :: [Int] -> Int
listToInt = foldl (\n m -> 10 * n + m) 0


int :: Parser Int
int = fmap listToInt (some digit)


data Switch = Toggle | SwitchOn | SwitchOff
    deriving Show
    
data Point = Point Int Int
    deriving Show
    
data Instruction = Instruction Switch Point Point
    deriving Show


isAffected :: Instruction -> (Int, Int) -> Bool
isAffected (Instruction _ (Point x1 y1) (Point x2 y2)) (n, m) = 
    ((x1 <= n && n <= x2) || (x1 >= n && n >= x2)) &&
    ((y1 <= m && m <= y2) || (y1 >= m && m >= y2)) 


getSwitch :: Instruction -> Switch
getSwitch (Instruction switch _ _) = switch


parseType :: String -> a -> Parser a
parseType searchString x = 
    fmap (\_ -> x) (string searchString)


parseSwitch :: Parser Switch
parseSwitch = parseType "toggle" Toggle <|> parseType "turn on" SwitchOn <|> parseType "turn off" SwitchOff 

parsePoint :: Parser Point
parsePoint = 
    do xCoordinate <- int
       char ','
       yCoordinate <- int
       return (Point xCoordinate yCoordinate)


instructionParser :: Parser Instruction
instructionParser = 
    do switch <- parseSwitch
       spaces
       point1 <- parsePoint
       spaces
       string "through"
       spaces
       point2 <- parsePoint 
       return (Instruction switch point1 point2)


parseInstruction :: String -> Maybe Instruction
parseInstruction string = fst (parse instructionParser string)