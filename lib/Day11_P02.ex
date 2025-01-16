defmodule Day11_P02 do
  @behaviour Common.Solver

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  def reduce_list(int, acc) do
    Map.update(acc, int, 1, &(&1 + 1))
  end

  def parse([str]) do
    str
    |> String.split(" ", trim: true)
    |> Enum.reduce(%{}, &reduce_list/2)
  end

  def split_int({intstr, count}) do
    intstr
    |> then(&{&1, div(String.length(&1), 2)})
    |> then(fn {intstr, mid} -> String.split_at(intstr, mid) end)
    |> Tuple.to_list()
    |> Enum.map(&String.trim_leading(&1, "0"))
    |> Enum.map(fn
      # replace stripped zeros
      "" -> "0"
      i -> i
    end)
    |> Enum.map(fn newint -> {newint, count} end)
  end

  def blink({"0", count}) do
    [{"1", count}]
  end

  def blink({"1", count}) do
    [{"2024", count}]
  end

  # when even digits, split and trim leading zeros
  def blink({intstr, count}) do
    is_even = rem(String.length(intstr), 2) == 0

    if is_even,
      do: split_int({intstr, count}),
      else: [{to_string(String.to_integer(intstr) * 2024), count}]
  end

  def reduce_blink(_i, intmap) do
    intmap
    |> Map.to_list()
    |> Enum.flat_map(&blink/1)
    |> Enum.reduce(%{}, fn {intstr, count}, acc ->
      Map.update(acc, intstr, count, &(&1 + count))
    end)
  end

  # blinks every value in the map `n` times
  def blink_times(intmap, n) do
    1..n
    |> Enum.reduce(intmap, &reduce_blink/2)
  end

  def solve(intmap) do
    blink_times(intmap, 75) |> Map.values() |> Enum.sum()
  end
end
