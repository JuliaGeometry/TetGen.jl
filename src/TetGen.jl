module TetGen
using DocStringExtensions
using TetGen_jll
using GeometryBasics
using GeometryBasics: Polygon, MultiPolygon, Point, LineFace, Polytope, Line,
    Simplex, connect, Triangle, NSimplex, Tetrahedron,
    TupleView, TriangleFace, SimplexFace, LineString, Mesh, TetrahedronP, TriangleP,
    NgonFace, Ngon, faces, coordinates, metafree, meta, faces

using StaticArrays


include("cpptetgenio.jl")
include("jltetgenio.jl")
include("rawtetgenio.jl")
include("meshes.jl")
include("api.jl")


export tetrahedralize
export RawTetGenIO, facetlist!, RawFacet
export numberofpoints,numberoftetrahedra,numberoftrifaces,numberofedges
export volumemesh,surfacemesh

end # module
