
module Day2

open Common

let input = System.IO.File.ReadLines(inputFolder + "2.txt") |> List.ofSeq |> List.head

let inputSplit = input.Split([|','|]) |> Array.map int

let inputCopy = Array.copy inputSplit

// Part 1

let rec iterate startPosition (arr : int array)= 
    let thisOpCode = arr.[startPosition]
    match thisOpCode with
    | 1 -> 
        let pos1 = arr.[startPosition + 1]
        let pos2 = arr.[startPosition + 2]
        let dest = arr.[startPosition + 3]
        let val1 = arr.[pos1]
        let val2 = arr.[pos2]
        Array.set arr dest (val1 + val2)
        iterate (startPosition + 4) arr
    | 2 -> 
        let pos1 = arr.[startPosition + 1]
        let pos2 = arr.[startPosition + 2]
        let dest = arr.[startPosition + 3]
        let val1 = arr.[pos1]
        let val2 = arr.[pos2]
        Array.set arr dest (val1 * val2)
        iterate (startPosition + 4) arr
    | 99 -> 
        arr

let runMachine noun verb = 
    let copyInput = Array.copy inputSplit
    Array.set copyInput 1 noun
    Array.set copyInput 2 verb
    let modifiedArray = iterate 0 copyInput
    modifiedArray.[0]

let part1 = runMachine 12 2

let inputSpace = List.allPairs [0..99] [0..99]

let rec part2 (xss : (int * int) list)= 
    match xss with
    | [] -> -1
    | x::xs -> 
        match x with
        | (noun, verb) -> 
        if runMachine noun verb = 19690720 then
            100 * noun + verb
        else
            part2 xs


let solution = (IntResult part1, IntResult (part2 inputSpace))