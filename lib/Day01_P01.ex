defmodule Day01_P01 do
  @behaviour Common.Solver

  @type int_list :: [integer()]
  @type parsed_input_line :: {integer(), integer()}
  @typedoc "List of integer tuples `[{1,1}, {2,2}]`"
  @type puzzle_input :: [parsed_input_line]
  @type list_tuple :: {int_list, int_list}

  @doc """
  Accepts (el, acc)
  Where el is a pair of integers, and acc is a list_tuple
  Prepends to left and right list respectively
  Returns accumulator
  """
  @spec assign_to_lists(parsed_input_line, list_tuple) :: list_tuple
  def assign_to_lists({int_left, int_right}, {l_left, l_right}) do
    {[int_left | l_left], [int_right | l_right]}
  end

  @doc "Sorts both lists in the given list_tuple"
  @spec sort_lists(list_tuple) :: list_tuple
  def sort_lists({l_left, l_right}) do
    {Enum.sort(l_left), Enum.sort(l_right)}
  end

  # Take absolute distance and add to the accumulator
  @spec add_distance([integer()], integer()) :: integer()
  def add_distance([l, r], acc) do
    abs(l - r) + acc
  end

  @spec read(String.t()) :: [String.t()]
  def read(path) do
    File.stream!(path)
    |> Enum.map(& &1)
  end

  @doc "Parse a single line of input from *_input.txt"
  @spec parse_line(String.t()) :: parsed_input_line
  def parse_line(line) do
    line
    |> String.trim()
    |> String.split("   ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  @spec parse([String.t()]) :: puzzle_input
  def parse(lines) do
    lines
    |> Enum.map(&parse_line/1)
  end

  @spec solve(puzzle_input) :: integer()
  def solve(puzzle_input) do
    puzzle_input
    # Reduce to two unsorted lists
    |> Enum.reduce({[], []}, &assign_to_lists/2)
    # Sort both lists
    |> sort_lists()
    # convert tuple to list for zip_reduce compat
    |> then(fn {l, r} -> [l, r] end)
    # compute and add distance at each index
    |> Enum.zip_reduce(0, &add_distance/2)
  end
end
