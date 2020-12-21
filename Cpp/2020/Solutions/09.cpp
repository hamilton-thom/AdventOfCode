#include <chrono>
#include <fstream>
#include <iostream>
#include <vector>
#include <set>
#include <deque>
#include <string>
#include <algorithm>

using std::string;
using std::deque;
using std::multiset;
using std::vector;

long long firstInvalid(vector<long long>);
bool isValid(multiset<long long> &, long long);
long long findContiguousMinMax(vector<long long>, long long);

long long searchArray[25] = {};

int main ()
{
 
    

    std::ifstream inputFile("Inputs/09.txt");
    string inputLine;
    long long n;
    vector<long long> inputs;

    auto time0 = std::chrono::high_resolution_clock::now();

    while (getline(inputFile, inputLine))
    {
        inputs.push_back(stoll(inputLine));
    }

    auto time1 = std::chrono::high_resolution_clock::now();

    long long part1 = firstInvalid(inputs);

    std::cout << "First bad value: " << part1 << std::endl;

    long long part2 = findContiguousMinMax(inputs, part1);

    std::cout << "Sum of min and max values " << part2 << std::endl;
    
    auto elapsed = std::chrono::duration_cast<std::chrono::microseconds>(time1 - time0);
    std::cout << "Total time: " << elapsed.count() << " microseconds" << std::endl;
}

long long firstInvalid(vector<long long> inputs)
{

    multiset<long long> orderedSet;
    deque<long long> inputList;

    for (int i = 0; i < 25; i++)
    {
        orderedSet.insert(inputs[i]);
        inputList.push_back(inputs[i]);        
    }

    int i;

    for (i = 25; true; i++)
    {
        if (isValid(orderedSet, inputs[i]))
        {
            long long firstValue = inputList.front();
            inputList.pop_front();
            // Find an interator to the element to erase.
            auto it = find(orderedSet.begin(), orderedSet.end(), firstValue);
            orderedSet.erase(it);
            inputList.push_back(inputs[i]);
            orderedSet.insert(inputs[i]);
        }
        else
        {
            break;
        }
    }

    return inputs[i];
}


// Note this _only_ works because the inputSet is odd.
bool isValid(multiset<long long> &inputSet, long long target)
{
    auto fit = inputSet.begin();
    auto rit = inputSet.rbegin();

    while (&*fit != &*rit)
    {
        long long thisSum = *fit + *rit;
        if (thisSum == target)
        {
            return true;
        }
        else if (thisSum > target)
        {
            rit++;
            continue;
        }
        else
        {
            fit++;
            continue;
        }
    }

    return false;
}


long long findContiguousMinMax(vector<long long> inputs, long long target)
{

    deque<long long> contiguousSet;

    long long currentSum = 0;
    int currentIndex = 0;

    while (currentSum != target)
    {
        if (currentSum < target)
        {
            contiguousSet.push_back(inputs[currentIndex]);
            currentSum += inputs[currentIndex++];
        }
        else
        {
            currentSum -= contiguousSet.front();   
            contiguousSet.pop_front();
        }
    }

    auto minMaxPair = minmax_element(contiguousSet.begin(), contiguousSet.end());

    return *minMaxPair.first + *minMaxPair.second;
}