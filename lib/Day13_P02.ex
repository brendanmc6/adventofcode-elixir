defmodule Day13_P02 do
  @behaviour Common.Solver
  # {x, y}
  @type button :: {integer(), integer()}
  @type target :: {integer(), integer()}
  @type claw_machine :: {button(), button(), target()}

  @button_a_cost 3
  @button_b_cost 1

  @part_two_surprise 10_000_000_000_000

  def to_int_tuple(pair_str) do
    pair_str
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def calculate_costs({a, b}), do: a * @button_a_cost + b * @button_b_cost

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  def positive_int?(n) when n === 0, do: false
  def positive_int?(n) when is_integer(n), do: true
  def positive_int?(n), do: trunc(n) == n

  @doc """
  True if both values are whole numbers, nonzero
  """
  def real_solution?({na, nb}), do: positive_int?(na) && positive_int?(nb)

  @doc "False if determinant is zero (x and y are on the same vector, either infinite solutions or zero solutions)"
  def nonzero_determinant?({{ax, ay}, {bx, by}, _targets}) do
    ax * by - bx * ay !== 0
  end

  def solve_presses({{ax, ay}, {bx, by}, {targetX, targetY}}) do
    d = ax * by - bx * ay
    na = (by * targetX + -bx * targetY) / d
    nb = (-ay * targetX + ax * targetY) / d
    {na, nb}
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
    |> Enum.map(fn {a_vals, b_vals, {tx, ty}} ->
      # add lots of zeros to the targets
      {a_vals, b_vals, {tx + @part_two_surprise, ty + @part_two_surprise}}
    end)
    |> Enum.filter(&nonzero_determinant?/1)
    |> Enum.map(&solve_presses/1)
    |> Enum.filter(&real_solution?/1)
    |> Enum.map(&calculate_costs/1)
    |> Enum.sum()
    |> trunc()
  end
end
