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

  test "count_south_east" do
    input1 = [
      "XX...",
      ".MM..",
      "..AA.",
      "...SS"
    ]

    grid = count({1, 1}, parse(input1), {0, 0})
    assert grid.count == 2
  end

  test "count_north_west" do
    input1 = [
      ".S...",
      ".SA..",
      "..AM.",
      "...MX",
      "....X"
    ]

    grid = count({-1, -1}, parse(input1), {0, 0})
    assert grid.count == 2
    assert grid.max_x == 4
    assert grid.max_y == 4
  end

  test "count_south" do
    input1 = [
      "XS...",
      "MSA.X",
      "A.AMM",
      "S..MA",
      "....S"
    ]

    grid = count({0, 1}, parse(input1), {0, 0})
    assert grid.count == 2
    assert grid.max_x == 4
    assert grid.max_y == 4
  end

  test "solve_all" do
    input1 = [
      "S..S..S",
      ".A.A.A.",
      "..MMM..",
      "SAMXMAS",
      "..MMM..",
      ".A.A.A.",
      "S..S..S"
    ]

    assert solve(parse(input1)) == 8

    # same but with M instead

    input2 = [
      "SMMSMMS",
      "MAMAMAM",
      "MMMMMMM",
      "SAMXMAS",
      "MMMMMMM",
      "MAMAMAM",
      "SMMSMMS"
    ]

    assert solve(parse(input2)) == 8
  end

  @tag :isolate
  test "solve_example" do
    input3 = [
      "....XXMAS.",
      ".SAMXMS...",
      "...S..A...",
      "..A.A.MS.X",
      "XMASAMX.MM",
      "X.....XA.A",
      "S.S.S.S.SS",
      ".A.A.A.A.A",
      "..M.M.M.MM",
      ".X.X.XMASX"
    ]

    assert solve(parse(input3)) == 18
  end
end
