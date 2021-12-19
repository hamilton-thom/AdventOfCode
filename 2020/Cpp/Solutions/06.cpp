#include <fstream>
#include <iostream>
#include <string>
#include <algorithm>
#include <vector>

using std::string;


int main()
{
    
    std::ifstream inputFile("Inputs/06.txt");
    std::vector<string> inputs;

    string temp;

    while (getline(inputFile, temp))
        inputs.push_back(temp);

    string groupAnswers;
    int count = 0;

    for (int i = 0; i < inputs.size(); i++)
    {
        groupAnswers += inputs[i];

        if (inputs[i].length() == 0 || i == inputs.size() - 1)
        {
            sort(groupAnswers.begin(), groupAnswers.end());
            auto it = unique(groupAnswers.begin(), groupAnswers.end());
            groupAnswers.erase(it, groupAnswers.end());
            count += groupAnswers.length();
            groupAnswers.clear();            
        }
    }

    std::cout << "Total count: " << count << std::endl;

    count = 0;
    string groupAnswerIntersection(inputs[0]);
    
    for (int i = 0; i < inputs.size(); i++)
    {
        groupAnswers = groupAnswerIntersection;
        groupAnswerIntersection = "";

        sort(groupAnswers.begin(), groupAnswers.end());
        sort(inputs[i].begin(), inputs[i].end());

        set_intersection(groupAnswers.begin(), groupAnswers.end(), 
                         inputs[i].begin(), inputs[i].end(),
                         std::back_insert_iterator<string>(groupAnswerIntersection));

        if (i == inputs.size() - 1 || inputs[i+1].length() == 0)
        {
            count += groupAnswerIntersection.length();            
            groupAnswerIntersection = inputs[i + 2]; // This will fall-off at the end.
            i++;
        }
    }

    std::cout << "Total count: " << count << std::endl;
}