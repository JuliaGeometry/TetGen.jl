module TetGen

const depsfile = joinpath(@__DIR__, "..", "deps", "deps.jl")

if isfile(depsfile)
    include(depsfile)
else
    error("Tetgen not build correctly. Please run Pkg.build(\"TetGen\")")
end

end # module
