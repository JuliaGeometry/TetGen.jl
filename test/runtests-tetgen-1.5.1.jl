push!(LOAD_PATH, "@v#.#", "@stdlib")
using Pkg
Pkg.activate(; temp = true)
Pkg.add("GeometryBasics")
Pkg.add(name = "TetGen_jll", version = "1.5.4")
Pkg.develop(path = joinpath(@__DIR__, ".."))
using Test
@testset "tetgen 1.5.1" begin
    include("tetgentests.jl")
end
