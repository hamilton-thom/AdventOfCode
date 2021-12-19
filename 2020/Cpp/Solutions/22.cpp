
#include "aoc.h"

deque<int> copyN(deque<int> &d, int n);
string buildState(const deque<int> &player1, const deque<int> &player2);
pair<deque<int>, deque<int>> playRound(deque<int> player1, deque<int> player2, unordered_set<string> &existingStates);
pair<deque<int>, deque<int>> playGame(deque<int> player1, deque<int> player2);
deque<int> part1Result(deque<int> player1, deque<int> player2);
int score(deque<int> d);
void print(deque<int> &player1, deque<int> &player2);

long iterationCount = 0;

int main ()
{
    auto t0 = getTime();
    ifstream inputFile("inputs/22.txt");

    string s;
    vector<int> player1;
    vector<int> player2;

    getline(inputFile, s);
    for (int i = 0; i < 25; i++)
    {
        getline(inputFile, s);
        player1.push_back(atoi(s.c_str()));
    }
    getline(inputFile, s);
    getline(inputFile, s);
    for (int i = 0; i < 25; i++)
    {
        getline(inputFile, s);
        player2.push_back(atoi(s.c_str()));
    }
    inputFile.close();

    deque<int> p1d;
    deque<int> p2d;

    for (int i : player1)
        p1d.push_back(i);

    for (int i : player2)
        p2d.push_back(i);

    deque<int> part1 = part1Result(p1d, p2d);

    cout << score(part1) << endl;

    pair<deque<int>, deque<int>> part2 = playGame(p1d, p2d);

    if (part2.first.size() == 0)
    {
        cout << score(part2.second) << endl;
    }
    else
    {
       cout << score(part2.first) << endl;
    }   

    cout << "Total number of iterations: " << iterationCount;
    printTimeElapsed(t0, getTime());

}


deque<int> part1Result(deque<int> player1, deque<int> player2)
{
    while (player1.size() != 0 && player2.size() != 0)
    {
        int p1, p2;
        p1 = player1.front(); p2 = player2.front();
        player1.pop_front(); player2.pop_front();

        if (p1 > p2)
        {
            player1.push_back(p1);
            player1.push_back(p2);
        } else
        {
            player2.push_back(p2);
            player2.push_back(p1);
        }
    }

    if (player1.size() == 0)
    {
        return player2;
    }
    else 
    {
        return player1;
    }

}


int score(deque<int> d)
{
    int output = 0;
    for (int i = 0; i <= d.size(); i++)
            output += (d.size() - i) * d[i];
    return output;
}


pair<deque<int>, deque<int>> playGame(deque<int> player1, deque<int> player2)
{
    unordered_set<string> existingStates;

    while (player1.size() > 0 && player2.size() > 0)
    {        
        pair<deque<int>, deque<int>> roundResult = playRound(player1, player2, existingStates);
        player1 = roundResult.first;
        player2 = roundResult.second;
    }

    return make_pair(player1, player2);
}


void print(deque<int> &player1, deque<int> &player2)
{
    cout << "Player 1: ";
    for (int i : player1)
        cout << i << " ";
    cout << endl;
    cout << "Player 2: ";
    for (int i : player2)
        cout << i << " ";
    cout << endl;
}

// Determine the winner from the sizes of the deques.
pair<deque<int>, deque<int>> playRound(deque<int> player1, deque<int> player2, unordered_set<string> &existingStates)
{
    iterationCount++;

    if (existingStates.count(buildState(player1, player2)) > 0)
    {
        player2.clear();
       
        return make_pair(player1, player2);
    } 
    else
    {
        existingStates.insert(buildState(player1, player2));
    }

    // draw cards
    int p1 = player1.front();
    int p2 = player2.front();
    player1.pop_front();
    player2.pop_front();

    if (p1 <= player1.size() && p2 <= player2.size())
    {
        pair<deque<int>, deque<int>> outcome = playGame(copyN(player1, p1), copyN(player2, p2));

        if (outcome.first.size() == 0)
        {
            player2.push_back(p2);
            player2.push_back(p1);

            
        }
        else if (outcome.second.size() == 0)
        {   
            player1.push_back(p1);
            player1.push_back(p2);
            
        }
        else 
        {
            cout << "Shouldn't be here.\n";
        }
    }
    else
    {
        if (p1 > p2)
        {
            player1.push_back(p1);
            player1.push_back(p2);
            
        }
        else
        {
            player2.push_back(p2);
            player2.push_back(p1);
            
        }
    }
    
    return make_pair(player1, player2);
}


deque<int> copyN(deque<int> &d, int n)
{
    deque<int> out;
    if (n > d.size())
        cout << "Shouldn't be here. N too large.\n";
    for (int i = 0; i < n; i++)
        out.push_back(d[i]);
    return out;
}


string buildState(const deque<int> &player1, const deque<int> &player2)
{
    string state = "";

    for (auto i : player1)
        state += i;
    state += "|";
    for (auto i : player2)
        state += i;
    return state;
}

