defmodule Day09_P01.Test do
  use ExUnit.Case
  import Day09_P01

  test "parse odd number" do
    input = [
      "12345"
    ]

    blocks = [{2, 5}, {1, 3}, {0, 1}]
    gaps = [{0, 2}, {1, 4}, {2, 0}]
    assert parse(input) == {gaps, blocks}
  end

  test "parse even number" do
    input = [
      "123456"
    ]

    blocks = [{2, 5}, {1, 3}, {0, 1}]
    gaps = [{0, 2}, {1, 4}, {2, 6}]
    assert parse(input) == {gaps, blocks}
  end

  test "parse example" do
    input = [
      "2333133121414131402"
    ]

    # 00...111...2...333.44.5555.6666.777.888899
    blocks = [{9, 2}, {8, 4}, {7, 3}, {6, 4}, {5, 4}, {4, 2}, {3, 3}, {2, 1}, {1, 3}, {0, 2}]
    gaps = [{0, 3}, {1, 3}, {2, 3}, {3, 1}, {4, 1}, {5, 1}, {6, 1}, {7, 1}, {8, 0}, {9, 0}]
    assert parse(input) == {gaps, blocks}
  end

  test "compact" do
    input = [
      "12345"
    ]

    {gaps, blocks} = parse(input)
    {remaining_blocks, filled_gaps} = compact(gaps, blocks, [])
    assert remaining_blocks == [{0, 1}, {1, 3}]
    assert filled_gaps == [{0, 2, 2}, {1, 2, 3}]
  end

  test "compact example" do
    input = [
      "2333133121414131402"
    ]

    {gaps, blocks} = parse(input)
    # 00...111...2...333.44.5555.6666.777.888899
    {remaining_blocks, filled_gaps} = compact(gaps, blocks, [])

    assert remaining_blocks == [
             {0, 2},
             {1, 3},
             {2, 1},
             {3, 3},
             {4, 2},
             {5, 4},
             {6, 1}
           ]

    # 0099811188827773336446555566..............
    assert filled_gaps == [
             {0, 9, 2},
             {0, 8, 1},
             {1, 8, 3},
             {2, 7, 3},
             {3, 6, 1},
             {4, 6, 1},
             {5, 6, 1}
           ]
  end

  test "zip" do
    input = [
      "2333133121414131402"
    ]

    {gaps, blocks} = parse(input)
    # 00...111...2...333.44.5555.6666.777.888899
    {remaining_blocks, filled_gaps} = compact(gaps, blocks, [])
    # 0099811188827773336446555566..............
    result = zip(remaining_blocks, filled_gaps)

    assert result == [
             {0, 2},
             {9, 2},
             {8, 1},
             {1, 3},
             {8, 3},
             {2, 1},
             {7, 3},
             {3, 3},
             {6, 1},
             {4, 2},
             {6, 1},
             {5, 4},
             {6, 1},
             {6, 1}
           ]
  end

  test "checksum example" do
    input = [
      "2333133121414131402"
    ]

    {gaps, blocks} = parse(input)
    # 00...111...2...333.44.5555.6666.777.888899
    {remaining_blocks, filled_gaps} = compact(gaps, blocks, [])
    # 0099811188827773336446555566..............
    results = zip(remaining_blocks, filled_gaps)
    val = checksum(results)
    assert val == 1928
  end

  test "solve example" do
    input = [
      "2333133121414131402"
    ]

    assert solve(parse(input)) == 1928
  end
end
