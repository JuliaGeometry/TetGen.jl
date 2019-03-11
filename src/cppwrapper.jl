

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

struct JLPolygon
    vertexlist::Vector{Cint}
end

struct JLFacet{T}
    polygons::Vector{JLPolygon}
    holelist::Vector{T}
end
JLFacet(x::JLPolygon) = JLFacet([x])
JLFacet(x::Vector{JLPolygon}) = JLFacet{Float64}(x, Float64[])


function JLPolygon(x::CPolygon)
    JLPolygon(unsafe_wrap(Array, x.vertexlist, x.numberofvertices, own = true))
end

function JLFacet(f::CFacet{T}) where T
    c_polys = unsafe_wrap(Array, f.polygonlist, f.numberofpolygons, own = true)
    holes = unsafe_wrap(Array, f.holelist, f.numberofholes, own = true)
    JLFacet{T}(JLPolygon.(c_polys), holes)
end


function Base.cconvert(::Type{CFacet{T}}, facets::JLFacet{T}) where T
    polygons = map(facets.polygons) do poly
        Base.cconvert(CPolygon, poly)
    end
    fptr, fn = vec_convert(CPolygon, polygons)
    hptr, hn = vec_convert(T, facets.holelist)
    return CFacet{T}(fptr, fn, hptr, hn)
end

function Base.cconvert(::Type{CPolygon}, p::JLPolygon)
    vptr, vn = vec_convert(Cint, p.vertexlist)
    return CPolygon(vptr, vn)
end

struct Region{T}
    pos::Point{3, T}
    attribute::T
    maxvol::T
end

struct FacetConstraint{IT, T}
    facet_marker::IT
    max_area_bound::T
end
struct SegmentationConstraint{IT, T}
    index::IT # index into pointlist
    max_length_bound::T
end


struct CPPTetgenIO{T}

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



inttype(::Type{Float64}) = Int64
inttype(::Type{Float32}) = Int32

struct TetgenIO{T, NSimplex, NAttributes, NMTr, IT}
    points::Vector{Point{3, T}}
    pointattributes::Vector{NTuple{NAttributes, T}}
    pointmtrs::Vector{NTuple{NMTr, T}}
    pointmarkers::Vector{Cint}

    tetrahedra::Vector{SimplexFace{NSimplex, Cint}}
    tetrahedronattributes::Vector{T}
    tetrahedronvolumes::Vector{T}
    neighbors::Vector{Cint}

    facets::Vector{JLFacet{T}}
    facetmarkers::Vector{Cint}

    holes::Vector{Point{3, T}}

    regions::Vector{Region{T}}

    facetconstraints::Vector{FacetConstraint{IT, T}}

    segmentconstraints::Vector{SegmentationConstraint{IT, T}}

    trifaces::Vector{TriangleFace{Cint}}
    trifacemarkers::Vector{Cint}

    edges::Vector{LineFace{Cint}}
    edgemarkers::Vector{Cint}

    function TetgenIO(
            points::Vector{Point{3, T}},
            pointattributes::Vector{NTuple{NAttributes, T}},
            pointmtrs::Vector{NTuple{NMTr, T}},
            pointmarkers::Vector{Cint},
            tetrahedrons::Vector{SimplexFace{NSimplex, Cint}},
            tetrahedronattributes::Vector{T},
            tetrahedronvolumes::Vector{T},
            neighbors::Vector{Cint},
            facets::Vector{JLFacet{T}},
            facetmarkers::Vector{Cint},
            holes::Vector{Point{3, T}},
            regions::Vector{Region{T}},
            facetconstraints::Vector{FacetConstraint{IT, T}},
            segmentconstraints::Vector{SegmentationConstraint{IT, T}},
            trifaces::Vector{TriangleFace{Cint}},
            trifacemarkers::Vector{Cint},
            edges::Vector{LineFace{Cint}},
            edgemarkers::Vector{Cint},
        ) where {T, NSimplex, NAttributes, NMTr, IT}


        new{T, NSimplex, NAttributes, NMTr, IT}(
            points,
            pointattributes,
            pointmtrs,
            pointmarkers,
            tetrahedrons,
            tetrahedronattributes,
            tetrahedronvolumes,
            neighbors,
            facets,
            facetmarkers,
            holes,
            regions,
            facetconstraints,
            segmentconstraints,
            trifaces,
            trifacemarkers,
            edges,
            edgemarkers,
        )
    end

end

