input = Vector{String}()
open("./input/day16.txt") do f    
    while !eof(f)                
        push!(input, readline(f))
    end
end

function parseInput(input) :: Tuple{Dict{String, Vector{String}}, Dict{String, Int}}
    connections = Dict{String, Vector{String}}()
    flows = Dict{String, Int}()

    for line in input        
        re = r"Valve ([A-Z]{2}) has flow rate=([0-9]+); tunnel[s]{0,1} lead[s]{0,1} to valve[s]{0,1} ([A-Z, ]+)"
        captures = match(re, line).captures
        fromValve = captures[1]
        flowRate = parse(Int, captures[2])
        toValves = split(captures[3], ", ")

        connections[fromValve] = toValves
        flows[fromValve] = flowRate
    end

    return (connections, flows)
end

function buildDistances(connections :: Dict{String, Vector{String}}, flows :: Dict{String, Int}) :: Dict{Tuple{String, String}, Int}
    # We're interested in the distances between nodes with non-zero valve flow. 
    # We need to include AA since that's also part of the network. The distances
    # between adjacent nodes is always 1.
    nodesOfInterest = Set{String}(["AA"])
    for (key, value) in flows
        if value > 0 
            push!(nodesOfInterest, key)
        end
    end

    distances = Dict{Tuple{String, String}, Int}()

    # Populate distances for the nodes that we care about
    for startNode in nodesOfInterest
        nodeQueue = Vector{String}()

        # Initialise the queue.
        for node in connections[startNode]
            push!(nodeQueue, node)
            distances[(startNode, node)] = 1
        end

        while length(nodeQueue) > 0
            testNode = popfirst!(nodeQueue)
            for node in connections[testNode]
                if (startNode, node) ∉ keys(distances)
                    distances[(startNode, node)] = distances[(startNode, testNode)] + 1
                    push!(nodeQueue, node)
                elseif distances[(startNode, testNode)] + 1 < distances[(startNode, node)]
                    distances[(startNode, node)] = distances[(startNode, testNode)] + 1
                    push!(nodeQueue, node)
                end
            end 
        end
    end
    # TODO: filter the distances dictionary to only contain keys where _both_ start and end
    # are in nodes of interest. Currently this will include a lot of keys which we don't care 
    # about.
    return distances
end

TurnOnValve = Nothing
Destination = String
ArrivalTime = Int
Move = Union{TurnOnValve, Tuple{Destination, ArrivalTime}}

struct ReferenceState
    distances :: Dict{Tuple{String, String}}
    flows :: Dict{String, Int}
    maxFlow :: Vector{Int} # This is stored once and then passed around on function calls - used to terminate recursion early.
    positionToBit :: Dict{String, Int}
    bitToPosition :: Dict{Int, String}
end

# Common set-up

connections, flows = parseInput(input)
distances = buildDistances(connections, flows)
initialRemainingValves = filter(p -> p.second > 0 || p.first == "AA", flows) |> keys |> Set  

positionToBit = Dict{String, Int}()
bitToPosition = Dict{Int, String}()

i = 0
for position in initialRemainingValves
    positionToBit[position] = i
    bitToPosition[i] = position
    global i += 1
end

refState = ReferenceState(distances, flows, [0], positionToBit, bitToPosition)

# Part 1 - Max flow
# This is confirmed working...

function bestPotentialExtraFlow(ref :: ReferenceState, position :: String, time :: Int, remainingValves :: Set{String})
    bestExtraFlow = 0
    for valve in remainingValves
        bestExtraFlow += max(0, time - 3) * ref.flows[valve]
    end
    return bestExtraFlow
end

function maxFlow1(ref :: ReferenceState, position :: String, time :: Int, remainingValves :: Set{String})
    if time <= 1
        return 0
    end

    remainingValves = copy(remainingValves)
    delete!(remainingValves, position)
    
    thisFlow = ref.flows[position] * (time - 1)

    return thisFlow + maximum([
        maxFlow1(ref, newPosition, time - 1 - ref.distances[(position, newPosition)], remainingValves) 
        for newPosition in remainingValves
        ])
