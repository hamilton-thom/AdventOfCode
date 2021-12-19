#include "aoc.h"

struct Coordinate { int x, y, z, w; };

struct hashFunc{
    size_t operator()(const Coordinate &k) const{
    size_t h1 = std::hash<int>()(k.x);
    size_t h2 = std::hash<int>()(k.y);
    size_t h3 = std::hash<int>()(k.z);
    size_t h4 = std::hash<int>()(k.w);
    return ((h1 ^ (h2 << 1)) ^ h3 << 1) ^ h4;
    }
};

struct equalsFunc{
  bool operator()( const Coordinate& lhs, const Coordinate& rhs ) const{
    return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z) && (lhs.w == rhs.w);
  }
};

typedef unordered_set<Coordinate, hashFunc, equalsFunc> CoordinateSet;

CoordinateSet neighbours(const CoordinateSet &currentState);
CoordinateSet iterateCycle(const CoordinateSet &currentState);
int activeNeighbourCount(const CoordinateSet &currentState, const Coordinate &coord);

int main()
{
    ifstream inputFile("inputs/17.txt");
    vector<string> input;
    for (string s; getline(inputFile, s); )
        input.push_back(s);

    CoordinateSet activeStates;

    for (int i = 0; i < input.size(); i++)
        for (int j = 0; j < input[i].length(); j++)
            if (input[i][j] == '#')
                activeStates.insert(Coordinate{i, j, 0, 0});

    CoordinateSet finalunordered_set = activeStates;
    for (int i = 0; i < 6; i++)
        finalunordered_set = iterateCycle(finalunordered_set);

    cout << "Active count: " << finalunordered_set.size() << endl;
}


CoordinateSet iterateCycle(const CoordinateSet &currentState)
{
    CoordinateSet newActiveStates;

    for (Coordinate c : currentState)
    {
        int neighbourCount = activeNeighbourCount(currentState, c);
        if (neighbourCount == 2 || neighbourCount == 3)
            newActiveStates.insert(c);
    }

    for (Coordinate c : neighbours(currentState))
    {
        int neighbourCount = activeNeighbourCount(currentState, c);
        if (neighbourCount == 3)
            newActiveStates.insert(c);
    }

    return newActiveStates;
}


CoordinateSet neighbours(const CoordinateSet &currentState)
{
    CoordinateSet allNeighbours;

    for (Coordinate coord : currentState)
    {        
        for (int i = -1; i != 2; i++)
            for (int j = -1; j != 2; j++)
                for (int k = -1; k != 2; k++)
                    for (int l = -1; l != 2; l++)
                    {
                        if (i == 0 && j == 0 && k == 0 && l == 0)
                            continue;
                        allNeighbours.insert(Coordinate{coord.x + i, coord.y + j, coord.z + k, coord.w + l});
                    }    
    }    

    CoordinateSet neighbours;

    for (auto c : allNeighbours)
    {
        if (currentState.count(c) == 0)
            neighbours.insert(c);
    }

    return neighbours;
}


int activeNeighbourCount(const CoordinateSet &currentState, const Coordinate &coord)
{
    int activeCount = 0;
    for (int i = -1; i != 2; i++)
        for (int j = -1; j != 2; j++)
            for (int k = -1; k != 2; k++)
                for (int l = -1; l != 2; l++)
                {
                    if (i == 0 && j == 0 && k == 0 && l == 0)
                        continue;
                    if (currentState.count(Coordinate{coord.x + i, coord.y + j, coord.z + k, coord.w + l}) != 0)
                        activeCount++;
                }

    return activeCount;
}