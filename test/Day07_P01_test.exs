defmodule Day07_P01.Test do
  use ExUnit.Case
  import Day07_P01

  test "parse" do
    rowstr = "432832280199: 3 286 4 3 17 682 7 7 9 2"
    out = {432_832_280_199, [3, 286, 4, 3, 17, 682, 7, 7, 9, 2]}
    res = parse([rowstr, rowstr])
    assert res == [out, out]
  end

  test "solvable?" do
    assert solvable?(11, [6, 16, 20], &Kernel.+/2, 292) == true
    assert solvable?(11, [6, 16, 20], &Kernel.*/2, 292) == false
    assert solvable?(11, [6, 16, 20], &Kernel.+/2, 293) == false
    assert solvable?(10, [19], &Kernel.*/2, 190) == true
    assert solvable?(81, [40, 27], &Kernel.*/2, 3267) == true
    assert solvable?(81, [40, 27], &Kernel.+/2, 3267) == true
  end

  test "solve" do
    inputs = [
      "190: 10 19",
      "3267: 81 40 27",
      "83: 17 5",
      "156: 15 6",
      "7290: 6 8 6 15",
      "161011: 16 10 13",
      "192: 17 8 14",
      "21037: 9 7 18 13",
      "292: 11 6 16 20"
    ]

    assert solve(parse(inputs)) == 3749
  end
end
