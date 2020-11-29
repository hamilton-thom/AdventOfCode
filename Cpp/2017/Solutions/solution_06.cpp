#include <algorithm>
#include <fstream>
#include <iostream>
#include <iterator>
#include <sstream>
#include <string>
#include <unordered_set>
#include <vector>

std::size_t hashMemory(std::vector<int> const&);
void redistributeMemory(std::vector<int>&);
void printVector(std::vector<int>);

int main() {

    std::ifstream inputFile;
    inputFile.open("Inputs/input_06.txt");
    std::string inputString;
    std::getline(inputFile, inputString);
    inputFile.close();
    
    std::istringstream iss(inputString);
    std::vector<int> memoryBlock;
    std::string memoryBlockString;
    while (iss >> memoryBlockString) {
        memoryBlock.push_back(atoi(memoryBlockString.c_str()));
    }

    std::unordered_set<unsigned long long> hashSet;
    int count = 0;
    unsigned long long hash = 0;
    while (true) {
        //printVector(memoryBlock);
        hash = hashMemory(memoryBlock);
        //std::cout << " hash: " << hash << std::endl;
        if (hashSet.count(hash) > 0) 
            break;
        hashSet.insert(hash);
        redistributeMemory(memoryBlock);
        count++;
    }
    
    int cycleLength = 0;    
    hashSet.clear();
    while (true) {
        hash = hashMemory(memoryBlock);
        if (hashSet.count(hash) > 0) 
            break;
        hashSet.insert(hash);
        redistributeMemory(memoryBlock);        
        cycleLength++;        
    }
    
    std::cout << "Part 1 - count before repeat = " << count << std::endl;
    std::cout << "Part 2 - cycle length = " << cycleLength << std::endl;
    return 0;
}


void printVector(std::vector<int> vec) {
    std::cout << "[ ";
    for (std::vector<int>::size_type i = 0; i != vec.size(); i++)
        std::cout << vec[i] << " ";
    std::cout << "]";
}


std::size_t hashMemory(std::vector<int> const& vec){
    std::size_t seed = vec.size();
    for (auto& i : vec) {
        seed ^= i + 0x9e3779b9 + (seed << 6) + (seed >> 2);
    }
    return seed;
}


void redistributeMemory(std::vector<int> &memoryBlock) {
    
    auto maxValueIterator = std::max_element(memoryBlock.begin(), memoryBlock.end());
    int maxIndex = std::distance(memoryBlock.begin(), maxValueIterator);
    
    int maxValue = memoryBlock[maxIndex];
    
    // Clear memory.
    memoryBlock[maxIndex] = 0;
    
    for (int i = 1; i <= maxValue; i++)
        memoryBlock[(maxIndex + i) % memoryBlock.size()]++;
}





