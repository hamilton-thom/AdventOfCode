
#include <fstream>
#include <iostream>
#include <string>
#include <sstream>
#include <vector>

using std::vector;
using std::string;
using std::pair;
using std::make_pair;

pair<bool, int> runAlgorithm(vector<pair<string, int>>);

int main ()
{
    
    vector<pair<string, int>> input;

    std::ifstream inputFile("Inputs/08.txt");

    string thisLine;
    while (getline(inputFile, thisLine))
    {
        std::istringstream iss(thisLine);

        string op;
        int val;

        iss >> op;
        iss.ignore();
        if (iss.peek() == '+')
        {
            iss.ignore();
            iss >> val;
        } 
        else
        {
            iss >> val;
        }

        input.push_back(make_pair(op, val));
    }

    std::cout << "Acc prior to repeat instruction: " << runAlgorithm(input).second << std::endl;

    vector<int> nopPositions;
    vector<int> jmpPositions;

    for (int i = 0; i < input.size(); i++)
    {
        if (input[i].first == "nop")
            nopPositions.push_back(i);
        if (input[i].first == "jmp")
            jmpPositions.push_back(i);
    }

    // (nop, jmp) coordinates;
    vector<pair<int, int>> nopJmpSwaps;

    for (int nopPos : nopPositions)
    {
        for (int jmpPos : jmpPositions)
            nopJmpSwaps.push_back(make_pair(nopPos, jmpPos));
    }

    std::cout << "Jump size " << nopJmpSwaps.size() << std::endl;

    for (auto p : nopJmpSwaps)
    {
        std::cout << "Running here... " << p.first << ", " << p.second << std::endl;
        vector<pair<string, int>> swappedInstructions(input);

        pair<string, int> temp = swappedInstructions[p.first];
        swappedInstructions[p.first] = swappedInstructions[p.second];
        swappedInstructions[p.second] = temp;

        pair<bool, int> runResult = runAlgorithm(swappedInstructions);

        if (runResult.first)
        {
            std::cout << "Final acc count " << runResult.second << std::endl;
            break;
        }
    }

    std::cout << "Finished with no result" << std::endl;
    
}

pair<bool, int> runAlgorithm(vector<pair<string, int>> input)
{
    int acc = 0;
    int currentInstruction = 0;
    int instructionCount = input.size();
    vector<bool> checkVec(instructionCount);
    bool exitBecauseComplete = false;

    while (!checkVec[currentInstruction])
    {

        string thisInstruction = input[currentInstruction].first;
        int jumpSize = input[currentInstruction].second;

        checkVec[currentInstruction] = true;

        if (thisInstruction == "acc")
        {
            currentInstruction++;
            acc += jumpSize; 
            continue;
        }

        if (thisInstruction == "jmp")
        {
            currentInstruction += jumpSize;
            continue;
        }

        if (thisInstruction == "nop")
        {
            currentInstruction++;
            continue;
        }

        if (currentInstruction == input.size())
        {
            exitBecauseComplete = true;
            break;
        }
    }

    return make_pair(exitBecauseComplete, acc);
}