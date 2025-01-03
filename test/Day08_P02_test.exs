defmodule Day08_P02.Test do
  use ExUnit.Case
  import Day08_P02

  @example_input [
    "............",
    "........0...",
    ".....0......",
    ".......0....",
    "....0.......",
    "......A.....",
    "............",
    "............",
    "........A...",
    ".........A..",
    "............",
    "............"
  ]

  test "solve" do
    assert solve(parse(@example_input)) == 34
  end
end
