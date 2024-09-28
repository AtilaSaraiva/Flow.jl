# FlowLock

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://AtilaSaraiva.github.io/FlowLock.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://AtilaSaraiva.github.io/FlowLock.jl/dev/)
[![Build Status](https://github.com/AtilaSaraiva/FlowLock.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/AtilaSaraiva/FlowLock.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/AtilaSaraiva/FlowLock.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/AtilaSaraiva/FlowLock.jl)

This packages provides a macro called `@flow` that wraps a piece of code that creates a file and only runs the code if the file is missing or changed.

Here is a snippet of how it works:

```julia
julia> using FlowLock

julia> filePath, _ = mktemp();

julia> @flow path=filePath begin
           println("This should only show once")
           write(filePath, "some random text")
       end
This should only show once
64

julia> @flow path=filePath begin
           println("This should only show once")
           write(filePath, "some random text")
       end
```

## How it works

The macro `@flow` prepends some code to check if the `path` file already exists and if its sha256 sum and the hash stored in a another file. If it matches, the piece of code passed to the macro is not ran. If doesn't match the piece of code is ran and afterwards creates with the same path as the `path` file but with the suffix ".hash".
This file contains the sha256 sum hash encoding of the output file.
