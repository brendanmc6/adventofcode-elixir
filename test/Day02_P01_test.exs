defmodule Day02_P01.Test do
  use ExUnit.Case
  import Day02_P01

  test "parse" do
    assert parse("9 12 14 16 17 18 15\n") == [9, 12, 14, 16, 17, 18, 15]
  end

  test "diff" do
    assert diff(1, 2, :increment) == 1
    assert diff(2, 1, :decrement) == 1
    assert diff(1, 1, :increment) == 0
  end

  test "valid_diff" do
    assert valid_diff(1)
    assert valid_diff(2)
    assert valid_diff(3)
    refute valid_diff(4)
    refute valid_diff(0)
    refute valid_diff(-9)
  end

  test "compare_increment" do
    input1 = [1, 2, 3, 4, 5, 6]
    assert compare(input1, :increment) == 1

    input2 = [1, 4, 7, 10, 13, 16]
    assert compare(input2, :increment) == 1

    input3 = [1, 2, 3, 4, 4, 5]
    assert compare(input3, :increment) == 0

    input4 = [1, 2, 1, 3, 5, 6]
    assert compare(input4, :increment) == 0
  end

  test "compare_decrement" do
    input1 = [6, 5, 4, 3, 2, 1]
    assert compare(input1, :decrement) == 1

    input2 = [16, 13, 10, 9, 8, 7]
    assert compare(input2, :decrement) == 1

    input3 = [5, 4, 4, 3, 2, 1]
    assert compare(input3, :decrement) == 0

    input4 = [6, 5, 3, 1, 2, 1]
    assert compare(input4, :decrement) == 0
  end

  test "validate_report" do
    input1 = [6, 5, 4, 3, 2, 1]
    assert validate_report(input1) == 1

    input1 = [1, 2, 3, 4, 5, 6]
    assert validate_report(input1) == 1

    input3 = [5, 4, 4, 3, 2, 1]
    assert validate_report(input3) == 0

    input4 = [6, 5, 3, 1, 2, 1]
    assert validate_report(input4) == 0

    input5 = [1, 1, 3, 4, 5]
    assert validate_report(input5) == 0
  end
end
