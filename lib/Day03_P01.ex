defmodule Day03_P01 do
  require Logger
  @behaviour Common.Solver

  @prefix_regex ~r/^\d+,\d+\)/
  @capture_regex ~r/^(\d+),(\d+)\)/

  @type string_list :: [String.t()]
  @type puzzle_input :: [string_list]

  def match_prefix(str), do: String.match?(str, @prefix_regex)

  # given a matched string "123,456)!@#"
  # extract the integers {123, 456}
  @spec extract_integers(String.t()) :: {integer(), integer()}
  def extract_integers(str) do
    [_segment, a, b] = Regex.run(@capture_regex, str)
    {String.to_integer(a), String.to_integer(b)}
  end

  @doc """
  Split on "mul(" to get a list of strings like `["123,456)!@#!@#1", "!@$!@$"]`
  """
  @spec parse(String.t()) :: string_list()
  def parse(line) do
    line
    |> String.trim()
    |> String.split("mul(")
  end

  @spec solve(puzzle_input) :: integer()
  def solve(puzzle_input) do
    puzzle_input
    |> List.flatten()
    |> Enum.filter(&match_prefix/1)
    |> Enum.map(&extract_integers/1)
    |> Enum.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end
end
