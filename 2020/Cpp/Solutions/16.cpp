#include "aoc.h"

class Field
{
    int l1, l2, u1, u2;
    

public: 
    bool operator()(int x)
    {
        return (l1 <= x && x <= l2) || (u1 <= x && x <= u2);
    }

    Field(string name, int l1, int l2, int u1, int u2) : name{name}, l1{l1}, l2{l2}, u1{u1}, u2{u2} {}

    string name;
};

using TicketNumbers = vector<int>;
bool verifyFigure(vector<Field> &fields, int n);
vector<int> parseString(string s);

int main ()
{

    vector<Field> allFields;

    allFields.push_back(Field("departure location", 47, 691, 713, 954));
    allFields.push_back(Field("departure station", 44, 776, 799, 969));
    allFields.push_back(Field("departure platform", 37, 603, 627, 953));
    allFields.push_back(Field("departure track", 41, 240, 259, 955));
    allFields.push_back(Field("departure date", 42, 370, 383, 961));
    allFields.push_back(Field("departure time", 50, 117, 136, 962));
    allFields.push_back(Field("arrival location", 33, 86, 104, 973));
    allFields.push_back(Field("arrival station", 29, 339, 347, 962));
    allFields.push_back(Field("arrival platform", 46, 644, 659, 970));
    allFields.push_back(Field("arrival track", 31, 584, 604, 960));
    allFields.push_back(Field("class", 42, 107, 115, 971));
    allFields.push_back(Field("duration", 31, 753, 770, 972));
    allFields.push_back(Field("price", 40, 515, 525, 957));
    allFields.push_back(Field("route", 31, 453, 465, 971));
    allFields.push_back(Field("row", 46, 845, 868, 965));
    allFields.push_back(Field("seat", 45, 475, 489, 960));
    allFields.push_back(Field("train", 34, 317, 323, 968));
    allFields.push_back(Field("type", 47, 150, 159, 969));
    allFields.push_back(Field("wagon", 45, 261, 279, 955));
    allFields.push_back(Field("zone", 33, 879, 891, 952));

    ifstream inputFile("inputs/16.txt");

    string s;
    TicketNumbers myTicket = parseString("191,139,59,79,149,83,67,73,167,181,173,61,53,137,71,163,179,193,107,197");

    vector<TicketNumbers> input;
    while (getline(inputFile, s))
        input.push_back(parseString(s));

    int errorNumber = 0;

    for (TicketNumbers tn : input)
    {
        for (int i : tn)
            if (!verifyFigure(allFields, i))
                errorNumber += i;
    }

    cout << "Total error rate: " << errorNumber;


    vector<TicketNumbers> validInput;

    for (TicketNumbers tn : input)
    {
        bool validTicket = true;
        for (int i : tn)
            if (!verifyFigure(allFields, i))
                validTicket = false;
        if (validTicket)
            validInput.push_back(tn);
    }



    vector<vector<int>> columnValues;

    for (TicketNumbers tn : validInput)
    {            
        for (int i = 0; i < tn.size(); i++)
        {
            if ((i+1) >= columnValues.size())
            {
                vector<int> temp;
                columnValues.push_back(temp);
            }
            columnValues[i].push_back(tn[i]);
        }        
    }

    vector<vector<Field>> validFields;

    for (vector<int> col : columnValues)
    {
        vector<Field> temp;
        for (Field f : allFields)
        {
            bool isValid = true;
            for (int i : col)
            {
                if (!f(i))
                    isValid = false;
            }
            if (isValid)
                temp.push_back(f);
        }
        validFields.push_back(temp);
    }

    int i = 1;

    for (vector<Field> thisCol : validFields)
    {
        cout << "Column " << i++ << " could be: \n";
        for (Field f : thisCol)
            cout << f.name << "\n";
        cout << endl;
    }

    // Using this information the rest of the puzzle was done in Excel :(

}

vector<int> parseString(string s)
{
    istringstream iss(s);

    vector<int> output;
    int token;

    while (iss)
    {
        char temp;
        iss >> token;
        output.push_back(token);
        iss >> temp;
        iss.peek();
    }

    return output;
}

bool verifyFigure(vector<Field> &fields, int n)
{
    for (Field f : fields)
        if (f(n))
            return true;

    return false;
}