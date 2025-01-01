defmodule Day07_P01 do
  @behaviour Common.Solver

  @type target :: integer()
  @type ints :: [integer()]
  @type input :: {target(), ints()}

  # Read the .txt, output list of strings
  @spec read(String.t()) :: [binary()]
  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  # Parse the list of strings into a list of inputs
  def parse(rowstrs) do
    rowstrs
    |> Enum.map(&String.split(&1, ":", trim: true))
    |> Enum.map(fn [targ_str, rest_str] ->
      target = String.to_integer(targ_str)
      ints = String.split(rest_str) |> Enum.map(&String.to_integer/1)
      {target, ints}
    end)
  end

  # base case, end of list
  def solvable?(acc, [n], op, target) do
    op.(acc, n) == target
  end

  # Recurse case: proceed if < target and not end of list
  def solvable?(acc, [n | rest], op, target) do
    val = op.(acc, n)

    cond do
      val > target ->
        false

      # can only be followed by multiplications of 1
      val == target ->
        solvable?(val, rest, &Kernel.*/2, target)

      true ->
        solvable?(val, rest, &Kernel.+/2, target) or solvable?(val, rest, &Kernel.*/2, target)
    end
  end

  @spec solve([input()]) :: integer()
  def solve(inputs) do
    inputs
    |> Enum.filter(fn {target, [n | ints]} ->
      solvable?(n, ints, &Kernel.+/2, target) or solvable?(n, ints, &Kernel.*/2, target)
    end)
    |> Enum.reduce(0, fn {t, _ints}, acc -> acc + t end)
  end
end
