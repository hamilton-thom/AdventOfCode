module Common

let inputFolder = "C:/Users/Public/git/AdventOfCode/2019/Inputs/"

type Result = 
    | IntResult of int
    | StringResult of string
    
let toString result = 
    match result with
    | IntResult i -> string(i)
    | StringResult s -> s