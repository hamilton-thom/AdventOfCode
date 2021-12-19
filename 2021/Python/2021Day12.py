# -*- coding: utf-8 -*-
"""
Created on Sun Dec 12 06:44:45 2021

@author: choes
"""


input = """QF-bw
end-ne
po-ju
QF-lo
po-start
XL-ne
bw-US
ne-lo
nu-ne
bw-po
QF-ne
ne-ju
start-lo
lo-XL
QF-ju
end-ju
XL-end
bw-ju
nu-start
lo-nu
nu-XL
xb-XL
XL-po"""


links = [x.split("-") for x in input.split("\n")]

edges = {}

for start, end in links:
    if start in edges:
        edges[start].add(end)
    else:
        edges[start] = {end}
    
    if end in edges:
        edges[end].add(start)
    else:
        edges[end] = {start}
        
# Part 1

def findRoutes(edges, visitedCaves, fromCell, route):
    returnRoutes = []    
    for nextCave in edges[fromCell]:
        routeCopy = route.copy()
        routeCopy.append(nextCave)
        if nextCave == "end":
            returnRoutes += [" -> ".join(route)]
            continue
        
        if nextCave not in visitedCaves:
            visitedCavesCopy = visitedCaves.copy()
            if nextCave.islower():
                visitedCavesCopy.add(nextCave)            
            returnRoutes += findRoutes(edges, visitedCavesCopy, nextCave, routeCopy)
    
    return returnRoutes

print(len(findRoutes(edges, {"start"}, "start", ["start"])))

# Part 1

def findRoutes2(edges, visitedCaveCounts, fromCell, route):
    returnRoutes = []    
    for nextCave in edges[fromCell]:
        if nextCave == "start":
            continue
        
        routeCopy = route.copy()
        routeCopy.append(nextCave)
        if nextCave == "end":
            returnRoutes += [" -> ".join(routeCopy)]
            continue
        
        if nextCave.isupper():
            visitedCaveCountsCopy = visitedCaveCounts.copy()
            returnRoutes += findRoutes2(edges, visitedCaveCountsCopy, nextCave, routeCopy)
        else:
            maxVisitCount = max([v for k,v in visitedCaveCounts.items() if k != "start"])            
            if maxVisitCount < 2:
                visitedCaveCountsCopy = visitedCaveCounts.copy()
                visitedCaveCountsCopy[nextCave] += 1
                returnRoutes += findRoutes2(edges, visitedCaveCountsCopy, nextCave, routeCopy)
                
            elif visitedCaveCounts[nextCave] == 0:
                visitedCaveCountsCopy = visitedCaveCounts.copy()
                visitedCaveCountsCopy[nextCave] += 1
                returnRoutes += findRoutes2(edges, visitedCaveCountsCopy, nextCave, routeCopy)            
    
    return returnRoutes

visitedCaveCounts = {cave: 0 for cave in edges if cave.islower()}
visitedCaveCounts["start"] = 2

print(len(findRoutes2(edges, visitedCaveCounts, "start", ["start"])))


def routeCount(edges):
    
    allJourneys = set()    
    thisJourney = ["start"]
    smallCavesVisited = {"start"}
    
    visitStack = []
    for cave in edges["start"]:
        visitStack.append(cave)
        
    pivotChoices = [len(visitStack)]
    
    while len(visitStack) > 0:
        print(visitStack)
        print(smallCavesVisited)
        nextCave = visitStack.pop()        
        
        thisJourney.append(nextCave)      
        print(" -> ".join(thisJourney))
        print(pivotChoices)        
        
        
        if nextCave == "end":
            allJourneys.add(" -> ".join(thisJourney))
            
            thisJourney.pop()
            
            while len(pivotChoices) > 0 and pivotChoices[-1] == 1:
                lastCave = thisJourney[-1]
                if lastCave in smallCavesVisited:                    
                    smallCavesVisited.remove(lastCave)
                pivotChoices.pop()
                thisJourney.pop()
            
            print()
            continue
        
        if nextCave.islower():
            smallCavesVisited.add(nextCave)
        
        canContinue = False
        routesAdded = 0
        for cave in edges[nextCave]:
            if cave not in smallCavesVisited:
                visitStack.append(cave)
                canContinue = True
                routesAdded += 1
        
        pivotChoices.append(routesAdded)
        
        print(canContinue)
        
        if not canContinue:
            # Have to re-wind a step.
            while len(pivotChoices) > 0 and pivotChoices[-1] == 1:
                lastCave = thisJourney[-1]
                if lastCave in smallCavesVisited:                    
                    smallCavesVisited.remove(lastCave)
                pivotChoices.pop()
                thisJourney.pop()      
                
        print()

    return allJourneys




['start -> b -> d -> b -> A -> c -> A -> c -> A -> end',
 'start -> b -> A -> b -> A -> c -> A -> c -> A -> end', 
 'start -> b -> A -> c -> A -> b -> A -> c -> A -> end',
 'start -> b -> A -> c -> A -> b -> A -> end', 
 'start -> b -> A -> c -> A -> c -> A -> b -> A -> end',
 'start -> b -> A -> c -> A -> c -> A -> b -> end',
 
 
 
 
 
 
 start,b,A,b,A,c,A,end
start,b,A,b,A,end
start,b,A,b,end
start,b,A,c,A,b,A,end
start,b,A,c,A,b,end
start,b,A,c,A,c,A,end
start,b,A,c,A,end
start,b,A,end
start,b,d,b,A,c,A,end
start,b,d,b,A,end
start,b,d,b,end
start,b,end