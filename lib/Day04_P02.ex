defmodule Day04_P02 do
  @type rows_list :: [String.t()]
  @type puzzle_input :: Grid.t()
  @type coord :: {integer(), integer()}
  @type vector :: {integer(), integer()}

  @behaviour Common.Solver

  @word "MAS"
  @word_length String.length(@word)
  @vectors %{
    ne: {1, -1},
    se: {1, 1},
    sw: {-1, 1},
    nw: {-1, -1}
  }

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

  def match_word(grid, {x, y}, {vx, vy}) do
    0..(@word_length - 1)
    # Optimistically get the value at each coordinate, even if out of bounds
    |> Enum.map(fn i ->
      Map.get(grid.map, {x + vx * i, y + vy * i})
    end)
    |> Enum.join("")
    |> then(&if &1 == @word, do: 1, else: 0)
  end

  def invert_coord(c) do
    c + (@word_length - 1)
  end

  def get_opposite_coords({x, y}, {vx, vy}) do
    {{x + vx * (@word_length - 1), y}, {x, y + vy * (@word_length - 1)}}
  end

  def get_opposite_vectors({vx, vy}) do
    {{vx * -1, vy}, {vx, vy * -1}}
  end

  def match_x_mas(grid, coords, vector) do
    first_match = match_word(grid, coords, vector)
    {check_x, check_y} = get_opposite_coords(coords, vector)
    {vx, vy} = get_opposite_vectors(vector)
    # check the adjacent coords where a crossing "MAS" may originate
    x_match = match_word(grid, check_x, vx)
    y_match = match_word(grid, check_y, vy)
    if first_match + x_match + y_match == 2, do: 1, else: 0
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
    newCount = grid.count + match_x_mas(grid, coords, vector)
    count(vector, %{grid | count: newCount}, {x + 1, y})
  end

  @spec solve(Grid.t()) :: integer()
  def solve(grid) do
    count_sw = count(@vectors.se, grid).count
    count_nw = count(@vectors.nw, grid).count
    count_sw + count_nw
  end
end
