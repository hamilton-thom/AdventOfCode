#include <fstream>
#include <iostream>
#include <string>
#include <sstream>
#include <set>
#include <unordered_set>
#include <map>
#include <vector>
#include <string>
#include <algorithm>
#include <chrono>
#include <cmath>

using std::string;
using std::vector;
using std::set;
using std::unordered_set;
using std::map;
using std::ifstream;
using std::istringstream;
using std::cout;
using std::endl;
using std::pair;
using std::tuple;

auto getTime()
{
    return std::chrono::high_resolution_clock::now();
}

auto printTimeElapsed(std::chrono::high_resolution_clock::time_point start, std::chrono::high_resolution_clock::time_point end)
{
    auto elapsed = std::chrono::duration_cast<std::chrono::microseconds>(end - start);
    cout << "Total time: " << elapsed.count() << " microseconds" << endl;
}