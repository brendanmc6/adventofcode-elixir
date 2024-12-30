defmodule Day06_P01.Cell do
  defstruct coord: {0, 0}, can_visit: true, visited: 0
  @type coord :: {integer(), integer()}
  @type t :: %__MODULE__{coord: coord(), can_visit: boolean(), visited: integer()}
end

defmodule Day06_P01.Grid do
  def visit(grid, coord) do
    Map.update!(grid, coord, fn cell -> %{cell | visited: 1} end)
  end

  def get(grid, coord) do
    Map.get(grid, coord)
  end
end

defmodule Day06_P01 do
  alias Day06_P01.Grid
  alias Day06_P01.Cell
  @behaviour Common.Solver

  @type vector :: {integer(), integer()}
  @type grid :: %{required(Cell.coord()) => Cell.t()}

  @north {0, -1}
  @east {1, 0}
  @south {0, 1}
  @west {-1, 0}

  @rotations %{
    @north => @east,
    @east => @south,
    @south => @west,
    @west => @north
  }

  def rotate(vector), do: @rotations[vector]

  def next_coord({vx, vy}, {x, y}), do: {x + vx, y + vy}

  # base case, edge reached, end
  def visit_cell(_vector, cell, next_cell, grid) when next_cell == nil do
    Grid.visit(grid, cell.coord)
  end

  # rotate case
  def visit_cell(vector, cell, next_cell, grid) when next_cell.can_visit == false do
    new_vector = rotate(vector)
    alt_next_cell = Grid.get(grid, next_coord(new_vector, cell.coord))
    visit_cell(new_vector, cell, alt_next_cell, grid)
  end

  # walk case
  def visit_cell(vector, cell, next_cell, grid) when next_cell.can_visit == true do
    new_grid = Grid.visit(grid, cell.coord)
    next_next_cell = Grid.get(new_grid, next_coord(vector, next_cell.coord))
    visit_cell(vector, next_cell, next_next_cell, new_grid)
  end

  def reduce_row({rowstring, y}, {start_coord, grid}) do
    String.split(rowstring, "", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({start_coord, grid}, fn {cell, x}, {start, grid} ->
      here = {x, y}

      case cell do
        # Marks the starting position
        "^" ->
          value = %Cell{coord: here, visited: 1}
          {here, Map.put_new(grid, here, value)}

        "." ->
          value = %Cell{coord: here}
          {start, Map.put_new(grid, here, value)}

        "#" ->
          value = %Cell{coord: here, can_visit: false}
          {start, Map.put_new(grid, here, value)}
      end
    end)
  end

  @doc """
  Reads the input.txt into a list of strings (list of rows)
  """
  @spec read(String.t()) :: [binary()]
  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  def parse(rows) do
    # starting coord, empty grid
    init = {{0, 0}, %{}}

    rows
    |> Enum.with_index()
    |> Enum.reduce(init, &reduce_row/2)
  end

  def solve({start_coord, grid}) do
    start_cell = Grid.get(grid, start_coord)
    next_cell = Grid.get(grid, next_coord(@north, start_coord))
    # I already know the start and next cell is walkable, and the vector is north
    visit_cell(@north, start_cell, next_cell, grid)
    |> Map.values()
    |> Enum.map(& &1.visited)
    |> Enum.sum()
  end
end
