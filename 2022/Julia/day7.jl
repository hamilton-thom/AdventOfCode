input = Vector{String}()
open("./input/day7.txt") do f    
    while !eof(f) 
       push!(input, readline(f))
    end
end

struct FileSystem
    directories :: Dict{String, FileSystem}
    files :: Dict{String, Int}
    parent :: Union{Nothing, FileSystem}
    size :: Vector{Int}    
    FileSystem() = new(Dict(), Dict(), nothing, [0])
    FileSystem(parent::FileSystem) = new(Dict(), Dict(), parent, [0])
end

root = FileSystem()

currentPosition = root
state = ("Waiting", "")
row = 1

while row <= length(input)    
    thisLine = input[row]
    if row < length(input)
        nextLine = input[row + 1]
    else
        nextLine = "moose"
    end

    println("$row - $thisLine")

    row = row + 1

    if state == ("Waiting", "")        
        if startswith(thisLine, "\$ cd ")
            cdRegex = r"\$ cd ([a-z/.]+)"

            targetDirectory, = match(cdRegex, thisLine).captures

            println("    cd $targetDirectory")

            if targetDirectory == "/"
                currentPosition = root
                continue
            end

            if targetDirectory == ".."
                currentPosition = currentPosition.parent
                continue
            end

            if haskey(currentPosition.directories, targetDirectory)
                currentPosition = currentPosition.directories[targetDirectory]
                continue
            end
            
            throw("Should not be here. Line: $thisLine Row: $row")
        end
    
        if startswith(thisLine, "\$ ls")
            println("    ls")
            state = ("Parsing directory", "")
            continue    
        end

    elseif state == ("Parsing directory", "")
        if startswith(nextLine, "\$")
            state = ("Waiting", "")
        end

        fileRegex = r"^([0-9]+) ([a-z.]+)"
        directoryRegex = r"^dir ([a-z]+)"

        fileMatch = match(fileRegex, thisLine)
        directoryMatch = match(directoryRegex, thisLine)

        println("    File match: $(!isnothing(fileMatch)) - Directory match: $(!isnothing(directoryMatch))")

        if isnothing(fileMatch) && isnothing(directoryMatch)
            throw("Should not be here. Line: $thisLine Row: $row")
        end

        if !isnothing(fileMatch)
            size, name = fileMatch.captures
            currentPosition.files[name] = parse(Int, size)
            continue                
        end

        if !isnothing(directoryMatch)            
            name, = directoryMatch.captures
            println("            $name")
            newFS = FileSystem(currentPosition)
            currentPosition.directories[name] = newFS
            continue
        end
    end   
end

function findSizes(fs)
    thisSize = 0

    for (_, subdirectory) in fs.directories
        thisSize += findSizes(subdirectory)
    end

    for (_, fileSize) in fs.files
        thisSize += fileSize
    end

    fs.size[1] = thisSize

    return thisSize
end

findSizes(root)

function totalSizes(fs)
    totalSize = 0

    for (_, subdirectory) in fs.directories
        totalSize += totalSizes(subdirectory)
    end

    if fs.size[1] <= 100000
        totalSize += fs.size[1]
    end
    
    return totalSize
end

totalSize = totalSizes(root)
totalSpace = 70000000
unusedSpaceRequired = 30000000

usedSpace = root.size[1]
remainingSpace = totalSpace - usedSpace
requiredSpace = unusedSpaceRequired - remainingSpace

allSizes = [root.size[1]]

function appendSizes!(fs)
    for (_, subdirectory) in fs.directories        
        append!(allSizes, subdirectory.size[1])
        appendSizes!(subdirectory)
    end
end

appendSizes!(root)

minSize = minimum([x for x in allSizes if x >= requiredSpace])