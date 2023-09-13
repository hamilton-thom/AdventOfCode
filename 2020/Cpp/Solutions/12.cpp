
#include "aoc.h"

struct State 
{ 
    pair<int, int> position, direction, waypoint;

    void forward(int n)
    {
        position.first += direction.first * n;
        position.second += direction.second * n;
    }

    void forwardWaypoint(int n)
    {
        for (int i = 0; i < n; i++)
            translate(waypoint.first, waypoint.second);
    }

    void translate(int x, int y)
    {
        position.first += x;
        position.second += y;
    }

    void translateWaypoint(int x, int y)
    {
        waypoint.first += x;
        waypoint.second += y;
    }

    void waypointLeft90()
    {        
        waypoint = rotateLeft90AroundOrigin(waypoint);        
    }

    pair<int, int> rotateLeft90AroundOrigin(pair<int, int> currentPosition)
    {
        int temp = currentPosition.first;
        currentPosition.first = -currentPosition.second;
        currentPosition.second = temp;
        return currentPosition;
    }

    void left90()
    {
        direction = rotateLeft90AroundOrigin(direction);
    }

    void left(int n)
    {
        switch (n)
        {
            case 90: left90(); break;
            case 180: left90(); left90(); break;
            case 270: left90(); left90(); left90(); break;
            default: cout << "Shouldn't be here. Left.\n";
        }
    }

    void right(int n)
    {
        switch (n)
        {
            case 90: left(270); break;
            case 180: left(180); break;
            case 270: left(90); break;
            default: cout << "Shouldn't be here. Right.\n";
        }
    }

    void leftWaypoint(int n)
    {
        switch (n)
        {
            case 90: waypointLeft90(); break;
            case 180: waypointLeft90(); waypointLeft90(); break;
            case 270: waypointLeft90(); waypointLeft90(); waypointLeft90(); break;
            default: cout << "Shouldn't be here. Left Waypoint.\n";
        }
    }

    void rightWaypoint(int n)
    {
        switch (n)
        {
            case 90: leftWaypoint(270); break;
            case 180: leftWaypoint(180); break;
            case 270: leftWaypoint(90); break;
            default: cout << "Shouldn't be here. Right Waypoint.\n";
        }
    }

    void print()
    {
        cout << "Position: (" << position.first << ", " << position.second << ") ";
        cout << "Direction: (" << direction.first << ", " << direction.second << ") ";
        cout << "Waypoint: (" << waypoint.first << ", " << waypoint.second << ")\n";
    }

};

void updateState(State&, pair<char, int>);
void updateStateWaypoint(State &, pair<char, int>);
pair<char, int> parseInput(string);

int main()
{
    auto start = getTime();

    ifstream inputFile("Inputs/12.txt");
    vector<pair<char, int>> instructions;
    string s;
    while (getline(inputFile, s))
    {
        instructions.push_back(parseInput(s));
    }

    State state { std::make_pair(0, 0), std::make_pair(1, 0), std::make_pair(0, 0) };

    for (auto instruction : instructions)
    {
        updateState(state, instruction);
    }

    int manhattenDistance = abs(state.position.first) + abs(state.position.second);

    cout << "Manhatten distance: " << manhattenDistance << "\n";

    state = { std::make_pair(0, 0), std::make_pair(1, 0), std::make_pair(10, 1) };

    for (auto instruction : instructions)
    {
        updateStateWaypoint(state, instruction);
    }

    manhattenDistance = abs(state.position.first) + abs(state.position.second);

    cout << "Manhatten distance (waypoint): " << manhattenDistance << endl;

    auto end = getTime();
    printTimeElapsed(start, end);

}

void updateState(State &currentState, pair<char, int> instruction)
{
    switch (instruction.first)
    {

        case 'F': 
            currentState.forward(instruction.second);
            break;
        case 'L': 
            currentState.left(instruction.second);
            break;
        case 'R':
            currentState.right(instruction.second);
            break;
        case 'N':
            currentState.translate(0, instruction.second);
            break;
        case 'S':
            currentState.translate(0, -instruction.second);
            break;
        case 'E':
            currentState.translate(instruction.second, 0);
            break;
        case 'W':
            currentState.translate(-instruction.second, 0);
            break;
        default:
            cout << "Shouldn't be here updateState.\n";
    }
}

void updateStateWaypoint(State &currentState, pair<char, int> instruction)
{
    switch (instruction.first)
    {

        case 'F': 
            currentState.forwardWaypoint(instruction.second);
            break;
        case 'L': 
            currentState.leftWaypoint(instruction.second);
            break;
        case 'R':
            currentState.rightWaypoint(instruction.second);
            break;
        case 'N':
            currentState.translateWaypoint(0, instruction.second);
            break;
        case 'S':
            currentState.translateWaypoint(0, -instruction.second);
            break;
        case 'E':
            currentState.translateWaypoint(instruction.second, 0);
            break;
        case 'W':
            currentState.translateWaypoint(-instruction.second, 0);
            break;
        default:
            cout << "Shouldn't be here updateState.\n";
    }
}

pair<char, int> parseInput(string s)
{
    istringstream iss(s);

    char c = iss.get();
    int n;
    iss >> n;

    return std::make_pair(c, n);
}