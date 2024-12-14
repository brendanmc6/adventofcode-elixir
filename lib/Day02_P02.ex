defmodule Day02_P02 do
  @behaviour Common.Solver

  @type level :: integer()
  @type report :: [level]
  @type puzzle_input :: [report]

  @min_diff 1
  @max_diff 3

  def valid_diff(diff), do: diff <= @max_diff && diff >= @min_diff

  def diff(a, b, :increment), do: b - a
  def diff(a, b, :decrement), do: a - b

  # Function header for default values
  def compare(list, direction, indexB \\ 1)

  # Recursive comparison (list length >= 3)
  def compare([a, b, c | tail], direction, indexB) do
    if !valid_diff(diff(a, b, direction)) do
      {0, indexB}
    else
      compare([b, c | tail], direction, indexB + 1)
    end
  end

  # happy path, end of report (list of length 2)
  def compare([a, b], direction, indexB) do
    if(valid_diff(diff(a, b, direction)), do: {1, indexB}, else: {0, indexB})
  end

  @spec validate_report(report) :: {integer(), integer()}
  def validate_report(report) do
    case report do
      # recover by throwing out the first, calling compare
      # {0, 1, report} means fail, at index 1
      [a, b | _] when a == b -> {0, 1}
      [a, b | _] when a < b -> compare(report, :increment)
      [a, b | _] when a > b -> compare(report, :decrement)
    end
  end

  # wrapper to return `report` in the tuple
  # because we don't pass the full report into the recursive loop
  # but we need it for retries in the parent fn
  def meta_validate_report(report) do
    {status, index} = validate_report(report)
    {status, index, report}
  end

  def retry_report({1, _i, _r}), do: 1

  # `with` clause is neat, if pattern does not match it passes the mismatch to `else`
  # here we try 3 different strategies for removing the item at report[index] and retrying
  # when a report is succesfully retried, we return 1
  def retry_report({0, index, report}) do
    with {0, _} <- validate_report(List.delete_at(report, index)),
         {0, _} <- validate_report(List.delete_at(report, index - 1)),
         {0, _} <- validate_report(List.delete_at(report, 0)) do
      0
    else
      {1, _} -> 1
    end
  end

  @spec read(String.t()) :: [String.t()]
  def read(path) do
    File.stream!(path)
    |> Enum.map(& &1)
  end

  @spec parse_line(String.t()) :: report
  def parse_line(line) do
    line
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  @spec parse(String.t()) :: puzzle_input
  def parse(lines) do
    lines
    |> Enum.map(&parse_line/1)
  end

  # after iterating to find failures and their index {0, i}

  @spec solve(puzzle_input) :: integer()
  def solve(puzzle_input) do
    puzzle_input
    |> Enum.map(&meta_validate_report/1)
    |> Enum.map(&retry_report/1)
    |> Enum.sum()
  end
end
