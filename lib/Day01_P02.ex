defmodule Day01_P02 do
  @behaviour Common.Solver

  @type int_list :: [integer()]
  @type int_tuple :: {integer(), integer()}
  @typedoc "List of integer tuples `[{1,1}, {2,2}]`"
  @type puzzle_input :: [int_tuple]
  @type count_map :: %{integer() => {integer(), integer()}}

  @doc """
  Accepts (el, acc)
  Where el is a tuple of 2 integers, and acc is a count_map
  Increments the count for the left and right integers respectively
  Returns map
  """
  @spec assign_count_map(int_tuple, count_map) :: count_map
  def assign_count_map({int_left, int_right}, map) do
    map
    |> Map.update(int_left, {1, 0}, fn {count_left, count_right} ->
      {count_left + 1, count_right}
    end)
    |> Map.update(int_right, {0, 1}, fn {count_left, count_right} ->
      {count_left, count_right + 1}
    end)
  end

  def sum_multiply_count({number, {count_left, count_right}}, acc_int) do
    number * count_left * count_right + acc_int
  end

  @spec read(String.t()) :: [String.t()]
  def read(path) do
    File.stream!(path)
    |> Enum.map(& &1)
  end

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
    |> Enum.reduce(%{}, &assign_count_map/2)
    |> Enum.reduce(0, &sum_multiply_count/2)
  end
end
