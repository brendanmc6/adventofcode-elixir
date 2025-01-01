defmodule Day06_P02.Test do
  use ExUnit.Case
  import Day06_P02

  test "solve 1 loop" do
    input = [
      ".#...",
      "....#",
      ".....",
      ".^.#."
    ]

    assert solve(parse(input)) == 1
  end
end
