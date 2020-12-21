#include <chrono>
#include <fstream>
#include <string>
#include <algorithm>
#include <vector>
#include <iostream>

using std::vector;
using std::string;

long long depthFirstSearchCount(vector<int>);
bool pushNextSection(vector<int> &, vector<int> &, int);
void printRoute(vector<int> &);
long long totalCount(vector<int>&);
void printRoute(vector<long long> &route);

int main ()
{
    auto time0 = std::chrono::high_resolution_clock::now();
    std::ifstream inputFile("Inputs/10.txt");    
    std::vector<int> inputs;

    for (string s; getline(inputFile, s); )
    {
        inputs.push_back(atoi(s.c_str()));
    }

    sort(inputs.begin(), inputs.end());

    int currentJoltage = 0;
    int oneDiffCount = 0;
    int threeDiffCount = 0;

    for (int i = 0; i != inputs.size(); i++)
    {
        if (inputs[i] - currentJoltage == 1)
            oneDiffCount++;

        if (inputs[i] - currentJoltage == 3)
            threeDiffCount++;

        currentJoltage = inputs[i];
    }

    threeDiffCount++;

    std::cout << "Product of jolts 1 and 3 = " << oneDiffCount * threeDiffCount << std::endl;
    std::cout << "Number of options: " << totalCount(inputs) << std::endl;

    auto time1 = std::chrono::high_resolution_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::microseconds>(time1 - time0);
    std::cout << "Total time: " << elapsed.count() << " microseconds" << std::endl;

}

long long depthFirstSearchCount(vector<int> inputs)
{
    int maxVertex = *max_element(inputs.begin(), inputs.end()) + 3;
    long long totalCount = 0;
    int currentJoltage = 0;
    vector<int> vertices;
    vector<int> currentRoute;    

    pushNextSection(inputs, vertices, currentJoltage);

    //std::cout << "Route: ";
    //printRoute(currentRoute);
    //std::cout << "Vertices ";
    //printRoute(vertices);

    while (vertices.size() > 0)
    {
        currentJoltage = vertices.back();        
        vertices.pop_back();

        //std::cout << "Current joltage " << currentJoltage << std::endl;

        bool success = pushNextSection(inputs, vertices, currentJoltage);

        if (success)
        {            
            currentRoute.push_back(currentJoltage);
        }
        else
        {
            while (currentRoute.back() > currentJoltage)
                currentRoute.pop_back();
        }
        if (totalCount % 1000 == 0)
            {
                std::cout << "Current count " << totalCount << std::endl;
                std::cout << "Vertices length: " << vertices.size() << std::endl;
                std::cout << "Current Route length: " << currentRoute.size() << std::endl;
            }

        if (maxVertex - currentJoltage <= 3)
        {
            totalCount++;
            
        }
    }

    return totalCount;

}

void printRoute(vector<int> &route)
{
    std::cout << "0";
    for (auto i : route)
    {
        std::cout << " -> " << i;
    }

    std::cout << std::endl;

}

void printRoute(vector<long long> &route)
{
    std::cout << "0";
    for (auto i : route)
    {
        std::cout << " -> " << i;
    }

    std::cout << std::endl;

}

bool pushNextSection(vector<int> &inputs, vector<int> &vertices, int currentJoltage)
{

    vector<int> extraElements;

    for (int i = 0; i < inputs.size(); i++)
    {
        if (inputs[i] > currentJoltage && inputs[i] - currentJoltage <= 3)
            extraElements.push_back(inputs[i]);
    }

    if (extraElements.size() == 0)
        return false;

    while (extraElements.size() > 0)
    {
        int back = extraElements.back();
        extraElements.pop_back();
        vertices.push_back(back);
    }

    return true;
}


long long totalCount(vector<int> &inputs)
{
    int maxVertex = *max_element(inputs.begin(), inputs.end()) + 3;

    vector<long long> counts(inputs.size() + 1);
    for (int i = 0; i < counts.size(); i++)
        counts[i] = 0;

    for (int i = inputs.size() - 1; i >= 0; i--)
    {
        if (maxVertex - inputs[i] <= 3)
            counts[i+1]++;

        for (int j = 1; i+j < inputs.size() && j <= 3; j++)
            if (inputs[j+i] - inputs[i] <= 3)
                counts[i+1] += counts[i+j+1];
    }

    long long result = 0;

    for (int j = 1; j <= 3; j++)
        if (inputs[j-1] <= 3)
            result += counts[j];

    return result;
}