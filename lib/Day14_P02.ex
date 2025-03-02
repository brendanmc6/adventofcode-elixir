defmodule Day14_P02 do
  @behaviour Common.Solver

  @width_x 101
  @height_y 103
  @x_range 0..(@width_x - 1)
  @y_range 0..(@height_y - 1)
  # Max steps to search for tree
  @max_steps 10000
  # Number of adjacent robots to look for on x axis
  @adjacency_target 10

  @doc "Convert `\"x,y\"` string into {x,y} tuple"
  def to_int_tuple(pair_str) do
    pair_str
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  @doc "From a starting X or Y coord, determines final position after `n` steps."
  def calc_position(start, velocity, board_size, steps) do
    total_distance = steps * velocity
    pos = rem(start + total_distance, board_size)
    # normalize the negative remainder by looping it back around
    if pos < 0, do: pos + board_size, else: pos
  end

  @doc "Moves robot from `{position, velocity}` a given number of `steps`"
  def move_robot({{px, py}, {vx, vy}}, steps) do
    x = calc_position(px, vx, @width_x, steps)
    y = calc_position(py, vy, @height_y, steps)
    {x, y}
  end

  @doc "Given a list of robots {position, velocity}, move all robots n steps and return list of positions"
  def move_all_robots(robot_list, steps) do
    robot_list
    |> Enum.map(&move_robot(&1, steps))
  end

  @doc "Convert unsorted list of {x,y} coords to a map of ${ y_coord => x_coords }"
  def positions_to_map(positions) do
    # Init map with empty array for each y coord
    init_map = @y_range |> Enum.to_list() |> Map.from_keys([])

    Enum.reduce(positions, init_map, fn {x, y}, acc ->
      Map.update!(acc, y, fn prev -> [x | prev] end)
    end)
  end

  @doc "Counts consecutive integers in a list. This function is used as a reducer with Enum.reduce/2"
  def count_consec(int, prev_int) when is_integer(prev_int) do
    count = if int - prev_int === 1, do: 2, else: 1
    {int, count}
  end

  # found our target adjacency count, skip the rest
  def count_consec(_int, {prev_int, count}) when count >= @adjacency_target do
    {prev_int, count}
  end

  # reset count if not adjacent, otherwise increment
  def count_consec(int, {prev_int, count}) do
    new_count = if int - prev_int === 1, do: count + 1, else: 1
    {int, new_count}
  end

  @doc "Given a sorted list of ints, return true if the number of consecutive integeres is at least equal to the @adjacency_target"
  def consec_ints?(int_list) do
    {_int, count} = Enum.reduce(int_list, &count_consec/2)
    count >= @adjacency_target
  end

  @doc "Prints grid to console and returns true"
  def print_grid(positions) do
    full_map = Enum.reduce(positions, %{}, &Map.put(&2, &1, "X"))

    # print rows from yrange
    Enum.each(@y_range, fn y ->
      rowstr =
        @x_range
        |> Enum.map(&Map.get(full_map, {&1, y}, "."))
        |> Enum.join("")

      IO.puts(rowstr)
    end)

    true
  end

  @doc """
  Given a list of {x,y} positions,
  returns true if any of the rows contain the target number of adjacent robots
  """
  def x_adjacency?(positions) do
    positions
    |> positions_to_map()
    |> Map.values()
    |> Enum.filter(fn list -> length(list) >= @adjacency_target end)
    |> Enum.map(&Enum.sort/1)
    |> Enum.any?(&consec_ints?/1)
  end

  @doc """
  Find the number of steps required to satisfy the @adjacency_target.
  Works by calculating their positions at every step up to @max_steps
  """
  def recursive_search(robot_list, steps, print? \\ true)

  # End case, none found
  def recursive_search(_robot_list, steps, _print?) when steps > @max_steps do
    IO.puts("No tree found within max steps: #{@max_steps}")
    0
  end

  # Check adjacency, if found return step count, otherwise recurse on steps+1
  def recursive_search(robot_list, steps, print?) do
    positions = move_all_robots(robot_list, steps)

    if x_adjacency?(positions) do
      if print? do
        print_grid(positions)
      end

      steps
    else
      recursive_search(robot_list, steps + 1, print?)
    end
  end

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  def parse(rowstrs) do
    rowstrs
    |> Enum.map(&String.replace(&1, "p=", ""))
    |> Enum.map(&String.replace(&1, "v=", ""))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [pstr, vstr] ->
      {to_int_tuple(pstr), to_int_tuple(vstr)}
    end)
  end

  def solve(robots) do
    recursive_search(robots, 1, true)
  end
end
