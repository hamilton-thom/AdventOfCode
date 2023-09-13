input = Vector{Tuple{Char, Char}}()
open("./input/day2.txt") do f    
    while !eof(f) 
       push!(input, Tuple(map(x -> x[1], split(readline(f), " "))))
    end
end
# 1 Rock
# 2 Paper
# 3 Scissors

# 0 Lost
# 3 Draw
# 6 Win

# X Rock
# Y Paper
# Z Scissors

function map1(hand)
    if hand == 'A'
        return "Rock"
    elseif hand == 'B'
        return "Paper"
    else 
        return "Scissors"
    end
end

function map2(hand)
    if hand == 'X'
        return "Rock"
    elseif hand == 'Y'
        return "Paper"
    else 
        return "Scissors"
    end
end

function result(hand1, hand2)
    """
    Result is with respect to hand2! If hand2 wins then 1,
    if they lose then -1, else 0.
    """
    if hand1 == hand2
        return 0
    elseif hand1 == "Rock"
        return hand2 == "Paper" ? 1 : -1
    elseif hand1 == "Paper"
        return hand2 == "Scissors" ? 1 : -1
    else
        return hand2 == "Rock" ? 1 : -1
    end
end

function value(hand)
    if hand == "Rock"
        return 1
    elseif hand == "Paper"
        return 2
    else
        return 3
    end
end

function round(hands :: Tuple{Char, Char}) :: Int64
    opponent, me = hands
    oHand, meHand = map1(opponent), map2(me)
    return 3(result(oHand, meHand) + 1) + value(meHand)
end

score = 0
for hands in input
    global score += round(hands)
end

println("Part 1: $score")

# Part 2
resultTable = Dict()
hands = ["Rock", "Paper", "Scissors"]
for (hand1, hand2) in [(hand1, hand2) for hand1 in hands for hand2 in hands]
    global resultTable[(hand1, result(hand1, hand2))] = hand2
end

function newHand(hands :: Tuple{Char, Char})
    opponentHand, meHand = hands
    opponentHandConformed = map1(opponentHand)
    result = meHand - 'Y'

    return resultTable[(opponentHandConformed, result)]
end

newHand(('A', 'X'))

function round2(hands :: Tuple{Char, Char}) :: Int
    opponent, me = hands
    opponentConformed = map1(opponent)
    meConformed = newHand(hands)

    return 3(result(opponentConformed, meConformed) + 1) + value(meConformed)
end

round2(('A', 'X'))

score = 0
for hands in input
    global score += round2(hands)
end

println("Part 2: $score")