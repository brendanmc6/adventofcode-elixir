defmodule Day13_P01 do
  @behaviour Common.Solver
  # {x, y}
  @type button :: {integer(), integer()}
  @type target :: {integer(), integer()}
  @type claw_machine :: {button(), button(), target()}

  @button_a_cost 3
  @button_b_cost 1

  def to_int_tuple(pair_str) do
    pair_str
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def calc_current(counts, values) do
    {a, b} = counts
    {a_val, b_val, _t} = values
    a * a_val + b * b_val
  end

  def compare(value, target) do
    cond do
      value === target -> :eq
      value < target -> :lt
      value > target -> :gt
    end
  end

  # Base Case
  def find_all_solutions({a, b} = counts, values, solutions) when b === 0 do
    {_, _, target} = values
    curr = calc_current(counts, values)

    case compare(curr, target) do
      :gt -> solutions
      :eq -> [counts | solutions]
      # Increase A until target exceeded or matched
      :lt -> find_all_solutions({a + 1, b}, values, solutions)
    end
  end

  # Recurse case, adding solutions to list.
  @doc "Return a sorted list of every combination of {a, b} that meets target"
  def find_all_solutions(counts, values, solutions) do
    {a, b} = counts
    {_a_val, _b_val, target} = values
    curr = calc_current(counts, values)

    case compare(curr, target) do
      # target exceeded, try b - 1
      :gt -> find_all_solutions({a, b - 1}, values, solutions)
      :eq -> find_all_solutions({a, b - 1}, values, [counts | solutions])
      # Below target, try a + 1
      :lt -> find_all_solutions({a + 1, b}, values, solutions)
    end
  end

  @doc "Given a claw_machine, find all the solutions to reach x, return tuple"
  def with_x_solutions({a_vals, b_vals, targets} = claw_machine) do
    {ax_val, _ay_val} = a_vals
    {bx_val, _by_val} = b_vals
    {target_x, _target_y} = targets
    # {a, b}
    counts = {0, floor(target_x / bx_val)}
    values = {ax_val, bx_val, target_x}
    solutions = []
    {claw_machine, find_all_solutions(counts, values, solutions)}
  end

  @doc "Given a list of x solutions, return first one in the list where ay and by also meet target_y"
  def find_y_solution({claw_machine, solutions}) do
    {a_vals, b_vals, targets} = claw_machine
    {_, ay_val} = a_vals
    {_, by_val} = b_vals
    {_, target_y} = targets

    solutions
    |> Enum.reverse()
    |> Enum.find({0, 0}, fn counts ->
      target_y === calc_current(counts, {ay_val, by_val, target_y})
    end)
  end

  def calculate_costs({a, b}), do: a * @button_a_cost + b * @button_b_cost

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  @spec parse([String.t()]) :: [claw_machine()]
  def(parse(rowstrs)) do
    rowstrs
    |> Enum.filter(&(&1 !== ""))
    |> Enum.map(&String.replace(&1, "Button A: X+", ""))
    |> Enum.map(&String.replace(&1, " Y+", ""))
    |> Enum.map(&String.replace(&1, "Button B: X+", ""))
    |> Enum.map(&String.replace(&1, "Prize: X=", ""))
    |> Enum.map(&String.replace(&1, " Y=", ""))
    |> Enum.chunk_every(3)
    |> Enum.map(fn chunk ->
      chunk
      |> Enum.map(&to_int_tuple/1)
      |> List.to_tuple()
    end)
  end

  @spec solve([claw_machine()]) :: integer()
  def solve(claw_machines) do
    claw_machines
    |> Enum.map(&with_x_solutions/1)
    |> Enum.map(&find_y_solution/1)
    # Instructions say can't exceed 100 presses
    |> Enum.reject(fn {a, b} -> a > 100 or b > 100 end)
    |> Enum.map(&calculate_costs/1)
    |> Enum.sum()
  end
end
