
module Day1

open Common

let input = System.IO.File.ReadLines(inputFolder + "1.txt") |> List.ofSeq |> List.map int;

let mass fuel = max (fuel / 3 - 2) 0
let totalMass = input |> List.map mass |> List.sum

let rec massRec fuel = 
    if fuel <= 0 then
        0
    else
        let thisModuleFuel = mass fuel
        thisModuleFuel + massRec thisModuleFuel

let totalMassRec = input |> List.map massRec |> List.sum

let solution = (IntResult totalMass, IntResult totalMassRec)