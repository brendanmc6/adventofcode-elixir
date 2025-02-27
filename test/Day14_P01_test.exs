defmodule Day14_P01.Test do
  use ExUnit.Case
  import Day14_P01

  test "parse" do
    assert parse(["p=2,4 v=2,-3"]) == [{{2, 4}, {2, -3}}]
  end

  test "calc_pos" do
    sec = 5
    board_width = 11
    board_height = 7
    start_x = 2
    start_y = 4
    vel_x = 2
    vel_y = -3
    assert calc_pos(start_x, vel_x, board_width, sec) === 1
    assert calc_pos(start_y, vel_y, board_height, sec) === 3
  end
end
