defmodule Day08_P01.Test do
  use ExUnit.Case
  import Day08_P01

  @example_input [
    "............",
    "........0...",
    ".....0......",
    ".......0....",
    "....0.......",
    "......A.....",
    "............",
    "............",
    "........A...",
    ".........A..",
    "............",
    "............"
  ]

  test "parse" do
    output = %{"0" => [{4, 4}, {7, 3}, {5, 2}, {8, 1}], "A" => [{9, 9}, {8, 8}, {6, 5}]}
    boundary = {11, 11}
    assert parse(@example_input) == {output, boundary}
  end

  test "to_antennae_pairs" do
    antennae = %{
      "A" => [{"a", "a"}, {"b", "b"}],
      "B" => [{"c", "c"}, {"d", "d"}]
    }

    pair1 = {{"a", "a"}, {"b", "b"}}
    pair2 = {{"c", "c"}, {"d", "d"}}

    output = [pair1, pair2]
    pairs = to_antennae_pairs(antennae)

    assert pairs == output
  end

  test "to_antennae_pairs - single loc" do
    antennae = %{
      "A" => [{"a", "a"}],
      "B" => [{"c", "c"}, {"d", "d"}]
    }

    pair2 = {{"c", "c"}, {"d", "d"}}

    output = [pair2]
    pairs = to_antennae_pairs(antennae)

    assert pairs == output
  end

  test "to_antennae_pairs - many pairs" do
    antennae = %{
      "A" => [{"a", "a"}, {"b", "b"}, {"c", "c"}, {"d", "d"}]
    }

    output = [
      {{"c", "c"}, {"d", "d"}},
      {{"b", "b"}, {"d", "d"}},
      {{"b", "b"}, {"c", "c"}},
      {{"a", "a"}, {"d", "d"}},
      {{"a", "a"}, {"c", "c"}},
      {{"a", "a"}, {"b", "b"}}
    ]

    pairs = to_antennae_pairs(antennae)

    assert pairs == output
  end

  test "to_antinodes" do
    pairs = [{{4, 3}, {5, 5}}, {{0, 0}, {1, 2}}]
    result = [{-1, -2}, {2, 4}, {3, 1}, {6, 7}]
    assert MapSet.size(to_antinodes(pairs)) == 4
    assert to_antinodes(pairs) == MapSet.new(result)
  end

  test "solve" do
    assert solve(parse(@example_input)) == 14
  end
end
