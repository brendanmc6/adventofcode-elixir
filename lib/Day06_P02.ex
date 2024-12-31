defmodule ErrorDuplicate do
  defexception message: "Duplicate visit_vector entry detected"
end

defmodule Day06_P02.Cell do
  defstruct coord: {0, 0}, can_visit: true, visit_vectors: MapSet.new()
  @type coord :: {integer(), integer()}
  @type vectorat :: atom()
  @type t :: %__MODULE__{
          coord: coord(),
          can_visit: boolean(),
          visit_vectors: MapSet.t([vectorat()])
        }
end

defmodule Day06_P02.Grid do
  alias Day06_P02.Cell

  def visit(grid, coord, vector) do
    Map.update!(grid, coord, fn cell ->
      vectors = cell.visit_vectors

      if MapSet.member?(vectors, vector) do
        raise(ErrorDuplicate)
      else
        %Cell{cell | visit_vectors: MapSet.put(vectors, vector)}
      end
    end)
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

  @rotations %{
    :n => :e,
    :e => :s,
    :s => :w,
    :w => :n
  }

  @vectors %{
    :n => {0, -1},
    :e => {1, 0},
    :s => {0, 1},
    :w => {-1, 0}
  }

  def rotate(vector), do: @rotations[vector]

  def next_coord(vectorat, {x, y}) do
    {vx, vy} = @vectors[vectorat]
    {x + vx, y + vy}
  end

  # base case, edge reached, end
  def visit_cell(vector, coord, nil, grid) do
    Grid.visit(grid, coord, vector)
  end

  # rotate case
  def visit_cell(vector, coord, next_cell, grid) when not next_cell.can_visit do
    new_vector = rotate(vector)
    alt_next_cell = Grid.get(grid, next_coord(new_vector, coord))
    visit_cell(new_vector, coord, alt_next_cell, grid)
  end

  # walk case
  def visit_cell(vector, coord, next_cell, grid) when next_cell.can_visit do
    new_grid = Grid.visit(grid, coord, vector)
    next_next_cell = Grid.get(new_grid, next_coord(vector, next_cell.coord))
    visit_cell(vector, next_cell.coord, next_next_cell, new_grid)
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

  # Base case, edge found
  @doc """
    This is used to check the vector recursively until either the edge or an obstruction is found.
  """
  def will_obstruct(_vector, nil, _grid), do: false

  # Base case, obstruction found
  def will_obstruct(_vector, cell, _grid) when not cell.can_visit, do: true

  # Recurse walk case, if the cell is unobstructed, check the next one in the same vector
  def will_obstruct(vector, cell, grid) when cell.can_visit do
    next_cell = Grid.get(grid, next_coord(vector, cell.coord))
    will_obstruct(vector, next_cell, grid)
  end

  def extract_candidates(walked_grid, start_coord) do
    walked_grid
    |> Map.values()
    |> Enum.filter(fn cell ->
      MapSet.size(cell.visit_vectors) > 0 and
        cell.coord != start_coord
    end)
    |> Enum.filter(fn cell ->
      # Since we know the vector, we can check for a common case where an obstruction would simply send the guard off the map
      # Only do this for cells with a single visit
      if MapSet.size(cell.visit_vectors) == 1 do
        vector = Enum.at(cell.visit_vectors, 0)
        # Assume visited cell is obstructed, so guard will rotate at the preceeding cell
        # to find the preceeding cell, invert the vector (rotate twice)
        inverted_vector = vector |> rotate() |> rotate()
        preceeding_coord = next_coord(inverted_vector, cell.coord)
        preceeding_cell = Grid.get(walked_grid, preceeding_coord)
        will_obstruct(rotate(vector), preceeding_cell, walked_grid)
      else
        true
      end
    end)
    |> Enum.map(& &1.coord)
  end

  # returns true if an error was caught (duplicate visit_vector in Grid.visit)
  # otherwise returns false
  # simulates the entire guard walk
  def infinite_loop?(grid, start_coord) do
    try do
      visit_cell(:n, start_coord, Grid.get(grid, next_coord(:n, start_coord)), grid)
      false
    rescue
      _e in ErrorDuplicate -> true
    end
  end

  # returns a filter fn that returns true for valid candidate cells
  # we test by obstructing the cell and checking for an infinite loop

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
    next_cell = Grid.get(grid, next_coord(:n, start_coord))

    walked_grid = visit_cell(:n, start_coord, next_cell, grid)

    extract_candidates(walked_grid, start_coord)
    |> Enum.map(fn coord ->
      valid =
        Grid.obstruct(grid, coord)
        |> infinite_loop?(start_coord)

      if valid, do: coord, else: nil
    end)
    |> Enum.reduce([], fn val, acc ->
      if val, do: [val | acc], else: acc
    end)
    |> then(fn list -> length(list) end)
  end
end