end

@time maxFlow1(refState, "AA", 31, initialRemainingValves)

println("Part 1: $(maxFlow1(refState, "AA", 31, initialRemainingValves))")

function maxFlow1b(ref :: ReferenceState, position :: String, time :: Int, flow :: Int, remainingValves :: Set{String})
    if time <= 1
        return 0
    end

    if flow + bestPotentialExtraFlow(ref, position, time, remainingValves) < ref.maxFlow[1]
        # This path cannot result in a better outcome than one that's already been found - so exit early.
        return 0
    end

    remainingValves = copy(remainingValves)
    delete!(remainingValves, position)
    
    thisFlow = ref.flows[position] * (time - 1)
    newFlow = flow + thisFlow

    if newFlow > ref.maxFlow[1]
        ref.maxFlow[1] = newFlow
    end

    return thisFlow + maximum([
        maxFlow1b(ref, newPosition, time - 1 - ref.distances[(position, newPosition)], newFlow, remainingValves) 
        for newPosition in remainingValves
        ])
end

@time maxFlow1b(refState, "AA", 31, 0, initialRemainingValves)
println("Part 1: $(maxFlow1b(refState, "AA", 31, 0, initialRemainingValves))")


# Trick: implment the set of remaining values as a bitset.

function addPosition(ref :: ReferenceState, set :: Int64, position :: String) :: Int64
    return set | 1 << ref.positionToBit[position]
end

function removePosition(ref :: ReferenceState, set :: Int64, position :: String) :: Int64
    return set & ~(1 << ref.positionToBit[position])
end

function inSet(ref :: ReferenceState, set :: Int64, position :: String) :: Bool
    return (1 & (set >> ref.positionToBit[position])) == 1
end

d = Dict{Int, Vector{String}}()

function getPositions(ref :: ReferenceState, set :: Int64) :: Vector{String}
    if set in d
        return d[set]
    end
    
    result = []
    i = 0
    while set != 0
        if 1 & set == 1
            push!(result, ref.bitToPosition[i])
        end
        i += 1
        set >>= 1
    end
    d[set] = result

    return result
end

function bestPotentialExtraFlow1c(ref :: ReferenceState, position :: String, time :: Int, remainingValves :: Int64)
    bestExtraFlow = 0
    for valve in getPositions(ref, remainingValves)
        bestExtraFlow += max(0, time - 3) * ref.flows[valve]
    end
    return bestExtraFlow
end
 
function maxFlow1c(ref :: ReferenceState, position :: String, time :: Int, flow :: Int, remainingValves :: Int64)
    if time <= 1
        return 0
    end

    if flow + bestPotentialExtraFlow1c(ref, position, time, remainingValves) < ref.maxFlow[1]
        # This path cannot result in a better outcome than one that's already been found - so exit early.
        return 0
    end
    
    remainingValves = removePosition(ref, remainingValves, position)

    thisFlow = ref.flows[position] * (time - 1)
    newFlow = flow + thisFlow

    if newFlow > ref.maxFlow[1]
        ref.maxFlow[1] = newFlow
    end

    return thisFlow + maximum([
        maxFlow1c(ref, newPosition, time - 1 - ref.distances[(position, newPosition)], newFlow, remainingValves) 
        for newPosition in getPositions(ref, remainingValves)
        ])
end

initialRemainingValvesIntSet = 0
for position in initialRemainingValves
    global initialRemainingValvesIntSet = addPosition(refState, initialRemainingValvesIntSet, position)
end

@time maxFlow1c(refState, "AA", 31, 0, initialRemainingValvesIntSet)
println("Part 1: $(maxFlow1c(refState, "AA", 31, 0, initialRemainingValvesIntSet))")

if false

# Part 2 - Elephant

