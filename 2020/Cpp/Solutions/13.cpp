

#include "aoc.h"

using Long = long long;
struct Pair {Long mod, rem;};
bool checkConditions(vector<Pair>&, Long&);

int main()
{
    //  {787, 739} and {523, 506} always satisfied.
    vector<Pair> targetList { { 41,  34}
                            , { 37,  20}
                            , { 29,  10}
                            , { 23,   6}
                            , { 19,   2} 
                            , { 17,   0}
                            , { 13,   4}
                            };

    Long startValue = 100000000000000;

    Long testValue = (startValue / 411601) * 411601 + 92031;

    int iteration = 0;

    while (!checkConditions(targetList, testValue))
    {
        testValue += 411601;
        iteration++;

        if (iteration % 10000000 == 0)
            cout << "Iteration: " << iteration << " test value: " << testValue << "\n";
    }

    cout << "First value satisfying all conditions: " << testValue << endl;
}

bool checkConditions(vector<Pair> &targetList, long long &testValue)
{
    for (Pair p : targetList)
        if (testValue % p.mod != p.rem)
            return false;
    return true;
}
/*


Long chineseRemainder(Pair p1, Pair p2)
{
    // Invariant: m = p * n + r
    vector<tuple<Long, Long, Long>>;









}



pair<Long, Long> euclidsAlgorithm(Long m, Long n)
{
    vector<tuple<Long, Long, Long, Long>> system;
    system.push_back(make_tuple(m, n, m / n, m % n));

    Long r = m % n;

    while (m % n != 0)
    {
       m = n;
       n = r;
       system.push_back(make_tuple(m, n, m / n, m % n));
    }

    // Now we come back up through the system, re-evaluating 
    // the remainder each time.

    Long a, b;

    // Always have invariant: r = a * m + b * n

    for (int i = system.size() - 2; i != 0; i--)
    {

    }




}

long long chineseRemainder(vector<Pair> inputs)
{
}*/