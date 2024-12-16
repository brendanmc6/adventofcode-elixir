defmodule Day04_P02.Test do
  use ExUnit.Case
  import Day04_P02

  test "match_x_mas" do
    input = [
      "M.M",
      ".A.",
      "S.S"
    ]

    grid = parse(input)
    assert match_x_mas(grid, {0, 0}, {1, 1}) == 1
    assert match_x_mas(grid, {2, 2}, {-1, -1}) == 0
  end

  test "solve" do
    input = [
      ".M.S......",
      "..A..MSMS.",
      ".M.S.MAA..",
      "..A.ASMSM.",
      ".M.S.M....",
      "..........",
      "S.S.S.S.S.",
      ".A.A.A.A..",
      "M.M.M.M.M.",
      ".........."
    ]

    assert solve(parse(input)) == 9
  end
end
