defmodule Grid do
  defstruct map: %{}, max_x: 0, max_y: 0, count: 0

  @type t :: %__MODULE__{map: map(), max_x: integer(), max_y: integer(), count: integer()}
end

defmodule Day04_P01 do
  @type rows_list :: [String.t()]
  @type puzzle_input :: Grid.t()
  @type coord :: {integer(), integer()}
  @type vector :: {integer(), integer()}

  @behaviour Common.Solver

  @word "XMAS"
  @word_length String.length(@word)
  @vectors [
    {:n, {0, -1}},
    {:ne, {1, -1}},
    {:e, {1, 0}},
    {:se, {1, 1}},
    {:s, {0, 1}},
    {:sw, {-1, 1}},
    {:w, {-1, 0}},
    {:nw, {-1, -1}}
  ]

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

  def match(grid, {x, y}, {vx, vy}) do
    0..(@word_length - 1)
    # Optimistically get the value at each coordinate, even if out of bounds
    |> Enum.map(fn i ->
      Map.get(grid.map, {x + vx * i, y + vy * i})
    end)
    |> Enum.join("")
    |> then(&if &1 == @word, do: 1, else: 0)
  end

  @spec count(vector(), Grid.t(), coord()) :: Grid.t()
  def count(vector, grid, coords \\ {0, 0})

  # Base case: vector y crosses bottom boundary, finish count
  def count({_vx, vy}, grid, {_x, y}) when y + vy * (@word_length - 1) > grid.max_y, do: grid

  # Recursive case: parsed entire row, move to next row
  def count({vx, _vy} = vector, grid, {x, y}) when x + vx * (@word_length - 1) > grid.max_x,
    do: count(vector, grid, {0, y + 1})

  # Recursive case: check for match and increment count
  def count(vector, grid, {x, y} = coords) do
    newCount = grid.count + match(grid, coords, vector)
    count(vector, %{grid | count: newCount}, {x + 1, y})
  end

  @spec solve(Grid.t()) :: integer()
  def solve(grid) do
    @vectors
    |> Enum.reduce(grid, fn {_dir, v}, g -> count(v, g) end)
    |> then(& &1.count)
  end
end
