defmodule Day07_P01.Test do
  use ExUnit.Case
  import Day07_P01

  test "parse" do
    rowstr = "432832280199: 3 286 4 3 17 682 7 7 9 2"
    out = {432_832_280_199, {3, 286, 4, 3, 17, 682, 7, 7, 9, 2}}
    res = parse([rowstr, rowstr])
    assert res == [out, out]
  end

  test "solvable?" do
    list1 = {11, 6, 16, 20}
    list2 = {81, 40, 27}
    assert solvable?(292, elem(list1, 0) + elem(list1, 1), 1, false, list1) == true
    assert solvable?(292, elem(list1, 0) * elem(list1, 1), 1, false, list1) == false
    assert solvable?(3267, elem(list2, 0) + elem(list2, 1), 1, false, list2) == true
    assert solvable?(3267, elem(list2, 0) + elem(list2, 1), 1, false, list2) == true
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
