defmodule Day01_P01.Test do
  use ExUnit.Case
  import Day01_P01

  test "parse" do
    assert parse("123   456\n") == {123, 456}

    parsedList = Enum.map(["123   123\n", "456   456\n"], &parse/1)
    assert parsedList == [{123, 123}, {456, 456}]
  end

  test "assign_to_lists" do
    assert assign_to_lists({111, 222}, {[], []}) == {[111], [222]}
    assert assign_to_lists({111, 222}, {[111], [222]}) == {[111, 111], [222, 222]}

    assert Enum.reduce([{111, 222}, {111, 222}], {[], []}, &assign_to_lists/2) ==
             {[111, 111], [222, 222]}
  end

  test "sort_lists" do
    assert sort_lists({[99, 88, 77], [33, 22, 11]}) == {[77, 88, 99], [11, 22, 33]}
  end

  test "add_distance" do
    assert add_distance([1, 2], 0) == 1
    assert add_distance([99, 100], 99) == 100
  end

  test "solve" do
    assert solve([{1, 1}, {2, 2}, {3, 3}]) == 0
    assert solve([{1, 1}, {2, 2}, {3, 4}]) == 1
    assert solve([{1, 2}, {2, 3}, {3, 4}]) == 3
  end
end
