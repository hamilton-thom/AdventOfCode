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

function convertStringToInt(connections :: Dict{String, Vector{String}}, flows :: Dict{String, Int}) :: Tuple{Dict{Int, Vector{Int}}, Dict{Int, Int}}
    keyMap = Dict{String, Int}()

    # We need to know explicitly what the AA valve corresponds to.
    # We fix AA to be 0 for each access later.
    keyMap["AA"] = 0

    # Here we map the elements which are non-zero to the first values
    # of the bitset. We'll then add in the remaining zero-flow valves
    # after. This speeds up access since we'll be looping through the
    # int - and only want to stop the iteration as soon as we complete.

    # Here we sort through the flows making sure that the largest flow
    # is at the top. Then when we calculate the heuristic max potential
    # extra flow, we can loop through and cut down the additional times.
    i = 1
    for key in map(p -> p[1], sort(filter(p -> p.second > 0, flows) |> collect, by = p -> p.second, rev = true))
        if flows[key] > 0
            keyMap[key] = i
            i += 1
        end
    end

    for key in keys(connections)
        if key ∉ keys(keyMap)
            keyMap[key] = i
            i += 1
        end
    end

    connectionsNew = Dict{Int, Vector{Int}}()
    for (position, links) in connections
        newValues = [keyMap[link] for link in links]
        connectionsNew[keyMap[position]] = newValues
    end

    flowsNew = Dict{Int, Int}()
    for (position, flow) in flows
        flowsNew[keyMap[position]] = flow
    end

    return (connectionsNew, flowsNew)
end

function buildDistances(connections :: Dict{Int, Vector{Int}}, flows :: Dict{Int, Int}) :: Dict{Tuple{Int, Int}, Int}
    # We're interested in the distances between nodes with non-zero valve flow. 
    # We need to include AA since that's also part of the network. The distances
    # between adjacent nodes is always 1.
    nodesOfInterest = Set{Int}([0])
    for (key, value) in flows
        if value > 0 
            push!(nodesOfInterest, key)
        end
    end

    distances = Dict{Tuple{Int, Int}, Int}()

    # Populate distances for the nodes that we care about
    for startNode in nodesOfInterest
        nodeQueue = Vector{Int}()

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
    
    return distances

    # Filter to keep only elements where the second node is also in NodesOfInterest.
    return filter(kvp -> kvp.first[2] in nodesOfInterest, distances)
end

struct ReferenceState
    distances :: Dict{Tuple{Int, Int}}
    flows :: Dict{Int, Int}
    maxFlow :: Vector{Int} # This is stored once and then passed around on function calls - used to terminate recursion early.    
end

# Common set-up

connections, flows = parseInput(input)
connectionsInt, flowsInt = convertStringToInt(connections, flows)
distances = buildDistances(connectionsInt, flowsInt)
initialRemainingValves = filter(p -> p.second > 0 || p.first == 0, flowsInt) |> keys |> Set  

refState = ReferenceState(distances, flowsInt, [0])

# Part 1 - Max flow
function bestPotentialExtraFlow(ref :: ReferenceState, time :: Int, remainingValves :: Int)
    bestExtraFlow = 0
    valve = 0
    
    # This is used to sharpen the estimate. We know that the keys are in-order, so as
    # we loop through, we can reduce the time multiplier by the time reduction factor.
    timeReduction = 0

    while remainingValves != 0
        if 1 & remainingValves == 1
            bestExtraFlow += max(0, time - 3 - timeReduction) * ref.flows[valve]
            timeReduction += 2
        end
        remainingValves >>= 1
        valve += 1
    end
    return bestExtraFlow
end

# Trick: implment the set of remaining values as a bitset.
addPosition(set :: Int, position :: Int) = set | 1 << position
removePosition(set :: Int, position :: Int) = set & ~(1 << position)
inSet(set :: Int, position :: Int) = set & (1 << position) != 0

function buildInitialSet(ref :: ReferenceState)
    nonZeroFlowCount = filter(kvp -> kvp.second > 0, ref.flows) |> length

    initialSet = 0
    # Note: this goes from 0, not 1, since we also need to include AA.
    for i in 0:nonZeroFlowCount
        initialSet |= (1 << i)
    end

    return initialSet
end

function maxFlow(ref :: ReferenceState, position :: Int, time :: Int, flow :: Int, remainingValves :: Int)
    if time <= 1
        return 0
    end

    if flow + bestPotentialExtraFlow(ref, time, remainingValves) <= ref.maxFlow[1]
        # This path cannot result in a better outcome than one that's already been found - so exit early.
        return 0
    end

    remainingValves = removePosition(remainingValves, position)    
    
    thisFlow = ref.flows[position] * (time - 1)
    newFlow = flow + thisFlow

    if newFlow > ref.maxFlow[1]
        ref.maxFlow[1] = newFlow
    end

    runningMaxFlow = 0
    newPosition = 0
    valveLoop = remainingValves # Make a copy so we can loop through it without affecting the original remainingValves set.
    while valveLoop != 0
        if valveLoop & 1 == 1            
            runningMaxFlow = max(runningMaxFlow, maxFlow(ref, newPosition, time - 1 - ref.distances[(position, newPosition)], newFlow, remainingValves))
        end
        newPosition += 1
        valveLoop >>= 1
    end

    return thisFlow + runningMaxFlow
end

@time maxFlow(refState, 0, 31, 0, buildInitialSet(refState))
@time maxFlow(refState, 0, 31, 0, buildInitialSet(refState))
println("Part 1: $(maxFlow(refState, 0, 31, 0, buildInitialSet(refState)))")

if false
# Part 2 - Elephant

TurnOnValve = Nothing
Destination = String
ArrivalTime = Int
Move = Union{TurnOnValve, Tuple{Destination, ArrivalTime}}

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