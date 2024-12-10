defmodule Day02_P01 do
  require Logger

  @behaviour Common.Solver

  @type level :: integer()
  @type report :: [level]
  @type puzzle_input :: [report]

  @min_diff 1
  @max_diff 3

  @doc """
  Given line of input.txt "9 12 14 16 17 18 15\n"
  Returns a list of integers [9, 12, 14, ...]
  """
  @spec parse(String.t()) :: report
  def parse(line) do
    line
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  def valid_diff(diff), do: diff <= @max_diff && diff >= @min_diff

  def diff(a, b, :increment), do: b - a
  def diff(a, b, :decrement), do: a - b

  # Recursive comparison (list length >= 3)
  def compare([a, b, c | tail], direction) do
    if !valid_diff(diff(a, b, direction)) do
      0
    else
      compare([b, c | tail], direction)
    end
  end

  # happy path, end of report (list of length 2)
  def compare([a, b], direction) do
    if valid_diff(diff(a, b, direction)), do: 1, else: 0
  end

  @spec validate_report(report) :: integer()
  def validate_report(report) do
    case report do
      [a, b | _] when a == b -> 0
      [a, b | _] when a < b -> compare(report, :increment)
      [a, b | _] when a > b -> compare(report, :decrement)
    end
  end

  @spec solve(puzzle_input) :: integer()
  def solve(puzzle_input) do
    puzzle_input
    |> Enum.map(&validate_report/1)
    |> Enum.sum()
  end
end
