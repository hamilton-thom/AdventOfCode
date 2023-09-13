#include "aoc.h"

enum class Space { Floor = 0, Occupied = 1, Unoccupied = 2};

using Grid = vector<vector<Space>>;

int seatCount(Grid &input);
int occupiedIndicator(Grid &input, int row, int col);
int occupiedCount(Grid &input, int row, int col);
void printGrid(Grid& grid);
char spaceToChar(Space s);
Space getState(Grid &input, int row, int col);
Grid nextGrid(Grid currentGrid);
Grid buildGrid(vector<string>& lines);
Grid nextGridDirectional(Grid currentGrid);
int occupiedCountDirectional(Grid &input, int row, int col);
bool between(int n, int lower, int upper);
int searchSeatDirection(Grid &input, int row, int col, int directionX, int directionC);

int main()
{

    auto start = getTime();

    ifstream inputFile("Inputs/11.txt");
    vector<string> lines;
    for (string s; getline(inputFile, s); )
        lines.push_back(s);

    // Rows of Columns, [r][c];
    Grid input = buildGrid(lines);
    Grid currentGrid = input, newGrid;

    while (currentGrid != (newGrid = nextGrid(currentGrid))) 
    {
        currentGrid = newGrid;        
    }

    cout << "Stable seat count = " << seatCount(currentGrid) << endl;

    currentGrid = input;

    while (currentGrid != (newGrid = nextGridDirectional(currentGrid))) 
    {
        currentGrid = newGrid;
    }

    cout << "Stable seat count = " << seatCount(currentGrid) << endl;

    auto finish = getTime();

    printTimeElapsed(start, finish);

}

int seatCount(Grid &input)
{
    int count = 0;
    for (auto row : input)
        for (auto col : row)
            if (col == Space::Occupied)
                count++;

    return count;
}


Grid nextGrid(Grid currentGrid)
{
    Grid newGrid = currentGrid;

    for (int row = 0; row < newGrid.size(); row++)
    {
        for (int col = 0; col < newGrid[0].size(); col++)
        {            
            switch (currentGrid[row][col])
            {
                case Space::Unoccupied: 
                    if (occupiedCount(currentGrid, row, col) == 0)
                        newGrid[row][col] = Space::Occupied;
                    break;
                case Space::Occupied:
                    if (occupiedCount(currentGrid, row, col) >= 4)
                    {
                        newGrid[row][col] = Space::Unoccupied;
                        break;
                    }
                    else
                    {
                        newGrid[row][col] = Space::Occupied;
                        break;   
                    }
            }
        }
    }

    return newGrid;
}

Grid nextGridDirectional(Grid currentGrid)
{
    Grid newGrid = currentGrid;

    for (int row = 0; row < newGrid.size(); row++)
    {
        for (int col = 0; col < newGrid[0].size(); col++)
        {            
            switch (currentGrid[row][col])
            {
                case Space::Unoccupied: 
                    if (occupiedCountDirectional(currentGrid, row, col) == 0)
                        newGrid[row][col] = Space::Occupied;
                    break;
                case Space::Occupied:
                    if (occupiedCountDirectional(currentGrid, row, col) >= 5)
                    {
                        newGrid[row][col] = Space::Unoccupied;
                        break;
                    }
                    else
                    {
                        newGrid[row][col] = Space::Occupied;
                        break;   
                    }
            }
        }
    }

    return newGrid;
}


Grid buildGrid(vector<string>& lines)
{
    vector<vector<Space>> spaces;

    for (auto &s : lines)
    {        
        vector<Space> thisLineVector;
        istringstream iss(s);

        for (char c = iss.get(); iss; c = iss.get())
        {
            switch (c)
            {
                case '.':   thisLineVector.push_back(Space::Floor); break;
                case 'L':   thisLineVector.push_back(Space::Unoccupied); break;
            }            
        }        
        spaces.push_back(thisLineVector);
    }

    return spaces;
}


int occupiedCount(Grid &input, int row, int col)
{
    return occupiedIndicator(input, row+1, col+1) +
           occupiedIndicator(input, row+1, col  ) +
           occupiedIndicator(input, row+1, col-1) +
           occupiedIndicator(input, row  , col+1) +
           occupiedIndicator(input, row  , col-1) +
           occupiedIndicator(input, row-1, col+1) +
           occupiedIndicator(input, row-1, col  ) +
           occupiedIndicator(input, row-1, col-1);
}

int occupiedCountDirectional(Grid &input, int row, int col)
{
    return searchSeatDirection(input, row, col,  1,  1) +
           searchSeatDirection(input, row, col,  1,  0) +
           searchSeatDirection(input, row, col,  1, -1) +
           searchSeatDirection(input, row, col,  0,  1) +
           searchSeatDirection(input, row, col,  0, -1) +
           searchSeatDirection(input, row, col, -1,  1) +
           searchSeatDirection(input, row, col, -1,  0) +
           searchSeatDirection(input, row, col, -1, -1);
}


int occupiedIndicator(Grid &input, int row, int col)
{
    if (getState(input, row, col) == Space::Occupied)
        return 1;
    return 0;
}


bool between(int n, int lower, int upper)
{
    return lower <= n && n <= upper;
}


int searchSeatDirection(Grid &input, int row, int col, int directionX, int directionY)
{
    int visibleSeatCount = 0;
    int steps = 1;

    while (between(row + steps * directionX, 0, input.size()) && 
           between(col + steps * directionY, 0, input[0].size()))    
    {
        if (getState(input, row + steps * directionX, col + steps * directionY) == Space::Occupied)
        {
            visibleSeatCount = 1;
            break;
        }

        if (getState(input, row + steps * directionX, col + steps * directionY) == Space::Unoccupied)
        {            
            break;
        }

        steps++;
    }

    return visibleSeatCount;
}


Space getState(Grid &input, int row, int col)
{
    int rows = input.size();
    int cols = input[0].size();

    if (row < 0 || row >= rows)
        return Space::Floor;
    if (col < 0 || col >= cols)
        return Space::Floor;

    return input[row][col];
}

char spaceToChar(Space s)
{
    switch (s)
    {
        case Space::Floor:      return '.';
        case Space::Occupied:   return '#';
        case Space::Unoccupied: return 'L';
    }
}


void printGrid(Grid& grid)
{
    for (auto row : grid)
    {
        for (auto col : row)
            cout << spaceToChar(col);
        cout << "\n";
    }

    cout << endl;
}