# This keeps track of the state of the program as it recurses through. Make sure you copy
# the variable before modifying it - or you'll modify it for everyone!
mutable struct Part2State
    move1 :: Move
    move2 :: Move    
    position1 :: String
    position2 :: String
    currentFlow :: Int # This is the current total amount of flow generated. We track so that we can terminate early if needed.
    nestedLevel :: Int
    remainingTime :: Int
    priorMoves1 :: Vector{Move}
    priorMoves2 :: Vector{Move}
end

Base.copy(s :: Part2State) = Part2State(s.move1, s.move2, s.position1, s.position2, s.currentFlow, s.nestedLevel, s.remainingTime, copy(s.priorMoves1), copy(s.priorMoves2))

function buildMoves(
    position :: String, remainingTime :: Int, remainingValves :: Set{String}, ref :: ReferenceState
    ) :: Vector{Tuple{String, Int}}
    # Hack! This is to ensure that if there's one location left 
    # We can test both routes where elephant 1 goes there and elephant 2 goes there.
    moves = [("AA", 0)]
    for move in remainingValves
        # Note: some pairs may end up having negative time for completion - this is fine - they just won't be completed.
        # We can filter them out - because of the ("AA",0) option above - we're guaranteed that we won't lose moves.
        if remainingTime > ref.distances[(position, move)]
            push!(moves, (move, remainingTime - ref.distances[(position, move)]))
        end
    end
    return moves
end


function maxPossibleExtraFlow(remainingValves :: Set{String}, ref :: ReferenceState, remainingTime :: Int) :: Int
    maxPotential = 0
    for move in remainingValves
        maxPotential += ref.flows[move]
    end
    return maxPotential * (remainingTime - 1)
end


