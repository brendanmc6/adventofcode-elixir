defmodule Day09_P02 do
  @behaviour Common.Solver

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  # handle stray ints at the end (add gap 0)
  def to_block_list({{block_size}, id}, blocks) do
    [%{id: id, size: block_size, used: block_size, gap: 0} | blocks]
  end

  # handle pairs, convert to list of blocks and gaps
  def to_block_list({{block_size, gap_size}, id}, blocks) do
    [%{id: id, size: block_size + gap_size, gap: gap_size, used: block_size} | blocks]
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
    |> Enum.reduce([], &to_block_list/2)
  end

  def reduce_checksum(block, {prev_checksum, index}) do
    end_i = index + (block.used - 1)

    checksum =
      Enum.reduce(
        index..end_i,
        prev_checksum,
        fn i, acc ->
          acc + i * block.id
        end
      )

    {checksum, end_i + block.gap + 1}
  end

  def checksum(results) do
    results
    |> Enum.reduce({0, 0}, &reduce_checksum/2)
    |> elem(0)
  end

  def sum_ops_list(ops_list) do
    ops_list
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def gap_after_ops({gap_size, block_id}, ops) do
    ops
    |> Map.get(block_id, [])
    |> sum_ops_list()
    |> then(&(gap_size - &1))
  end

  # Same behavior as Enum.find() but exits early when block_ids have been exhausted (minor optimization)
  def find_leftmost_fit(gaps, block, ops) do
    Enum.reduce_while(gaps, nil, fn {size, id}, _ ->
      cond do
        id >= block.id ->
          {:halt, nil}

        block.used <= size and block.used <= gap_after_ops({size, id}, ops) ->
          {:halt, id}

        true ->
          {:cont, nil}
      end
    end)
  end

  # returns a map of lists of tuples
  # %{ node_id => { slots_claimed, by_block_id }
  def get_ops(blocks) do
    # reverse and create gap tuples to speed up the scan
    gaps =
      blocks
      |> Enum.map(&{&1.gap, &1.id})
      |> Enum.reverse()

    # construct map of ops. Either 1 op or zero ops per block, enumerating in descending order (last block first)
    Enum.reduce(blocks, %{}, fn block, ops ->
      # scan for first gap that fits the block
      id = find_leftmost_fit(gaps, block, ops)

      if id == nil do
        ops
      else
        # add an op for the block that had the gap, claiming `{slots_claimed, by_block_id}`
        Map.update(ops, id, [{block.used, block.id}], &[{block.used, block.id} | &1])
      end
    end)
  end

  def zip(blocks, ops, deletions) do
    blocks
    |> Enum.reverse()
    |> Enum.reduce([], fn
      block, [] ->
        block_ops = Map.get(ops, block.id, [])
        remainder = block.gap - sum_ops_list(block_ops)
        acc_with_block = [%{id: block.id, used: block.used, gap: 0}]

        filled_gaps =
          for({used, by_id} <- block_ops) do
            %{id: by_id, used: used, gap: 0}
          end

        [last | rest] = filled_gaps ++ acc_with_block
        [%{last | gap: last.gap + remainder} | rest]

      block, acc ->
        block_ops = Map.get(ops, block.id, [])
        deleted? = MapSet.member?(deletions, block.id)

        remainder = block.gap - sum_ops_list(block_ops)
        [preceeding | rest_acc] = acc

        new_preceeding_gap = if deleted?, do: preceeding.gap + block.used, else: preceeding.gap

        new_preceeding = %{preceeding | gap: new_preceeding_gap}

        new_acc = [new_preceeding | rest_acc]

        acc_with_block =
          if deleted?,
            do: new_acc,
            else: [%{id: block.id, used: block.used, gap: 0} | new_acc]

        filled_gaps =
          for({used, by_id} <- block_ops) do
            %{id: by_id, used: used, gap: 0}
          end

        [last | rest] = filled_gaps ++ acc_with_block
        [%{last | gap: last.gap + remainder} | rest]
    end)
  end

  def ops_to_deletions(ops) do
    ops
    |> Map.values()
    |> Enum.flat_map(&for {_, x} <- &1, do: x)
    |> MapSet.new()
    |> then(&{ops, &1})
  end

  def solve(blocks) do
    blocks
    |> get_ops()
    |> ops_to_deletions()
    |> then(fn {ops, deletions} -> zip(blocks, ops, deletions) end)
    |> Enum.reverse()
    |> checksum()
  end
end
