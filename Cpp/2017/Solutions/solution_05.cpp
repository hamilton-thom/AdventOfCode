#include <chrono>
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

int countStepsToExit(std::vector<int>);

int main() {
    
    auto start = std::chrono::high_resolution_clock::now();
    
    std::ifstream inputFile;
    inputFile.open("Inputs/input_05.txt");
    
    std::vector<int> inputVector;
    
    std::string temp;
    
    while (std::getline(inputFile, temp)) {
        inputVector.push_back(atoi(temp.c_str()));
    }
    
    inputFile.close();
    
    auto fileClosed = std::chrono::high_resolution_clock::now();
    
    int stepCount1 = countStepsToExit(inputVector);
    
    auto end = std::chrono::high_resolution_clock::now();
    auto durationFile = std::chrono::duration_cast<std::chrono::microseconds>(fileClosed - start);
    auto durationCalculation = std::chrono::duration_cast<std::chrono::microseconds>(end - fileClosed);
    
    std::cout << "Part 1 - count to exit = " << stepCount1 << std::endl;
    std::cout << "Opening file: " << durationFile.count() << " microseconds" << std::endl;
    std::cout << "Running calculation: " << durationCalculation.count() << " microseconds" << std::endl;
    
    
    return 0;
}

int countStepsToExit(std::vector<int> input) {
 
    int currentPosition = 0;
    int step = 0;
    int offset = 0;
    
    while (currentPosition >= 0 && currentPosition < input.size()) {
        offset = input[currentPosition];
        if (offset >= 3) {
            input[currentPosition]--;
        } else {
            input[currentPosition]++;
        }
        currentPosition += offset;
        step++;
    }
    
    return step;
}