function maxFlow2(ref :: ReferenceState, state :: Part2State, remainingValves :: Set{String}) :: Int
    state = copy(state)
    state.nestedLevel += 1
    state.remainingTime -= 1
    remainingValves = copy(remainingValves)

    switchValve1, switchValve2 = isnothing(state.move1), isnothing(state.move2)

    # Both valves get switched on
    if (switchValve1, switchValve2) == (true, true)
        if state.position1 ∉ remainingValves ∪ Set("AA")
            println("\n\n")
            println("$state")
            println("Remaining Valves: $remainingValves")
            println("\n\n")
            throw("Error - trying to un-do a given state, but it should already be undone.")
        end
        if state.position2 ∉ remainingValves ∪ Set("AA")
            println("\n\n")
            println("$state")
            println("Remaining Valves: $remainingValves")
            println("\n\n")
            throw("Error - trying to un-do a given state, but it should already be undone.")
        end

        extraFlow = state.remainingTime * (ref.flows[state.position1] + ref.flows[state.position2])
        state.currentFlow += extraFlow
        
        delete!(remainingValves, state.position1)
        delete!(remainingValves, state.position2)

        if state.currentFlow + maxPossibleExtraFlow(remainingValves, ref, state.remainingTime) < ref.maxFlow[1]
            # If there's no possible way that we can complete the valves better 
            # than the current best, terminate early.
            return 0
        elseif state.currentFlow > ref.maxFlow[1]
            # If we've beaten the recorded max flow - update the max flow.
            ref.maxFlow[1] = state.currentFlow
        end

        newMoves1 = buildMoves(state.position1, state.remainingTime, remainingValves, ref)
        newMoves2 = buildMoves(state.position2, state.remainingTime, remainingValves, ref)

        newStates = []
        for (move1, move2) in [(move1, move2) for move1 in newMoves1 for move2 in newMoves2 if move1[1] ≠ move2[1]]
            newState = copy(state)
            newState.move1 = move1
            newState.move2 = move2
            push!(newState.priorMoves1, move1)
            push!(newState.priorMoves2, move2)
            push!(newStates, newState)
        end

        if length(newStates) == 0
            return extraFlow
        end

        return extraFlow + maximum([maxFlow2(ref, state, remainingValves) for state in newStates])
    end

    # Valve 1 gets switched on
    if (switchValve1, switchValve2) == (true, false)
        if state.position1 ∉ remainingValves ∪ Set("AA")
            println("\n\n")
            println("$state")
            println("Remaining Valves: $remainingValves")
            println("\n\n")
            throw("Error - trying to un-do a given state, but it should already be undone.")
        end
        extraFlow = state.remainingTime * ref.flows[state.position1]
        state.currentFlow += extraFlow
        
        delete!(remainingValves, state.position1)

        if state.currentFlow + maxPossibleExtraFlow(remainingValves, ref, state.remainingTime) < ref.maxFlow[1]
            # If there's no possible way that we can complete the valves better 
            # than the current best, terminate early.
            return 0
        elseif state.currentFlow > ref.maxFlow[1]
            # If we've beaten the recorded max flow - update the max flow.
            ref.maxFlow[1] = state.currentFlow
        end

        newStates = []
        for move in buildMoves(state.position1, state.remainingTime, remainingValves, ref)
            if move[1] ≠ state.move2[1]
                newState = copy(state)
                newState.move1 = move 
                push!(newState.priorMoves1, move)
                if newState.move2[2] == state.remainingTime            
                    newState.position2 = newState.move2[1]
                    newState.move2 = nothing
                    push!(newState.priorMoves2, nothing)
                end
                push!(newStates, newState)
            end
        end

        if length(newStates) == 0
            return extraFlow + max(0, (state.move2[2] - 1) * ref.flows[state.move2[1]])
        end

        return extraFlow + maximum([maxFlow2(ref, state, remainingValves) for state in newStates])
    end

    # Valve 2 gets switched on
    if (switchValve1, switchValve2) == (false, true)
        if state.position2 ∉ remainingValves ∪ Set("AA")
            println("\n\n")
            println("$state")
            println("Remaining Valves: $remainingValves")
            println("\n\n")
            throw("Error - trying to un-do a given state, but it should already be undone.")
        end
        extraFlow = state.remainingTime * ref.flows[state.position2]
        state.currentFlow += extraFlow
        
        delete!(remainingValves, state.position2)

        if state.currentFlow + maxPossibleExtraFlow(remainingValves, ref, state.remainingTime) < ref.maxFlow[1]
            # If there's no possible way that we can complete the valves better 
            # than the current best, terminate early.
            return 0
        elseif state.currentFlow > ref.maxFlow[1]
            # If we've beaten the recorded max flow - update the max flow.
            ref.maxFlow[1] = state.currentFlow
        end

        newStates = []
        for move in buildMoves(state.position2, state.remainingTime, remainingValves, ref)
            if move[1] ≠ state.move1[1]
                newState = copy(state)
                newState.move2 = move
                push!(newState.priorMoves2, move)
                if newState.move1[2] == state.remainingTime      
                    newState.position1 = newState.move1[1]      
                    newState.move1 = nothing
                    push!(newState.priorMoves1, nothing)
                end
                push!(newStates, newState)
            end
        end

        if length(newStates) == 0
            return extraFlow + max(0, (state.move1[2] - 1) * ref.flows[state.move1[1]])
        end

        return extraFlow + maximum([maxFlow2(ref, state, remainingValves) for state in newStates])
    end

    # Neither valve gets switched on
    if (switchValve1, switchValve2) == (false, false)
        if state.move1[2] == state.remainingTime
            state.position1 = state.move1[1]
            state.move1 = nothing
            push!(state.priorMoves1, nothing)
        end

        if state.move2[2] == state.remainingTime
            state.position2 = state.move2[1]
            state.move2 = nothing
            push!(state.priorMoves2, nothing)
        end 
        
        return maxFlow2(ref, state, remainingValves)
    end
end



for i in 27:30
    refState = ReferenceState(distances, flows, [0])
    initialState = State(nothing, nothing, "AA", "AA", 0, 0, i, [], [])
    initialRemainingValues = filter(p -> p.second > 0 || p.first == "AA", flows) |> keys |> Set    
    println("Part 2: $i $(maxFlow2(refState, initialState, initialRemainingValues))")
end 
end