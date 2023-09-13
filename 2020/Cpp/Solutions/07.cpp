


//dull silver bags contain 2 striped magenta bags, 2 dark coral bags, 1 bright orange bag, 4 plaid blue bags.

#include <algorithm>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <deque>

using std::string;
using std::vector;
using std::deque;
using std::unordered_map;
using std::unordered_set;
using std::pair;

void processLine(unordered_map<string, vector<pair<int, string>>>&, string);
void printMap(unordered_map<string, vector<pair<int, string>>>&);
void printVector(vector<pair<int, string>>);



int main ()
{
    

    unordered_map<string, vector<pair<int, string>>> edges;
    std::ifstream inputFile("Inputs/07.txt");
    string thisLine;

    while (getline(inputFile, thisLine))
    {
        processLine(edges, thisLine);
    }

    string targetBag = "shiny gold";

    unordered_set<string> allContainingShinyGold;

    unordered_set<string> allBagSet;
    deque<string> testingSequence;

    testingSequence.push_back(targetBag);

    while (testingSequence.size() != 0)
    {
        string extractBag = testingSequence.front();
        testingSequence.pop_front();

        for (auto kvp : edges)
        {
            for (auto p : kvp.second)
            {
                if (p.second == extractBag && allBagSet.count(kvp.first) == 0)
                {
                    allBagSet.insert(kvp.first);
                    testingSequence.push_back(kvp.first);       
                }                
            }
        }
    }

    std::cout << "Total number of bags including \"shiny gold\" as a decendent bag " << allBagSet.size() << std::endl;


    unordered_map<string, int> bagMap;

    // Initially populate with bags that contain no other bags.
    unordered_set<string> allEdges;
    for (auto kvp : edges)
    {
        allEdges.insert(kvp.first);
        for (auto p : kvp.second)
            allEdges.insert(p.second);

        if (kvp.second.size() == 0)
            bagMap.insert(make_pair(kvp.first, 1));
    }

    for (auto kvp : bagMap)
        allEdges.erase(kvp.first);

    while (allEdges.size() > 0)
    {
        for (string edge : allEdges)
        {
            if (all_of(edges[edge].begin(), 
                       edges[edge].end(), 
                       [bagMap] (pair<int, string> thisPair) -> bool { return bagMap.count(thisPair.second) != 0; }
                       )
                )
            {
                int totalSubBags = 1;

                for (pair<int, string> p : edges[edge])
                {
                    totalSubBags += p.first * bagMap[p.second];
                }

                bagMap.insert(make_pair(edge, totalSubBags));
            }
        }

        for (auto kvp : bagMap)
        {
            allEdges.erase(kvp.first);
        }
    }

    std::cout << "Total number of sub-bags for shiny gold = " << bagMap[targetBag] << std::endl;
    std::cout << "Bagmap size: " << bagMap.size() << std::endl;

}


void printMap(unordered_map<string, vector<pair<int, string>>> &edges)
{

    for (auto kvp : edges)
    {        
        std::cout << kvp.first << " >> ";
        for (auto p : kvp.second)
        {
            std::cout << "(" << p.first << ", " << p.second << ") ";
        }
        std::cout << std::endl;
    }

    
}


void processLine(unordered_map<string, vector<pair<int, string>>> &edges, string line)
{
    std::istringstream iss(line);

    string adjective, colour;
    int count;

    iss >> adjective;
    iss >> colour;

    string thisBagColour = adjective + " " + colour;    
    
    iss >> adjective >> adjective; // Skipping past "contains" and "bags".

    vector<pair<int, string>> endVector;

    while (iss)
    {
        iss >> count;
        iss >> adjective;
        iss >> colour;
        endVector.push_back(make_pair(count, adjective + " " + colour));        
        iss >> adjective;
        iss.peek();
        
    }
    edges.insert(make_pair(thisBagColour, endVector));    
}

void printVector(vector<pair<int, string>> vec) 
{

    std::cout << "Vector contents: ";
    for (auto p : vec)
    {
        std::cout << "(" << p.first << ", " << p.second << ") ";
    }
    std::cout << std::endl;
}