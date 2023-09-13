#include <fstream
#include <string>
#include <isstream>
#include <sstream>
#include <vector>



int main() {

    std::ifstream inputFile;
    inputFile.open("Inputs/input_10.txt");
    std::string inputLine;
    std::getline(inputFile, inputLine);
    std::vector<int> inputLengths = getLengths(inputLine);



}

std::vector<int> getLengths(std::string input) {
    std::vector<int> output;
    std::stringstream ss(input);
    
    for (int i; ss >> i; ) {
        output.push_back(i);
        if (ss.peek() == ',')
            ss.ignore();
    }
    
    return output;   
}

void processLength(std::vector<int> &list, int length, int &currentPos, int &skipSize) {

    int endPos = (currentPos + length) % list.size();

    std::vector<int> buffer;

    
    if (endPos < currentPos) {  // Case when we've wrapped around.
        for (int i = currentPos; i != list.size(); i++)
            buffer[i - currentPos] = list[i];
        for (int i = 0; i < endPos; i++)
            buffer[i + (list.size() - currentPos)] = list[i];
    } else {                    // Case when we haven't wrapped around.
        for (int i = 0; i < endPos - currentPos; i++) 
            buffer[i] = list[currentPos + i];
    }
    
    std::reverse(buffer);
    
    if (endPos < currentPos) {  // Case when we've wrapped around.
        for (int i = 0; i != list.size() - currentPos; i++)
            list[i + currentPos] = buffer[i];
        for (int i = ; i < endPos; i++)
            buffer[i + (list.size() - currentPos)] = list[i];
    } else {                    // Case when we haven't wrapped around.
        for (int i = 0; i < endPos - currentPos; i++) 
            buffer[i] = list[currentPos + i];
    }
    
    currentPos += length + skipSize;
    currentPos %= list.size();
    skipSize++;
}













