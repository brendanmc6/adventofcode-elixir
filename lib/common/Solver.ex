defmodule Common.Solver do
  @moduledoc "Common interface defining @behavior for all puzzle solvers"

  @doc "Parse a single line of text input from the puzzle input"
  @callback parse(String.t()) :: any()
  @doc "Accepts a list of parsed lines, returns the solution"
  @callback solve([any()]) :: any()
end
