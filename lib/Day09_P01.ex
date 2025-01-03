defmodule Day09_P01 do
  @behaviour Common.Solver

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  # handle stray ints at the end (add gap 0)
  def to_block_lists({{block_size}, id}, {gaps, blocks}) do
    {[{id, 0} | gaps], [{id, block_size} | blocks]}
  end

  # handle pairs, convert to list of blocks and gaps
  def to_block_lists({{block_size, gap_size}, id}, {gaps, blocks}) do
    {[{id, gap_size} | gaps], [{id, block_size} | blocks]}
  end

  # starting case
  def to_int_pairs(int, []) do
    [{int}]
  end

  def to_int_pairs(int, acc) do
    [prev_pair | tail] = acc

    case prev_pair do
      {x} -> [{x, int} | tail]
      {_x, _y} -> [{int} | acc]
      _ -> raise("to_int_pairs should have a pair of size 1 or 2")
    end
  end

  def parse([data]) do
    data
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce([], &to_int_pairs/2)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce({[], []}, &to_block_lists/2)
    # blocks are reversed by appending to list, we want the gaps in original order
    |> then(fn {gaps, blocks} -> {Enum.reverse(gaps), blocks} end)
  end

  # base case, gap_id and block_id match, can not assign anymore
  def compact([{gap_id, _gap_size} | _gaps], [{block_id, block_size} | blocks], filled_gaps)
      when block_id == gap_id do
    {Enum.reverse([{block_id, block_size} | blocks]), Enum.reverse(filled_gaps)}
  end

  # recurse case, fill gaps
  def compact([{gap_id, gap_size} | gaps], [{block_id, block_size} | blocks], filled_gaps) do
    cond do
      # split gap, pop block, fill partial gap
      gap_size > block_size ->
        compact(
          [{gap_id, gap_size - block_size} | gaps],
          blocks,
          [{gap_id, block_id, block_size} | filled_gaps]
        )

      gap_size < block_size ->
        # pop gap, split block, fill gap
        # 0 size gaps are handled safely here
        compact(
          gaps,
          [{block_id, block_size - gap_size} | blocks],
          [{gap_id, block_id, gap_size} | filled_gaps]
        )

      true ->
        # pop gap, pop block, fill gap
        compact(
          gaps,
          blocks,
          [{gap_id, block_id, gap_size} | filled_gaps]
        )
    end
  end

  # takes a filled gap like {0, 1, 2} and pushes it to the accumulator
  # returns a list of {block_id, size} without gaps
  # there may be remaining blocks. These need to be concatenated at the end.
  def reduce_filled_gap(filled_gap, {result, blocks}) do
    {gap_id, original_block_id, gap_size} = filled_gap
    [next_block | tail] = blocks
    {block_id, _bs} = next_block

    cond do
      # push filled gap
      gap_id < block_id ->
        {[{original_block_id, gap_size} | result], blocks}

      # push block and filled gap, pop blocks
      gap_id == block_id ->
        {[{original_block_id, gap_size}, next_block] ++ result, tail}

      true ->
        raise "reduce_filled_gap - block_id should never exceed gap_id"
    end
  end

  def zip(blocks, gaps) do
    gaps
    |> Enum.reduce({[], blocks}, &reduce_filled_gap/2)
    |> then(fn {result, blocks} -> Enum.reverse(result) ++ blocks end)
  end

  def reduce_checksum({_id, size}, acc) when size == 0, do: acc

  def reduce_checksum({id, size}, {prev_checksum, index}) do
    end_i = index + (size - 1)
    checksum = Enum.reduce(index..end_i, prev_checksum, &(&2 + &1 * id))
    {checksum, end_i + 1}
  end

  def checksum(results) do
    results
    |> Enum.reduce({0, 0}, &reduce_checksum/2)
    |> elem(0)
  end

  def solve({gaps, blocks}) do
    compact(gaps, blocks, []) |> then(fn {b, g} -> zip(b, g) end) |> checksum()
  end
end
