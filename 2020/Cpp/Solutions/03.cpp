
#include <fstream>
#include <string>
#include <iostream>

using std::string;
using std::endl;
using std::cout;

int getSlopeCount(int, int);

int main() 
{

    int slope1 = getSlopeCount(1, 1);
    int slope2 = getSlopeCount(1, 3);
    int slope3 = getSlopeCount(1, 5);
    int slope4 = getSlopeCount(1, 7);
    int slope5 = getSlopeCount(2, 1);

    cout << "Part 1 count: " << slope2 << endl; //270
    cout << "Part 2 count: " << slope1 * slope2 * slope3 * slope4 * slope5 << endl; 
}

int getSlopeCount(int row,int  col)
{
    int count = 0;
    int columnOffset = col;    

    std::ifstream inputFile("Inputs/03.txt");
    string stringRow;

    for (int i = 0; i < row; i++)
        getline(inputFile, stringRow);
    

    while (getline(inputFile, stringRow))
    {

        if (stringRow[columnOffset] == '#')
            count++;

        int rowLength = stringRow.length();
        columnOffset += col;
        columnOffset %= rowLength;
        for (int i = 0; i < row - 1; i++)
            getline(inputFile, stringRow);
    }
    return count;
}