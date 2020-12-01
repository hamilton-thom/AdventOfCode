#include <chrono>
#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

using std::string;
using std::cout;
using std::endl;
using std::pair;
using std::tuple;
using std::unordered_set;
using std::unordered_map;
using std::vector;


pair<int, int> findPair(vector<int>::iterator, vector<int>::iterator, int);

int main () 
{

    auto begin = std::chrono::high_resolution_clock::now();

    std::ifstream ifile;
    ifile.open("Inputs/01.txt");
    string line;
    vector<int> figures;
    while(getline(ifile, line))
        figures.push_back(atoi(line.c_str()));
    ifile.close();

    int target = 2020;

    unordered_set<int> intSet;    

    pair<int, int> answerPair;
    tuple<int, int, int> answerTuple;

    // Part 1
    answerPair = findPair(figures.begin(), figures.end(), target);

    // Part 2
    for (int n = 0; n < figures.size(); n++)
    {
        // Swap the current element and the last element.
        int temp;
        temp = figures[n];
        figures[n] = figures.back();
        figures.back() = temp;

        // Find the target pair.
        pair<int, int> answer = findPair(figures.begin(), figures.end() - 1, target - temp);

        if ((answer.first + answer.second) != 0)
        {
            answerTuple = tuple<int, int, int>(temp, answer.first, answer.second);
            break;
        }

        // Swap the currentElement and the last element back again.
        figures.back() = figures[n];
        figures[n] = temp;
    }
    
    cout << "Part 1: (" << answerPair.first << ", " << answerPair.second << ")" << endl;
    cout << "Part 2: (" << std::get<0>(answerTuple) << ", " << std::get<1>(answerTuple) << ", " << std::get<2>(answerTuple) << ")" << endl;
    
    auto end = std::chrono::high_resolution_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::nanoseconds>(end - begin);
    cout << "Total time: " << elapsed.count() * 1e-9 << endl;


    return 0;
}


pair<int, int> findPair(vector<int>::iterator front, vector<int>::iterator end, int target) 
{
    unordered_set<int> testElements;

    for (auto it = front; it != end; it++)        
    {
        if (testElements.count(target - *it))
        {
            return std::make_pair(*it, target - *it);            
        }
        testElements.insert(*it);
    }
    return std::make_pair(0, 0);
}