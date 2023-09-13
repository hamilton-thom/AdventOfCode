// Example program
#include <iostream>
#include <set>

int main()
{
  std::set<int> test{1, 2, 3, 4, 5, 6, 7};
  
  auto it = test.begin();
  auto rit = test.rbegin();
  
  while (&*it != &*rit)
  {
    std::cout << *it << ", " << *rit << std::endl;
    it++;
    rit++;
  }
  
}