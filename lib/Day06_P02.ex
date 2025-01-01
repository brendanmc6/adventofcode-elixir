defmodule ErrorDuplicate do
  defexception message: "Duplicate visit_vector entry detected"
end

defmodule Day06_P02.Grid do
  def visit(grid, coord, v) do
    Map.update(grid, coord, [v], fn list ->
      if Enum.member?(list, v) do
        raise(ErrorDuplicate)
      else
        [v | list]
      end
    end)
  end

  def obstruct(grid, coord) do
    Map.put(grid, coord, false)
  end
end

defmodule Day06_P02 do
  alias Day06_P02.Grid
  @behaviour Common.Solver

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
  def visit_cell(vector, coord, nil, _grid, history) do
    Grid.visit(history, coord, vector)
  end

  # rotate case
  def visit_cell(vector, coord, unobstructed?, grid, history) when not unobstructed? do
    new_vector = rotate(vector)
    alt_next_cell = Map.get(grid, next_coord(new_vector, coord))
    visit_cell(new_vector, coord, alt_next_cell, grid, history)
  end

  # walk case
  def visit_cell(vector, coord, unobstructed?, grid, history) when unobstructed? do
    new_history = Grid.visit(history, coord, vector)
    next_cell_coord = next_coord(vector, coord)
    next_next_cell_coord = next_coord(vector, next_cell_coord)
    next_next_cell = Map.get(grid, next_next_cell_coord)
    visit_cell(vector, next_cell_coord, next_next_cell, grid, new_history)
  end

  def reduce_row({rowstring, y}, {start_coord, grid}) do
    String.split(rowstring, "", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({start_coord, grid}, fn {cell, x}, {start, grid} ->
      here = {x, y}

      case cell do
        # Marks the starting position
        "^" ->
          {here, Map.put_new(grid, here, true)}

        "." ->
          {start, Map.put_new(grid, here, true)}

        "#" ->
          {start, Map.put_new(grid, here, false)}
      end
    end)
  end

  # returns true if an error was caught (duplicate visit_vector in Grid.visit)
  # otherwise returns false
  # simulates the entire guard walk
  def infinite_loop?(grid, start_coord) do
    try do
      visit_cell(:n, start_coord, Map.get(grid, next_coord(:n, start_coord)), grid, %{})
      false
    rescue
      _e in ErrorDuplicate -> true
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
    next_cell = Map.get(grid, next_coord(:n, start_coord))

    visit_cell(:n, start_coord, next_cell, grid, %{})
    |> Map.delete(start_coord)
    |> Map.keys()
    |> Enum.filter(fn coord ->
      Grid.obstruct(grid, coord)
      # TODO optimize by recording the vector of obstruction and pathing from there?
      |> infinite_loop?(start_coord)
    end)
    |> then(fn list -> length(list) end)
  end
end
