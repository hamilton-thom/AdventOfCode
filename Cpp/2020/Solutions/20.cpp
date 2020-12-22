#include "aoc.h"

using Grid = vector<string>;
using std::make_pair;
using Coordinate = pair<int, int>;
using SidePair = pair<int, int>;

struct pair_hash
{
    template <class T1, class T2>
    std::size_t operator() (const std::pair<T1, T2> &pair) const
    {
        return std::hash<T1>()(pair.first) ^ std::hash<T2>()(pair.second);
    }
};

pair<int, Grid> getGrid(ifstream &inputFile);
vector<SidePair> getOptions(Grid grid);
SidePair sideToInt(string s);
Grid rotateGrid(Grid grid);
unordered_map<Coordinate, Grid, pair_hash> generateMap(vector<Grid> &inputs);
void printGrid(Grid g);
int leftBottomFrequencies(Grid, unordered_map<SidePair, int, pair_hash>);
Grid findBottomLeftCorner(const vector<Grid> &input);
string getRightEdge(Grid g);
string getTopEdge(Grid g);
Grid findGridWithEdge(unordered_set<Grid, pair_hash> grids, string edge);

int main()
{
    ifstream inputFile("inputs/20.txt");

    vector<pair<int, Grid>> input;

    while (inputFile)
    {
        input.push_back(getGrid(inputFile));
    }
    
    vector<Grid> grids;
    for (auto p : input)
        grids.push_back(p.second);

    unordered_map<Coordinate, Grid, pair_hash> test = generateMap(grids);

    for (int i = 0; i < 12; i++)
    {
        Grid g = test[make_pair(i, 0)];
        printGrid(g);
    }
}

void printGrid(Grid g)
{
    for (int i = 0; i < g.size(); i++)
    {
        for (int j = 0; j < g[0].size(); j++)
        {
            cout << g[i][j];
        }
        cout << endl;
    }
    cout << endl;
}


pair<int, Grid> getGrid(ifstream &inputFile)
{
    string s;
    getline(inputFile, s);
    istringstream iss(s);

    iss >> s;
    int tileId;
    iss >> tileId;

    vector<string> tile;
    getline(inputFile, s);
    
    while (s != "")
    {
        tile.push_back(s);
        getline(inputFile, s);
    }

    return make_pair(tileId, tile);
}


vector<SidePair> getOptions(Grid grid)
{
    string top, bottom, left, right;

    top = grid.front();
    bottom = grid.back();

    left = "";
    right = "";

    for (int i = 0; i < grid.size(); i++)
    {
        left += grid[i].front();
        right += grid[i].back();
    }

    vector<pair<int, int>> output;

    output.push_back(sideToInt(top));
    output.push_back(sideToInt(bottom));
    output.push_back(sideToInt(left));
    output.push_back(sideToInt(right));

    return output;
}


SidePair sideToInt(string s)
{
    int normal = 0, reverse = 0;

    for (int i = 0; i < s.length(); i++)
    {
        if (s[i] == '#')
        {
            normal += 1 << (s.length() - i - 1);
            reverse += 1 << i;
        }
    }

    if (normal < reverse)
    {
        return make_pair(normal, reverse);
    }
    else
    {
        return make_pair(reverse, normal);
    }    
}


vector<Grid> findCorners(const vector<Grid> &input)
{
    unordered_map<SidePair, int, pair_hash> edgeCounts;

    for (auto grid : input)
    {
        for (auto sidePair : getOptions(grid))
        {
            if (edgeCounts.count(sidePair) == 0)
            {
                edgeCounts[sidePair] = 1;                
            }   
            else
            {
                edgeCounts[sidePair]++;
            }
        }
    }

    // Find corners: these will be tiles which have two edges with count 1.

    vector<Grid> corners;

    for (auto grid : input)
    {
        int thisCount = 0;
        for (auto sidePair : getOptions(grid))
            thisCount += edgeCounts[sidePair];
        if (thisCount == 6)
            corners.push_back(grid);
    }    

    return corners;
}


Grid findBottomLeftCorner(const vector<Grid> &input)
{
    unordered_map<SidePair, int, pair_hash> edgeCounts;

    for (auto grid : input)
    {
        for (auto sidePair : getOptions(grid))
        {
            if (edgeCounts.count(sidePair) == 0)
            {
                edgeCounts[sidePair] = 1;                
            }   
            else
            {
                edgeCounts[sidePair]++;
            }
        }
    }

    // Find corners: these will be tiles which have two edges with count 1.

    vector<Grid> corners;

    for (auto grid : input)
    {
        int thisCount = 0;
        for (auto sidePair : getOptions(grid))
            thisCount += edgeCounts[sidePair];
        if (thisCount == 6)
            corners.push_back(grid);
    }    


    // Take the first grid element and then rotate so that it is in the right orientation.

    Grid initialPick = corners[0];
    while (leftBottomFrequencies(initialPick, edgeCounts) != 2)
    {
        initialPick = rotateGrid(initialPick);
    }

    return initialPick;
}

