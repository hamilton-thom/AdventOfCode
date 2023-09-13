input = Vector{String}()
open("./input/day6.txt") do f    
    while !eof(f) 
        push!(input, readline(f))
    end
end
input = input[1]

# Part 1
start = 1
while length(Set(input[start:start+3])) != 4
    start += 1
end

print("Part 1: $(start + 3)")


# Part 2
start = 1
while length(Set(input[start:start+13])) != 14
    start += 1
end

print("Part 2: $(start+13)")