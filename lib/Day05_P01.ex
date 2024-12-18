defmodule Day05_P01 do
  @behaviour Common.Solver

  # 4 integers separated by a pipe, 5 bytes e.g. `12|34`
  @bytes_len 5

  def reduce_input(str, {r, i}) when byte_size(str) == @bytes_len, do: {[str | r], i}
  def reduce_input(str, acc) when byte_size(str) == 0, do: acc
  def reduce_input(str, {r, i}), do: {r, [str | i]}

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

  def return_middle_val(list), do: Enum.at(list, div(length(list), 2))

  # Scan left for r (because r should only come after l)
  def check_violation({l, r}, n, i, list) when n == l do
    list
    |> Enum.slice(0..i)
    |> Enum.member?(r)
  end

  # Scan right for l (because l should only come before r)
  def check_violation({l, r}, n, i, list) when n == r do
    list
    |> Enum.drop(i)
    |> Enum.member?(l)
  end

  def page_validator(pages, rules_map) do
    fn {n, i} ->
      rules_map[n]
      |> Enum.all?(fn rule ->
        not check_violation(rule, n, i, pages)
      end)
    end
  end

  # Validates a list of pages [1,2,3,4] against the rules
  # Returns the middle value or 0
  def validate_pages_list(pages, rules_map) do
    pages
    |> Enum.with_index()
    |> Enum.all?(page_validator(pages, rules_map))
    |> then(fn bool -> if bool, do: return_middle_val(pages), else: 0 end)
  end

  @doc """
  Filters the input.txt into two lists of strings.
  Since the first half of the input is rule-strings `"12|34"` and the second half is list-strings `"1,2,3,4"`
  Returns {rules, inputs}
  """
  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({[], []}, &reduce_input/2)
  end

  @doc """
  Assigns rules to a map of lists of tuples.
  %{ 1 => [{1,2}, {2,1}] }

  Assigns inputs to a list of lists of integers.
  [[1,2,3,4],[1,2,3,4]]
  """
  def parse({rules, inputs}) do
    rules_map =
      rules
      |> Enum.map(&rule_to_tuple/1)
      |> Enum.reduce(%{}, &assign_rules/2)

    pages_lists =
      inputs
      |> Enum.map(fn str ->
        String.split(str, ",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    {rules_map, pages_lists}
  end

  def solve({rules_map, pages_lists}) do
    pages_lists
    |> Enum.map(&validate_pages_list(&1, rules_map))
    |> Enum.sum()
  end
end
