input = Vector{String}()
open("./input/day11.txt") do f    
    while !eof(f)                
        push!(input, readline(f))
    end
end

numbers(txt) = [parse(Int, m.match) for m in eachmatch(r"([0-9]+)", txt)]

mutable struct Monkey
    id :: Int
    items :: Vector{Int}
    operation #:: Function{Int, Int}
    throwTo #:: Function{Int, Int}
end

function parseMonkey(lines, megamod)
    monkeyId = numbers(lines[1])[1]
    startItems = numbers(lines[2])
    operationNumbers = numbers(lines[3])        
    operation =             
        typeof(match(r"\+", lines[3])) == Nothing ? 
        x -> x * (length(operationNumbers) == 0 ? x : operationNumbers[1]) :
        x -> x + (length(operationNumbers) == 0 ? x : operationNumbers[1])
    testDivisibleBy = numbers(lines[4])[1]
    push!(megamod, testDivisibleBy)
    trueThrowTo = numbers(lines[5])[1]
    falseThrowTo = numbers(lines[6])[1]
    throwTo = x -> x % testDivisibleBy == 0 ? trueThrowTo : falseThrowTo
    return Monkey(monkeyId, startItems, operation, throwTo)
end

# Part 1

monkeys = []
currentLines = []
for line in input
    if line == ""        
        push!(monkeys, parseMonkey(currentLines, []))
        global currentLines = []
    else
        push!(currentLines, line)
    end
end
push!(monkeys, parseMonkey(currentLines, []))

inspectionCounts = fill(0, length(monkeys))

function runRound!(monkeys)
    for monkey in monkeys
        for item in monkey.items
            inspectionCounts[monkey.id + 1] += 1
            newItemValue = monkey.operation(item)
            newItemValue ÷= 3
            toMonkey = monkey.throwTo(newItemValue)
            push!(monkeys[toMonkey + 1].items, newItemValue)
        end
        monkey.items = []
    end
end

for round in 1:20    
    runRound!(monkeys)    
end

# Part 2

function getMonkeysAndProduct() :: Tuple{Vector{Monkey}, Int}
    monkeys = []
    currentLines = []
    megamod = []
    for line in input
        if line == ""            
            push!(monkeys, parseMonkey(currentLines, megamod))
            currentLines = []
        else
            push!(currentLines, line)
        end
    end
    push!(monkeys, parseMonkey(currentLines, megamod))
    return monkeys, prod(megamod)
end

function part2(monkeys, primeProduct)
    inspectionCounts = fill(0, length(monkeys))
    for round in 1:10000
        for monkey in monkeys
            inspectionCounts[monkey.id + 1] += length(monkey.items)
            for item in monkey.items                
                newItemValue = monkey.operation(item) % primeProduct
                toMonkey = monkey.throwTo(newItemValue)
                push!(monkeys[toMonkey + 1].items, newItemValue)
            end
            monkey.items = []
        end
    end
    return sort(inspectionCounts[end-1:end])
end

function part2_withTypes(monkeys :: Vector{Monkey}, primeProduct :: Int)
    inspectionCounts = fill(0, length(monkeys))
    for _ in 1:10000
        for monkey in monkeys
            inspectionCounts[monkey.id + 1] += length(monkey.items)
            for item in monkey.items
                newItemValue = monkey.operation(item) % primeProduct
                toMonkey = monkey.throwTo(newItemValue)
                push!(monkeys[toMonkey + 1].items, newItemValue)
            end
            monkey.items = []
        end
    end
    return sort(inspectionCounts[end-1:end])
end


function setupState(monkeys :: Vector{Monkey})
    itemCount = sum(map(x -> length(x.items), monkeys))
    itemValues = zeros(Int, length(monkeys), 2 * itemCount)    
    counts = zeros(Int, length(monkeys)) # Represents the number to read on your turn
    
    for monkey in monkeys
        i = 1 # Start on the left side of the matrix
        monkeyIndex = monkey.id + 1        
        counts[monkeyIndex] += length(monkey.items)
        for item in monkey.items
            itemValues[monkeyIndex, i] = item            
            i += 1
        end
    end

    return itemValues, counts, itemCount
end


function part2_withNoAllocations(monkeys :: Vector{Monkey}, primeProduct :: Int)
    inspectionCounts = fill(0, length(monkeys))
    readFirstSection = true  
    itemValues, counts, itemCount = setupState(monkeys)

    startEndValues = Dict{Bool, Tuple{Int, Int, Int, Int}}()
    
    readStart, readEnd = 1, itemCount
    writeStart, writeEnd = itemCount + 1, 2 * itemCount
    startEndValues[true] = (readStart, readEnd, writeStart, writeEnd)

    readStart, readEnd = itemCount + 1, 2 * itemCount
    writeStart, writeEnd = 1, itemCount
    startEndValues[false] = (readStart, readEnd, writeStart, writeEnd)

    # We now have a matrix which we'll flick between the left and right sides.
    for _ in 1:10000
        readStart, readEnd, writeStart, writeEnd = startEndValues[readFirstSection]
        for monkey in monkeys
            monkeyIndex = monkey.id + 1
            inspectionCounts[monkeyIndex] += counts[monkeyIndex]
            for i in 1:counts[monkeyIndex]
                newItemValue = monkey.operation(itemValues[monkeyIndex, readStart + i - 1]) % primeProduct
                toMonkey = monkey.throwTo(newItemValue)

                counts[toMonkey + 1] += 1
                if toMonkey > monkey.id
                    itemValues[toMonkey + 1, readStart + counts[toMonkey + 1]] = newItemValue
                elseif toMonkey < monkey.id
                    itemValues[toMonkey + 1, writeStart + counts[toMonkey + 1]] = newItemValue
                else
                    error("Shouldn't be here...")
                end
            end
            counts[monkeyIndex] = 0
        end
        readFirstSection = !readFirstSection
    end
    return sort(inspectionCounts[end-1:end])
