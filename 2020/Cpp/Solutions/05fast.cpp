#include <chrono>
#include <fstream>
#include <iostream>
#include <string>
#include <set>

using std::string;

int sequenceToInt(string, string);
int fbToInt(char[11]);
int lrToInt(char[11]);
void printTime(std::chrono::time_point<std::chrono::high_resolution_clock>, std::chrono::time_point<std::chrono::high_resolution_clock>, string);

int main ()
{
    auto time0 = std::chrono::high_resolution_clock::now();

    std::ifstream inputFile("Inputs/05.txt");

    auto time1 = std::chrono::high_resolution_clock::now();

    int maxSeatID = 0;
    char seatString[11] = "";

    // Position = row * 8 + col;
    int *seatNumbers = new int[128 * 8];

    for (int i = 0; i < 128 * 8; i++)
        *(seatNumbers + i) = 0;

    auto time2 = std::chrono::high_resolution_clock::now();

    while (inputFile >> seatString)
    {
        int row = fbToInt(seatString);
        int col = lrToInt(seatString);
        int seatID = 8 * row + col;
        if (seatID > maxSeatID)
            maxSeatID = seatID;
        *(seatNumbers + seatID) = 1;
    }

    auto time3 = std::chrono::high_resolution_clock::now();

    for (int i = 0; i < 128 * 8; i++)
    {
        if (!*(seatNumbers + i))
        {
            if (*(seatNumbers + i - 1) & *(seatNumbers + i + 1))
                std::cout << "ID = " << i << " is the missing seat" << std::endl;
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


int fbToInt(char inputRow[11])
{
    char binaryArray[8] = "0000000";

    int result = 0;

    for (int i = 0; i != 7; i++)
        if (inputRow[i] == 'B')
            result += (1 << (6 - i));

    return result;
}


int lrToInt(char inputRow[11])
{
    char binaryArray[4] = "000";

    int result = 0;

    for (int i = 7; i != 10; i++)
        if (inputRow[i] == 'R')
            result += (1 << (9 - i));

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