defmodule Day14_P01 do
  @behaviour Common.Solver

  @seconds 100
  @width_x 101
  @height_y 103

  @mid_x div(@width_x - 1, 2)
  @mid_y div(@height_y - 1, 2)

  def to_int_tuple(pair_str) do
    pair_str
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def calc_pos(start, velocity, board_size, sec) do
    total_distance = sec * velocity
    pos = rem(start + total_distance, board_size)
    # normalize the negative remainder by looping it back around
    if pos < 0, do: pos + board_size, else: pos
  end

  def zoom_robot({{px, py}, {vx, vy}}) do
    x = calc_pos(px, vx, @width_x, @seconds)
    y = calc_pos(py, vy, @height_y, @seconds)
    {x, y}
  end

  def reduce_quadrant({x, y}, acc) when x == @mid_x or y == @mid_y, do: acc

  def reduce_quadrant({x, y}, {a, b, c, d}) when x < @mid_x and y < @mid_y, do: {a + 1, b, c, d}

  def reduce_quadrant({x, y}, {a, b, c, d}) when x > @mid_x and y < @mid_y, do: {a, b + 1, c, d}

  def reduce_quadrant({x, y}, {a, b, c, d}) when x < @mid_x and y > @mid_y, do: {a, b, c + 1, d}

  def reduce_quadrant({x, y}, {a, b, c, d}) when x > @mid_x and y > @mid_y, do: {a, b, c, d + 1}

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  def parse(rowstrs) do
    rowstrs
    |> Enum.map(&String.replace(&1, "p=", ""))
    |> Enum.map(&String.replace(&1, "v=", ""))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [pstr, vstr] ->
      {to_int_tuple(pstr), to_int_tuple(vstr)}
    end)
  end

  def solve(puzzles) do
    puzzles
    |> Enum.map(&zoom_robot/1)
    |> Enum.reduce({0, 0, 0, 0}, &reduce_quadrant/2)
    |> Tuple.product()
  end
end
