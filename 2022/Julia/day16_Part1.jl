input = Vector{String}()
open("./input/day16.txt") do f    
    while !eof(f)                
        push!(input, readline(f))
    end
end

struct Move
    move :: Union{Tuple{String, String}, Nothing} # From -> To, Nothing => Turn on Valve      
end

isTurnOnValve(move :: Move) = isnothing(move.move)

Base.show(io::IO, move::Move) = 
    if isTurnOnValve(move)
        print(io, "Turn on valve")
    else
        print(io, "$(move.move[1]) -> $(move.move[2])")
    end

function Base.getindex(move :: Move, index :: Int)
    if isnothing(move.move)
        throw("Attempting to access a position in a nothing case.")
    else
        return move.move[index]
    end
end

struct GlobalState 
    flowDict :: Dict{String, Int}
    pathDict :: Dict{String, Vector{String}}
    visitCounts :: Dict{String, Int} # Allow you to visit each node twice - since you might need to go back.
    valves :: Dict{String, Bool} # true - open
    moveStack :: Vector{Tuple{Int, Move}} # The tuple is (Depth, Move) <- depth used to determine going back
    GlobalState() = new(Dict(), Dict(), Dict(), Dict(), Vector())
end 

function Base.show(io::IO, globalState :: GlobalState)
    println(io, "Global State")
    println(io, "    Visitor Counts: $(globalState.visitCounts)")
    println(io, "    Valves: $(globalState.valves)")
    println(io, "    Move stack:")
    for move in globalState.moveStack
        println(io, "        $move")
    end
end

mutable struct LocalState
    totalFlow :: Int
    startOfMinute :: Int # Time at the start of the move.
    position :: String
    moveHistory :: Vector{Move}
    LocalState() = new(0, 0, "AA", Vector())
end

function Base.show(io::IO, localState::LocalState)
    println(io, "Local State")
    println(io, "    Time: $(localState.startOfMinute), Flow: $(localState.totalFlow), Position: $(localState.position)")
    println(io, "    Historic moves:")
    i = 29
    for move in localState.moveHistory
        print(io, "        $move")
        if isTurnOnValve(move)
            print(io, " - remaining time: $i")
        end
        println(io)
        i -= 1
    end
end

function initialiseGlobalState(input)    
    state = GlobalState()

    for line in input        
        re = r"Valve ([A-Z]{2}) has flow rate=([0-9]+); tunnel[s]{0,1} lead[s]{0,1} to valve[s]{0,1} ([A-Z, ]+)"
        captures = match(re, line).captures
        fromValve = captures[1]
        flowRate = parse(Int, captures[2])
        toValves = split(captures[3], ", ")

        state.valves[fromValve] = false
        state.visitCounts[fromValve] = 0
        state.flowDict[fromValve] = flowRate
        state.pathDict[fromValve] = toValves
    end

    state.visitCounts["AA"] = 1

    return state
end

function makeMove!(globalState :: GlobalState, localState :: LocalState, move :: Move)
    # Return false - run out of time
    # Return true - time remaining
    push!(localState.moveHistory, move)

    remainingTime = 29 - localState.startOfMinute    
    
    localState.startOfMinute += 1
    if remainingTime == 0
        return false
    end

    if isTurnOnValve(move)
        globalState.valves[localState.position] = true        
        localState.totalFlow += remainingTime * globalState.flowDict[localState.position]
    else
        # Move to another place
        localState.position = move[2]
        globalState.visitCounts[localState.position] += 1
        if globalState.visitCounts[localState.position] > 2
            throw("Error - should not be here.")
        end
    end 

    return true
end

function undoLastMove!(globalState :: GlobalState, localState :: LocalState)
    # Return true - undo successful
    # Return false - no more moves to undo
    if length(localState.moveHistory) > 0
        move = pop!(localState.moveHistory)
    else
        return false
    end

    localState.startOfMinute -= 1
    previousRemainingTime = 29 - localState.startOfMinute

    if isTurnOnValve(move)        
        globalState.valves[localState.position] = false
        localState.totalFlow -= previousRemainingTime * globalState.flowDict[localState.position]
    else
        # Move back
        globalState.visitCounts[localState.position] -= 1
        localState.position = move[1]
    end 

    return true
end

function lastPosition(localState :: LocalState)
    i = length(localState.moveHistory)
    while i > 0 && isTurnOnValve(localState.moveHistory[i])
        i -= 1
    end

    if i == 0
        return nothing
    else
        return localState.moveHistory[i][1]
    end    
end

function getMoves(globalState :: GlobalState, localState :: LocalState)
    moves = []

    if localState.startOfMinute >= 29
        return moves
    end

    currentPosition = localState.position
    currentDepth = length(localState.moveHistory)
    for to in globalState.pathDict[currentPosition]
        if globalState.visitCounts[to] < 1
            push!(moves, (currentDepth, Move((currentPosition, to))))
        end
    end

    if !globalState.valves[currentPosition] && globalState.flowDict[currentPosition] > 0        
        push!(moves, (currentDepth, Move(nothing)))
    end

    return moves
end

function printState(io :: IO, globalState :: GlobalState, localState :: LocalState)
    println(io, localState)
    println(io, globalState)        
    println(io)
end

function search(input)
    open("Moose.txt", "w") do io
        currentMax = 0

        globalState = initialiseGlobalState(input)
        localState = LocalState()

        moveStack = globalState.moveStack
        append!(moveStack, getMoves(globalState, localState))
        
        debug = true

        i = 1
        while length(globalState.moveStack) > 0
            println(io, "------------------------------------------------")    
            println(io, "Iteration: $i")
            if debug
                printState(io, globalState, localState)
            end

            (depth, move) = pop!(moveStack)

            while depth < length(localState.moveHistory)
                undoLastMove!(globalState, localState)
                println(io, "Undoing last move")
            end

            if !makeMove!(globalState, localState, move)
                println(io, "Run out of time")                            
            end

            if length(getMoves(globalState, localState)) == 0
                println(io, "No available moves")                            
            end

            append!(moveStack, getMoves(globalState, localState))
                
            if localState.totalFlow > currentMax
                currentMax = localState.totalFlow      
                if !debug
                    println(io, "New max: $currentMax, at iteration: $i")
                    printState(io, globalState, localState)           
                end
            end
            i += 1
        end
        
        return currentMax
    end
end

println("Part 1: $(search(input))")