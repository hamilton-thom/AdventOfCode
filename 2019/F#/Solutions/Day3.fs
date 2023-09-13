
module Day3

open Common
open System.Text.RegularExpressions

let input = System.IO.File.ReadLines(inputFolder + "3.txt") |> List.ofSeq


type Movement = 
    | Left of int
    | Right of int
    | Up of int
    | Down of int


let wireToMovements (wireString : string) = 
    let splitString = wireString.Split([|','|])
    let regex = Regex("([A-Z])([\d]+)")
    let toMovement s = 
        let matches = regex.Match(s)
        let groups = matches.Groups
        let direction, distance = groups.[1].Value, groups.[2].Value
        match direction with
        | "U" -> Up (int distance)
        | "D" -> Down (int distance)
        | "L" -> Left (int distance)
        | "R" -> Right (int distance)
    splitString |> Array.map toMovement |> Array.toList


let wireMovements = input |> List.map wireToMovements

let move (x, y) movement = 
    match movement with
    | Left n -> (x - n, y)
    | Right n -> (x + n, y)
    | Up n -> (x, y + n)
    | Down n -> (x, y - n)


let rec processList pos movements = 
    match movements with
    | [] -> [pos]
    | x::xs -> pos :: processList (move pos x) xs
    

let buildPositions = processList (0, 0)

for pos in buildPositions wireMovements.[0] do
    printf "%A\n" pos

printf "\n ----- \n"

for pos in buildPositions wireMovements.[1] do
    printf "%A\n" pos

let wireCoordinates = wireMovements |> List.map (fun ls -> Set(buildPositions ls))

let manhattenDistance (x, y) = abs x + abs y

printf "%A" (Set.intersect wireCoordinates.[0] wireCoordinates.[1])

let minIntersection = 1
    //Set.intersect wireCoordinates.[0] wireCoordinates.[1] |> 
    //    Set.map manhattenDistance |> 
    //    Set.filter ((<) 0) |>
    //    Set.minElement


let solution = (IntResult 1, IntResult -1)