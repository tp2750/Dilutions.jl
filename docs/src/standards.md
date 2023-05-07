# Standards

The `standards` function makes a set of target concentrations often used as a standard row.

``` julia
using Dilutions

julia> standards(1000,[100,50,20], 100)
3×5 DataFrame
 Row │ source_concentration  target_concentration  target_volume  source_volume  solvent_volume 
     │ Int64                 Int64                 Int64          Float64        Float64        
─────┼──────────────────────────────────────────────────────────────────────────────────────────
   1 │                 1000                   100            100           10.0            90.0
   2 │                 1000                    50            100            5.0            95.0
   3 │                 1000                    20            100            2.0            98.0
```
