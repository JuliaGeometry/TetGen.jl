module TetGen
using DocStringExtensions
using TetGen_jll

import GeometryBasics
using GeometryBasics: Polygon, MultiPolygon, Point, Point3f, LineFace, Polytope, Line,
                      Simplex, connect, Triangle, NSimplex, Tetrahedron,
                      TupleView, TriangleFace, SimplexFace, LineString, Mesh, TetrahedronP, TriangleP,
                      NgonFace, Ngon, faces, coordinates, metafree, meta, faces

using Printf

using StaticArrays

include("cpptetgenio.jl")
include("jltetgenio.jl")
include("rawtetgenio.jl")
include("meshes.jl")
include("api.jl")

export tetrahedralize
export tetunsuitable!, tetunsuitable
export TetGenError
export RawTetGenIO, facetlist!, RawFacet
export numberofpoints, numberoftetrahedra, numberoftrifaces, numberofedges
export volumemesh, surfacemesh

end # module
