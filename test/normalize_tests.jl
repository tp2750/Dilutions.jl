using Test
using Dilutions
using Unitful
using DataFrames

@testset "Normalize" begin
    @test normalize(5000,200,1000) == (source_volume = 40.0, solvent_volume = 960.0)
    @test normalize(5000u"µmol/L",200u"µmol/L", 1000u"µL") == (source_volume = 40.0u"μL", solvent_volume = 960.0u"μL")
    (a,b) = normalize(5u"mmol/L",200u"µmol/L", 1000u"µL")
    @test a == 40.0u"μL"
    @test isapprox(b, 960u"µL")
    @test_throws "Negative solvent volume" normalize(5u"mmol/L",200u"mmol/L", 1000u"µL")
    @test normalize(source_concentration=1u"mol/L", target_concentration=1u"mmol/L",target_volume=2u"mL") == (source_volume = 0.002u"mL", solvent_volume = 1.9979999999999998u"mL")
    sc = [5, 10]; tc = [1,1]; tv = [100,100];
    df1 = DataFrame(source_concentration = sc, target_concentration = tc, target_volume = tv)
    res1 = normalize(df1);
    @test res1.source_volume == [20.0, 10.0]
    @test res1.solvent_volume ==  [80.0, 90.0]
    df2 = DataFrame(stock_conc = sc, target_vol = tv, target_conc = tc)
    res2 = normalize(df2);
    @test res2.source_volume == [20.0, 10.0]
    @test res2.solvent_volume ==  [80.0, 90.0]
end

@testset "Standards" begin
    d1 = standards(1000,[100,50,20], 100)
    @test d1.source_volume == [10.0, 5.0, 2.0]
end
