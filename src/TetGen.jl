"""
    TetGen

$(read(joinpath(@__DIR__,"..","README.md"),String))
"""
module TetGen
using DocStringExtensions: DocStringExtensions, SIGNATURES, TYPEDEF,
                           TYPEDFIELDS, TYPEDSIGNATURES
import GeometryBasics
using GeometryBasics: Point, Point3f, LineFace, Polytope, Triangle,
                      TriangleFace, SimplexFace, Mesh, Tetrahedron, Triangle,
                      NgonFace, faces, coordinates

using Printf: Printf
using StaticArrays: StaticArrays, SVector
using TetGen_jll: TetGen_jll, libtet

include("cpptetgenio.jl")
include("jltetgenio.jl")
include("rawtetgenio.jl")
include("meshes.jl")
include("api.jl")

export tetrahedralize
export tetunsuitable!
export TetGenError
export RawTetGenIO, facetlist!, RawFacet
export numberofpoints, numberoftetrahedra, numberoftrifaces, numberofedges
export volumemesh, surfacemesh

end # module
