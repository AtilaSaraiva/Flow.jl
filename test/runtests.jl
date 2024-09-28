using FlowLock
using Test

@testset "FlowLock.jl" begin
    counter = 1

    path = "this should not change"

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
    @test path == "this should not change"
end
