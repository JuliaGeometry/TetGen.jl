module TetGen
using TetGen_jll

using GeometryBasics
using GeometryBasics: Polygon, MultiPolygon, Point, LineFace, Polytope, Line,
    Simplex, connect, Triangle, NSimplex, Tetrahedron,
    TupleView, TriangleFace, SimplexFace, LineString, Mesh, TetrahedronP, TriangleP,
    NgonFace, Ngon, faces, coordinates, metafree, meta, faces

using StaticArrays


include("cppwrapper.jl")
include("meshes.jl")
include("api.jl")


export tetrahedralize

end # module
