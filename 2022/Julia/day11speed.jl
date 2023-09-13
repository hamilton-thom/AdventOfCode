input = Vector{String}()
open("./input/day11.txt") do f    
    while !eof(f)                
        push!(input, readline(f))
    end
end

numbers(txt) = [parse(Int, m.match) for m in eachmatch(r"([0-9]+)", txt)]

struct Monkey    
    items :: Vector{Int}
    operation :: Tuple{Char, Int} # + = plus, * = multiply, ^ = square
    throwTo :: Tuple{Int, Int, Int} # Divisiblity criteria, send if true, send if false
end

function parseMonkey(lines)
    startItems = numbers(lines[2])

    operationNumbers = numbers(lines[3])
    operation =
        length(operationNumbers) == 0 ?
            ('^', 0) :
        typeof(match(r"\+", lines[3])) == Nothing ?
            ('*', operationNumbers[1]) :
            ('+', operationNumbers[1])
    
    testDivisibleBy = numbers(lines[4])[1]
    trueThrowTo = numbers(lines[5])[1] + 1
    falseThrowTo = numbers(lines[6])[1] + 1

    throwTo = (testDivisibleBy, trueThrowTo, falseThrowTo)
    
    return Monkey(startItems, operation, throwTo)
end

function getMonkies() :: Vector{Monkey}
    monkeys = []
    currentLines = []    
    for line in input
        if line == ""            
            push!(monkeys, parseMonkey(currentLines))
            currentLines = []
        else
            push!(currentLines, line)
        end
    end
    push!(monkeys, parseMonkey(currentLines))
    return monkeys
end

function newValue(monkey :: Monkey, value :: Int, primeProduct :: Int)
    if monkey.operation[1] == '+'
        return (value + monkey.operation[2]) % primeProduct
    elseif monkey.operation[1] == '*'
        return (value * monkey.operation[2]) % primeProduct
    else
        return (value * value) % primeProduct
    end
end

function toMonkey(monkey :: Monkey, value :: Int)
    if value % monkey.throwTo[1] == 0
        return monkey.throwTo[2]
    else
        return monkey.throwTo[3]
    end
end

function runRounds(monkies :: Vector{Monkey})
    itemCounts = collect(map(x -> length(x.items), monkies))
    allItemCount = sum(itemCounts)
    modValue = prod(map(x -> x.throwTo[1], monkies))
    monkeyCount = length(monkies)

    itemStorage = zeros(Int, monkeyCount, allItemCount)
    for monkeyId in 1:monkeyCount
        for itemId in 1:itemCounts[monkeyId]
            itemStorage[monkeyId, itemId] = monkies[monkeyId].items[itemId]
        end
    end
    
    processCounts = zeros(Int, monkeyCount)

    for _ in 1:10000
        for monkeyId in 1:monkeyCount
            processCounts[monkeyId] += itemCounts[monkeyId]
            for itemId in 1:itemCounts[monkeyId]
                newItemValue = newValue(monkies[monkeyId], itemStorage[monkeyId, itemId], modValue)
                to = toMonkey(monkies[monkeyId], newItemValue)
                itemStorage[to, itemCounts[to] + 1] = newItemValue
                itemCounts[to] += 1
            end
            itemCounts[monkeyId] = 0
        end
    end

    return sort(processCounts)
end

@time runRounds(getMonkies())
@time runRounds(getMonkies())

print(runRounds(getMonkies()))
