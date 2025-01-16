defmodule Day11_P01 do
  @behaviour Common.Solver

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  def parse([str]) do
    str
    |> String.split(" ", trim: true)
  end

  def split_int(intstr) do
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
  end

  def blink("0") do
    ["1"]
  end

  def blink("1") do
    ["2024"]
  end

  # when even digits, split and trim leading zeros
  def blink(intstr) do
    is_even = rem(String.length(intstr), 2) == 0
    if is_even, do: split_int(intstr), else: [to_string(String.to_integer(intstr) * 2024)]
  end

  def reduce_blink(_i, intlist) do
    Enum.flat_map(intlist, &blink/1)
  end

  # blinks every value in the list `n` times
  def blink_times(intlist, n) do
    1..n
    |> Enum.reduce(intlist, &reduce_blink/2)
  end

  def solve(intlist) do
    blink_times(intlist, 25) |> length()
  end
end
