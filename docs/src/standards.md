# Standards

The `standards` function makes a set of target concentrations often used as a standard row.

``` julia
using Dilutions
using Unitful

julia> standards(1000,[100,50,20], 100u"µL")
3×5 DataFrame
 Row │ source_concentration  target_concentration  target_volume  source_volume  solvent_volume 
     │ Int64                 Int64                 Quantity…      Quantity…      Quantity…      
─────┼──────────────────────────────────────────────────────────────────────────────────────────
   1 │                 1000                   100         100 μL        10.0 μL         90.0 μL
   2 │                 1000                    50         100 μL         5.0 μL         95.0 μL
   3 │                 1000                    20         100 μL         2.0 μL         98.0 μL
```
