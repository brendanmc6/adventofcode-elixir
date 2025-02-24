defmodule Day13_P01.Test do
  use ExUnit.Case
  import Day13_P01

  test "calc_current" do
    counts1 = {1, 1}
    values1 = {10, 10, 100}
    assert calc_current(counts1, values1) === 20
    counts1 = {2, 2}
    values1 = {10, 10, 100}
    assert calc_current(counts1, values1) === 40
  end

  test "compare" do
    value = 100
    target = 100
    assert compare(value, target) === :eq
    assert compare(value + 1, target) === :gt
    assert compare(value - 1, target) === :lt
  end

  test "find_all_solutions - b equals target" do
    counts = {0, 1}
    values = {3, 4, 4}
    expected = [{0, 1}]
    assert find_all_solutions(counts, values, []) === expected
  end

  test "find_all_solutions - two solutions" do
    counts = {0, 1}
    values = {1, 4, 4}
    expected = [{4, 0}, {0, 1}]
    assert find_all_solutions(counts, values, []) === expected
  end

  test "find_all_solutions - b is 1 short" do
    counts = {0, 0}
    values = {50, 99, 100}
    expected = [{2, 0}]
    assert find_all_solutions(counts, values, []) === expected
  end

  test "find_all_solutions - b is 1 extra" do
    counts = {0, 1}
    values = {50, 101, 100}
    expected = [{2, 0}]
    assert find_all_solutions(counts, values, []) === expected
  end

  test "find_all_solutions - a > target" do
    counts = {0, 2}
    values = {101, 50, 100}
    expected = [{0, 2}]
    assert find_all_solutions(counts, values, []) === expected
  end

  test "find_all_solutions - example" do
    # Button A: X+94, Y+34
    # Button B: X+22, Y+67
    # Prize: X=8400, Y=5400
    counts = {0, 381}
    values = {94, 22, 8400}

    assert List.first(find_all_solutions(counts, values, [])) === {80, 40}
  end

  test "with_x_solutions - example" do
    # Button A: X+94, Y+34
    # Button B: X+22, Y+67
    # Prize: X=8400, Y=5400
    claw_machine = {{94, 34}, {22, 67}, {8400, 5400}}
    {_, solutions} = with_x_solutions(claw_machine)
    assert List.first(solutions) === {80, 40}
  end

  test "find_y_solution - example" do
    # Button A: X+94, Y+34
    # Button B: X+22, Y+67
    # Prize: X=8400, Y=5400
    claw_machine = {{94, 34}, {22, 67}, {8400, 5400}}

    solutions =
      with_x_solutions(claw_machine)
      |> find_y_solution()

    assert solutions === {80, 40}
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
