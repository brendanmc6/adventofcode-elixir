defmodule Day13_P02.Test do
  use ExUnit.Case
  import Day13_P02

  test "nonzero_determinant? true" do
    targets = {0, 0}

    assert nonzero_determinant?({{26, 66}, {67, 21}, targets}) === true
  end

  test "nonzero_determinant? false" do
    targets = {0, 0}

    assert nonzero_determinant?({{1, 1}, {10, 10}, targets}) === false
  end

  test "solve_presses" do
    targets = {10_000_000_012_748, 10_000_000_012_176}
    assert solve_presses({{26, 66}, {67, 21}, targets}) === {118_679_050_709.0, 103_199_174_542.0}
  end

  test "solve - example" do
    input = [
      {{94, 34}, {22, 67}, {8400, 5400}},
      {{26, 66}, {67, 21}, {12748, 12176}},
      {{17, 86}, {84, 37}, {7870, 6450}},
      {{69, 23}, {27, 71}, {18641, 10279}}
    ]

    assert solve(input) === 480
  end
end
