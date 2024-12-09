# Advent of Code 2024 solved with Elixir

WIP. This is my first time using Elixir, and first time doing AOC, so the solutions are not optimal nor idiomatic.

## Overview
The implementation for each puzzle resides in a .ex module in the `lib` folder.
```
lib/Day01_P01.ex // day 1, puzzle 1
lib/Day01_P02.ex // day 1, puzzle 2
lib/Day02_P01.ex
``` 

Each implementation should have a corresponding puzzle input `.txt` in `/inputs/`.

Running `mix solve {day} {puzzle}` will output the solution for the given day and puzzle.

```
mix solve 01 01
// Writes to `/solutions/Day01_P01_solution.txt`