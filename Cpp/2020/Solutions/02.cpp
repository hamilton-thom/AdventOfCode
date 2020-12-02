#include <algorithm>
#include <fstream>
#include <sstream>
#include <iostream>
#include <string>
#include <tuple>
#include <vector>

using std::get;
using std::string;
using std::cout;
using std::endl;
using std::tuple;
using std::vector;

void printTuple(tuple<int, int, char, string>);
bool isValid(tuple<int, int, char, string>);
bool isValid2(tuple<int, int, char, string>);

int main() 
{

    std::ifstream ifile("Inputs/02.txt");

    string line;
    vector<tuple<int, int, char, string>> inputs;    
    while (getline(ifile, line)) 
    {
        int int1, int2;
        char character;
        string password;
        std::istringstream iss(line);

        iss >> int1;
        iss >> int2;
        iss >> character;
        iss >> password; // skip :        
        iss >> password;

        inputs.push_back(make_tuple(int1, -int2, character, password));
    }
    

    int validCount = 0;
    int validCount2 = 0;
    for (auto tup : inputs)
    {
        if (isValid(tup))
            validCount++;
       if (isValid2(tup))
       {
            validCount2++;
       } 
       else 
       {
            printTuple(tup);
       }

    }

    cout << "Part 1: valid password count = " << validCount << endl;
    cout << "Part 2: valid password count = " << validCount2 << endl;
}

bool isValid(tuple<int, int, char, string> tup)
{
    int charCount = std::count(get<string>(tup).begin(), get<string>(tup).end(), get<char>(tup));
    int min = get<0>(tup);
    int max = get<1>(tup);
    return (min <= charCount) && (charCount <= max);
}

bool isValid2(tuple<int, int, char, string> tup)
{
    char c = get<char>(tup);
    int pos1 = get<0>(tup);
    int pos2 = get<1>(tup);
    string password = get<string>(tup);
    if (pos2 > password.length())
        return false;
    char c1 = password[pos1-1];
    char c2 = password[pos2-1];

    return ((c1 == c) && (c2 != c)) || ((c1 != c) && (c2 == c));
    
}

void printTuple(tuple<int, int, char, string> tup) 
{
    cout << get<0>(tup) << "-" << get<1>(tup) << ":" << get<char>(tup) << " " << get<string>(tup) << endl;
}