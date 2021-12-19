#include <algorithm>
#include <deque>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

using std::string;
using std::cout;
using std::deque;
using std::endl;
using std::istringstream;
using std::make_pair;
using std::pair;
using std::unordered_map;
using std::unordered_set;
using std::vector;

using CellInfo = pair<int, unordered_set<string>>;
using ParentDict = unordered_map<string, string>;
using Tree = unordered_map<string, CellInfo>;
using DistanceMap = unordered_map<string, int>;

void addEntry(string, Tree&);
int parseWeightToken(string);
pair<int, string> findBalancingWeight(Tree);
pair<int, string> requiredWeight(Tree&, unordered_set<string>);
unordered_set<string> getFurthestLeaves(Tree&, DistanceMap&);
void collapseTree(Tree&, DistanceMap&);
DistanceMap buildDistanceMap(Tree&, string);
ParentDict buildParentMap(Tree&);
string findRoot(Tree);
void printSet(unordered_set<string>);
void printParentDict(ParentDict&);

int main() {
    // Process input text file.
    std::ifstream inputFile;
    inputFile.open("Inputs/input_07.txt");
    
    string thisLine;
    Tree tree;    
    
    while (getline(inputFile, thisLine)) 
    {
        addEntry(thisLine, tree);
    }

    inputFile.close();

    pair<int, string> balancingPair = findBalancingWeight(tree);

    int balancingWeight = tree[balancingPair.second].first + balancingPair.first;
    
    cout << "Part 1 - root element is " << findRoot(tree) << endl;
    cout << "Part 2 - the missing weight from the balancing element is " << balancingWeight << endl;

    return 0;
}

// Build the tree in the first place.
void addEntry(string input, Tree &tree) {

    istringstream iss(input);    
    string token;       
    iss >> token;    
    string thisName(token);

    string weightToken;
    iss >> weightToken;

    string intPart = weightToken.substr(1, weightToken.length() - 2);
    int weight = atoi(intPart.c_str());
    
    unordered_set<string> children;
    
    if (iss >> token || token == string("->")) 
    {
        while (iss >> token) 
        {
            if (token[token.length() - 1] == ',')
            {
                token = token.substr(0, token.length() - 1);
                
            }
            children.insert(token);
        }
    }

    std::pair<int, unordered_set<string>> entry (weight, children);
    tree.insert(make_pair(thisName, entry));
}


string findRoot(Tree tree)
{
    unordered_set<string> parentElements;
    unordered_set<string> childElements;
    
    for (auto kvp : tree)
    {
        parentElements.insert(kvp.first);
        unordered_set<string> children = kvp.second.second;
        for (string child : children)
            childElements.insert(child);
    }

    for (string child : childElements) 
        parentElements.erase(child);

    return *parentElements.begin();    
}


// Remember - Tree ~ unordered_map<string, pair<int, unordered_set<string>>>
// Part 2 - works out the balancing weight required.
pair<int, string> findBalancingWeight(Tree tree) 
{   
    string root = findRoot(tree);
    ParentDict parentMap = buildParentMap(tree);

    // Iterate through the outer-most edge of the map. For each level
    // group together leaves with the same parent, and then determine
    // if one of those leaves requires balancing. 
    // If this is the case then determine the balancing amount and return it.
    // If this is not the case, then keep iterating.
    while (tree.size() > 0) {       
        DistanceMap distanceMap = buildDistanceMap(tree, root);
        cout << "Iteration tree size: " << tree.size() << endl; 
        unordered_set<string> currentLeaves = getFurthestLeaves(tree, distanceMap);
        
        while (currentLeaves.size() > 0) 
        {
            string child = *currentLeaves.begin();
            string parent = parentMap[child];            
            unordered_set<string> siblings = tree[parent].second;

            pair<int, string> oddWeight = requiredWeight(tree, siblings);
            if (oddWeight.first)
                return oddWeight;
            
            for (string sibling : siblings)
                currentLeaves.erase(sibling);
        }

        collapseTree(tree, distanceMap);
    }

    return make_pair(-1, "");
}


