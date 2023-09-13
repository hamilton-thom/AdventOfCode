#include "aoc.h"
#include <functional>

using std::make_pair;

using Grid = vector<string>;
using Coordinate = pair<int, int>;
using SideHash = int;

struct pair_hash
{
    template <class T1, class T2>
    std::size_t operator() (const std::pair<T1, T2> &pair) const
    {
        return std::hash<T1>()(pair.first) ^ std::hash<T2>()(pair.second);
    }
};

struct Grid_hash
{
    std::size_t operator() (const Grid &g) const
    {
        std::size_t hash = 0;
        for (string s : g)
            hash ^= std::hash<std::string>{}(s);

        return hash;
    }
};


pair<int, Grid> getGrid(ifstream &inputFile);
unordered_map<Coordinate, Grid, pair_hash> generateMap(vector<Grid> &inputs);
void printGrid(Grid g);
Grid extractImage(unordered_map<Coordinate, Grid, pair_hash> megaGrid);


int main(int ac, char** av)
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

    printGrid(extractImage(test));
}


void printGrid(Grid g)
{
    for (string s : g)
        cout << s << "\n";    
    cout << endl;    
}


pair<int, Grid> getGrid(ifstream &inputFile)
{
    string s;
    getline(inputFile, s);
    istringstream iss(s);

    iss.ignore(5);
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


SideHash hashSide(string s)
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

    return normal < reverse ? normal : reverse;
}


vector<SideHash> edgeHashes(Grid grid)
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

    vector<SideHash> output;

    output.push_back(hashSide(top));
    output.push_back(hashSide(bottom));
    output.push_back(hashSide(left));
    output.push_back(hashSide(right));

    return output;
}


unordered_map<SideHash, int> globalEdgeCounts(vector<Grid> &input)
{
    unordered_map<SideHash, int> edgeCounts;

    for (auto grid : input)
        for (SideHash hash : edgeHashes(grid))
        {
            if (edgeCounts.count(hash) == 0)
            {
                edgeCounts[hash] = 1;                
            }
            else
            {
                edgeCounts[hash]++;
            }
        }

    return edgeCounts;
}

vector<Grid> findCorners(vector<Grid> &input)
{
    unordered_map<SideHash, int> edgeCounts = globalEdgeCounts(input);

    // Find corners: these will be tiles which have two edges with count 1.
    vector<Grid> corners;

    for (auto grid : input)
    {
        int thisCount = 0;
        for (SideHash hash : edgeHashes(grid))
            thisCount += edgeCounts[hash];
        if (thisCount == 6)
            corners.push_back(grid);
    }    

    return corners;
}


int leftBottomFrequencies(Grid g, unordered_map<SideHash, int> &edgeCounts)
{
    string leftString = "";
    for (int i = 0; i < 10; i++)
        leftString += g[i][0];

    SideHash left = hashSide(leftString);
    SideHash bottom = hashSide(g.back());

    return edgeCounts[bottom] + edgeCounts[left];
}


Grid rotateGrid(Grid grid)
{
    Grid rotatedGrid = grid;

    for (int i = 0; i < 10; i++)
        for (int j = 0; j < 10; j++)
        {
            double translatedX = i - 4.5;
            double translatedY = j - 4.5;
            double rotatedX = -translatedY;
            double rotatedY = translatedX;
            int rotatedBackX = std::lround(rotatedX + 4.5);
            int rotatedBackY = std::lround(rotatedY + 4.5);
            rotatedGrid[i][j] = grid[rotatedBackX][rotatedBackY];
        }

    return rotatedGrid;
}


Grid bottomLeftCorner(vector<Grid> &input)
{
    unordered_map<SideHash, int> edgeCounts = globalEdgeCounts(input);

    vector<Grid> corners = findCorners(input);

    Grid initialPick = corners[0];
    while (leftBottomFrequencies(initialPick, edgeCounts) != 2)
    {
        initialPick = rotateGrid(initialPick);
    }

    return initialPick;
}


