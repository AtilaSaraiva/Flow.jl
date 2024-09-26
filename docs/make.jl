using Flow
using Documenter

DocMeta.setdocmeta!(Flow, :DocTestSetup, :(using Flow); recursive=true)

makedocs(;
    modules=[Flow],
    authors="Átila Saraiva Quintela Soares",
    sitename="Flow.jl",
    format=Documenter.HTML(;
        canonical="https://AtilaSaraiva.github.io/Flow.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/AtilaSaraiva/Flow.jl",
    devbranch="main",
)
