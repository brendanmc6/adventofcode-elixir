defmodule Day14_P02.Test do
  use ExUnit.Case
  import Day14_P02

  test "parse" do
    assert parse(["p=2,4 v=2,-3"]) == [{{2, 4}, {2, -3}}]
  end

  test "calc_position" do
    steps = 5
    board_width = 11
    board_height = 7
    start_x = 2
    start_y = 4
    vel_x = 2
    vel_y = -3
    assert calc_position(start_x, vel_x, board_width, steps) === 1
    assert calc_position(start_y, vel_y, board_height, steps) === 3
  end

  test "to_int_tuple" do
    assert to_int_tuple("2,4") == {2, 4}
    assert to_int_tuple("-3,5") == {-3, 5}
    assert to_int_tuple("0,0") == {0, 0}
  end

  test "positions_to_map" do
    positions = [
      {1, 3},
      {2, 3},
      {5, 7},
      {6, 7}
    ]

    result = positions_to_map(positions)

    # Check that the map has entries for all y values in the range
    assert map_size(result) == 103

    # Check specific entries
    assert result[3] == [2, 1]
    assert result[7] == [6, 5]

    # Check that other y values have empty lists
    assert result[0] == []
    assert result[1] == []
  end

  test "count_consec" do
    # First iteration
    assert count_consec(2, 1) == {2, 2}
    assert count_consec(3, 1) == {3, 1}

    # Subsequent iterations
    assert count_consec(3, {2, 1}) == {3, 2}
    assert count_consec(5, {3, 2}) == {5, 1}

    # Test when count reaches adjacency threshold
    assert count_consec(8, {7, 7}) == {7, 7}
  end

  test "consec_ints?" do
    # Not enough consecutive integers
    assert consec_ints?([1, 2, 3, 4, 6, 7, 8]) == false

    # Enough consecutive integers
    assert consec_ints?([1, 2, 3, 4, 5, 6, 7, 8]) == true
  end

  test "x_adjacency?" do
    # Not enough adjacent positions
    positions = [
      {1, 3},
      {2, 3},
      {3, 3},
      {5, 3},
      {6, 3},
      {7, 3}
    ]

    assert x_adjacency?(positions) == false

    # Enough adjacent positions
    positions = [
      {1, 3},
      {2, 3},
      {3, 3},
      {4, 3},
      {5, 3},
      {6, 3},
      {7, 3},
      {8, 3}
    ]

    assert x_adjacency?(positions) == true
  end

  test "recursive_search" do
    # Create a simple test case where we know the solution
    # Using a pattern that will form adjacent positions quickly
    robots = [
      # Robot moving right
      {{0, 0}, {1, 0}},
      # Robot moving right
      {{1, 0}, {1, 0}},
      # Robot moving right
      {{2, 0}, {1, 0}},
      # Robot moving right
      {{3, 0}, {1, 0}},
      # Robot moving right
      {{4, 0}, {1, 0}},
      # Robot moving right
      {{5, 0}, {1, 0}},
      # Robot moving right
      {{6, 0}, {1, 0}}
    ]

    # These robots are already adjacent, so should return step 1
    # Disable printing during test
    result = recursive_search(robots, 1, false)
    assert result == 1

    # Test with robots that need to move to become adjacent
    robots = [
      # Robot moving right faster
      {{0, 0}, {2, 0}},
      # Robot moving right faster
      {{1, 0}, {2, 0}},
      # Robot moving right faster
      {{2, 0}, {2, 0}},
      # Stationary robot
      {{10, 0}, {0, 0}},
      # Stationary robot
      {{11, 0}, {0, 0}},
      # Stationary robot
      {{12, 0}, {0, 0}},
      # Stationary robot
      {{13, 0}, {0, 0}}
    ]

    # After 4 steps, the first three robots will have moved to positions
    # that make them adjacent to the stationary robots
    result = recursive_search(robots, 1, false)
    # We expect a solution to be found
    assert result > 0
  end
end
