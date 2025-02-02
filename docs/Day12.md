# Day12 Notes

## Finding Regions

Input map

```elixir
%{
    {x, y} => "X"
}
```

Region assignment, because the letters can appear multiple times and we need to assign a region_id

```elixir
%{
    {x, y} => region_id,
}
```

Traversing and assigning a region
Start case: get the value at x,y
Assign {x,y} => region_count
Check all 4 cardinal directions for a like value.
Recurse on all like values.

## Counting fences

By checking the 4 cardinals for each coord in a region.

# Day12 Part 2

Number of sides instead of perimeter.

Store the perimiter in a map for easy comparison.

Update to count_units algo:

- Enumerates each pair of {coord, region_id} in the region_map
- Checks each cardinal for a perimiter (unalike neighbor)
- If a perimeter is found, "look left" and check that neighbor (n->w, e->n, s->e, w->s)
- if the "left" neighbor is alike and has a paralell perimeter, do not increase count.
- If the "left" neighbor is not alike, or is alike without a paralell (same cardinal) perimiter, increase count +1
