defmodule Day05_P01 do
  @behaviour Common.Solver

  # 4 integers separated by a pipe, 5 bytes e.g. `12|34`
  @bytes_len 5

  def reduce_input(str, {r, i}) when byte_size(str) == @bytes_len, do: {[str | r], i}
  def reduce_input(str, acc) when byte_size(str) == 0, do: acc
  def reduce_input(str, {r, i}), do: {r, [str | i]}

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({[], []}, &reduce_input/2)
  end

  def rule_to_tuple(rule) do
    rule
    |> String.split("|")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def assign_rules({l, r} = rule, map) do
    map
    |> Map.update(l, [rule], &[rule | &1])
    |> Map.update(r, [rule], &[rule | &1])
  end

  def parse({rules, inputs}) do
    rules_map =
      rules
      |> Enum.map(&rule_to_tuple/1)
      |> Enum.reduce(%{}, &assign_rules/2)

    input_lists =
      inputs
      |> Enum.map(fn str ->
        String.split(str, ",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    {rules_map, input_lists}
  end

  def solve({rules_map, input_lists}) do
    # TODO
  end
end
