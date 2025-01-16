defmodule Day10_P02.Test do
  use ExUnit.Case
  import Day10_P02

  test "parse" do
    input = [
      "89010123",
      "78121874",
      "87430965",
      "96549874",
      "45678903",
      "32019012",
      "01329801",
      "10456732"
    ]

    {grid, trailheads} = parse(input)

    assert grid[{0, 0}] == 8
    assert grid[{7, 7}] == 2
    assert length(trailheads) == 9
  end

  test "solve" do
    input = [
      "89010123",
      "78121874",
      "87430965",
      "96549874",
      "45678903",
      "32019012",
      "01329801",
      "10456732"
    ]

    result = solve(parse(input))
    assert result == 81
  end
end
