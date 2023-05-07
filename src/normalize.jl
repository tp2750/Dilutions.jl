#=
| Reagent  | Stock concentration | unit | Volume | unit | Conc needed | unit | Stock volume | unit | Solvent volume | unit |
|----------+---------------------+------+--------+------+-------------+------+--------------+------+----------------+------|
| CuCl2    |                5000 | µM   |   1000 | µL   |         200 | µM   |           40 | µL   |            960 | µL   |
| Thiamine |               10000 | µM   |   1000 | µL   |         600 | µM   |           60 | µL   |            940 | µL   |
Input is:
- Reagent name
- Sock concentration
- Volume needed
- Concentration needed
Output:
- H2O volume
- Solvent volume
=#

using Unitful
using DataFrames


"""
    normalize(source_concentration, target_concentration, target_volume)
    normalize(df::DataFrame)
    source_concentration: concentration of stock
    target_concentration: needed concentration
    target_volume: needed volume

    The values can be either numeric or with units from Unitful.
    If units are used, the result will be in the unit of `target_volume`.
    Values can also be given as keyword arguments.
    For a DataFrame, it must have columns matching `r"[source|stock]_con", r"target_con", r"target_vol"`

    Result: (;source_volume, solvent_volume)n

    Examples:
    ``` julia
    normalize(5000,200,1000) == (source_volume = 40.0, solvent_volume = 960.0)
    normalize(5000u"µmol/L",200u"µmol/L", 1000u"µL") == (source_volume = 40.0u"μL", solvent_volume = 960.0u"μL")
    normalize(5u"mmol/L",200u"µmol/L", 1u"mL") == (source_volume = 0.04u"mL", solvent_volume = 0.96u"mL")
    ```
"""
function normalize(source_concentration, target_concentration, target_volume)
    source_volume = target_concentration / source_concentration * target_volume
    @debug source_volume
    solvent_volume = target_volume - source_volume
    @debug solvent_volume
    if ustrip(solvent_volume) < 0  ## unit does not change sign
      error("Negative solvent volume: ", solvent_volume)
    end
    (;source_volume = uconvert(unit(target_volume), source_volume), solvent_volume = uconvert(unit(target_volume), solvent_volume))
end

## kwargs
normalize(;source_concentration=1, target_concentration=1, target_volume=1) = normalize(source_concentration, target_concentration, target_volume)

## Data Frame matching column names losely
normalize(df::DataFrame) = transform(df, Cols(r"[source|stock]_con"i, r"target_con"i, r"target_vol"i) => ByRow(normalize) => AsTable)

## Standard series
"""
    standards(source_concentration, target_concentrations, target_volume)
    
    source_concentration: concetration of stock
    target_concentrations: vector of target concentrations
    target_volume: desired volume of each standard

    result:
    DataFrame with columns: source_concentration  target_concentration  target_volume  source_volume  solvent_volume
    where the last 2 are instructions in how to make the standard solutions.
    
    Currently this is very simple using only the given stock concentration.
    A more realistic version will allows for using intermediate dilutions for the lower concentrations.
"""
function standards(source_concentration, target_concentrations, target_volume)
    ## This is a simple version using the stock for all values.
    ## A more realistic one will use the intermediate solutions as "stocks"
    r1 = DataFrame(map(x->normalize(source_concentration, x, target_volume), target_concentrations))
    hcat(DataFrame(source_concentration = repeat([source_concentration], length(target_concentrations)), target_concentration = target_concentrations, target_volume = repeat([target_volume],length(target_concentrations))), r1)
end
