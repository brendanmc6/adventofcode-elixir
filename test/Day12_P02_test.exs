defmodule Day12_P02.Test do
  use ExUnit.Case
  import Day12_P02

  test "parse" do
    input = [
      "AABB",
      "CCDD"
    ]

    input_map = parse(input)

    output = %{
      {0, 0} => "A",
      {0, 1} => "C",
      {1, 0} => "A",
      {1, 1} => "C",
      {2, 0} => "B",
      {2, 1} => "D",
      {3, 0} => "B",
      {3, 1} => "D"
    }

    assert input_map == output
  end

  test "assign_all_coords" do
    input = [
      "AABB",
      "CCDD"
    ]

    input_map = parse(input)
    output_map = assign_all_coords(input_map)
    assert output_map[{0, 0}] == output_map[{1, 0}]
    assert output_map[{2, 0}] == output_map[{3, 0}]
    count = Map.values(output_map) |> Enum.uniq() |> length()
    assert count == 4
  end

  test "count_units" do
    input = [
      "AABB",
      "CCCC"
    ]

    input_map = parse(input)
    region_map = assign_all_coords(input_map)
    count_map = count_units(region_map)
    assert Map.values(count_map) == [{4, 2}, {4, 4}, {4, 2}]
  end

  test "solve" do
    input = [
      "RRRRIICCFF",
      "RRRRIICCCF",
      "VVRRRCCFFF",
      "VVRCCCJFFF",
      "VVVVCJJCFE",
      "VVIVCCJJEE",
      "VVIIICJJEE",
      "MIIIIIJJEE",
      "MIIISIJEEE",
      "MMMISSJEEE"
    ]

    result = input |> parse() |> solve()
    assert result == 1206
  end
end
