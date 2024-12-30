defmodule Day06_P01.Test do
  use ExUnit.Case
  import Day06_P01

  test "solve 3" do
    input = ["...#", "....", "....", "...^"]
    {start, grid} = parse(input)
    assert solve({start, grid}) == 3
  end
end
