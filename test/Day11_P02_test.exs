defmodule Day11_P02.Test do
  use ExUnit.Case
  import Day11_P02

  test "solve" do
    input = "125 17"
    intlist = parse([input])
    result = solve(intlist)
    assert result == 65_601_038_650_482
  end
end