int leftBottomFrequencies(Grid g, unordered_map<SidePair, int, pair_hash> edgeCounts)
{
    SidePair bottom = sideToInt(g[9]);

    string leftString = "";
    for (int i = 0; i < 9; i++)
        leftString += g[i][0];

    SidePair left = sideToInt(leftString);

    return edgeCounts[bottom] + edgeCounts[left];
}


// Tested and works!
Grid rotateGrid(Grid grid)
{
    Grid rotatedGrid = grid;

    for (int i = 0; i < 10; i++)
    {
        for (int j = 0; j < 10; j++)
        {
            double translatedX = i - 4.5;
            double translatedY = j - 4.5;
            double rotatedX = -translatedY;
            double rotatedY = translatedX;
            int rotatedBackX = std::lround(rotatedX + 4.5);
            int rotatedBackY = std::lround(rotatedY + 4.5);
            //cout << "(" << i << ", " << j << ") -> (" << rotatedBackX << ", " << rotatedBackY << ")\n";
            rotatedGrid[i][j] = grid[rotatedBackX][rotatedBackY];
        }
    }

    return rotatedGrid;
}


Grid flipHorizontal(Grid grid)
{
    Grid flippedGrid = grid;

    for (int i = 0; i < 10; i++)
    {
        for (int j = 0; j < 10; j++)
        {            
            flippedGrid[i][j] = grid[i][9 - j];
        }
    }

    return flippedGrid;
}


vector<Grid> allSymmetries(Grid grid)
{
    vector<Grid> output;

    output.push_back(grid);
    output.push_back(rotateGrid(grid));
    output.push_back(rotateGrid(rotateGrid(grid)));
    output.push_back(rotateGrid(rotateGrid(rotateGrid(grid))));
    output.push_back(flipHorizontal(grid));
    output.push_back(flipHorizontal(rotateGrid(grid)));
    output.push_back(flipHorizontal(rotateGrid(rotateGrid(grid))));
    output.push_back(flipHorizontal(rotateGrid(rotateGrid(rotateGrid(grid)))));

    return output;
}


Grid rotateMatchingBottom(Grid initialGrid, string bottomEdge)
{
    vector<Grid> symmetries = allSymmetries(initialGrid);

    Grid output;

    for (Grid g : symmetries)
        if (g[9] == bottomEdge)
            return g;

    cout << "Shouldn't be here. Should have returned a grid.";
    return output;
}


Grid rotateMatchingLeft(Grid initialGrid, string leftEdge)
{
    vector<Grid> symmetries = allSymmetries(initialGrid);

    Grid output;

    for (Grid g : symmetries)
    {
        bool valid = true;
        for (int i = 0; i < 10; i++)
            if (g[i][0] != leftEdge[i])
                valid = false;
        if (valid)
            return g;
    }

    cout << "Shouldn't be here. Should have returned a grid.";
    return output;
}



unordered_map<Coordinate, Grid, pair_hash> generateMap(vector<Grid> &inputs)
{

    Grid bottomLeft = findBottomLeftCorner(inputs);

    unordered_map<Coordinate, Grid, pair_hash> mapPlacement;

    mapPlacement[make_pair(0, 0)] = bottomLeft;

    // place the bottom row - then we'll go up through each column 
    // from the bottom.

    unordered_set<Grid, pair_hash> availableGrids;
    for (Grid g : inputs)
        availableGrids.insert(g);
    availableGrids.erase(bottomLeft);

    Grid currentGrid = bottomLeft;
    for (int i = 1; i < 12; i++)
    {
        string rightEdge = getRightEdge(currentGrid);
        Grid nextGrid = findGridWithEdge(availableGrids, rightEdge);        
        Grid rotatedGrid = rotateMatchingLeft(nextGrid, rightEdge);
        mapPlacement[make_pair(0, i)] = rotatedGrid;
        currentGrid = rotatedGrid;
    }

    return mapPlacement;
}

Grid findGridWithEdge(unordered_set<Grid, pair_hash> grids, string edge)
{

    SidePair targetSidePair = sideToInt(edge);

    for (Grid grid : grids)
    {
        vector<SidePair> options = getOptions(grid);
        for (SidePair sp : options)
        {
            if (targetSidePair == sp)
                return grid;
        }
    }

    cout << "Shouldn't be here, there should be a matching grid beforehand.";

    Grid temp;
    return temp;
}


string getRightEdge(Grid g)
{
    string s = "";
    for (int i = 0; i < 9; i++)
    {
        s += g[i][9];
    }

    return s;
}


string getTopEdge(Grid g)
{
    return g[0];
}