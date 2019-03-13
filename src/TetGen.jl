module TetGen

const depsfile = joinpath(@__DIR__, "..", "deps", "deps.jl")
using GeometryBasics
using GeometryBasics: Polygon, MultiPolygon, Point, LineFace, Polytope, Line,
    Simplex, connect, Triangle, NSimplex, Tetrahedron,
    TupleView, TriangleFace, SimplexFace, LineString, Mesh, TetrahedronP, TriangleP,
    NgonFace, Ngon, faces, coordinates, metafree, meta, faces, getcolumn, hascolumn

using StaticArrays

if isfile(depsfile)
    include(depsfile)
else
    error("Tetgen not build correctly. Please run Pkg.build(\"TetGen\")")
end

function __init__()
    check_deps()
end

include("cppwrapper.jl")
include("meshes.jl")
include("api.jl")


export tetrahedralize

end # module
