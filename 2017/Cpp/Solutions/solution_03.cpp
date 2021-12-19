
#include <iostream>

struct Direction;

void changeDirection(Direction&);
void printArray(int[11][11], int);

struct Direction {
    int x;
    int y;

    Direction(int x, int y): x(x), y(y) {}
 
    constexpr int hash() {
        return 10 * x + y;
    }
 
    bool operator==(const Direction& rhs) {
        return x == rhs.x && y == rhs.y;
    }    
    
    void move(int distance, Direction direction) {
        x += direction.x * distance;
        y += direction.y * distance;
    }
    
    bool inSquare(int size) {
        return x >= 0 && x < size && y >= 0 && y < size;
    }
};
   

int main() {
    constexpr int guessSize = 200;
    constexpr int guessWidth = 2 * guessSize + 1;
    int target = 265149;
    
    int squareArray[guessWidth][guessWidth] = {};    
    
    Direction direction = Direction(1, 0);
    
    int moveAmount = 1;
    int moveSection = 0;
    int moveCount = 1;
    
    int currentValue = 0;
    
    // Initialise the array.
    Direction turtleLocation = Direction(guessSize, guessSize);
    squareArray[turtleLocation.x][turtleLocation.y] = 1;
    
    while(currentValue < target && turtleLocation.inSquare(guessWidth)) {        
        turtleLocation.move(1, direction);
        
        squareArray[turtleLocation.x][turtleLocation.y] = 
            squareArray[turtleLocation.x + 1][turtleLocation.y + 1] +
            squareArray[turtleLocation.x + 1][turtleLocation.y] +
            squareArray[turtleLocation.x + 1][turtleLocation.y - 1] +            

            squareArray[turtleLocation.x][turtleLocation.y + 1] +
            squareArray[turtleLocation.x][turtleLocation.y - 1] +
            
            squareArray[turtleLocation.x - 1][turtleLocation.y + 1] +
            squareArray[turtleLocation.x - 1][turtleLocation.y] +
            squareArray[turtleLocation.x - 1][turtleLocation.y - 1];
        
        currentValue = squareArray[turtleLocation.x][turtleLocation.y];        
        //printArray(squareArray, guessWidth);
        //std::cout << std::endl;
        std::cout << "moveAmount = " << moveAmount << ", moveCount = " << moveCount << ", moveSection = " << moveSection << ", currentValue = " << currentValue << std::endl;
        
        if (moveCount == moveAmount || moveCount == 0) {
            changeDirection(direction);
            moveCount = 0;
            moveSection++;
            if (moveSection > 1) {
                moveAmount++;
                moveSection = 0;
            }
        }
        moveCount++;
    }
    
    std::cout << "Part 2 - the first value above target is: " << squareArray[turtleLocation.x][turtleLocation.y] << std::endl;
    
    return 0;
}


void printArray(int array[11][11], int width) {    
    for (int i = 0; i < width; i++) {        
        for (int j = 0; j < width; j++)
            std::cout << array[i][j] << " ";
        std::cout << std::endl;
    }
}


void changeDirection(Direction &currentDirection) {
    
    constexpr int right = 10;
    constexpr int up = 1;
    constexpr int left = -10;
    constexpr int down = -1;
    
    switch (currentDirection.hash()) {                    
        case right:
            currentDirection = Direction(0, 1);
            return;
        case up:
            currentDirection = Direction(-1, 0);
            return;
        case left:
            currentDirection = Direction(0, -1);
            return;
        case down:
            currentDirection = Direction(1, 0);
            return;        
    }    
}