#include <unordered_set>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <algorithm>

bool isValid(std::string);
bool isValid2(std::string);

int main() {

    std::ifstream inputFile;
    inputFile.open("Inputs/input_04.txt");
    
    int validCount = 0;
    int validCount2 = 0;
    std::string line;
    while (std::getline(inputFile, line)) {
        if (isValid(line)) {
            validCount++;
        }
        if (isValid2(line)) {
            validCount2++;
        }
    }
    
    std::cout << "Part 1 - number of valid phrases: " << validCount << std::endl;
    std::cout << "Part 2 - number of valid phrases: " << validCount2 << std::endl;
    return 0;
}

bool isValid(std::string s) {
    std::istringstream iStringStream(s);
    std::unordered_set<std::string> wordSet;
    
    std::string word;
    while (iStringStream >> word) {
        if (wordSet.count(word) > 0)
            return false;
        wordSet.insert(word);
    }
    
    return true;
}

bool isValid2(std::string s) {
    std::istringstream iStringStream(s);
    std::unordered_set<std::string> wordSet;
    
    std::string word;
    while (iStringStream >> word) {
        std::sort(word.begin(), word.end());
        if (wordSet.count(word) > 0)
            return false;
        wordSet.insert(word);
    }
    
    return true;
}