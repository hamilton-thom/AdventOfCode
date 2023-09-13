input = Vector{String}()
open("./input/day5.txt") do f    
    while !eof(f) 
        push!(input, readline(f))
    end
end

function buildStacks()
    stacks = []
    for i in 1:9
        push!(stacks, [])
    end

    for row in 1:8
        thisInput = input[row]
        for i in 1:9
            position = i + 1 + 3(i-1)
            thisLetter = thisInput[position]            
            if thisLetter != ' '
                push!(stacks[i], thisLetter)
            end
        end
    end

    for i in 1:9
        stacks[i] = stacks[i][end:-1:1]
    end

    return stacks
end

instructionList = []
for instruction in input[11:end]
    matches = match(r"move ([0-9]+) from ([0-9]) to ([0-9])", instruction)
    number, from, to = parse.(Int, matches.captures)    

    push!(instructionList, (number, from, to))
end

function part1()
    stacks = buildStacks()
    for instruction in instructionList
        number, from, to = instruction
        
        for i in 1:number
            temp = pop!(stacks[from])
            push!(stacks[to], temp)
        end
    end

    for i in stacks
        print(i[end])
    end
end


function part2()
    stacks = buildStacks()
    for instruction in instructionList
        number, from, to = instruction
        
        append!(stacks[to], stacks[from][end - number + 1:end])

        for i in 1:number
            temp = pop!(stacks[from])            
        end
    end

    for i in stacks
        print(i[end])
    end
end