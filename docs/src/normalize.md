```@meta
CurrentModule = Dilutions
```

# Normalize Concentrations

Often we have some stock at a given concentration, and need to obtain a sample of a lower concentration.

In a spreadsheet, we would have a table like this:


| Reagent  | Stock conc | unit | Conc need | unit | Volume need | unit | Stock volume | unit | Solvent volume | unit |
|----------|------------|------|-----------|------|-------------|------|--------------|------|----------------|------|
| CuCl2    |       5000 | µM   |       200 | µM   |        1000 | µl   |           40 | µl   |            960 | µl   |
| Thiamine |      10000 | µM   |       600 | µM   |        1000 | µL   |           60 | µL   |            940 | µL   |


where we edit "Stock conc", "Conc need" and "Volume need", and then formulas will compute the stock volume and solvent volume to add (assuming additive volumes).
One issue with this is that we need to make sure we use the same units for the concentrations.

With this package, we can do the same in this way:

``` julia
using Dilutions
using DataFrmaes
using Unitful
julia> df = DataFrame(Reagent = ["CuCl2", "Thiamine"], stock_conc = [5,10]u"mM", target_conc = [200,600]u"µM", target_vol = [1000, 1000]u"µL")
2×4 DataFrame
 Row │ Reagent   stock_conc  target_conc  target_vol 
     │ String    Quantity…   Quantity…    Quantity…  
─────┼───────────────────────────────────────────────
   1 │ CuCl2           5 mM       200 μM     1000 μL
   2 │ Thiamine       10 mM       600 μM     1000 μL

julia> normalize(df)
2×6 DataFrame
 Row │ Reagent   stock_conc  target_conc  target_vol  source_volume  solvent_volume 
     │ String    Quantity…   Quantity…    Quantity…   Quantity…      Quantity…      
─────┼──────────────────────────────────────────────────────────────────────────────
   1 │ CuCl2           5 mM       200 μM     1000 μL        40.0 μL        960.0 μL
   2 │ Thiamine       10 mM       600 μM     1000 μL        60.0 μL        940.0 μL
```

There is a bit of flexibility in the column names: "stock" can also be "source", "volume" can be spelled out in full, and upper/lowercase is ignored.

The normalize function is also defined on positional and key-word arguments:

```@docs
normalize
```

