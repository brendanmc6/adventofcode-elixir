defmodule Common.Solver do
  @moduledoc "Common interface defining @behavior for all puzzle solvers"

  @doc "Parses whatever the result of read() is, returns the puzzle input for solve()"
  @callback parse(any()) :: any()
  @doc "Accepts the parsed puzzle input, returns the solution"
  @callback solve(any()) :: any()
  @doc "Accepts a path, reads the file and returns the values"
  @callback read(String.t()) :: any()
end
