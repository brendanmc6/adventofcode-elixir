# Day14

Determine the location of each robot after 100 iterations.
The grid is 101 wide and 103 tall.

# Brainstorming

Trying to solve with arithmetic first.

The example starts at `{2,4}` with `v = {2,-3}` and ends at `{1,3}` after 5 seconds

The grid is 11 wide 7 tall

```elixir
@seconds 100
def calculate(start, velocity, board_size) do
  total_distance = @seconds * velocity
  pos = rem(start + total_distance, board_size)
  # normalize the negative remainder by looping it back around
  if pos < 0, do: pos + board_size, else: pos
end
```

Determine the quadrant ranges

101x103 grid

filter out anything in tile 51 (x=50)
filter out anything in tile 52 (y=51)

First quad would be {0-49, 0-50}
second quad would be {51-100, 0-50}
third quad would be {0-49, 52-102}
fourth quad would be {51-100, 52-102}

Count the robots in each quadrant, multiply

# Part 2

For range of steps 1...1000
Calculate final position of robots
Check for 7 adjacent robots on the X axis
If found, print the grid and the step count.
If not found, continue.

## Algo for quickly checking adjacency

Push them to a map of lists

```elixir
%{
  x_coord => [y1, y2, y3, y4]
}
```

Scan for x_coords where `length(y_list) > n`

Scan list for `n` adjacent elements
