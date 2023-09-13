input = Vector{String}()
open("./input/day18.txt") do f    
    while !eof(f)                
        push!(input, readline(f))
    end
end

numbers(txt) = [parse(Int, m.match) for m in eachmatch(r"([0-9]+)", txt)]

coordinates = Set{Vector{Int}}()

for line in input
    push!(coordinates, numbers(line))
end

function part1(coordinates :: Set{Vector{Int}})
    matchingCount = 0
    
    for c1 in coordinates
        for c2 in coordinates
            if sum(abs.(c1-c2)) == 1
                matchingCount += 1
            end
        end
    end

    return 6 * length(coordinates) - matchingCount
end

println("Part 1: $(part1(coordinates))")

function bfsAllCoords(coordinates :: Set{Vector{Int}}) :: Set{Vector{Int}}
    projectX(xyz) = xyz[1]
    projectY(xyz) = xyz[2]
    projectZ(xyz) = xyz[3]

    xValues = map(projectX, collect(coordinates)) |> Set
    yValues = map(projectY, collect(coordinates)) |> Set
    zValues = map(projectZ, collect(coordinates)) |> Set

    minX, maxX = minimum(xValues)-1, maximum(xValues)+1
    minY, maxY = minimum(yValues)-1, maximum(yValues)+1
    minZ, maxZ = minimum(zValues)-1, maximum(zValues)+1

    println("$minX, $maxX, $minY, $maxY, $minZ, $maxZ")

    # Search Cube will be (MinX -1, MaxX +1) (MinY - 1, MaxY + 1) (MinZ - 1, MaxZ + 1)
    
    reachableCoordinates = Set{Vector{Int}}()

    function neighbours(xyz)
        x, y, z = xyz
        return [[x-1, y, z], [x+1, y, z], [x, y-1, z], [x, y+1, z], [x, y, z-1], [x, y, z+1]]
    end
       
    function filterInBox(neighbours)
        filteredList = []
        for xyz in neighbours
            x, y, z = xyz
            if x ∈ minX:maxX && y ∈ minY:maxY && z ∈ minZ:maxZ
                push!(filteredList, xyz)
            end
        end
        return filteredList
    end

    function filterNotInDrop(neighbours)
        filteredList = []
        for xyz in neighbours
            if xyz ∉ coordinates && xyz ∉ reachableCoordinates
                push!(filteredList, xyz)
            end
        end
        return filteredList
    end

    newNeighbours(xyz) = xyz |> neighbours |> filterInBox |> filterNotInDrop

    searchStart = [minX, minY, minZ]
    searchQueue = []
    push!(searchQueue, searchStart)

    existingSearchElements = Dict()
    
    while length(searchQueue) > 0
        println("Search queue length: $(length(searchQueue))")
        firstElement = popfirst!(searchQueue)
        push!(reachableCoordinates, firstElement)
        
        for neighbour in newNeighbours(firstElement)
            queueCount = get!(existingSearchElements, neighbour, 0)
            if queueCount == 0
                existingSearchElements[neighbour] = 1
                push!(searchQueue, neighbour)
            end
        end
    end

    println("Search cube size: $((maxX - minX + 1) * (maxY - minY + 1) * (maxZ - minZ + 1))")
    println("Reachable cube count: $(length(reachableCoordinates))")    

    return reachableCoordinates
end

function part2(coordinates :: Set{Vector{Int}})
    reachableCoordinates = bfsAllCoords(coordinates)

    projectXY(xyz) = [xyz[1], xyz[2]]
    projectXZ(xyz) = [xyz[1], xyz[3]]
    projectYZ(xyz) = [xyz[2], xyz[3]]

    xyCoords = Dict()
    yzCoords = Dict()
    xzCoords = Dict()

    for coordinate in coordinates
        xy, yz, xz = projectXY(coordinate), projectYZ(coordinate), projectXZ(coordinate)

        if xy ∈ keys(xyCoords)
            push!(xyCoords[xy], coordinate)
        else
            xyCoords[xy] = [coordinate]
        end 

        if yz ∈ keys(yzCoords)
            push!(yzCoords[yz], coordinate)
        else
            yzCoords[yz] = [coordinate]
        end 

        if xz ∈ keys(xzCoords)
            push!(xzCoords[xz], coordinate)
        else
            xzCoords[xz] = [coordinate]
        end 
    end

    interiorCells = Set{Vector{Int}}()

    # XY projection -> Z axis
    for (_, cubes) in xyCoords
        sortedCubes = sort(cubes)
        first, last = sortedCubes[1], sortedCubes[end]        
        for i in first[3]:last[3]
            thisCube = [first[1], first[2], i]
            if thisCube ∉ coordinates && thisCube ∉ reachableCoordinates
                push!(interiorCells, thisCube)
            end
        end
    end

    println()
    # yz projection -> X axis
    for (_, cubes) in yzCoords
        sortedCubes = sort(cubes)
        first, last = sortedCubes[1], sortedCubes[end]        
        for i in first[1]:last[1]
            thisCube = [i, first[2], first[3]]
            if thisCube ∉ coordinates && thisCube ∉ reachableCoordinates
                push!(interiorCells, thisCube)
            end
        end
    end
    println()
    # XZ projection -> Y axis
    for (_, cubes) in xzCoords
        sortedCubes = sort(cubes)
        first, last = sortedCubes[1], sortedCubes[end]        
        for i in first[2]:last[2]
            thisCube = [first[1], i, first[3]]
            if thisCube ∉ coordinates && thisCube ∉ reachableCoordinates
                push!(interiorCells, thisCube)
            end
        end
    end

    println("Interior cells: $interiorCells")

    return part1(coordinates) - part1(interiorCells)
end

print("Part 2: $(part2(coordinates))")
    