function TetgenIO(
        points::Vector{Point{3, T}};
        pointattributes = NTuple{0, T}[],
        pointmtrs = NTuple{0, T}[],
        pointmarkers = Cint[],
        tetrahedrons = SimplexFace{4, Cint}[],
        tetrahedronattributes = T[],
        tetrahedronvolumes = T[],
        neighbors = Cint[],
        facets = JLFacet{T}[],
        facetmarkers = Cint[],
        holes = Point{3, T}[],
        regions = Region{T}[],
        facetconstraints = FacetConstraint{inttype(T), T}[],
        segmentconstraints = SegmentationConstraint{inttype(T), T}[],
        trifaces = TriangleFace{Cint}[],
        trifacemarkers = Cint[],
        edges = LineFace{Cint}[],
        edgemarkers = Cint[]

    ) where T
    TetgenIO(
        points,
        pointattributes,
        pointmtrs,
        pointmarkers,
        tetrahedrons,
        tetrahedronattributes,
        tetrahedronvolumes,
        neighbors,
        facets,
        facetmarkers,
        holes,
        regions,
        facetconstraints,
        segmentconstraints,
        trifaces,
        trifacemarkers,
        edges,
        edgemarkers,
    )

end


function number_of_elements_field(io, basename)
    nfield = if basename == "tetrahedra"
        Symbol("numberof" * basename)
    else
        Symbol("numberof" * basename * "s")
    end
    n = if nfield in fieldnames(typeof(io))
        return nfield
    elseif startswith(basename, "point")
        return :numberofpoints
    elseif startswith(basename, "facet")
        return :numberoffacets
    elseif startswith(basename, "triface")
        return :numberoftrifaces
    elseif startswith(basename, "edge")
        return :numberofedges
    else
        error("No numberof for $nfield")
    end
end

function get_array(io, field::Symbol, Typ)
    basename = if field == :tetrahedra
        string(field)
    else
        string(field)[1:end-1] # cut of s
    end
    ptr = if field == :tetrahedra
        io.tetrahedronlist
    else
        getfield(io, Symbol(basename * "list"))
    end
    ptr == C_NULL && return Typ[]
    n = getfield(io, number_of_elements_field(io, basename))
    # own true, since we disable freeing in the c-part
    return unsafe_wrap(Array, Base.unsafe_convert(Ptr{Typ}, ptr), n, own = true)
end

function Base.convert(
        IOT::Type{TetgenIO{T, NSimplex, NAttributes, NMTr, IT}}, io::CPPTetgenIO{T}
    ) where {T, NSimplex, NAttributes, NMTr, IT}
    TetgenIO(ntuple(fieldcount(IOT)) do i
        fname, ftype = fieldname(IOT, i), fieldtype(IOT, i)
        get_array(io, fname, eltype(ftype))
    end...)
end

function Base.convert(::Type{TetgenIO}, io::CPPTetgenIO{T}) where T
    NSimplex = Int(io.numberofcorners)
    NAttributes = Int(io.numberofpointattributes)
    NMTr = Int(io.numberofpointmtrs)
    IT = inttype(T) # TODO these are indices,
    convert(TetgenIO{T, NSimplex, NAttributes, NMTr, IT}, io)
end


"""
This needs to be a macro to be safe (I think :D)
"""
function vec_convert(::Type{T1}, vector::Vector{T2}) where {T1, T2}
    @assert sizeof(T2) % sizeof(T1) == 0 "type mismatch for $T1 and $T2"
    if isempty(vector)
        Ptr{T1}(C_NULL), Cint(0)
    else
        Base.unsafe_convert(Ptr{T1}, Base.cconvert(Ptr{T2}, vector)), Cint(length(vector))
    end
end

"""
This needs to be a macro to be safe (I think :D)
"""
function vec_convert(::Type{T1}, vector::Vector{JLFacet{T2}}) where {T1, T2}
    isempty(vector) && return (Ptr{CFacet{T2}}(C_NULL), Cint(0))
    x = Base.cconvert.(CFacet{T2}, vector)
    vec_convert(T1, x)
end


function Base.cconvert(CIO::Type{CPPTetgenIO{ELT}}, obj::TetgenIO{ELT, NSimplex, NAttributes, NMTr, IT}) where {ELT, NSimplex, NAttributes, NMTr, IT}
    cfnames = fieldnames(CIO)
    dict = Dict{Symbol, Any}()
    for field in fieldnames(typeof(obj))
        basename = if field == :tetrahedra
            string(field)
        else
            string(field)[1:end-1] # cut of s
        end
        listname = Symbol(replace(basename * "list", "tetrahedra" => "tetrahedron"))
        listtype = fieldtype(CIO, listname)
        T = eltype(listtype)
        ptr, nelements = vec_convert(T, getfield(obj, field))
        dict[listname] = ptr

        nfield = if basename == "tetrahedra"
            Symbol("numberof" * basename)
        else
            Symbol("numberof" * basename * "s")
        end
        if nfield in cfnames
            dict[nfield] = nelements
        end
    end
    dict[:firstnumber] = Cint(1)
    dict[:mesh_dim] = Cint(3)

    dict[:numberofpointattributes] = NAttributes
    dict[:numberofpointmtrs] = NMTr
    dict[:numberofcorners] = NSimplex

    return CPPTetgenIO{ELT}(
        (dict[field] for field in cfnames)...
    )
end
