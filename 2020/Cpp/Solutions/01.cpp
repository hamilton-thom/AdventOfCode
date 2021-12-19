#include <algorithm>
#include <chrono>
#include <fstream>
#include <sstream>
#include <iostream>
#include <string>
#include <tuple>
#include <vector>
#include <streambuf>
#include <ios>

using std::string;
using std::cout;
using std::endl;
using std::pair;
using std::tuple;
using std::vector;
using std::make_pair;


pair<int, int> findPair(vector<int>::iterator, vector<int>::iterator, int);

int main ()
{
    std::ios_base::sync_with_stdio(false);
    auto begin = std::chrono::high_resolution_clock::now();
    
    std::ifstream ifile("Inputs/01.txt");    
    string puzzleInput;
    ifile.seekg(0, std::ios::end);   
    puzzleInput.reserve(ifile.tellg());
    ifile.seekg(0, std::ios::beg);

    puzzleInput.assign((std::istreambuf_iterator<char>(ifile)), std::istreambuf_iterator<char>());

    vector<int> figures;
    std::istringstream iss(puzzleInput);    
    int inputInt;
    while(iss >>inputInt)
        figures.push_back(inputInt);

    std::sort(figures.begin(), figures.end());

    int target = 2020;

    pair<int, int> answerPair;
    tuple<int, int, int> answerTuple;

    // Part 1
    answerPair = findPair(figures.begin(), figures.end()-1, target);

    auto part1End = std::chrono::high_resolution_clock::now();

    // Part 2
    for (auto maxIt = figures.end() - 1; maxIt != figures.begin(); maxIt--)
    {
        // Work backwards, running findPair only for the interval containing
        // potential solutions.
        int thisTarget = target - *maxIt;
        vector<int>::iterator upperBound = std::upper_bound(figures.begin(), maxIt, thisTarget);

        pair<int, int> answer = findPair(figures.begin(), upperBound, thisTarget);

        if ((answer.first + answer.second) != 0)
        {
            answerTuple = tuple<int, int, int>(*maxIt, answer.first, answer.second);
            break;
        }
    }

    
    
    cout << "Part 1: (" << answerPair.first << ", " << answerPair.second << ")" << endl;
    cout << "Part 2: (" << std::get<0>(answerTuple) << ", " << std::get<1>(answerTuple) << ", " << std::get<2>(answerTuple) << ")" << endl;
    
    auto end = std::chrono::high_resolution_clock::now();
    
    auto elapsed = std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin);
    auto part1Time = std::chrono::duration_cast<std::chrono::nanoseconds>(part1End - begin);
    auto part2Time = std::chrono::duration_cast<std::chrono::nanoseconds>(end - part1End);

    cout << "Total time: " << elapsed.count() * 1e-3 << " microseconds" << endl;
    cout << "Part 1 time: " << part1Time.count() * 1e-3 << " microseconds" << endl;
    cout << "Part 2 time: " << part2Time.count() * 1e-3 << " microseconds" << endl;

    return 0;
}


pair<int, int> findPair(vector<int>::iterator front, vector<int>::iterator end, int target) 
{
    while (front != end) 
    {
        int currentSum = *front + *end;
        if (currentSum < target)
        {
            front++;
        }
        else if (currentSum > target)
        {
            end--;
        }
        else
        {
            return make_pair(*front, *end);
        }
    }
    return std::make_pair(0, 0);
}