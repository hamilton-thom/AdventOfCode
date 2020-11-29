
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

int countStepsToExit(std::vector<int>);

int main() {
    
    std::ifstream inputFile;
    inputFile.open("Inputs/input_05.txt");
    
    std::vector<int> inputVector;
    
    std::string temp;
    
    while (std::getline(inputFile, temp)) {
        inputVector.push_back(atoi(temp.c_str()));
    }
    
    inputFile.close();
    
    int stepCount1 = countStepsToExit(inputVector);
    
    std::cout << "Part 1 - count to exit = " << stepCount1 << std::endl;
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