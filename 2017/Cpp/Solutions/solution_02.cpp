
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>

int checkSum(std::string);


int main() {
    std::ifstream inputFile;
    inputFile.open("Inputs/input_02.txt");
    std::string currentLine;
    int total = 0;
    while (std::getline(inputFile, currentLine))
        total += checkSum(currentLine);
    inputFile.close();
    std::cout << "Part 1 - the sum of the check-sums is: " << total << std::endl;
    return 0;
}


int checkSum(std::string inputLine) {

    std::istringstream lineStream(inputLine);

    std::string digitString;
    
    getLine(lineStream, digitString, 


    
    
    getLine(inputLine, chunk, 

    
    
    
}