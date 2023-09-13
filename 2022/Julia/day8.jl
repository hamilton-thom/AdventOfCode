input = Vector{Vector{Int}}()
open("./input/day8.txt") do f    
    while !eof(f) 
       line = readline(f)
       ints = parse.(Int, split(line, ""))
       push!(input, ints)
    end
end

input = hcat(input...) |> transpose


input

rows, cols = size(input)

# Directions - top, bottom, left, right

treeCount = -4

trees = Set()

for i in 1:rows
    # Top
    maxHeight = -1
    row = 1
    while row <= rows
        if input[row, i] > maxHeight
            print("Top: ($row, $i) ")
            maxHeight = input[row, i]
            treeCount += 1
            push!(trees, (row, i))
        end
        row += 1
    end

    # Bottom
    maxHeight = -1
    row = rows
    while row >= 1
        if input[row, i] > maxHeight
            print("Bottom: ($row, $i) ")
            maxHeight = input[row, i]
            treeCount += 1
            push!(trees, (row, i))
        end
        row -= 1
    end

    # Left
    maxHeight = -1
    col = 1
    while col <= cols
        if input[i, col] > maxHeight
            print("Left: ($i, $col) ")
            maxHeight = input[i, col]
            treeCount += 1
            push!(trees, (i, col))            
        end
        col += 1
    end

    # Right
    maxHeight = -1
    col = cols
    while col >= 1
        if input[i, col] > maxHeight
            print("Right: ($i, $col) ")
            maxHeight = input[i, col]
            treeCount += 1
            push!(trees, (i, col))
        end
        col -= 1
    end
    println()
end

print(length(collect(trees)))

import Base: +

function +(t1 :: Tuple{Int, Int}, t2 :: Tuple{Int, Int})
    return (t1[1] + t2[1], t1[2] + t2[2])
end

function countInOneDirection(position :: Tuple{Int, Int}, direction :: Tuple{Int, Int})
    thisTreeHeight = input[position...]

    testPosition = position + direction

    visibleTrees = 0
    while testPosition[1] ∈ 1:rows && testPosition[2] ∈ 1:cols 
        visibleTrees += 1

        if input[testPosition...] >= thisTreeHeight
            break
        end
        
        testPosition += direction
    end
    
    return visibleTrees
end

function scenicScore(position :: Tuple{Int, Int})
    return (
        countInOneDirection(position, ( 1,  0)) *
        countInOneDirection(position, ( 0,  1)) * 
        countInOneDirection(position, (-1,  0)) * 
        countInOneDirection(position, ( 0, -1))
    )
end

maxScore = 0
for row in 1:rows
    for col in 1:cols
        maxScore = max(maxScore, scenicScore((row, col)))
    end
end

print(maxScore)