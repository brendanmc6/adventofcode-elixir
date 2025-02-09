defmodule Day12_P02 do
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

  # return the neighbor of the coordinate in the given vector
  def get_neighbor(vec_atom, {x, y}) do
    case vec_atom do
      :n -> {x, y - 1}
      :e -> {x + 1, y}
      :s -> {x, y + 1}
      :w -> {x - 1, y}
    end
  end

  def get_neighbor_coords(coord) do
    # [N, E, S, W]
    [:n, :e, :s, :w]
    |> Enum.map(fn vec_atom -> get_neighbor(vec_atom, coord) end)
  end

  # get left (counter-clockwise) neighbor coord
  # e.g. the left neighbor of {:n, {1,0}} is {0,0}
  def get_left_neighbor(vec_atom, {x, y}) do
    case vec_atom do
      :n -> {x - 1, y}
      :e -> {x, y - 1}
      :s -> {x + 1, y}
      :w -> {x, y + 1}
    end
  end

  # wrap each neighbor coord with a vector atom so we can look left
  def with_vector_atom([a, b, c, d]) do
    [{:n, a}, {:e, b}, {:s, c}, {:w, d}]
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

  # check *left neighbor* and *left neighbor's neighbor* to return `true` if we found a new side
  # if left-neighbor is alike and left-neighbors-neighbor is unalike (parallel perimeter), return false (not a new side)
  # otherwise a new side has been found because we found either an inside corner (left-neighbor and l.n.n. are both alike) or an outside corner (ln unalike)
  def check_left_neighbor(coord, region_id, vec_atom, region_map) do
    # left neighbor
    ln = get_left_neighbor(vec_atom, coord)
    # left-neighbor's neighbor in the same direction
    lnn = get_neighbor(vec_atom, ln)
    ln_region_id = Map.get(region_map, ln)
    lnn_region_id = Map.get(region_map, lnn)

    if ln_region_id === region_id and lnn_region_id !== region_id do
      false
    else
      true
    end
  end

  # Enumuerates every coordinate in the region_map
  # Counts unalike neighbors in all 4 cardinals (+1 perimeter)
  # - Looks "left" and skips count if the left-neighbor has a paralell perimeter (side is already accounted for)
  # And adds +1 to area
  # Assigns these to a map of %{ region_id => {perim_count, area_count} }
  def count_units(region_map) do
    Enum.reduce(region_map, %{}, fn {coord, region_id}, acc ->
      new_sides =
        get_neighbor_coords(coord)
        |> with_vector_atom()
        |> Enum.count(fn {vec_atom, neigh_coord} ->
          neigh_region_id = Map.get(region_map, neigh_coord)
          neigh_is_alike? = neigh_region_id === region_id

          if neigh_is_alike? do
            # neighbor is alike, there is no perimiter here
            false
          else
            # need to check our left-neighbor and left-neighbors-neighbor for a parallel perimiter
            check_left_neighbor(coord, region_id, vec_atom, region_map)
          end
        end)

      Map.update(acc, region_id, {new_sides, 1}, fn {s, a} ->
        {s + new_sides, a + 1}
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
