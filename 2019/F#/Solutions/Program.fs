
open System


let solutions = 
    Map [(1, Day1.solution);
         (2, Day2.solution);
         (3, Day3.solution);
        ]


[<EntryPoint>]
let main argv =    
    for kvp in solutions do
        let solutionNumber, (part1, part2) =  kvp.Key, kvp.Value
        printf "Day %d, part1: %s, part 2: %s\n" solutionNumber (Common.toString part1) (Common.toString part2)
    
    0 // return an integer exit code