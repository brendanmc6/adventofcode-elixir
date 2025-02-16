defmodule Day12_P01 do
  @behaviour Common.Solver

  def read(path) do
    File.stream!(path)
    |> Enum.map(&String.trim/1)
  end

  def parse(rowstrs) do
    for {row, y} <- Enum.with_index(rowstrs),
        {val, x} <- Enum.with_index(String.graphemes(row)),
        into: %{},
        do: {{x, y}, val}
  end

  def get_neighbor_coords({x, y}) do
    # [N, E, S, W]
    [{x, y - 1}, {x + 1, y}, {x, y + 1}, {x - 1, y}]
  end

  # Recursively assigns region_ids to coordinates, to construct a map of coord => region_id
  def assign_with_neighbors(input_map, region_map, coord, plot_char, region_id) do
    updated_region_map = Map.put_new(region_map, coord, region_id)

    Enum.reduce(get_neighbor_coords(coord), updated_region_map, fn nb_coord, acc ->
      # skip if the neighbor was already handled, or is not alike
      if Map.has_key?(acc, nb_coord) or Map.get(input_map, nb_coord) !== plot_char do
        acc
      else
        assign_with_neighbors(input_map, acc, nb_coord, plot_char, region_id)
      end
    end)
  end

  def assign_all_coords(input_map) do
    Enum.reduce(input_map, %{}, fn {coord, plot_char}, acc ->
      region_id = Map.get(acc, coord)

      if region_id !== nil do
        acc
      else
        assign_with_neighbors(input_map, acc, coord, plot_char, inspect(coord))
      end
    end)
  end

  # Enumerates every coordinate in the region_map
  # Counts unalike neighbors in all 4 cardinals (+1 perimeter)
  # And adds +1 to area
  # Assigns these to a map of %{ region_id => {perim_count, area_count} }
  def count_units(region_map) do
    Enum.reduce(region_map, %{}, fn {coord, region_id}, acc ->
      perim =
        get_neighbor_coords(coord)
        |> Enum.map(&Map.get(region_map, &1))
        |> Enum.count(&(&1 !== region_id))

      Map.update(acc, region_id, {perim, 1}, fn {p, a} ->
        {p + perim, a + 1}
      end)
    end)
  end

  def calc_prices(count_map) do
    count_map
    |> Map.values()
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end

  def solve(input_map) do
    input_map
    |> assign_all_coords()
    |> count_units()
    |> calc_prices()
  end
end
