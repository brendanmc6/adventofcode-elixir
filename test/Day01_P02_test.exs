defmodule Day01_P02.Test do
  use ExUnit.Case
  import Day01_P02

  test "parse" do
    assert parse("123   456\n") == {123, 456}

    parsedList = Enum.map(["123   123\n", "456   456\n"], &parse/1)
    assert parsedList == [{123, 123}, {456, 456}]
  end

  test "assign_count_map" do
    assert assign_count_map({1, 2}, %{}) == %{1 => {1, 0}, 2 => {0, 1}}
    assert assign_count_map({1, 2}, %{1 => {1, 0}, 2 => {0, 1}}) == %{1 => {2, 0}, 2 => {0, 2}}

    assert Enum.reduce([{1, 1}, {2, 2}, {3, 3}, {1, 1}], %{}, &assign_count_map/2) == %{
             1 => {2, 2},
             2 => {1, 1},
             3 => {1, 1}
           }
  end

  test "sum_multiply_count" do
    assert sum_multiply_count({1, {1, 1}}, 0) == 1
    assert Enum.reduce(%{3 => {3, 3}, 4 => {1, 1}, 2 => {1, 0}}, 0, &sum_multiply_count/2) == 31
  end
end
