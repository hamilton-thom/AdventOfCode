input = Vector{String}()
open("./input/day3.txt") do f    
    while !eof(f) 
       push!(input, readline(f))
    end
end

function value(c) :: Int64
    if c <= 'Z'
        return c - 'A' + 27
    else
        return c - 'a' + 1
    end
end

function compartmentSets(backpack :: String) :: Tuple{Set{Char}, Set{Char}}
    len = length(backpack)
    mid = len ÷ 2
    compartment1 = backpack[1:mid]
    compartment2 = backpack[mid+1:end]

    return Set(compartment1), Set(compartment2)
end

function commonItemTypes(backpack)
    set1, set2 = compartmentSets(backpack)    
    commonCharacters = collect(intersect(set1, set2))    
    return sum(map(value, commonCharacters))
end

total = 0
for line in input
    global total += commonItemTypes(line)
end

println("Part 1: $total")

function commonBadge(backpacks :: Vector{String})
    function backpackSet(backpack :: String)
        return union(compartmentSets(backpack)...)
    end
    backpackSets = map(backpackSet, backpacks)
    badge = collect(intersect(backpackSets...))
    return sum(map(value, badge))
end

total = 0
groups = length(input) ÷ 3
for group in 1:groups
    groupStart = 1 + 3(group - 1)
    groupEnd = 3group    
    global total += commonBadge(input[groupStart:groupEnd])
end

println("Part 2: $total")