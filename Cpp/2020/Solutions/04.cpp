#include <fstream>
#include <iostream>
#include <sstream>
#include <unordered_set>
#include <string>
#include <algorithm>
#include <vector>

using std::string;
using std::unordered_set;
using std::vector;

bool validatePassword(std::ifstream&);
bool validCharacters(string, string);
bool validByr(string);
bool validIyr(string);
bool validEyr(string);
bool validHgt(string);
bool validHcl(string);
bool validEcl(string);
bool validPid(string);

int main()
{

    std::ifstream inputFile("Inputs/04.txt");

    int count = 0;

    while (inputFile)
    {
        std::cout << std::endl;
        if (validatePassword(inputFile))
        {
            count++;
            std::cout << "Incrementing count... " << std::endl;
        }
    }

    std::cout << "Number of valid passports = " << count << std::endl;

}

bool validatePassword(std::ifstream &input)
{
    unordered_set<string> requiredValues({"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"});

    string line, field;

    getline(input, line);
    std::istringstream iss(line);    

    while (line != "" && input)
    {   
        iss >> field;        
        string fieldName = field.substr(0, 3);
        string fieldValue = field.substr(4);

        if (fieldName == "byr" && validByr(fieldValue))
        {
            std::cout << "byr " << fieldValue << " valid." << std::endl;
            requiredValues.erase(fieldName);
        } 
        else if (fieldName == "byr")
        {
            std::cout << "byr " << fieldValue << " invalid." << std::endl;
        }

        if (fieldName == "iyr" && validIyr(fieldValue))
        {
            std::cout << "iyr " << fieldValue << " valid." << std::endl;
            requiredValues.erase(fieldName);
        }
        else if (fieldName == "iry")
        {
            std::cout << "iyr " << fieldValue << " invalid." << std::endl;
        }

        if (fieldName == "eyr" && validEyr(fieldValue))
        {            
            std::cout << "eyr " << fieldValue << " valid." << std::endl;
            requiredValues.erase(fieldName);
        }
        else if (fieldName == "eyr")
        {
            std::cout << "eyr " << fieldValue << " invalid." << std::endl;
        }

        if (fieldName == "hgt" && validHgt(fieldValue))
        {
            std::cout << "hgt " << fieldValue << " valid." << std::endl;
            requiredValues.erase(fieldName);
        }
        else if (fieldName == "hgt")
        {
            std::cout << "hgt " << fieldValue << " invalid." << std::endl;
        }

        if (fieldName == "hcl" && validHcl(fieldValue))
        {
            std::cout << "hcl " << fieldValue << " valid." << std::endl;
            requiredValues.erase(fieldName);
        }
        else if (fieldName == "hcl")
        {
            std::cout << "hcl " << fieldValue << " invalid." << std::endl;
        }

        if (fieldName == "ecl" && validEcl(fieldValue))
        {
            std::cout << "ecl " << fieldValue << " valid." << std::endl;
            requiredValues.erase(fieldName);
        }
        else if (fieldName == "ecl")
        {
            std::cout << "ecl " << fieldValue << " invalid." << std::endl;
        }

        if (fieldName == "pid" && validPid(fieldValue))
        {       
            std::cout << "pid " << fieldValue << " valid." << std::endl;
            requiredValues.erase(fieldName);        
        }
        else if (fieldName == "pid")
        {
            std::cout << "pid " << fieldValue << " invalid." << std::endl;
        }

        iss.peek();

        if (!iss)
        {
            iss.clear();
            getline(input, line);
            iss.str(line);
        }
    }

    if (requiredValues.size() > 0)
        return false;
    return true;
}


bool validCharacters(string characters, string testString)
{
    for (char c : testString)
        if (find(characters.begin(), characters.end(), c) == characters.end())
            return false;

    return true;
}


bool validByr(string s)
{
    int temp = atoi(s.c_str());
    return 1920 <= temp && temp <= 2002;
}


bool validIyr(string s)
{
    int temp = atoi(s.c_str());
    return 2010 <= temp && temp <= 2020;
}


bool validEyr(string s)
{
    int temp = atoi(s.c_str());
    return 2020 <= temp && temp <= 2030;
}


bool validHgt(string s)
{
    if (s.length() != 5 && s.length() != 4)
        return false;
    string units(s.substr(s.length() - 2, 2));

    int length = atoi(s.substr(0, s.length() - 2).c_str());

    if (units == "in")
        return 59 <= length && length <= 76;

    if (units == "cm")
        return 150 <= length && length <= 193;

    return false;
}


bool validHcl(string s)
{
    if (s.length() != 7)
        return false;

    if (s[0] != '#')
        return false;

    return validCharacters("0123456789abcdef", s.substr(1));
}


bool validEcl(string s)
{
    vector<string> validStrings({"amb", "blu", "brn", "gry", "grn", "hzl", "oth"});

    if (find(validStrings.begin(), validStrings.end(), s) == validStrings.end())
        return false;

    return true;
}


bool validPid(string s)
{
    if (s.length() != 9)
        return false;

    return validCharacters("0123456789", s);
}