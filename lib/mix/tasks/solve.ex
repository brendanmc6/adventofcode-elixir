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

  @doc "Abstracts the read, stream and write logic for each solver"
  @impl Mix.Task
  @spec run([String.t()]) :: :ok
  def run([day, puzzle]) when valid_args(day, puzzle) do
    slug = "Day#{day}_P#{puzzle}"
    solver = Module.concat([slug])

    File.stream!("inputs/Day#{day}_input.txt")
    |> Enum.map(&solver.parse/1)
    |> solver.solve()
    |> write("solutions/#{slug}_solution.txt")

    Mix.shell().info("Task complete.")
    :ok
  end

  def run(_args) do
    Mix.shell().error("Solve task failed. Invalid arguments.")
  end
end
