
#include <fstream>
#include <iostream>
#include <string>

int processString(std::string);
int processStringB(std::string);
void test(char c);


int main() {
    std::ifstream inputFile;    
    inputFile.open("Inputs/input_01.txt");
    std::string inputString;
    std::getline(inputFile, inputString);
    inputFile.close();
    std::cout << inputString << std::endl;        
    std::cout << "Part 1 - sum of digits matching next digit = " << processString(inputString) << std::endl;
    std::cout << "Part 2 - sum of digits matching half-way digit = " << processStringB(inputString) << std::endl;
    return 0;
}


int charToI(char c) {    
    char temp[] = {'0', '\0'};
    temp[0] = c;
    return atoi(temp);
}
    

int processString(std::string inputString) {
    int inputStringSize = inputString.size();
    if (inputStringSize < 2) return 0;
    
    int total = 0;
    int charIndex = 0;    
    
    while (charIndex++ < inputStringSize)
        if (inputString[charIndex] == inputString[(charIndex + 1) % inputStringSize])
            total += charToI(inputString[charIndex]);
    
    return total;
}


int processStringB(std::string inputString) {
    int inputStringSize = inputString.size();
    if (inputStringSize < 2) return 0;
    
    int total = 0;
    int charIndex = 0; 
    int jumpSize = inputStringSize / 2;
    
    while (charIndex < inputStringSize) {
        if (inputString[charIndex] == inputString[(charIndex + jumpSize) % inputStringSize])
            total += charToI(inputString[charIndex]);
        charIndex++;
    }
        
    return total;
}



void test(char c) {
    std::cout << charToI(c) << std::endl;
}