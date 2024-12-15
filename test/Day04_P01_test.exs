defmodule Day04_P01.Test do
  use ExUnit.Case
  import Day04_P01

  test "parse" do
    rows_list = ["XMAS", "XMAS", "XMAS", "XMAS"]
    grid = parse(rows_list)
    assert grid.max_x == 3
    assert grid.max_y == 3
    assert Map.get(grid.map, {0, 0}) == "X"
    assert Map.get(grid.map, {3, 3}) == "S"
  end
end