DistanceMap buildDistanceMap(Tree &tree, string root)
{
    DistanceMap output;

    deque<pair<string, int>> processingQueue;
    processingQueue.push_back(make_pair(root, 0));

    while (processingQueue.size() > 0)
    {
        pair<string, int> thisEntry = processingQueue.front();
        processingQueue.pop_front();

        for (string entry : tree[thisEntry.first].second)
            processingQueue.push_back(make_pair(entry, thisEntry.second + 1));
        
        output.insert(thisEntry);
    }

    return output;
}


ParentDict buildParentMap(Tree &tree)
{
    ParentDict dict;
    
    for (auto kvp : tree)
    {        
        string parent = kvp.first;
        unordered_set<string> children = kvp.second.second;
        for (string child : children) 
            dict.insert(make_pair(child, parent));
    }

    return dict;    
}


unordered_set<string> getFurthestLeaves(Tree &tree, DistanceMap &distanceMap)
{    
    unordered_set<string> leaves;
    
    int furthestDistance = 0;

    for (auto kvp : distanceMap)
        if (kvp.second > furthestDistance)
            furthestDistance = kvp.second;


    for (auto kvp : tree) 
        if (kvp.second.second.size() == 0 && distanceMap[kvp.first] == furthestDistance)
            leaves.insert(kvp.first);
        
    return leaves;
}


pair<int, string> requiredWeight(Tree &tree, unordered_set<string> siblings) 
{   
    // Assume only _one_ child is incorrect => siblings 
    // have to have size > 2.
    if (siblings.size() <= 2)
        return make_pair(0, "");
    
    int siblingTotalWeight = 0;

    using Weight = int;
    using Count = int;
    unordered_map<Weight, pair<Count, vector<string>>> weightCounts;
    
    for (string sibling : siblings) 
    {
        int thisWeight = tree[sibling].first;
        if (weightCounts.find(thisWeight) == weightCounts.end()) 
        { // The weight has not been added.
            vector<string> initialVector;
            initialVector.push_back(sibling);
            weightCounts.insert(make_pair(thisWeight, make_pair(1, initialVector)));
        }
        else 
        { // The weight has been added.
            weightCounts[thisWeight].first++;
            weightCounts[thisWeight].second.push_back(sibling);
        }
        siblingTotalWeight += thisWeight;
    }
    
    for (auto kvp : weightCounts)
    {            
        if (kvp.second.first == 1)
            return make_pair((siblingTotalWeight - kvp.first) / (siblings.size() - 1) - kvp.first, kvp.second.second.front());
    }
    
    return make_pair(0, "");
}


void collapseTree(Tree &tree, DistanceMap &distanceMap) 
{
    unordered_set<string> startingLeaves = getFurthestLeaves(tree, distanceMap);
    for (string leaf : startingLeaves)
        cout << leaf << " ";
    cout << endl;
    ParentDict parentMap = buildParentMap(tree);

    while (startingLeaves.size() > 0) 
    {
        string child = *startingLeaves.begin();
        string parent = parentMap[child];
        unordered_set<string> siblings = tree[parent].second;
        
        int siblingWeight = 0;
        for (string sibling : siblings)
            siblingWeight += tree[sibling].first;

        tree[parent].first += siblingWeight;

        for (string sibling : siblings) 
        {
            tree.erase(sibling);            
            startingLeaves.erase(sibling);
        }

        unordered_set<string> emptySet;
        tree[parent].second = emptySet;
    }
}


void printSet(unordered_set<string> set) {
    for (unordered_set<string>::iterator it = set.begin(); it != set.end(); it++)
        cout << *it << " ";
}


void printParentDict(ParentDict &dict) 
{
    for (auto kvp : dict)
        cout << "Child: " << kvp.first << " Parent: " << kvp.second << endl;
}