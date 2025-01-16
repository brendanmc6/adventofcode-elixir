# Day11 Notes

Optimization:
Reduce the search space by deduplicating

"Map of counts" solution
125 17

```elixir
%{
    253000 => 1,
    1 => 1,
    7 => 1
}
```

Blink each key in the map n times

```
%{
    253 => 1,
    0 => 1,
    2024 => 1,
    14168 => 1,
}
```

Then sum the values of the map

# Result

133ms
