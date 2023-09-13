input = Vector{String}()
open("./input/day14.txt") do f    
    while !eof(f)                
        push!(input, readline(f))
    end
end

numbers(txt) = [parse(Int, m.match) for m in eachmatch(r"([0-9]+)", txt)]

import Base: +, -

function +(t1 :: Tuple{<:Number, <:Number}, t2 :: Tuple{<:Number, <:Number})
    return (t1[1] + t2[1], t1[2] + t2[2])
end

function -(t1 :: Tuple{<:Number, <:Number}, t2 :: Tuple{<:Number, <:Number})
    return (t1[1] - t2[1], t1[2] - t2[2])
end

function pushPoints!(coordinateSet, startCoordinate, endCoordinate)
    sx, sy = startCoordinate
    ex, ey = endCoordinate

    if sx == ex
        if sy < ey
            for i in sy:ey
                push!(coordinateSet, (sx, i))
            end
        else    
            for i in ey:sy
                push!(coordinateSet, (sx, i))
            end
        end
    else
        if sx < ex
            for i in sx:ex
                push!(coordinateSet, (i, sy))
            end
        else    
            for i in ex:sx
                push!(coordinateSet, (i, sy))
            end
        end
    end
end

function buildCoordinates(input)
    rockLocations = Set{Tuple{Int, Int}}()
    
    for line in input
        points = [numbers(point) for point in split(line, " -> ")]
        for (s, e) in zip(points, points[2:end])
            pushPoints!(rockLocations, s, e)
        end
    end

    return rockLocations
end

function dropGrain!(coordinateSet, bottomRow)
    sandPosition = (500, 0)    
    while true
        if sandPosition + (0, 1) ∉ coordinateSet
            if sandPosition[2] + 1 >= bottomRow
                return false
            end
            sandPosition += (0, 1)
            continue
        end
            
        if sandPosition + (-1, 1) ∉ coordinateSet
            if sandPosition[2] + 1 >= bottomRow
                return false
            end
            sandPosition += (-1, 1)
            continue
        end

        if sandPosition + (1, 1) ∉ coordinateSet
            if sandPosition[2] + 1 >= bottomRow
                return false
            end
            sandPosition += (1, 1)
            continue
        end
        
        push!(coordinateSet, sandPosition)
        return true
    end
end

function fillArea!(coordinateSet)
    bottomRow = maximum(map(x -> x[2], collect(coordinateSet)))
    count = 0
    while dropGrain!(coordinateSet, bottomRow)
        count += 1
    end 
    return count
end

# x, y -> y is going down!
print("Part 1: ")
println(fillArea!(buildCoordinates(input)))

# Part 2

function dropGrain2!(coordinateSet, bottomRow)
    sandPosition = (500, 0)    
    while true
        # If the next row is the floor then just stop.
        if sandPosition[2] + 1 == bottomRow
            push!(coordinateSet, sandPosition)
            return true
        end

        if sandPosition + (0, 1) ∉ coordinateSet            
            sandPosition += (0, 1)
            continue
        end
            
        if sandPosition + (-1, 1) ∉ coordinateSet            
            sandPosition += (-1, 1)
            continue
        end

        if sandPosition + (1, 1) ∉ coordinateSet            
            sandPosition += (1, 1)
            continue
        end
        
        push!(coordinateSet, sandPosition)
        return true
    end
end

function fillArea2!(coordinateSet)
    bottomRow = maximum(map(x -> x[2], collect(coordinateSet))) + 2
    count = 0
    while (500, 0) ∉ coordinateSet
        dropGrain2!(coordinateSet, bottomRow)
        count += 1
    end 
    return count
end

print("Part 2: ")
println(fillArea2!(buildCoordinates(input)))