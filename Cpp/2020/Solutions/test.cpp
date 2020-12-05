

#include <string>
#include <sstream>
#include <iostream>
#include <ios>

using std::string;

void printState(std::istringstream&);

int main ()
{
    std::istringstream iss;

    iss.str("1005 .283  283 ,192");

    int temp;
    std::string token;
    std::istringstream tempiss;


    std::cout << "Position: " << iss.tellg() << std::endl;
    
    iss >> token;
    tempiss.str(token);
    tempiss.clear();
    tempiss >> temp;
    printState(iss);
    std::cout << "Temp value: " << temp << std::endl;

    std::cout << "Position: " << iss.tellg() << std::endl;
    
    iss >> token;
    tempiss.str(token);
    tempiss.clear();
    tempiss >> temp;
    printState(iss);
    std::cout << "Temp value: " << temp << std::endl;
    iss.clear();

    std::cout << "Position: " << iss.tellg() << std::endl;
    
    iss >> token;
    tempiss.str(token);
    tempiss.clear();
    tempiss >> temp;
    printState(iss);
    std::cout << "Temp value: " << temp << std::endl;
    iss.clear();

    std::cout << "Position: " << iss.tellg() << std::endl;
    
    iss >> token;
    tempiss.str(token);
    tempiss.clear();
    tempiss >> temp;
    printState(iss);
    std::cout << "Temp value: " << temp << std::endl;
    iss.clear();

    std::cout << "Position: " << iss.tellg() << std::endl;    
    iss >> token;
    tempiss.str(token);
    tempiss.clear();
    tempiss >> temp;
    printState(tempiss);
    std::cout << "Temp value: " << temp << std::endl;    
    iss.clear();
}

void printState(std::istringstream &iss)
{
    if (!iss.rdstate())
        std::cout << "Good bit set" << std::endl;

    if (iss.rdstate() & std::ios_base::badbit)
        std::cout << "Bad bit set" << std::endl;

    if (iss.rdstate() & std::ios_base::failbit)
        std::cout << "Fail bit set" << std::endl;

    if (iss.rdstate() & std::ios_base::eofbit)
        std::cout << "Eof bit set" << std::endl;
}
