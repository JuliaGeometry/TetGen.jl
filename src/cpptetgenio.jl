struct CPolygon
    vertexlist::Ptr{Cint}
    numberofvertices::Cint
end

struct CFacet{T}
    polygonlist::Ptr{CPolygon}
    numberofpolygons::Cint
    holelist::Ptr{T}
    numberofholes::Cint
end

struct CPPTetGenIO{T}
    firstnumber::Cint # 0 or 1, default 0.
    mesh_dim::Cint # must be 3.

    pointlist::Ptr{T}
    pointattributelist::Ptr{T}
    pointmtrlist::Ptr{T}

    pointmarkerlist::Ptr{Cint}
    numberofpoints::Cint
    numberofpointattributes::Cint
    numberofpointmtrs::Cint

    tetrahedronlist::Ptr{Cint}
    tetrahedronattributelist::Ptr{T}
    tetrahedronvolumelist::Ptr{T}
    neighborlist::Ptr{Cint}
    numberoftetrahedra::Cint
    numberofcorners::Cint
    numberoftetrahedronattributes::Cint

    facetlist::Ptr{CFacet{T}}
    facetmarkerlist::Ptr{Cint}
    numberoffacets::Cint

    holelist::Ptr{T}
    numberofholes::Cint

    regionlist::Ptr{T}
    numberofregions::Cint

    facetconstraintlist::Ptr{T}
    numberoffacetconstraints::Cint

    segmentconstraintlist::Ptr{T}
    numberofsegmentconstraints::Cint

    trifacelist::Ptr{Cint}
    trifacemarkerlist::Ptr{Cint}
    numberoftrifaces::Cint

    edgelist::Ptr{Cint}
    edgemarkerlist::Ptr{Cint}
    numberofedges::Cint
end

"""
   Error struct for TetGen
"""
struct TetGenError <: Exception
    rc::Cint
end

"""
   Show TetGen error, messages have been lifted
   from TetGen 
"""
function Base.show(io::IO, e::TetGenError)
    if e.rc == 1
        println(io, "TetGen error $(e.rc): out of memory.")
    elseif e.rc == 2
        println(io, "TetGen error $(e.rc): internal error.")
    elseif e.rc == 3
        println(io, "TetGen error $(e.rc): a self-intersection was detected. Hint: use -d option to detect all self-intersections.")
    elseif e.rc == 4
        println(io,
                "TetGen error $(e.rc): a very small input feature size was detected. Hint: use -T option to set a smaller tolerance.")
    elseif e.rc == 5
        println(io,
                "TetGen error $(e.rc): two very close input facets were detected. Hint: use -Y option to avoid adding Steiner points in boundary.\n")
    elseif e.rc == 10
        println(io, "TetGen error $(e.rc): an input error was detected.\n")
    elseif e.rc == 101
        println(io, "TetGen error: unable to load stl file\n")
    else
        println(io, "TetGen error $(e.rc): unknown error.\n")
    end
end

"""
$(SIGNATURES)

Tetrahedralization with error handling
"""
function tetrahedralize(input::CPPTetGenIO{Float64}, command::String)
    rc = Cint[0]
    output = ccall((:tetrahedralize2_f64, libtet),
                   CPPTetGenIO{Float64},
                   (CPPTetGenIO{Float64}, Cstring, Ptr{Cint}),
                   input,
                   command,
                   rc)
    if rc[1] != 0
        throw(TetGenError(rc[1]))
    end
    output
end

"""
   Trivial Julia tetunsuitable function
"""
my_jl_tetunsuitable = (pa, pb, pc, pd) -> 0

"""
   Tetunsuitable function called from C wrapper
"""
function jl_wrap_tetunsuitable(pa::Ptr{Float64}, pb::Ptr{Float64}, pc::Ptr{Float64}, pd::Ptr{Float64})
    pax = Base.unsafe_wrap(Array, pa, (3,); own = false)
    pbx = Base.unsafe_wrap(Array, pb, (3,); own = false)
    pcx = Base.unsafe_wrap(Array, pc, (3,); own = false)
    pdx = Base.unsafe_wrap(Array, pd, (3,); own = false)
    Cint(my_jl_tetunsuitable(pax, pbx, pcx, pdx))
end

"""
$(SIGNATURES)

Set tetunsuitable function called from C wrapper.
Setting this function is valid only for one subsequent call to tetrahedralize.
The function to be passed has the signature
```
unsuitable(p1::Vector{Float64},p2::Vector{Float64},p3::Vector{Float64},p4::Vector{Float64})::Bool
```
where `p1...p4` are 3-Vectors describing the corners of a tetrahedron, and the return value is `true` if
its volume is seen as too large.
   
"""
function tetunsuitable!(unsuitable::Function; check_signature = true)
    if check_signature
        retval = unsuitable(rand(3), rand(3), rand(3), rand(3))
        if !isa(retval, Bool)
            error("unsuitable function should return a Bool")
        end
    end
    global my_jl_tetunsuitable
    my_jl_tetunsuitable = unsuitable
    c_wrap_tetunsuitable = @cfunction(jl_wrap_tetunsuitable, Cint, (Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}))
    ccall((:tetunsuitable_callback, libtet), Cvoid, (Ptr{Cvoid},), c_wrap_tetunsuitable)
end
