struct WorkPair
    elf1 :: Tuple{Int, Int}
    elf2 :: Tuple{Int, Int}    
end

function WorkPair(a, b, c, d)
   t1 = (a, b)
   t2 = (c, d)
   return WorkPair(t1, t2)
end

input = Vector{WorkPair}()
open("./input/day4.txt") do f    
    while !eof(f) 
        line = readline(f)
        println(line)
        a, b, c, d = parse.(Int, match(r"([0-9]+)-([0-9]+),([0-9]+)-([0-9]+)", line).captures)
        push!(input, WorkPair(a, b, c, d))
    end
end


# Part 1
function isContainedInOther(workPair)
    if workPair.elf1[1] <= workPair.elf2[1] && workPair.elf2[2] <= workPair.elf1[2]
        return 1
    elseif workPair.elf2[1] <= workPair.elf1[1] && workPair.elf1[2] <= workPair.elf2[2]
        return 1
    else
        return 0
    end
end

for workPair in input
    if isContainedInOther(workPair) != 0
        println(workPair)
    end
end

println("Part 1: $(sum(map(isContainedInOther, input)))")
        
# Part 2
function hasOverlap(workPair)
    a, b = workPair.elf1
    c, d = workPair.elf2
    
    if a <= c && c <= b
        return 1
    elseif a <= d && d <= b
        return 1
    elseif c <= a && a <= d
        return 1
    elseif c <= b && b <= d
        return 1
    else
        return 0
    end
end

for workPair in input
    if hasOverlap(workPair) != 0
        println(workPair)
    end
end

println("Part 2: $(sum(map(hasOverlap, input)))")