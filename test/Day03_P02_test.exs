defmodule Day03_P02.Test do
  use ExUnit.Case
  import Day03_P02

  test "parse" do
    input1 = "mul(427,266)#mul(287,390)mul(398,319)#!$>don't()mul(613,600)from()@!\n"

    result1 = [
      "",
      "427,266)#",
      "287,390)",
      "398,319)#!$>"
    ]

    assert parse(input1) ==
             result1

    input2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

    result2 = [
      "x",
      "2,4)&mul[3,7]!^?",
      "8,5))"
    ]

    assert parse(input2) == result2
  end

  test "solve" do
    input1 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    assert solve([parse(input1)]) == 48

    assert solve([parse(input1), parse(input1)]) == 96
  end

  test "solve edge cases" do
    # starting with a don't
    input1 = "don't()xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    assert solve([parse(input1)]) == 40
    assert solve([parse(input1), parse(input1)]) == 80
    # starting with a do
    input2 = "do()xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
    assert solve([parse(input2)]) == 48
    assert solve([parse(input2), parse(input2)]) == 96
    # successive
    input3 =
      "do()don't()do()xmul(2,4)&mul[3,7]!^don't()do()don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

    assert solve([parse(input3)]) == 48
    assert solve([parse(input3), parse(input3)]) == 96

    # compact
    input4 =
      "mul(1,1)mul()mul()don't()mul(1,1)mul(1,1)do()mul(1,1)mul(1,1)\n"

    assert solve([parse(input4)]) == 3
    assert solve([parse(input4), parse(input4)]) == 6
  end
end
