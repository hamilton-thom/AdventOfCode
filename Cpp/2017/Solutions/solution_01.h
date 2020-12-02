#pragma once

#include <vector>
#include <optional> // C++17 
#include <variant>  // C++17 
#include <string>
#include <tuple>

using std::get;
using std::get_if;
using std::string;
using std::tuple;
using std::vector;
using std::variant;
using std::optional;
using std::cout;

using RegisterInt = variant<char, long long>;
using Instruction = tuple<string, RegisterInt, optional<RegisterInt>>;

class RegisterSet
{
    long long registers[26] = {};
    long long soundFrequency = 0;

public:

    long value(RegisterInt val)
    {
        if (char *p = get_if<char>(&val))
            return registers[*p - 'a'];
        
        if (long long *p = get_if<long long>(&val))
            return *p;
        
        return 0;
    }

    void set(char regstr, RegisterInt val) { registers[regstr - 'a'] = value(val); }
    void add(char regstr, RegisterInt val) { registers[regstr - 'a'] += value(val); }
    void mul(char regstr, RegisterInt val) { registers[regstr - 'a'] *= value(val); }
    void mod(char regstr, RegisterInt val) { registers[regstr - 'a'] %= value(val); }

    void snd(char regstr)
    {
        soundFrequency = registers[regstr - 'a'];
    }

    optional<long long> rcv(char regstr)
    {
        optional<long long> output;
        if (registers[regstr - 'a'] != 0)
            output.emplace(soundFrequency);
        return output;
    }

    void print() 
    {
        for (char c = 'a'; c <= 'z'; c++) 
            cout << c << ": " << registers[c - 'a'];
    }
};


class InstructionSet
{
    RegisterSet registers;
    vector<Instruction> instructions;    
    int currentInstruction = 0;

public:

    InstructionSet(vector<Instruction> instructions) : instructions(instructions) {}

    Instruction getCurrentInstruction() 
    {
        return instructions[currentInstruction];
    }

    RegisterSet getRegisterState()
    {
        return registers;
    }

    optional<long long> runInstruction() 
    {
        Instruction thisInstruction = instructions[currentInstruction];
        string instruction = get<string>(thisInstruction);
        RegisterInt rgstrX = get<RegisterInt>(thisInstruction);

        optional<long long> output;

        if (instruction == "jgz" && registers.value(rgstrX) > 0)
        {
            optional<RegisterInt> optRgstrY = get<optional<RegisterInt>>(thisInstruction);
            if (optRgstrY)
            {
                RegisterInt rgstrY = optRgstrY.value();
                currentInstruction += registers.value(rgstrY) - 1; // We always append 1, here we go back one prior.    
            }
        } 
        else 
        {
            char rgstr = get<char>(rgstrX);

            optional<RegisterInt> optRgstrY = get<optional<RegisterInt>>(thisInstruction);

            if (optRgstrY)
            {
                RegisterInt rgstrY = optRgstrY.value();
                if (instruction == "set") { registers.set(rgstr, rgstrY); }
                if (instruction == "mul") { registers.mul(rgstr, rgstrY); }
                if (instruction == "add") { registers.add(rgstr, rgstrY); }
                if (instruction == "mod") { registers.mod(rgstr, rgstrY); }    
            }
            
            if (instruction == "snd")
                registers.snd(rgstr); 
            if (instruction == "rcv")
                output = registers.rcv(rgstr);
        }

        currentInstruction++;
        return output;
    }
};