

// 2 * 3 + (4 * 5) becomes 26.

// Evaluted left to right always (regardless of + *)
// Brackets override.

enum class Operator { Add, Multiply };

struct Expression
{
    Operator op;
    bool isVal;
    int val = 0;
    optional<Expression> lhs, rhs;

    int evaluate()
    {
        if (isVal) return val;

        int lhsVal = lhs.value().evaluate();
        int rhsVal = rhs.value().evaluate();

        if (op == Operator::Add)
        {
            return lhsVal + rhsVal;
        }
        else
        {
            return lhsVal * rhsVal;
        }
    }
}

Expression buildExpression(string s)
{

    //all single digit expressions

    Expression *lhs = nullptr, *rhs = nullptr;

    
    if (s[0] == '(')
    {   
        string subExpr;
        subExpr = s.substring(0, subExpression(s))
        lhs = 
    }






}

int subExpression(string s)
{
    // Assume that the first character is a (.

    int bracketMatch = 1;

    int matchPosition = 1;

    while (bracketMatch != 0)
    {
        if(s[matchPosition] == '(')
            bracketMatch++;
        if (s[matchPosition] == ')')
            bracketMatch--;
        matchPosition++;
    }

    return matchPosition;
}