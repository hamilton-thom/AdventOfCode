
#include <iostream>

struct Cursor
{
  unsigned int *cursor;
  unsigned int index = 0;

  Cursor(unsigned int *cursor) : cursor(cursor) {}

  bool get()
  {
    unsigned int bitmask = 1 << index;
    return (*cursor & bitmask) >> index == 1;
  }

  void set(bool b)
  {
    unsigned int bitmask = 1 << index;

    if (b)
    {
      *cursor = (*cursor & ~bitmask) | bitmask;  
    }
    else
    {
      *cursor = *cursor & ~bitmask;
    }
    
  }

  // Array assumed to be structured [0, ..., 800000]
  // Individual ints assumed to be stored [large bits, ..., zero bit]
  // Hence moving left means increasing bits, or moving to a smaller index
  // moving right means decreasing bits, or moving to a larger index.

  void moveLeft()
  {
    if (index == 31) 
    {
      index = 0;
      cursor--;
    } 
    else
    {
      index++;
    }
  }

  void moveRight()
  {
    if (index == 0) 
    {
      index = 31;
      cursor++;
    } 
    else
    {
      index--;
    }
  }

  void print()
  {
    std::cout << "Index: " << index << " dictionary: " << *cursor << std::endl;
  }
};

enum State 
{
  A, B, C, D, E, F
};

unsigned int setBitCount(unsigned int n)
{
  unsigned int count = 0;
  for (int i = 0; i < 32; i++)
  {
    if (((n & (1 << i)) >> i) == 1)
      count++;
  }

  return count;
}

int main() 
{
  unsigned int *tape = new unsigned int[800000];
  for (int i = 0; i < 800000; i++)
      *(tape + i) = 0;

  Cursor cursor(tape + 400000);
  
  int instructionCount = 0;

  State currentState = A;

  while (instructionCount < 12172063)
  {    
    //for (int i = 400000-5; i < 400000+5; i++)
       // std::cout << *(tape+i) << " ";
     // std::cout << currentState << " - " << *(cursor.cursor) << " : " << cursor.index << std::endl;
    //cursor.print();
    switch (currentState)
    {
      case A: 
        if (cursor.get()) { cursor.set(false); cursor.moveLeft(); currentState = C; }
        else              { cursor.set(true); cursor.moveRight(); currentState = B; }
        break;
      
      case B: 
        if (cursor.get()) { cursor.set(true); cursor.moveLeft(); currentState = D; }
        else              { cursor.set(true); cursor.moveLeft(); currentState = A; }
        break;

      case C: 
        if (cursor.get()) { cursor.set(false); cursor.moveRight(); currentState = C; }
        else              { cursor.set(true); cursor.moveRight();  currentState = D; }
        break;

      case D: 
        if (cursor.get()) { cursor.set(false); cursor.moveRight(); currentState = E; }
        else              { cursor.set(false); cursor.moveLeft();  currentState = B; }
        break;

      case E: 
        if (cursor.get()) { cursor.set(true); cursor.moveLeft();  currentState = F; }
        else              { cursor.set(true); cursor.moveRight(); currentState= C; }
        break;

      case F: 
        if (cursor.get()) { cursor.set(true); cursor.moveRight(); currentState = A; }
        else              { cursor.set(true); cursor.moveLeft();  currentState= E; }
        break;
    }
    instructionCount++;
  }

  unsigned int checkSum = 0;

  for (int i = 0; i < 800000; i++)
    checkSum += setBitCount(*(tape + i));

  std::cout << "Check sum = " << checkSum << std::endl;
}