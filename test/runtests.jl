using Flow
using Test

@testset "Flow.jl" begin
    counter = 1

    filePath, _ = mktemp()
    @flow path=filePath begin
        counter += 1
        write(path, "oi1")
    end

    @flow path=filePath begin
        counter += 1
    end

    rm(filePath)
    rm(filePath * ".hash")

    @test counter == 2
end