end

function part2_withNoAllocationsAndFunction(monkeys :: Vector{Monkey}, primeProduct :: Int)
    inspectionCounts = fill(0, length(monkeys))
    readFirstSection = true  
    itemValues, counts, itemCount = setupState(monkeys)

    startValues = Dict{Bool, Tuple{Int, Int}}()
    
    readStart, writeStart = 1, itemCount + 1    
    startValues[true] = (readStart, writeStart)

    readStart, writeStart = itemCount + 1, 1    
    startValues[false] = (readStart, writeStart)

    # We now have a matrix which we'll flick between the left and right sides.
    for _ in 1:10000        
        round!(monkeys, itemValues, inspectionCounts, counts, startValues[readFirstSection], primeProduct)
        readFirstSection = !readFirstSection
    end
    return sort(inspectionCounts[end-1:end])
end

function part2_withNoAllocations(monkeys :: Vector{Monkey}, primeProduct :: Int)
    inspectionCounts = fill(0, length(monkeys))
    readFirstSection = true  
    itemValues, counts, itemCount = setupState(monkeys)

    startEndValues = Dict{Bool, Tuple{Int, Int, Int, Int}}()
    
    readStart, readEnd = 1, itemCount
    writeStart, writeEnd = itemCount + 1, 2 * itemCount
    startEndValues[true] = (readStart, readEnd, writeStart, writeEnd)

    readStart, readEnd = itemCount + 1, 2 * itemCount
    writeStart, writeEnd = 1, itemCount
    startEndValues[false] = (readStart, readEnd, writeStart, writeEnd)

    # We now have a matrix which we'll flick between the left and right sides.
    for _ in 1:10000
        readStart, readEnd, writeStart, writeEnd = startEndValues[readFirstSection]
        for monkey in monkeys
            monkeyIndex = monkey.id + 1
            inspectionCounts[monkeyIndex] += counts[monkeyIndex]
            newItemValues = monkey.operation.(itemValues[monkeyIndex, readStart:readEnd]) .% primeProduct
            toMonkeys = monkey.throwTo.(newItemValues)

            for i in 1:counts[monkeyIndex]
                counts[toMonkeys[i] + 1] += 1
                if toMonkeys[i] > monkey.id
                    itemValues[toMonkeys[i] + 1, readStart + counts[toMonkeys[i] + 1]] = newItemValues[i]
                elseif toMonkeys[i] < monkey.id
                    itemValues[toMonkeys[i] + 1, writeStart + counts[toMonkeys[i] + 1]] = newItemValues[i]
                else
                    error("Shouldn't be here...")
                end
            end
            counts[monkeyIndex] = 0
        end
        readFirstSection = !readFirstSection
    end
    return sort(inspectionCounts[end-1:end])
end

function round!(
    monkeys :: Vector{Monkey}, itemValues :: Matrix{Int}, inspectionCounts :: Vector{Int}, 
    counts :: Vector{Int}, startValues :: Tuple{Int, Int}, primeProduct :: Int
    )
    readStart, writeStart = startValues
    for monkey in monkeys
        monkeyIndex = monkey.id + 1
        inspectionCounts[monkeyIndex] += counts[monkeyIndex]
        for i in 1:counts[monkeyIndex]
            newItemValue = 2 * itemValues[monkeyIndex, readStart + i - 1] % primeProduct# monkey.operation(itemValues[monkeyIndex, readStart + i - 1]) % primeProduct
            toMonkey = monkey.throwTo(newItemValue)

            counts[toMonkey + 1] += 1
            start = toMonkey > monkey.id ? readStart : writeStart
            itemValues[toMonkey + 1, start + counts[toMonkey + 1]] = newItemValue            
        end
        counts[monkeyIndex] = 0
    end
end

inputs = getMonkeysAndProduct()

@time part2(inputs...)
@time part2_withTypes(inputs...)
@time part2_withNoAllocations(inputs...)
@time part2_withNoAllocationsAndFunction(inputs...)
@time setupState(inputs[1])

monkeys, primeProd = inputs
itemValues, counts, itemCount = setupState(monkeys)


startValues = Dict{Bool, Tuple{Int, Int}}()
   
readStart, writeStart = 1, itemCount + 1    
startValues[true] = (readStart, writeStart)

readStart, writeStart = itemCount + 1, 1    
startValues[false] = (readStart, writeStart)

@time round!(monkeys, itemValues, inspectionCounts, counts, startValues[true], primeProd)
@time round!(monkeys, itemValues, inspectionCounts, counts, startValues[true], primeProd)