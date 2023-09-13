input = Vector{String}()
open("./input/day10.txt") do f    
    while !eof(f)                
        push!(input, readline(f))
    end
end

numbers(txt) = [parse(Int, m.match) for m in eachmatch(r"([\-0-9]+)", txt)]

import Base: +, -

function +(a :: Tuple{Number, Number}, b :: Number)
    x1, x2 = a
    return (x1 + b, x2 + b)
end

cycle = (0, 1)
X = 1

total = 0

for instruction in input
    if instruction == "noop"
        println("$cycle: $X")  
        if cycle[2] in [20, 60, 100, 140, 180, 220]                  
            total += cycle[2] * X
        end
        cycle += 1
    else
        number = numbers(instruction)[1]
        println("$cycle: $X")  
        if cycle[2] in [20, 60, 100, 140, 180, 220]        
            total += cycle[2] * X
        end
        cycle += 1
        println("$cycle: $X")  
        if cycle[2] in [20, 60, 100, 140, 180, 220]        
            total += cycle[2] * X
        end
        cycle += 1
        X += number
    end
end

print(total)

# Part 2

cycle = (0, 1)
X = 1
for instruction in input
    if instruction == "noop"        
        cycleMod40 = cycle[1] % 40
        if X ∈ cycleMod40-1:cycleMod40+1
            print("#")
        else
            print(".")
        end        
        cycle += 1
        if cycle[2] % 40 == 0
            println()
        end
    else
        number = numbers(instruction)[1]        
        cycleMod40 = cycle[1] % 40
        if X ∈ cycleMod40-1:cycleMod40+1
            print("#")
        else
            print(".")
        end        
        cycle += 1
        if cycle[2] % 40 == 0
            println()
        end
        
        cycleMod40 = cycle[1] % 40
        if X ∈ cycleMod40-1:cycleMod40+1
            print("#")
        else
            print(".")
        end        
        cycle += 1
        if cycle[2] % 40 == 0
            println()
        end
        X += number
    end
end