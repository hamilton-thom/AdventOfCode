#include "aoc.h"

using Ingredient = string;
using Allergen = string;
using Ingredients = set<Ingredient>;
using Allergens = set<Allergen>;

pair<Ingredients, Allergens> parseLine(string s);
void matches(vector<pair<Ingredients, Allergens>> input);
set<string> unionAll(vector<set<string>> vs);
bool verifyGuess(const vector<pair<Ingredients, Allergens>> &, const Ingredient, const Allergen);

int main()
{
    ifstream inputFile("inputs/21.txt");
    vector<pair<Ingredients, Allergens>> input;
    string s;
    while (getline(inputFile, s))
        input.push_back(parseLine(s));

    matches(input);

    Ingredients actualIngredients {"zbhp", "ndnlm", "fsr", "xcljh", "mgbv", "dvjrrkv", "skrxt", "lqbcg"};
    
    int count = 0;

    for (auto p : input)
        for (string s : p.first)
            if (actualIngredients.count(s) == 0)
                count++;

    cout << "Other count: " << count << "\n";

}

pair<Ingredients, Allergens> parseLine(const string s)
{
    Ingredients ingredients;
    Allergens allergens;

    istringstream iss(s);

    string thisToken;
    iss >> thisToken;
    while (thisToken != "(contains")
    {
        ingredients.insert(thisToken);
        iss >> thisToken;
    }

    iss >> thisToken;
    while (iss)
    {
        allergens.insert(thisToken.substr(0, thisToken.length() - 1));
        iss >> thisToken;
    }

    return make_pair(ingredients, allergens);
}


set<string> unionAll(vector<set<string>> vs)
{
    set<string> all;
    set<string> temp;
    for (auto s : vs)
    {
        std::set_union(s.begin(), s.end(), 
                       all.begin(), all.end(),
                       std::inserter(temp, temp.begin()));
        all = temp;
        temp.clear();
    }
    return all;
}


void matches(vector<pair<Ingredients, Allergens>> input)
{
    vector<set<string>> allIngredients;
    vector<set<string>> allAllergens;

    for (auto p : input)
    {
        allIngredients.push_back(p.first);
        allAllergens.push_back(p.second);
    }

    Ingredients uniqueIngredients = unionAll(allIngredients);
    Allergens uniqueAllergens = unionAll(allAllergens);

    vector<pair<Ingredient, Allergen>> actualPairs;

    for (Allergen a : uniqueAllergens)
    {
        for (Ingredient i : uniqueIngredients)
        {
            if (verifyGuess(input, i, a))
                cout << a << " = " << i << "\n";
        }
    }
}



// Can only reject guesses, can't confirm them.
bool verifyGuess(const vector<pair<Ingredients, Allergens>> &inputs, const Ingredient guessI, const Allergen guessA)
{

    for (auto p : inputs)
    {   
        if (p.second.count(guessA) > 0 && p.first.count(guessI) == 0)
            return false;
    }

    return true;
}

void removePair(vector<pair<Ingredients, Allergens>> &inputs, const Ingredient guessI, const Allergen guessA)
{
    for (auto p : inputs)
    {
        p.first.erase(guessI);
        p.second.erase(guessA);
    }
}