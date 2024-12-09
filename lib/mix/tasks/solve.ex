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

  @impl Mix.Task
  @spec run([String.t()]) :: :ok
  def run([day, puzzle]) when valid_args(day, puzzle) do
    slug = "Day#{day}_P#{puzzle}"
    module_name = Module.concat([slug])
    puzzle_input_path = "inputs/#{slug}_input.txt"
    puzzle_output_path = "solutions/#{slug}_solution.txt"
    apply(module_name, :solve, [puzzle_input_path, puzzle_output_path])
    Mix.shell().info("Task complete.")
    :ok
  end

  def run(_args) do
    Mix.shell().error("Solve task failed. Invalid arguments.")
  end
end
