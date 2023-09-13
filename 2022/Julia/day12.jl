input = Vector{String}()
open("./input/day12.txt") do f    
    while !eof(f)                
        push!(input, readline(f))
    end
end


import Base: +, -

function +(t1 :: Tuple{<:Number, <:Number}, t2 :: Tuple{<:Number, <:Number})
    return (t1[1] + t2[1], t1[2] + t2[2])
end

function -(t1 :: Tuple{<:Number, <:Number}, t2 :: Tuple{<:Number, <:Number})
    return (t1[1] - t2[1], t1[2] - t2[2])
end

function parseMatrix(input :: Vector{String})
    rows, cols = length(input), length(input[1])
    result = zeros(Int, rows, cols)

    for i in 1:rows
        for j in 1:cols
            result[i, j] = input[i][j] - 'a'
        end
    end

    return result
end

inputMatrix = parseMatrix(input)

function getStartEnd(mat)
    s, e = -1, -1
    rows, cols = size(mat)
    for row in 1:rows
        for col in 1:cols
            if mat[row, col] == -14
                s = (row, col)
            elseif mat[row, col] == -28
                e = (row, col)
            end
        end
    end
    return (s, e)
end

function isValid(mat, coord)
    rows, cols = size(mat)
    row, col = coord

    if row ∈ 1:rows && col ∈ 1:cols
        return true
    else
        return false
    end
end

# Returns 0 if you can't make the distance.
function distance(mat, from, to)    
    if mat[from...] + 1 >= mat[to...]
        return 1
    else
        return 0
    end
end

function dijkstra(mat, s, e)
    mat = copy(mat)
    mat[s...] = 0
    mat[e...] = 26

    dists = Dict{Tuple{Int, Int}, Int}()
    stack = Vector{Tuple{Int, Int}}()

    dists[s] = 0
    push!(stack, s)

    while length(stack) > 0
        start = popfirst!(stack)
        directionOptions = [(0, 1), (0, -1), (1, 0), (-1, 0)]

        for option in directionOptions
            step = start + option            
            if isValid(mat, step)
                currentMinDistance = dists[start]
                stepSize = distance(mat, start, step)                
                if stepSize == 1
                    if haskey(dists, step)
                        if currentMinDistance + 1 < dists[step] 
                            dists[step] = currentMinDistance + 1
                            push!(stack, step)
                        end
                    else
                        dists[step] = currentMinDistance + 1
                        push!(stack, step)
                    end
                end
            end
        end

    end

    if haskey(dists, e)
        return dists[e]
    else
        return 1000000
    end
end

s, e = getStartEnd(inputMatrix)

println(dijkstra(inputMatrix, s, e))

rows, cols = size(inputMatrix)

lowestPoint = dijkstra(inputMatrix, s, e)

for row in 1:rows
    for col in 1:cols
        if inputMatrix[row, col] == 0
            global lowestPoint = min(dijkstra(inputMatrix, (row, col), e), lowestPoint)
        end
    end
end

println(lowestPoint)
