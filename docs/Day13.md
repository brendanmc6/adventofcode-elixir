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

# Algebra solution

O(n) was too slow for part 2. I had to cheat.

There is a mathematical solution and this is my attempt to understand it. I did not explore math solutions because I believed that multiple solutions could exist.
I don't have formal math education so I had no idea how to formulate an equation that would result in multiple potential solutions.

Apparently there is only one solution for each puzzle which makes this feasible.

Construct these into a matrix equation, where one matrix describes the movements of a and b, and the other is a vector (na, nb) that we try to solve for.

We need to calculate the Determinant which tells us if the equation has a unique solution.

For a 2x2 matrix ( a, b / c, d )

```
[a b]
[c d]

D = ad-bc
```

To understand Determinants intuitively, consider that if the rows or columns were the same: D would be 0

```
[a a]
[b b]

or

[a b]
[a b]

ab - ba = 0
```

So for our equation:

```
[ax bx]
[ay by]

D = ax * by - bx * ay
```

If D = 0, there will not be a solution, because this implies the columns (or rows) are linearly dependent— on the same line- one is just a multiple of the other.

For example if Button A was (1, 1) and B was (10, 10), they are the same movement vector! (direction, angle) so `na` and `nb` can be infinite if the target is on the line, or zero if it is not.

The next step is to invert the matrix, which is equivalent to "dividing" to move it to the other side of the equation. So we started with:

```
[ax bx][na] = [targetX]
[ay by][nb]   [targetY]
```

Then we end up with:

```
[na] = 1/D * [by -bx][targetX]
[nb]         [-ay ax][targetY]
```

Now we solve for `na` and `nb` by doing dot-product multiplication. Assuming D is non-zero.

```elixir
na = (by * targetX + (-bx) * targetY) / d
nb = (-ay * targetX + ax * targetY) / d
```
