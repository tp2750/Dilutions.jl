using Dilutions
using Documenter

DocMeta.setdocmeta!(Dilutions, :DocTestSetup, :(using Dilutions); recursive=true)

makedocs(;
    modules=[Dilutions],
    authors="Thomas Poulsen",
    repo="https://github.com/tp2750/Dilutions.jl/blob/{commit}{path}#{line}",
    sitename="Dilutions.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://tp2750.github.io/Dilutions.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/tp2750/Dilutions.jl",
    devbranch="main",
)
