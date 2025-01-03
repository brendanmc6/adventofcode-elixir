defmodule Day08_P01 do
  @behaviour Common.Solver

  # base case, end of tail reached
  def assign_pairs(coord, [last_coord], pairs) do
    [{coord, last_coord} | pairs]
  end

  # recurse case, pair coord with next coord, then recurse on the tail
  def assign_pairs(coord, [next_coord | tail], pairs) do
    assign_pairs(coord, tail, [{coord, next_coord} | pairs])
  end

  # takes the given coord, pairs it against everything in the tail
  # concat with the previous pairs, and return the remaining tail
  def combine_pairs(coord, {pairs, tail}) do
    if tail == [] do
      pairs
    else
      [_first | rest] = tail
      {assign_pairs(coord, tail, pairs), rest}
    end
  end

  def get_location_pairs([_first | tail] = locations) do
    locations
    # for each location, pair with it's tail
    |> Enum.reduce({[], tail}, &combine_pairs/2)
  end

  def to_antennae_pairs(antennae) do
    antennae
    |> Map.values()
    |> Enum.filter(&(length(&1) > 1))
    |> Enum.map(&get_location_pairs/1)
    |> Enum.concat()
  end

  def apply_vector({x, y}, {vx, vy}), do: {x + vx, y + vy}

  def get_vector({x_a, y_a}, {x_b, y_b}), do: {x_b - x_a, y_b - y_a}

  def within_boundary?({x, y}, {max_x, max_y}) do
    x >= 0 and y >= 0 and x <= max_x and y <= max_y
  end

  def to_antinodes(pairs) do
    # each pair results in 2 antinodes. Push to MapSet for dedupe
    pairs
    |> Enum.reduce(MapSet.new(), fn {a, b}, mapset ->
      mapset
      |> MapSet.put(apply_vector(b, get_vector(a, b)))
      |> MapSet.put(apply_vector(a, get_vector(b, a)))
    end)
  end

  def col_reducer(y) do
    fn {val, x}, antennae ->
      here = {x, y}

      case val do
        "." -> antennae
        _ -> Map.update(antennae, val, [here], fn coords -> [here | coords] end)
      end
    end
  end

  def reduce_row({rowstring, y}, antennae) do
    rowstring
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(antennae, col_reducer(y))
  end

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  def parse(rowstrs) do
    antennae =
      rowstrs
      |> Enum.with_index()
      |> Enum.reduce(%{}, &reduce_row/2)

    max_x = String.length(Enum.at(rowstrs, 0)) - 1
    max_y = length(rowstrs) - 1
    {antennae, {max_x, max_y}}
  end

  def solve({antennae, boundary}) do
    antennae
    |> to_antennae_pairs()
    |> to_antinodes()
    |> MapSet.filter(&within_boundary?(&1, boundary))
    |> MapSet.size()
  end
end
