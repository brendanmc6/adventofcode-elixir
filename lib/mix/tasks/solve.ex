defmodule Mix.Tasks.Solve do
  use Mix.Task

  defmacro valid_args(day, puzzle) do
    quote do
      is_binary(unquote(day)) and
        is_binary(unquote(puzzle)) and
        byte_size(unquote(day)) == 2 and
        byte_size(unquote(puzzle)) == 2
    end
  end

  def write(value, path) do
    Mix.shell().info("Writing solution to #{path} \n Solution is: #{value}")
    File.write(path, Integer.to_string(value))
  end

  def load_solver(day, puzzle) do
    slug = "Day#{day}_P#{puzzle}"
    Module.concat([slug])
  end

  def solve(day, puzzle) do
    solver = load_solver(day, puzzle)

    solver.read("inputs/Day#{day}_input.txt")
    |> solver.parse()
    |> solver.solve()
  end

  @doc "Abstracts the read, stream and write logic for each solver"
  @impl Mix.Task
  @spec run([String.t()]) :: :ok
  def run([day, puzzle]) when valid_args(day, puzzle) do
    start_time = :os.system_time(:millisecond)

    solution = solve(day, puzzle)

    end_time =
      :os.system_time(:millisecond)

    write(solution, "solutions/Day#{day}_P#{puzzle}_solution.txt")

    Mix.shell().info("Finished in #{end_time - start_time} ms")
    :ok
  end

  def run(_args) do
    Mix.shell().error("Solve task failed. Invalid arguments.")
  end
end
