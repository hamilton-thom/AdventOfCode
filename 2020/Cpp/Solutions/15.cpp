
#include "aoc.h"

using std::pair;

int main()
{
    auto startTime = getTime();
    vector<int> guesses {0, 12, 6, 13, 20, 1, 17};

    using number = int;
    using SpokenTime = int;
    using PreviousSpokenTime = int;

    // First time -> previousSpokenTime = 0;
    map<number, pair<PreviousSpokenTime, SpokenTime>> plays;
    int turn = 1;

    for (int i = 0; i < guesses.size(); i++)
        plays[guesses[i]] = std::make_pair(0, turn++);

    int previousSpokenNumber = guesses.back();
    int max = 0;

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

        if (plays.count(thisSpokenNumber) == 0)
        {
            plays[thisSpokenNumber] = std::make_pair(0, turn);
        }
        else
        {
            pair<PreviousSpokenTime, SpokenTime> zeroSpokenTimes = plays[thisSpokenNumber];
            plays[thisSpokenNumber] = std::make_pair(zeroSpokenTimes.second, turn);
        }

        if (thisSpokenNumber > max)
            max = thisSpokenNumber;

        previousSpokenNumber = thisSpokenNumber;
        turn++;
    }

    cout << "Max jump: " << max;

    cout << "2020th number: " << previousSpokenNumber << endl;
    printTimeElapsed(startTime, getTime());
}