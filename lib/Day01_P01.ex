defmodule Day01_P01 do
  require Logger

  @type int_list :: [integer()]
  @type int_tuple :: {integer(), integer()}
  @typedoc "List of integer tuples `[{1,1}, {2,2}]`"
  @type puzzle_input :: [int_tuple]
  @type list_tuple :: {int_list, int_list}

  @doc """
  Given line of input.txt "123 456\n"
  Returns a tuple of integers {123, 456}
  """
  @spec parse_line(String.t()) :: int_tuple
  def parse_line(line) do
    line
    |> String.trim()
    |> String.split("   ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  @doc """
  Accepts (el, acc)
  Where el is a pair of integers, and acc is a list_tuple
  Prepends to left and right list respectively
  Returns accumulator
  """
  @spec assign_to_lists(int_tuple, list_tuple) :: list_tuple
  def assign_to_lists({int_left, int_right}, {l_left, l_right}) do
    {[int_left | l_left], [int_right | l_right]}
  end

  @doc "Sorts both lists in the given list_tuple"
  @spec sort_lists(list_tuple) :: list_tuple
  def sort_lists({l_left, l_right}) do
    {Enum.sort(l_left), Enum.sort(l_right)}
  end

  @doc "Parses txt input and returns 2 sorted lists."
  @spec read(String.t()) :: puzzle_input
  def read(input_path) do
    File.stream!(input_path)
    # From string to list of tuples [{123, 456}, {789, 012}]
    |> Enum.map(&parse_line/1)
  end

  # Take absolute distance and add to the accumulator
  @spec add_distance([integer()], integer()) :: integer()
  def add_distance([l, r], acc) do
    abs(l - r) + acc
  end

  @spec compute(puzzle_input) :: integer()
  def compute(puzzle_input) do
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

  @spec write(integer(), String.t()) :: :ok
  def write(value, output_path) do
    Mix.shell().info("Writing solution to #{output_path} \n Solution is: #{value}")
    File.write(output_path, Integer.to_string(value))
  end

  @spec solve(String.t(), String.t()) :: :ok
  def solve(input_path, output_path) do
    read(input_path) |> compute() |> write(output_path)
  end
end
