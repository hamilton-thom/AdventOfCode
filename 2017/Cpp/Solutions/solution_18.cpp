#include <algorithm>
#include <fstream>
#include <sstream>
#include <iostream>

#include "solution_01.h"

using std::cout;
using std::endl;


Instruction buildInstruction(string);
void printInstruction(Instruction);


int main() 
{
    std::ifstream inputFile("Inputs/input_18.txt");
    string line;
    vector<Instruction> instructions;
    while (getline(inputFile, line)) 
        instructions.push_back(buildInstruction(line));

    InstructionSet instructionSet(instructions);

    while (true)
    {
        optional<long long> instructionVal = instructionSet.runInstruction();
        if (instructionVal)
        {
            cout << "Part 1 - sound frequency = " << instructionVal.value() << endl;
            break;
        }
    }

    // Part 2. Build two programs, then iterate through them until they're both
    // waiting.

    Program p0(instructions, 0);
    Program p1(instructions, 1);
    p0.connectProgram(p1);
    p1.connectProgram(p0);

    do 
    {
        //p0.print("P0");
        //p1.print("P1");
        p0.runInstruction();
        p1.runInstruction();
    } while (!(p0.isWaiting() && p1.isWaiting()));

    cout << "Part 2 - send count for program 1 = " << p1.getSendCount() << endl;

}


Instruction buildInstruction(string instructionString)
{
    std::istringstream iss(instructionString);

    string instruction;
    bool xIsChar = false, yIsChar = false;
    char xChar = 0, yChar = 0;
    long long xInt = 0, yInt = 0;
    
    RegisterInt x, y;
    optional<RegisterInt> optY;

    iss >> instruction;       
    iss.ignore();

    if (isalpha(iss.peek()))
    {
        iss >> xChar;        
        x = xChar;
    } 
    else
    {
        iss >> xInt;        
        x = xInt;
    }
    iss.peek(); // Check if we've reached the end of the file.
    if (!iss.eof())
    {
        iss.ignore();        
        if (isalpha(iss.peek()))
        {
            iss >> yChar;            
            y = yChar;
        } 
        else
        {
            iss >> yInt;            
            y = yInt;
        }
        optY = y;
    }
    
    return make_tuple(instruction, x, optY);
}


void printInstruction(Instruction e)
{
    cout << get<string>(e) << " ";
    std::visit([](auto&& arg){std::cout << arg << " ";}, get<RegisterInt>(e));
    if (get<optional<RegisterInt>>(e))
        std::visit([](auto&& arg){std::cout << arg;}, get<optional<RegisterInt>>(e).value());    
}