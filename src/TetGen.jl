module TetGen

const depsfile = joinpath(@__DIR__, "..", "deps", "deps.jl")
using GeometryBasics
using GeometryBasics: Polygon, MultiPolygon, Point, LineFace, Polytope, Line, Simplex, connect, Triangle, NSimplex, Tetrahedron, TupleView, TriangleFace, SimplexFace, LineString, Mesh


if isfile(depsfile)
    include(depsfile)
else
    error("Tetgen not build correctly. Please run Pkg.build(\"TetGen\")")
end

function __init__()
    check_deps()
end

include("cppwrapper.jl")


function tetrahedralize(io::JLTetgenIO{Float64}, command::String)
    cres = ccall((:tetrahedralizef64, libtet), CPPTetgenIO{Float64}, (CPPTetgenIO{Float64}, Cstring), io, command)
    return convert(JLTetgenIO, cres)
end

function tetrahedralize(io::JLTetgenIO{Float32}, command::String)
    cres = ccall((:tetrahedralizef32, libtet), CPPTetgenIO{Float32}, (CPPTetgenIO{Float32}, Cstring), io, command)
    return convert(JLTetgenIO, cres)
end


export tetrahedralize

end # module
