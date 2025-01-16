defmodule Day11_P01.Test do
  use ExUnit.Case
  import Day11_P01

  test "blink_times 1" do
    input = "0 1 10 99 999"
    expected = "1 2024 1 0 9 9 2021976"
    intlist = parse([input])
    res = blink_times(intlist, 1)
    assert Enum.join(res, " ") == expected
  end

  test "blink_times 6" do
    input = "125 17"
    expected = "2097446912 14168 4048 2 0 2 4 40 48 2024 40 48 80 96 2 8 6 7 6 0 3 2"
    intlist = parse([input])
    res = blink_times(intlist, 6)
    assert Enum.join(res, " ") == expected
  end

  test "solve" do
    input = "125 17"
    intlist = parse([input])
    result = solve(intlist)
    assert result == 55312
  end
end
