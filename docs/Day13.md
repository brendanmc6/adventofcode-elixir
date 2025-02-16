# Day13

We have `targetX` and `targetY`
We have values `AX`, `AY`, `BX`, `BY`

We must find values `na` and `nb` (number of A and B button presses)

We must achieve targets

```elixir
targetX = (ax * na) + (bx * nb)
targetY = (ay * na) + (by * nb)
```

If multiple solutions for `na` and `nb` exist, take the solution with the largest `nb`.

`na + nb` may not exceed 100

Calculate the "cost" of the solution, where:

```elixir
cost = (na * 3) + nb
```

# Brute approach

Start with `targetX` and find all valid combinations for `na` and `nb`
Then check those combinations against `targetY`.

Start with

```elixir
na = 0
nb = floor(targetX / bx)
# Then check for potential solution:
potentialSolution? = targetX === (ax * na) + (bx * nb)
```

Push found solution tuples to a list, by default it becomes sorted from most expensive (max `na`, last in), to cheapest (max `nb`, first in)

```elixir
xSolutions = [{na, nb} | prevSolutions]
```

Recurse until `nb === 0`

```elixir
check_solution(targetX, na + 1, nb - 1, xSolutions)
```

At this point we have a list of solutions for targetX, reverse it (so cheapest is first) and find the first one that also solves `targetY`

```elixir
xSolutions
|> List.reverse()
|> List.find(nil, fn {na, nb} -> check_solution(targetY, na, nb) end)
```

# Math shortcuts

Partially cheating with GPT, I learned about the Greatest Common Divisor test (GCD Test) and the Frobenius Bound (coprime GCD).

If I find the GCD of `AX` and `BX` (the largest number that evenly divides both) then I can use that to reduce the search space.

- `potentiallySolvable? = rem(target, gcd) === 0`

If the GCD is 1 (coprime) then I can make any sufficently large number, so I can eliminate numbers that are too small to be made

- `definitelySolvable? = target > A * B - A - B`

# Other optimizations

- Handle case where A or B are greater than target?
