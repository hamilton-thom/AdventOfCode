input = Vector{Tuple{String, Int}}()
open("./input/day9.txt") do f    
    while !eof(f)        
        direction, steps = match(r"([UDLR]) ([0-9]+)", readline(f)).captures
        push!(input, (direction, parse(Int, steps)))
    end
end


import Base: +, -
import LinearAlgebra: norm

function +(t1 :: Tuple{<:Number, <:Number}, t2 :: Tuple{<:Number, <:Number})
    return (t1[1] + t2[1], t1[2] + t2[2])
end

function -(t1 :: Tuple{<:Number, <:Number}, t2 :: Tuple{<:Number, <:Number})
    return (t1[1] - t2[1], t1[2] - t2[2])
end



function mapDirection(direction)
    if direction == "U"
        return (1, 0)
    elseif direction == "D"
        return (-1, 0)
    elseif direction == "L"
        return (0, -1)
    elseif direction == "R" 
        return (0, 1)
    end
end

function updateTail(head, currentTail)
    difference = head - currentTail
    distance = norm(difference)

    if distance < 2
        return currentTail
    end
    
    # In this case the head is 2 or more away
    if distance == 2
        return currentTail + ((head - currentTail) ./ 2)
    end

    if abs(head[1] - currentTail[1]) == 1
        return (head[1], (head[2] + currentTail[2]) / 2)
    else
        return ((head[1] + currentTail[1]) / 2, head[2])
    end
end

head = (0, 0)
tail = (0, 0)

tailStates = Set()
push!(tailStates, tail)

for instruction in input
    direction, steps = instruction

    directionStep = mapDirection(direction)

    for i in 1:steps
        head += directionStep
        tail = updateTail(head, tail)
        push!(tailStates, tail)
    end
end

print(length(tailStates))

function run()
    # Part 2
    positions = []
    for _ in 1:10
        push!(positions, (0, 0))
    end

    tailStates = Set()
    printState(positions)
    println()

    moose = 1
    for instruction in input[1:2]        
        direction, steps = instruction

        directionStep = mapDirection(direction)

        for _ in 1:steps
            print("Position [1]: $(positions[1]) -> ")
            positions[1] += directionStep
            println("$(positions[1])")

            for j in 2:10
                print("Position [$j]: $(positions[j]) -> ")
                positions[j] = updateTail(positions[j-1], positions[j])
                println("$(positions[j])")
            end
            if moose == 102922
                printState(positions)
                println()
            end
            println()
            push!(tailStates, positions[10])
        end
        println()
        println()
        moose += 1
    end
end

function printNumber(n)
    if n > 0
        print(" ")
        if n ∈ 1:9
            print(" ")
            print(n)
        else 
            print(n)
        end
        return
    end
    if n == 0
        print("  0")
        return
    end

    if n ∈ -1:-1:-9
        print(" ")
        print(n)
    else
        print(n)
    end
end



print(length(tailStates))

function printState(state)
    for row in 20:-1:-20
        printNumber(row)
        for col in -20:20
            if (row, col) ∈ state
                print("#")
            else
                print(".")
            end
        end 
        println()
    end
end

