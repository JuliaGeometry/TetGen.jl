module TetGen
using DocStringExtensions
using TetGen_jll
using Libdl


# Do this here as we appearantly cannot pin build numbers in [compat}
# At least we provide an error message here if this fails.
function __init__()
    lib=something(Libdl.dlopen_e(libtet,Libdl.RTLD_NOW),C_NULL)
    try
        sym = Libdl.dlsym(lib, :tetrahedralize2_f64)  
    catch err
        println(err)
        println("Ensure updating TetGen_jll to version 1.5.1+1")
        rethrow(err)
    end
end

using GeometryBasics
using GeometryBasics: Polygon, MultiPolygon, Point, LineFace, Polytope, Line,
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
export tetunsuitable
export TetGenError
export RawTetGenIO, facetlist!, RawFacet
export numberofpoints,numberoftetrahedra,numberoftrifaces,numberofedges
export volumemesh,surfacemesh

end # module
