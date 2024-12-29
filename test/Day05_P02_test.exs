defmodule Day05_P02.Test do
  use ExUnit.Case
  import Day05_P02

  @pages [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9
  ]

  test "rule_violation?" do
    assert rule_violation?({0, 1}, 0, @pages) == false
    assert rule_violation?({0, 1}, 1, @pages) == false
    assert rule_violation?({1, 0}, 0, @pages) == true
    assert rule_violation?({1, 0}, 1, @pages) == true
    assert rule_violation?({0, 9}, 0, @pages) == false
    assert rule_violation?({0, 9}, 9, @pages) == false
    assert rule_violation?({9, 0}, 0, @pages) == true
    assert rule_violation?({9, 0}, 9, @pages) == true
  end

  test "fix_violation" do
    # assumes violations need fixing
    assert fix_violation({9, 0}, 9, @pages) == {[1, 2, 3, 4, 5, 6, 7, 8, 9, 0], 0}
    assert fix_violation({9, 8}, 8, @pages) == {[0, 1, 2, 3, 4, 5, 6, 7, 9, 8], 9}
  end

  test "repair_list_at_page | Simple" do
    rules_map = %{
      0 => [{0, 1}],
      1 => [{0, 1}, {1, 2}],
      2 => [{1, 2}]
    }

    # happy path, no invalid rules
    assert repair_list_at_page(0, @pages, rules_map) == @pages
  end

  test "repair_list_at_page | Recursive" do
    # fixing 9,0 breaks 0,1
    rules_map = %{
      0 => [{9, 0}, {0, 1}],
      1 => [{0, 1}],
      2 => [{2, 3}],
      3 => [{2, 3}, {3, 4}],
      4 => [{3, 4}, {4, 5}],
      5 => [{4, 5}, {5, 6}],
      6 => [{5, 6}, {6, 7}],
      7 => [{6, 7}, {7, 8}],
      8 => [{7, 8}, {8, 9}],
      9 => [{8, 9}, {9, 0}]
    }

    # happy path, no invalid rules
    assert repair_list_at_page(0, @pages, rules_map) == [2, 3, 4, 5, 6, 7, 8, 9, 0, 1]
  end

  test "repair_pages_list | Recursive" do
    # [2,3,4,5,6,7,8,0,1]
    rules_map = %{
      0 => [{8, 0}, {0, 1}],
      1 => [{0, 1}],
      2 => [{2, 3}],
      3 => [{2, 3}, {3, 4}],
      4 => [{3, 4}, {4, 5}],
      5 => [{4, 5}, {5, 6}],
      6 => [{5, 6}, {6, 7}],
      7 => [{6, 7}, {7, 8}],
      8 => [{8, 0}]
    }

    assert repair_pages_list([0, 1, 2, 3, 4, 5, 6, 7, 8], rules_map) == 6
  end

  test "solve" do
    pages_list = [
      [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8
      ],
      [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8
      ]
    ]

    # [2,3,4,5,6,7,8,0,1]
    rules_map = %{
      0 => [{8, 0}, {0, 1}],
      1 => [{0, 1}],
      2 => [{2, 3}],
      3 => [{2, 3}, {3, 4}],
      4 => [{3, 4}, {4, 5}],
      5 => [{4, 5}, {5, 6}],
      6 => [{5, 6}, {6, 7}],
      7 => [{6, 7}, {7, 8}],
      8 => [{8, 0}]
    }

    assert solve({rules_map, pages_list}) == 12
  end
end
