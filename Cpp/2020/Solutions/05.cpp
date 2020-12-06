#include <chrono>
#include <fstream>
#include <iostream>
#include <string>
#include <set>

using std::string;

int sequenceToInt(string, string);
void printTime(std::chrono::time_point<std::chrono::high_resolution_clock>, std::chrono::time_point<std::chrono::high_resolution_clock>, string);

int main ()
{
    auto time0 = std::chrono::high_resolution_clock::now();

    std::ifstream inputFile("Inputs/05.txt");

    int maxSeatID = 0;
    string seatString;

    auto rowConverter = [] (string rowString) -> int { return sequenceToInt("FB", rowString); };
    auto colConverter = [] (string rowString) -> int { return sequenceToInt("LR", rowString); };

    auto time1 = std::chrono::high_resolution_clock::now();

    std::set<int> seatNumbers;
    for (int row = 0; row < 128; row++)
    {
        for (int col = 0; col < 8; col++)
        {
            seatNumbers.insert(8*row + col);
        }
    }

    auto time2 = std::chrono::high_resolution_clock::now();

    while (getline(inputFile, seatString))
    {
        int row = rowConverter(seatString.substr(0, 7));
        int col = colConverter(seatString.substr(7, 3));
        int seatID = 8 * row + col;
        if (seatID > maxSeatID)
            maxSeatID = seatID;
        seatNumbers.erase(seatID);
    }

    auto time3 = std::chrono::high_resolution_clock::now();

    std::cout << "Max seat id = " << maxSeatID << std::endl;
    for (auto it = ++seatNumbers.begin(); it != --seatNumbers.end(); it++)
    {
        int thisID = *it;
        int previousID = *(--it);
        it++;
        int nextID = *(it++);
        it--;
        if (previousID != thisID - 1 && thisID + 1 != nextID)
        {
            std::cout << "Missing seat number: " << thisID << std::endl;
            break;
        }
    }        

    auto time4 = std::chrono::high_resolution_clock::now();

    printTime(time0, time1, "setting up variables");
    printTime(time1, time2, "inserting values into the set");
    printTime(time2, time3, "iterating through the input and calculating seatIDs");
    printTime(time3, time4, "working out the max seat number");    
}

void printTime(std::chrono::time_point<std::chrono::high_resolution_clock> start,  std::chrono::time_point<std::chrono::high_resolution_clock> end, string message)
{
    auto elapsed = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
    std::cout << "Total time: " << message << " " << elapsed.count() << " microseconds" << std::endl;
}


int fbToInt(char inputRow[8])
{
    char binaryArray[8] = "0000000";

    int result = 0;

    for (int i = 0; i != 7; i++)
        if (inputRow[i] == 'B')
            result += (1 << (6 - i));

    return result;
}


int lrToInt(char inputRow[4])
{
    char binaryArray[8] = "000";

    int result = 0;

    for (int i = 0; i != 7; i++)
        if (inputRow[i] == 'R')
            result += (1 << (2 - i));

    return result;
}


int sequenceToInt(string ZeroOneChars, string number)
{

    if (ZeroOneChars.length() != 2)
        return -1;

    string binaryString;

    for (int i = 0; i != number.length(); i++)
    {
        if (number[i] == ZeroOneChars[0])
        {
            binaryString += '0';
        }
        else if (number[i] == ZeroOneChars[1])
        {
            binaryString += '1';
        }
        else
        {
            return -1;
        }
    }

    return stoi(binaryString, 0, 2);
}