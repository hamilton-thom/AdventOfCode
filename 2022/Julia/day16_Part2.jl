input = Vector{String}()
open("./input/day16.txt") do f    
    while !eof(f)                
        push!(input, readline(f))
    end
end

Destination = String
ArrivalTime = Int
TurnOnValve = Nothing
Move = Union{TurnOnValve, Tuple{Destination, ArrivalTime}}

struct ReferenceState
    distances :: Dict{Tuple{String, String}}
    flows :: Dict{String, Int}
    maxFlow :: Vector{Int} # This is stored once and then passed around on function calls - used to terminate recursion early.
end

# This keeps track of the state of the program as it recurses through. Make sure you copy
# the variable before modifying it - or you'll modify it for everyone!
mutable struct State
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

Base.copy(s :: State) = State(s.move1, s.move2, s.position1, s.position2, s.currentFlow, s.nestedLevel, s.remainingTime, copy(s.priorMoves1), copy(s.priorMoves2))

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
    # We need to include AA since that's also part of the network.
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

    return distances
end


# Part 2 - Elephant
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


function maxFlow(ref :: ReferenceState, state :: State, remainingValves :: Set{String}) :: Int
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

        return extraFlow + maximum([maxFlow(ref, state, remainingValves) for state in newStates])
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

        return extraFlow + maximum([maxFlow(ref, state, remainingValves) for state in newStates])
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

        return extraFlow + maximum([maxFlow(ref, state, remainingValves) for state in newStates])
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
        
        return maxFlow(ref, state, remainingValves)
    end
end

connections, flows = parseInput(input)
distances = buildDistances(connections, flows)

for i in 27:30
    refState = ReferenceState(distances, flows, [0])
    initialState = State(nothing, nothing, "AA", "AA", 0, 0, i, [], [])
    initialRemainingValues = filter(p -> p.second > 0 || p.first == "AA", flows) |> keys |> Set    
    println("Part 2: $i $(maxFlow(refState, initialState, initialRemainingValues))")
end 