defmodule Day10_P02 do
  @behaviour Common.Solver

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  def parse(rowstrs) do
    coords =
      rowstrs
      |> Enum.with_index()
      |> Enum.flat_map(fn {strlist, y} ->
        strlist
        |> String.split("", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.with_index()
        |> Enum.map(fn {val, x} -> {{x, y}, val} end)
      end)

    trailheads = Enum.filter(coords, fn {_c, val} -> val == 0 end) |> Enum.map(&elem(&1, 0))

    {Map.new(coords), trailheads}
  end

  def next_coord(dir, {x, y}) do
    case dir do
      :north -> {x, y - 1}
      :east -> {x + 1, y}
      :south -> {x, y + 1}
      :west -> {x - 1, y}
    end
  end

  # boundary case, target coord not found
  def find_peaks(_prev, nil, _coord, _grid) do
    []
  end

  # not passable case
  def find_peaks(prev, height, _coord, _grid) when height - prev != 1 do
    []
  end

  # base case, peak found, return it's coord
  def find_peaks(_prev, height, coord, _grid) when height == 9 do
    [coord]
  end

  # recurse case, walk in all directions
  def find_peaks(_prev, height, coord, grid) do
    Enum.flat_map([:north, :south, :east, :west], fn dir ->
      next_coord = next_coord(dir, coord)

      find_peaks(
        height,
        Map.get(grid, next_coord, nil),
        next_coord,
        grid
      )
    end)
  end

  def solve({grid, trailheads}) do
    trailheads
    |> Enum.map(fn coord ->
      find_peaks(-1, 0, coord, grid)
    end)
    |> Enum.map(&length(&1))
    |> Enum.sum()
  end
end
