defmodule Day06_P02.Test do
  use ExUnit.Case
  import Day06_P02
  alias Day06_P02.Grid

  @north {0, -1}
  @east {1, 0}
  @south {0, 1}
  @west {-1, 0}

  test "grid.visit" do
    input = ["...#", "....", "....", "...^"]
    {start, grid} = parse(input)

    cell =
      grid
      |> Grid.visit(start, @east)
      |> Grid.visit(start, @south)
      |> Grid.visit(start, @west)
      |> Grid.get(start)

    assert cell.visit_vectors == [@west, @south, @east]
  end

  test "visit_cell recursive" do
    input = ["...#", "....", "....", "...^"]
    {start, grid} = parse(input)
    start_cell = Grid.get(grid, start)
    next_cell = Grid.get(grid, next_coord(@north, start))
    final_grid = visit_cell(@north, start_cell, next_cell, grid)
    cell = Grid.get(final_grid, next_cell.coord)
    assert cell.visit_vectors == [@north]
  end

  test "extract_candidates" do
    input = ["...#", "....", "....", "...^"]
    {start, grid} = parse(input)
    start_cell = Grid.get(grid, start)
    next_cell = Grid.get(grid, next_coord(@north, start))
    final_grid = visit_cell(@north, start_cell, next_cell, grid)
    candidates = extract_candidates(final_grid, start)
    assert candidates == [{3, 1}, {3, 2}]
  end

  test "infinite_loop? true" do
    input = [
      ".#...",
      "....#",
      "#....",
      ".^.#."
    ]

    {start, grid} = parse(input)
    assert infinite_loop?(grid, start) == true
  end

  test "infinite_loop? false" do
    input1 = [
      ".#...",
      "....#",
      ".....",
      ".^.#."
    ]

    {start, grid} = parse(input1)
    assert infinite_loop?(grid, start) == false

    input2 = [
      ".#...",
      ".#..#",
      ".....",
      ".^.#."
    ]

    {start2, grid2} = parse(input2)
    assert infinite_loop?(grid2, start2) == false
  end

  test "solve 1 loop" do
    input = [
      ".#...",
      "....#",
      ".....",
      ".^.#."
    ]

    assert solve(parse(input)) == 1
  end
end
