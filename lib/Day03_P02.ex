defmodule Day03_P02 do
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

  @spec read(String.t()) :: [String.t()]
  def read(path) do
    File.stream!(path)
    |> Enum.map(& &1)
  end

  @doc """
  Split on "don't()" to get a list of strings like `["mul(5,5)+mu", "do()?mul(8,5))"]`
  """
  @spec parse(String.t()) :: string_list()
  def parse(line) do
    line
    |> then(fn l -> "do()#{l}" end)
    |> String.trim()
    |> String.split("don't()")
    |> Enum.map(fn str ->
      String.split(str, "do()")
    end)
    # remove the items that were disabled by dont()
    |> Enum.map(fn string_list ->
      List.delete_at(string_list, 0)
    end)
    |> List.flatten()
    |> Enum.join()
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
