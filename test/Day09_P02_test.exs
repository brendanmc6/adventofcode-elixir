defmodule Day09_P02.Test do
  use ExUnit.Case
  import Day09_P02

  test "parse odd number" do
    input = [
      "12345"
    ]

    # 0..111....22222
    assert parse(input) == [
             %{id: 2, gap: 0, size: 5, used: 5},
             %{id: 1, size: 7, used: 3, gap: 4},
             %{id: 0, size: 3, used: 1, gap: 2}
           ]
  end

  test "parse even number" do
    input = [
      "123456"
    ]

    # 0..111....22222......
    assert parse(input) ==
             [
               %{gap: 6, id: 2, size: 11, used: 5},
               %{gap: 4, id: 1, size: 7, used: 3},
               %{gap: 2, id: 0, size: 3, used: 1}
             ]
  end

  test "find_leftmost_fit 1" do
    # 0.1..2.3.
    gaps = [{1, 0}, {2, 1}, {1, 2}, {1, 3}]
    block = %{id: 3, gap: 1, size: 2, used: 1}
    ops = %{}
    result = find_leftmost_fit(gaps, block, ops)
    assert result == 0
  end

  test "find_leftmost_fit nil" do
    # 0.1..2.333.
    gaps = [{1, 0}, {2, 1}, {1, 2}, {1, 3}]
    block = %{id: 3, gap: 1, size: 4, used: 3}
    ops = %{}
    result = find_leftmost_fit(gaps, block, ops)
    assert result == nil
  end

  test "find_leftmost_fit ops" do
    # 0.1..2.3.
    gaps = [{1, 0}, {2, 1}, {1, 2}, {1, 3}]
    block = %{id: 2, gap: 1, size: 2, used: 1}
    ops = %{0 => [{1, 3}]}
    result = find_leftmost_fit(gaps, block, ops)
    assert result == 1
  end

  test "get_ops" do
    blocks =
      parse([
        "2333133121414131402"
      ])

    assert get_ops(blocks) == %{0 => [{1, 2}, {2, 9}], 1 => [{3, 7}], 2 => [{2, 4}]}
  end

  test "ops_to_deletions" do
    blocks =
      parse([
        "2333133121414131402"
      ])

    ops = get_ops(blocks)
    {_, deletions} = ops_to_deletions(ops)
    assert deletions == %MapSet{map: %{2 => [], 4 => [], 7 => [], 9 => []}}
  end

  test "zip" do
    blocks =
      parse([
        "2333133121414131402"
      ])

    ops = get_ops(blocks)
    {_, deletions} = ops_to_deletions(ops)

    assert zip(blocks, ops, deletions) == [
             %{id: 8, used: 4, gap: 2},
             %{id: 6, used: 4, gap: 5},
             %{id: 5, used: 4, gap: 1},
             %{id: 3, used: 3, gap: 4},
             %{id: 4, used: 2, gap: 1},
             %{id: 7, used: 3, gap: 1},
             %{id: 1, used: 3, gap: 0},
             %{id: 2, used: 1, gap: 0},
             %{id: 9, used: 2, gap: 0},
             %{id: 0, used: 2, gap: 0}
           ]
  end

  test "solve" do
    assert solve(parse(["2333133121414131402"])) == 2858
  end
end
