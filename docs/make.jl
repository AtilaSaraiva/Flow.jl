using FlowLock
using Documenter

DocMeta.setdocmeta!(FlowLock, :DocTestSetup, :(using FlowLock); recursive=true)

makedocs(;
    modules=[FlowLock],
    authors="Átila Saraiva Quintela Soares",
    sitename="FlowLock.jl",
    format=Documenter.HTML(;
        canonical="https://AtilaSaraiva.github.io/FlowLock.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/AtilaSaraiva/FlowLock.jl",
    devbranch="main",
)
