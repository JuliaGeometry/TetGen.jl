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

tetrahedralize(input::CPPTetGenIO{Float64}, command::String)=ccall((:tetrahedralizef64, libtet), CPPTetGenIO{Float64}, (CPPTetGenIO{Float64}, Cstring), input, command)

