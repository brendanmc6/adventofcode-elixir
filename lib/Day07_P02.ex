defmodule Day07_P02 do
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
      list = String.split(rest_str) |> Enum.map(&String.to_integer/1) |> List.to_tuple()
      {target, list, tuple_size(list) - 1}
    end)
  end

  # base case, end of list
  def solvable?(target, value, i, _list, end_i) when i == end_i do
    value == target
  end

  # recurse case, not end of list, can still solve
  def solvable?(target, value, i, list, end_i) when value < target do
    next_i = i + 1
    next_el = elem(list, next_i)

    solvable?(target, value + next_el, next_i, list, end_i) or
      solvable?(target, value * next_el, next_i, list, end_i) or
      solvable?(target, concat_ints(value, next_el), next_i, list, end_i)
  end

  # recurse case, can only be solved with mul
  def solvable?(target, value, i, list, end_i) when value == target do
    next_i = i + 1
    solvable?(target, value * elem(list, next_i), next_i, list, end_i)
  end

  # not solvable, target > value
  def solvable?(_target, _value, _i, _list, _end_i), do: false

  def concat_ints(a, b), do: String.to_integer("#{a}#{b}")

  @spec solve([input()]) :: integer()
  def solve(inputs) do
    inputs
    |> Enum.filter(fn {target, list, end_i} ->
      a = elem(list, 0)
      b = elem(list, 1)

      solvable?(target, a + b, 1, list, end_i) or
        solvable?(target, a * b, 1, list, end_i) or
        solvable?(target, concat_ints(a, b), 1, list, end_i)
    end)
    |> Enum.reduce(0, fn {t, _ints, _end_i}, acc -> acc + t end)
  end
end
