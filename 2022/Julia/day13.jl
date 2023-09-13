input = Vector{String}()
open("./input/day13.txt") do f    
    while !eof(f)                
        push!(input, readline(f))
    end
end

numbers(txt) = [parse(Int, m.match) for m in eachmatch(r"([0-9]+)", txt)]

function parsePair(string)
    if length(string) == 0
        # Passed an empty line
        return nothing
    end

    listOfInts = r"^\[(([0-9]*)[,]{0,1})+\]$"

    if !isnothing(match(listOfInts, string))
        return numbers(string)
    end

    output = []

    innerString = string[2:end-1]
    
    while length(innerString) > 0
        firstElement, remainder = getFirstSegment(innerString)

        if typeof(firstElement) == Int
            push!(output, firstElement)
        else
            push!(output, parsePair(firstElement))
        end

        if isnothing(remainder)            
            return output
        else
            innerString = remainder
        end
    end

    return output
end

function getFirstSegment(string)
    if string[1] == '['
        leftCount = 1
        rightCount = 0
        i = 1        
        while rightCount < leftCount
            i += 1
            if string[i] == ']'
                rightCount += 1
            elseif string[i] == '[' 
                leftCount += 1
            end
        end
        if i + 1 <= length(string) && string[i+1] == ','
            return (string[1:i], string[i+2:end])
        else
            return (string[1:i], nothing)
        end
    end

    i = 1
    while i <= length(string) && !isnothing(match(r"^[0-9]+$", string[1:i]))
        i += 1
    end
    i -= 1
    if i + 1 <= length(string) && string[i+1] == ','        
        return (parse(Int, string[1:i]), string[i+2:end])
    else
        return (parse(Int, string[1:i]), nothing)
    end
end

x = ["[1,1,3,1,1]", "[1,1,5,1,1]", "[[1],[2,3,4]]", "[[1],4]"]

for example in x
    println(parsePair(example))
end

# REturn 1 if left > right, -1 if left < right, 0 if left == right
function compare(left, right)
    leftLen = length(left)
    rightLen = length(right)

    for i in 1:leftLen
        leftElement = left[i]
        if i > rightLen
            return 1
        end
        rightElement = right[i]

        if typeof(leftElement) == Int && typeof(rightElement) == Int            
            if leftElement < rightElement
                return -1
            elseif leftElement > rightElement
                return 1
            end
            continue
        end

        if typeof(leftElement) <: Vector{Any} && typeof(rightElement) <: Vector{Any}            
            comp = compare(leftElement, rightElement)
            if comp != 0
                return comp
            end
            continue
        end

        if typeof(leftElement) == Int
            leftElement = [leftElement]
        elseif typeof(rightElement) == Int
            rightElement = [rightElement]
        end
        
        comp = compare(leftElement, rightElement)
        if comp != 0
            return comp
        end
    end

    return 0
end

y = map(parsePair, x)

compare(y[3], y[4])

pairs = []
pairId = 1
for line in input    
    parsedInput = parsePair(line)
    if isnothing(parsedInput)
        pairs = []
        continue
    end

    push!(pairs, parsedInput)

    if length(pairs) == 2
        println("Pairs: $pairId")
        println(pairs)        
        println(compare(pairs[1], pairs[2]))
        pairId += 1
    end
end