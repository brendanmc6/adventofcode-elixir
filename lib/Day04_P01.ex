defmodule Grid do
  defstruct map: %{}, max_x: 0, max_y: 0

  @type t :: %__MODULE__{map: map(), max_x: integer(), max_y: integer()}
end

defmodule Day04_P01 do
  @type rows_list :: [String.t()]

  @behaviour Common.Solver

  @spec read(String.t()) :: rows_list()
  def read(path) do
    File.stream!(path)
    |> Enum.map(& &1)
  end

  @doc "Higher-order function that returns a reducer, so I can add yIndex to the closure"
  @spec char_reducer(integer()) :: ({String.t(), integer()}, Grid.t() -> Grid.t())
  def char_reducer(yIndex) do
    fn {char, xIndex}, grid ->
      newMap = Map.put_new(grid.map, {xIndex, yIndex}, char)
      %{grid | map: newMap, max_x: xIndex}
    end
  end

  @spec reduce_row({String.t(), integer()}, Grid.t()) :: Grid.t()
  def reduce_row({str, yIndex}, grid) do
    str
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(grid, char_reducer(yIndex))
  end

  @spec parse(rows_list()) :: Grid.t()
  def parse(rows_list) do
    initial_grid = %Grid{map: %{}, max_x: 0, max_y: length(rows_list) - 1}

    rows_list
    |> Enum.with_index()
    |> Enum.reduce(initial_grid, &reduce_row/2)
  end

  def solve(puzzle_input) do
    puzzle_input
  end
end
