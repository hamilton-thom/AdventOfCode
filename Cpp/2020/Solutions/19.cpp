#include "aoc.h"
#include <variant>

using std::variant;
using std::get_if;

using RuleList = vector<int>;
using RecursiveRule = pair<RuleList, RuleList>;
using RuleDefinition = variant<char, RecursiveRule>;
using RuleID = int;
using Rules = map<RuleID, RuleDefinition>;

void parseRule(const string, Rules&);
RuleDefinition parseRuleDefinition(string s);
RuleList parseRuleList(string s);
void printRecursiveRule(RecursiveRule rr);
void printRule(pair<RuleID, RuleDefinition>);


int main()
{
    ifstream inputFile("Inputs/19.txt");
    string s;
    getline(inputFile, s);
    Rules inputRules;
    while (s != "")
    {
        parseRule(s, inputRules);
        getline(inputFile, s);
    }

    vector<string> inputMessages;
    while (getline(inputFile, s))
        inputMessages.push_back(s);

    map<int, set<string>> fullOptionSet;
    Rules testRules = inputRules;

    // Initialise the fullOptionSet with values which have 'char' type.
    for (auto p : testRules)
    {
        if (char *c = get_if<char>(&p.second))
        {
            set<string> newSet;
            newSet.insert(string (1, *c));
            fullOptionSet.insert(make_pair(p.first, newSet));
        }
    }    
    for (auto p : fullOptionSet)
        testRules.erase(p.first);

    for (auto p : fullOptionSet)
    {
        cout << p.first;
        for (string s : p.second)
            cout << " " << s;
        cout << endl;
    }
    cout << fullOptionSet.size() << endl;
    cout << testRules.size() << endl;




}


void printRule(pair<RuleID, RuleDefinition> r)
{
    cout << "id: " << r.first;
    RuleDefinition *rd = &r.second;

    if (char* c = get_if<char>(rd))
    {
        cout << " character: " << *c << endl;
    }
    else if (RecursiveRule *rr = get_if<RecursiveRule>(rd))
    {
        printRecursiveRule(*rr);        
    }
    else
    {
        cout << "Shouldn't be here...\n";
    }
}


void printRecursiveRule(RecursiveRule rr)
{
    RuleList l1 = rr.first;
    RuleList l2 = rr.second;

    cout << " First list: ";
    for (int i : l1)
        cout << i << " ";

    if (l2.size() > 0)
    {
        cout << "Second list:";
        for (int i : l2)
            cout << " " << i;
    }

    cout << endl;
}



void parseRule(const string s, Rules &rules)
{
    istringstream iss(s);
    
    int id;
    iss >> id;

    iss.ignore(2);

    string remainder;
    getline(iss, remainder);

    rules.insert(make_pair(id, parseRuleDefinition(remainder)));
}


RuleDefinition parseRuleDefinition(string s)
{
    istringstream iss(s);

    RuleDefinition output;

    if (iss.peek() == '"')
    {
        iss.ignore();
        output = iss.get();
        return output;
    }

    if (count(s.begin(), s.end(), '|') > 0)
    {
        string firstPart;
        string secondPart;

        int midPoint = 0;

        for (int i = 0; i < s.length(); i++)
        {
            if (s[i] == '|')
            {
                firstPart = s.substr(0, i - 1);
                secondPart = s.substr(i + 1);
            }
        }

        RuleList firstList = parseRuleList(firstPart);
        RuleList secondList = parseRuleList(secondPart);
        return make_pair(firstList, secondList);
    } 
    else
    {
        RuleList firstList = parseRuleList(s);
        RuleList secondList;
        return make_pair(firstList, secondList);
    }
}

RuleList parseRuleList(string s)
{
    istringstream iss(s);

    vector<int> output;
    int temp;
    
    while (iss)
    {
        iss >> temp;
        output.push_back(temp);
        iss.peek();
    }

    return output;
}