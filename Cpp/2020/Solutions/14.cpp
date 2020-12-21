#include <bitset>
#include <variant>

#include "aoc.h"

using longlong = long long;
using std::get_if;

struct MaskInstruction { longlong orMask, andMask; };
struct MemoryInstruction { longlong location, value; };
struct Instruction 
{ 
    std::variant<MaskInstruction, MemoryInstruction> instruction;

    void print()
    {
        MaskInstruction *pMask = get_if<MaskInstruction>(&instruction);
        MemoryInstruction *pMemory = get_if<MemoryInstruction>(&instruction);

        if (pMask) 
        {
            string orBinary = std::bitset<36>(pMask->orMask).to_string();
            string andBinary = std::bitset<36>(pMask->andMask).to_string();
            cout << "orMask " << orBinary << "\nandMask: " << andBinary << "\n";
        }

        if (pMemory)
        {
            cout << "location: " << pMemory->location 
                 << " value: " << pMemory->value << "\n";
        }        
    }
};

Instruction parseInput(string s);
vector<longlong> getAllAddresses(longlong maskX, longlong mask1, longlong inputAddress);
vector<vector<longlong>> combinations(vector<longlong> input);
longlong generateX(vector<longlong> xPositions);

int main ()
{

    ifstream inputFile("inputs/14.txt");
    string s;
    vector<Instruction> inputInstructions;

    while (getline(inputFile, s))
        inputInstructions.push_back(parseInput(s));

    using Location = longlong;
    using Value = longlong;

    map<Location, Value> mem;

    MaskInstruction currentMask;

    for (Instruction i : inputInstructions)
    {
        MaskInstruction *pMask = get_if<MaskInstruction>(&i.instruction);
        MemoryInstruction *pMemory = get_if<MemoryInstruction>(&i.instruction);

        if (pMask)
        {
            currentMask.orMask = pMask->orMask;
            currentMask.andMask = pMask->andMask;
        }

        if (pMemory)
        {
            mem[pMemory->location] = (pMemory->value & currentMask.orMask) | currentMask.andMask;
        }        
    }

    longlong totalVal = 0;
    for (auto p : mem)
        totalVal += p.second;

    cout << "Total value: " << totalVal << "\n";

    mem.clear();

    int n = 0;

    for (Instruction i : inputInstructions)
    {
        MaskInstruction *pMask = get_if<MaskInstruction>(&i.instruction);
        MemoryInstruction *pMemory = get_if<MemoryInstruction>(&i.instruction);

        if (pMask)
        {
            currentMask.orMask = pMask->orMask;
            currentMask.andMask = pMask->andMask;            
        }

        if (pMemory)
        {
            vector<longlong> addresses = getAllAddresses(currentMask.orMask, currentMask.andMask, pMemory->location);
            for (longlong address : addresses)
            {
                mem[address] = pMemory->value;
            }
        }     
    }

    totalVal = 0;
    for (auto p : mem)
    {
        //cout << "Location: " << p.first << " value: " << p.second << "\n";
        totalVal += p.second;
    }

    cout << "Total value (part 2): " << totalVal << "\n";
}


vector<longlong> getAllAddresses(longlong maskX, longlong mask1, longlong inputAddress)
{
    longlong long1 = 1;
    longlong maskXCopy = maskX;

    vector<longlong> xPositions;
    longlong i = 0;

    while (maskXCopy != 0)
    {        
        if (maskXCopy & long1 == 1)
            xPositions.push_back(i);
        i++;
        maskXCopy = maskXCopy >> 1;
    }

    vector<vector<longlong>> allCombinations = combinations(xPositions);

    vector<longlong> output;

    for (vector<longlong> combination : allCombinations)
    {
        longlong thisX = generateX(combination);

        longlong baseNonXAddress = ~maskX & inputAddress;

        longlong resultAddress = (mask1 | baseNonXAddress) | thisX;

        output.push_back(resultAddress);
    }

    return output;
}


longlong generateX(vector<longlong> xPositions)
{

    longlong long1 = 1;

    longlong output = 0;

    for (longlong pos : xPositions)
    {
        output += long1 << pos;
    }

    return output;
}


vector<vector<longlong>> combinations(vector<longlong> input)
{
    vector<vector<longlong>> output;

    if (input.size() > 32)
    {
        cout << "Input size too large: " << input.size() << ", unable to compute that many combinations\n";
        return output;
    }
    
    int combinationSize = 1 << input.size();

    for (int i = 0; i < combinationSize; i++)
    {
        vector<longlong> thisCombination;
        for (int j = 0; j < input.size(); j++)
        {
            if (i >> j & 1)
            {
                thisCombination.push_back(input[j]);
            }
        }
        output.push_back(thisCombination);
    }

    return output;
}


Instruction parseInput(string s)
{
    istringstream iss(s);

    // Mask
    if (s.find("[", 0) == string::npos)
    {
        string temp;
        iss >> temp;
        iss >> temp;
        vector<char> maskVector;
        iss.get();
        while (iss)
        {            
            char thisChar = iss.get();
            if (thisChar == 'X' || thisChar == '0' || thisChar == '1')
                maskVector.push_back(thisChar);
        }

        longlong orMask = 0;
        longlong andMask = 0;

        for (int i = 0; i < maskVector.size(); i++)
        {            
            longlong maskAddition = 1;
            maskAddition = maskAddition << (35 - i);
            switch (maskVector[i])
            {       
                case '1':   andMask += maskAddition; break;
                case '0':   break;
                case 'X':   orMask += maskAddition; break;
                default:    cout << "Shouldn't be here. Input string: " << s << "\n";
            }
        }

        MaskInstruction msk {orMask, andMask};
        Instruction i;
        i.instruction = msk;
        return i;
    }
    else // Memory
    {
        while(char c = iss.get() != '[') {}
        longlong location, value;
        iss >> location;
        iss.ignore(4);
        iss >> value;
        MemoryInstruction mem {location, value};
        Instruction i;
        i.instruction = mem;
        return i;
    }
}