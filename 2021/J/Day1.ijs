input =: fread < 'C:\Users\choes\git\aoc2021\Input\day1.txt'

depths =: _". > CRLF splitstring input

increasingCount =. +/ @ (1&}. > _1&}.)

[ part1 =: increasingCount depths

NB. Part 2 - create a matrix which contains indicators for the 
NB. moving sum fields - multiply this by the values, sum and compare.

cyclicValues =: 1 1 1, 0 $~ (_2&+@#) depths

matrix =: cyclicValues $~ ((#depths) - 2), #depths

movingAverages =: +/"1 matrix *"1 depths

[ part2 =: +/ increasingDepth

