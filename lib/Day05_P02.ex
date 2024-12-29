defmodule Day05_P02 do
  @behaviour Common.Solver

  # 4 integers separated by a pipe, 5 bytes e.g. `12|34`
  @bytes_len 5

  @type page :: integer()
  @type pages :: [page()]
  @type rule :: {integer(), integer()}
  @type rules_list :: [rule()]
  @type rules_map :: %{integer() => rules_list}

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
  def rule_violation?({l, r}, page, pages) when page == l do
    index = Enum.find_index(pages, &(page == &1))

    pages
    |> Enum.slice(0..index)
    |> Enum.member?(r)
  end

  # Scan right for l (because l should only come before r)
  def rule_violation?({l, r}, page, pages) when page == r do
    index = Enum.find_index(pages, &(page == &1))

    pages
    |> Enum.drop(index)
    |> Enum.member?(l)
  end

  # r must come after n
  # returns the repaired list, and the page that was relocated
  @spec fix_violation(rule(), page(), pages()) :: {pages(), page()}
  def fix_violation({l, r}, page, pages) when page == l do
    i = Enum.find_index(pages, &(page == &1))
    index_r = Enum.find_index(pages, &(r == &1))

    pages
    |> List.insert_at(i + 1, r)
    |> List.delete_at(index_r)
    |> then(fn new_pages -> {new_pages, r} end)
  end

  # l must come before n
  # returns the repaired list, and the page that was relocated
  @spec fix_violation(rule(), page(), pages()) :: {pages(), page()}
  def fix_violation({l, r}, page, pages) when page == r do
    i = Enum.find_index(pages, &(page == &1))
    index_l = Enum.find_index(pages, &(l == &1))

    pages
    |> List.insert_at(i, l)
    |> List.delete_at(index_l + 1)
    |> then(fn new_pages -> {new_pages, l} end)
  end

  # Given a page, validates and repairs all the relevant rules
  # If a repair is made, recurses on the repaired page (Handle earlier rules broken by the rearranging of list)
  # returns the repaired list after all rules have been enumerated
  def repair_list_at_page(page, pages, rules_map) do
    # enumerate the list of relevant rules for the current page
    rules_map[page]
    # reduce the list of rules to a repaired list of pages
    |> Enum.reduce(pages, fn rule, acc ->
      if not rule_violation?(rule, page, acc) do
        acc
      else
        {repaired_list, relocated_page} = fix_violation(rule, page, acc)
        repair_list_at_page(relocated_page, repaired_list, rules_map)
      end
    end)
  end

  # Invokes repair_list_at_page on every page in the list
  # Returns the middle integer
  def repair_pages_list(pages, rules_map) do
    pages
    |> Enum.reduce(pages, &repair_list_at_page(&1, &2, rules_map))
    |> then(&return_middle_val/1)
  end

  # Returns true if all pages are valid and no repairs are needed
  def list_is_valid?(pages, rules_map) do
    pages
    |> Enum.all?(fn page ->
      rules_map[page] |> Enum.all?(fn rule -> not rule_violation?(rule, page, pages) end)
    end)
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
      # Filter out the valid lists, return only invalid lists
      |> Enum.filter(fn pages -> not list_is_valid?(pages, rules_map) end)

    {rules_map, pages_lists}
  end

  def solve({rules_map, pages_lists}) do
    pages_lists
    |> Enum.map(&repair_pages_list(&1, rules_map))
    |> Enum.sum()
  end
end
