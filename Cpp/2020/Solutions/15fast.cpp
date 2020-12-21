
#include "aoc.h"

using std::pair;

int main()
{
    auto startTime = getTime();
    vector<int> guesses {0, 12, 6, 13, 20, 1, 17};

    using number = int;
    using SpokenTime = int;
    using PreviousSpokenTime = int;

    int targetRuns = 30000000;

    // First time -> previousSpokenTime = 0;
    vector<pair<PreviousSpokenTime, SpokenTime>> plays(targetRuns);
    int turn = 1;

    for (int i = 0; i < guesses.size(); i++)
        plays[guesses[i]] = std::make_pair(0, turn++);

    int previousSpokenNumber = guesses.back();

    while (turn <= 30000000)
    {
        pair<PreviousSpokenTime, SpokenTime> lastSpokenTimes = plays[previousSpokenNumber];

        int thisSpokenNumber;

        if (lastSpokenTimes.first == 0) // i.e. the first time it's been spoken
        {
            thisSpokenNumber = 0;
        }
        else
        {
            thisSpokenNumber = lastSpokenTimes.second - lastSpokenTimes.first;
        }

        if (plays[thisSpokenNumber].second == 0)
        {
            plays[thisSpokenNumber].second = turn;
        }
        else
        {            
            plays[thisSpokenNumber].first = plays[thisSpokenNumber].second;
            plays[thisSpokenNumber].second = turn;
        }

        previousSpokenNumber = thisSpokenNumber;
        turn++;
    }

    cout << targetRuns << "th number: " << previousSpokenNumber << endl;
    printTimeElapsed(startTime, getTime());
}