Grid flipHorizontal(Grid grid)
{
    Grid flippedGrid = grid;

    for (int i = 0; i < 10; i++)
        for (int j = 0; j < 10; j++)
        {            
            flippedGrid[i][j] = grid[i][9 - j];
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


string getTopEdge(Grid g)
{
    return g.front();
}


string getBottomEdge(Grid g)
{
    return g.back();
}


string getRightEdge(Grid g)
{
    string s = "";
    for (int i = 0; i < 10; i++)
        s += g[i].back();

    return s;
}


string getLeftEdge(Grid g)
{
    string s = "";
    for (int i = 0; i < 10; i++)
        s += g[i].front();

    return s;
}


// Note that for these functions, the grid being tested is above/to the right of
// the grid which it will connect onto.
Grid rotateMatchingBottom(Grid grid, string bottomEdge)
{
    vector<Grid> symmetries = allSymmetries(grid);

    Grid output;

    for (Grid g : symmetries)
        if (getBottomEdge(g) == bottomEdge)
            return g;

    cout << "rotateMatchingBottom: Shouldn't be here.\n";
    return output;
}


Grid rotateMatchingLeft(Grid initialGrid, string leftEdge)
{
    vector<Grid> symmetries = allSymmetries(initialGrid);

    Grid output;

    //cout << "Target edge: " << leftEdge << "\n";

    for (Grid g : symmetries)
    {
        //printGrid(g);
      //  cout << "Left edge: " << getLeftEdge(g) << "\n";
        if (getLeftEdge(g) == leftEdge)
            return g;
    }

    cout << "rotateMatchingLeft: Shouldn't be here.\n";
    return output;
}



Grid findGridWithEdge(unordered_set<Grid, Grid_hash> &grids, string edge)
{
    SideHash targetHash = hashSide(edge);

    for (Grid g : grids)
    {
        vector<SideHash> hashes = edgeHashes(g);
        for (SideHash hash : hashes)
            if (targetHash == hash)
                return g;
    }   

    cout << "findGridWithEdge: Shouldn't be here.\n";
    
    return Grid {};
}


unordered_map<Coordinate, Grid, pair_hash> generateMap(vector<Grid> &inputs)
{
    Grid bottomLeft = bottomLeftCorner(inputs);

    unordered_map<Coordinate, Grid, pair_hash> mapPlacement;

    mapPlacement[make_pair(0, 0)] = bottomLeft;

    // Place the bottom row.

    unordered_set<Grid, Grid_hash> availableGrids;
    for (Grid g : inputs)
        availableGrids.insert(g);
    availableGrids.erase(bottomLeft);

    Grid currentGrid = bottomLeft;
    for (int i = 1; i < 12; i++)
    {
        Coordinate thisPosition = make_pair(i, 0);
        string rightEdge = getRightEdge(currentGrid);
        Grid nextGrid = findGridWithEdge(availableGrids, rightEdge);        
        Grid rotatedGrid = rotateMatchingLeft(nextGrid, rightEdge);
        mapPlacement[thisPosition] = rotatedGrid;

        

        currentGrid = rotatedGrid;
    }

    for (int i = 0; i < 12; i++)
    {
        currentGrid = mapPlacement[make_pair(i, 0)];
        for (int j = 1; j < 12; j++)
        {
            Coordinate thisPosition = make_pair(i, j);
            string topEdge = getTopEdge(currentGrid);
            Grid nextGrid = findGridWithEdge(availableGrids, topEdge);
            Grid rotatedGrid = rotateMatchingBottom(nextGrid, topEdge);
            mapPlacement[thisPosition] = rotatedGrid;
            currentGrid = rotatedGrid;
        }
    }

    return mapPlacement;
}


Grid cutEdges(Grid g)
{
    Grid output;

    for (int i = 1; i < g.size() - 1; i++)
    {
        string thisLine = g[i];
        output.push_back(thisLine.substr(1, thisLine.length() - 2));
    }

    return output;
}


Grid extractImage(unordered_map<Coordinate, Grid, pair_hash> megaGrid)
{
    Grid megaImage;

    for (int i = 0; i < 12; i++)
        for (int j = 0; j < 12; j++)
        {
            megaGrid[make_pair(i, j)] = cutEdges(megaGrid[make_pair(i, j)]);
        }

    for (int row = 12 * 8 - 1; row >= 0; row--)
    {
        string thisRow;

        int j = row / 8;

        for (int i = 0; i < 12; i++)
            thisRow += megaGrid[make_pair(i, j)][7 - (row % 8)];

        megaImage.push_back(thisRow);
    }

    return megaImage;
}


unordered_set<Coordinate, pair_hash> HashfindMonsters(Grid g, Transform inverseTransform)
{


// Work out all the positions of the monsters in the usual coordinates.
// Then use the inverseTransform to map those back to the original coordinates

                      # 
#    ##    ##    ###
 #  #  #  #  #  #   
}