defmodule ErrorDuplicate do
  defexception message: "Duplicate visit_vector entry detected"
end

defmodule Day06_P02.Cell do
  defstruct coord: {0, 0}, can_visit: true, visit_vectors: []
  @type coord :: {integer(), integer()}
  @type vector :: {integer(), integer()}
  @type t :: %__MODULE__{coord: coord(), can_visit: boolean(), visit_vectors: [vector()]}
end

defmodule Day06_P02.Grid do
  alias Day06_P02.Cell

  def visit(grid, coord, vector) do
    if vector in grid[coord].visit_vectors do
      raise(ErrorDuplicate)
    else
      Map.update!(
        grid,
        coord,
        &%{&1 | visit_vectors: [vector | &1.visit_vectors]}
      )
    end
  end

  def obstruct(grid, coord) do
    Map.update!(
      grid,
      coord,
      &%{&1 | can_visit: false}
    )
  end

  def get(grid, coord), do: Map.get(grid, coord)

  def put(grid, coord, props \\ %Cell{}) do
    Map.put_new(grid, coord, %Cell{props | coord: coord})
  end
end

defmodule Day06_P02 do
  alias Day06_P02.Cell
  alias Day06_P02.Grid
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
  def visit_cell(vector, cell, next_cell, grid) when next_cell == nil do
    Grid.visit(grid, cell.coord, vector)
  end

  # rotate case
  def visit_cell(vector, cell, next_cell, grid) when next_cell.can_visit == false do
    new_vector = rotate(vector)
    alt_next_cell = Grid.get(grid, next_coord(new_vector, cell.coord))
    visit_cell(new_vector, cell, alt_next_cell, grid)
  end

  # walk case
  def visit_cell(vector, cell, next_cell, grid) when next_cell.can_visit == true do
    new_grid = Grid.visit(grid, cell.coord, vector)
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
          {here, Grid.put(grid, here)}

        "." ->
          {start, Grid.put(grid, here)}

        "#" ->
          {start, Grid.put(grid, here, %Cell{can_visit: false})}
      end
    end)
  end

  def extract_candidates(grid, start_coord) do
    grid
    |> Map.values()
    |> Enum.filter(fn cell ->
      length(cell.visit_vectors) > 0 and
        cell.coord != start_coord
    end)
    |> Enum.map(& &1.coord)
  end

  # returns true if an error was caught (duplicate visit_vector in Grid.visit)
  # otherwise returns false
  # simulates the entire guard walk
  def infinite_loop?(grid, start_coord) do
    start_cell = Grid.get(grid, start_coord)
    next_cell = Grid.get(grid, next_coord(@north, start_coord))

    try do
      visit_cell(@north, start_cell, next_cell, grid)
      false
    rescue
      _e in ErrorDuplicate -> true
    end
  end

  # returns a filter fn that returns true for valid candidate cells
  # we test by obstructing the cell and checking for an infinite loop
  def filter_candidate(grid, start_coord) do
    fn coord ->
      Grid.obstruct(grid, coord)
      |> infinite_loop?(start_coord)
    end
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
    walked_grid = visit_cell(@north, start_cell, next_cell, grid)

    candidates =
      walked_grid
      |> extract_candidates(start_coord)

    Enum.filter(candidates, filter_candidate(grid, start_coord))
    |> then(fn candidates -> length(candidates) end)
  end
end
