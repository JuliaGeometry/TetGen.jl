"""
A  "polygon"  describes  a  simple  polygon  (no  holes).  It  is  not
necessarily convex. Each polygon contains a number of corners (points)
and the same number of sides  (edges).  The points of the polygon must
be given in either counterclockwise or clockwise order and they form a
ring, so every two consecutive points forms an edge of the polygon.
"""
struct RawPolygon
    vertexlist::Array{Cint,2}
end

"""
A "facet" describes a polygonal region possibly with holes, edges, and
points floating in it.  Each facet  consists of a list of polygons and
a list of hole points (which lie strictly inside holes).
"""
struct RawFacet{T}
    polygonlist::Array{RawPolygon,1}
    holelist::Array{T,2}
end


mutable struct RawTetGenIO{T}
    """
    'pointlist':  An array of point coordinates.  The first point's x
     coordinate is at index [0] and its y coordinate at index [1], its
     z coordinate is at index [2], followed by the coordinates of the
     remaining points.  Each point occupies three REALs. 
    """
    pointlist::Array{T,2}

    """
    'pointattributelist':  An array of point attributes.  Each point's
    attributes occupy 'numberofpointattributes' REALs.
    """
    pointattributelist::Array{T,2}

    """
    'pointmtrlist': An array of metric tensors at points. Each point'
     tensor occupies 'numberofpointmtr' REALs.
    """
    pointmtrlist::Array{T,2}

    """
    'pointmarkerlist':  An array of point markers; one integer per point.
    """
    pointmarkerlist::Array{T,2}

    """
    'tetrahedronlist':  An array of tetrahedron corners.  The first 
    tetrahedron's first corner is at index [0], followed by its other 
    corners, followed by six nodes on the edges of the tetrahedron if the
    second order option (-o2) is applied. Each tetrahedron occupies
    'numberofcorners' ints.  The second order nodes are ouput only. 
    """
    tetrahedronlist::Array{Cint,2}

    """
    'tetrahedronattributelist':  An array of tetrahedron attributes.  Each
    tetrahedron's attributes occupy 'numberoftetrahedronattributes' REALs.
    """
    tetrahedronattributelist::Array{T,2}

    """
    'tetrahedronvolumelist':  An array of constraints, i.e. tetrahedron's
     volume; one REAL per element.  Input only.
    """
    tetrahedronvolumelist::Array{T,1}

    """
    'neighborlist':  An array of tetrahedron neighbors; 4 ints per element. 
     Output only.
    """
    neighborlist::Array{Cint,2}

    """
    'facetlist':  An array of facets.  Each entry is a structure of facet.
    """
    facetlist::Array{RawFacet{T},1}

    """
    'facetmarkerlist':  An array of facet markers; one int per facet.
    """
    facetmarkerlist::Array{Cint,1}

    """
    'holelist':  An array of holes (in volume).  Each hole is given by a
     seed (point) which lies strictly inside it. The first seed's x, y and z
     coordinates are at indices [0], [1] and [2], followed by the
     remaining seeds.  Three REALs per hole. 
    """
    holelist::Array{T,2}

    """
     'regionlist': An array of regions (subdomains).  Each region is given by
     a seed (point) which lies strictly inside it. The first seed's x, y and
     z coordinates are at indices [0], [1] and [2], followed by the regional
     attribute at index [3], followed by the maximum volume at index [4]. 
     Five REALs per region.

      Note that each regional attribute is used only if you select the 'A'
     switch, and each volume constraint is used only if you select the
     'a' switch (with no number following).
    """
    regionlist::Array{T,2}

    """
    'facetconstraintlist':  An array of facet constraints.  Each constraint
    specifies a maximum area bound on the subfaces of that facet.  The
    first facet constraint is given by a facet marker at index [0] and its
    maximum area bound at index [1], followed by the remaining facet con-
    straints. Two REALs per facet constraint.  Note: the facet marker is
    actually an integer.
    """
    facetconstraintlist::Array{T,2}

    """
    'segmentconstraintlist': An array of segment constraints. Each constraint 
    specifies a maximum length bound on the subsegments of that segment.
    The first constraint is given by the two endpoints of the segment at
    index [0] and [1], and the maximum length bound at index [2], followed
    by the remaining segment constraints.  Three REALs per constraint. 
    Note the segment endpoints are actually integers.
    """
    segmentconstraintlist::Array{T,2}

    """
    'trifacelist':  An array of face (triangle) corners.  The first face's
    three corners are at indices [0], [1] and [2], followed by the remaining
    faces.  Three ints per face.
    """
    trifacelist::Array{Cint,2}

    """
    'trifacemarkerlist':  An array of face markers; one int per face.
    """
    trifacemarkerlist::Array{Cint,1}

    """
    'edgelist':  An array of edge endpoints.  The first edge's endpoints
    are at indices [0] and [1], followed by the remaining edges.
    Two ints per edge.
    """
    edgelist::Array{Cint,2}

    """
    'edgemarkerlist':  An array of edge markers; one int per edge.
    """
    edgemarkerlist::Array{Cint}
end

function RawTetGenIO{T}(;
                        pointlist=Array{T,2}(undef,0,0),
                        pointattributelist=Array{T,2}(undef,0,0),
                        pointmtrlist=Array{T,2}(undef,0,0),
                        pointmarkerlist=Array{T,2}(undef,0,0),
                        tetrahedronlist=Array{Cint,2}(undef,0,0),
                        tetrahedronattributelist=Array{T,2}(undef,0,0),
                        tetrahedronvolumelist=Array{T,1}(undef,0),
                        neighborlist=Array{Cint,2}(undef,0,0),
                        facetlist=Array{RawFacet{T},1}(undef,0),
                        facetmarkerlist=Array{Cint,1}(undef,0),
                        holelist=Array{T,2}(undef,0,0),
                        regionlist=Array{T,2}(undef,0,0),
                        facetconstraintlist=Array{T,2}(undef,0,0),
                        segmentconstraintlist=Array{T,2}(undef,0,0),
                        trifacelist=Array{Cint,2}(undef,0,0),
                        trifacemarkerlist=Array{Cint,1}(undef,0),
                        edgelist=Array{Cint,2}(undef,0,0),
                        edgemarkerlist=Array{Cint}(undef,0)
                        ) where T
    
    RawTetGenIO{T}(
        pointlist,
        pointattributelist,
        pointmtrlist,
        pointmarkerlist,
        tetrahedronlist,
        tetrahedronattributelist,
        tetrahedronvolumelist,
        neighborlist,
        facetlist,
        facetmarkerlist,
        holelist,
        regionlist,
        facetconstraintlist,
        segmentconstraintlist,
        trifacelist,
        trifacemarkerlist,
        edgelist,
        edgemarkerlist
    )
end

function Base.show(io::IO, tio::RawTetGenIO)
    nonempty(a)=size(a,ndims(a))>0
    println(io,"RawTetGenIO(")
    for name in fieldnames(typeof(tio))
        a=getfield(tio,name)
        if nonempty(a)
            print(io,"$(name)=")
            print(io,a)
            println(io,",")
        end
    end
    println(io,")")
end


function CPPTetGenIO(tio::RawTetGenIO{T}) where T
    
    # Set dummy defaults
    firstnumber = zero(Cint) 
    mesh_dim = zero(Cint) 
    
    pointlist = C_NULL
    pointattributelist = C_NULL
    pointmtrlist = C_NULL

    pointmarkerlist = C_NULL
    numberofpoints = zero(Cint)
    numberofpointattributes = zero(Cint)
    numberofpointmtrs = zero(Cint)

    tetrahedronlist = C_NULL
    tetrahedronattributelist = C_NULL
    tetrahedronvolumelist = C_NULL

    neighborlist = C_NULL
    numberoftetrahedra = zero(Cint)
    numberofcorners = zero(Cint)
    numberoftetrahedronattributes = zero(Cint)

    facetlist =  C_NULL
    facetmarkerlist = C_NULL
    numberoffacets = zero(Cint)

    holelist = C_NULL
    numberofholes = zero(Cint)

    regionlist = C_NULL
    numberofregions = zero(Cint)

    facetconstraintlist = C_NULL
    numberoffacetconstraints = zero(Cint)

    segmentconstraintlist = C_NULL
    numberofsegmentconstraints = zero(Cint)

    trifacelist = C_NULL
    trifacemarkerlist = C_NULL
    numberoftrifaces = zero(Cint)

    edgelist = C_NULL
    edgemarkerlist = C_NULL
    numberofedges = zero(Cint)

    # Override defaults
    numberofpoints=size(tio.pointlist,2)
    @assert numberofpoints>zero(Cint)
    @assert size(tio.pointlist,1) == 3
    pointlist=pointer(tio.pointlist)

    numberofpointattributes=size(tio.pointattributelist,1)
    if numberofpointattributes>0
        @assert size(tio.pointattributelist,2)==numberofpoints
        pointattributelist=pointer(tio.pointattributelist)
    end

    numberofpointmtrs=size(tio.pointmtrlist,1)
    if numberofpointmtrs>0
        @assert size(tio.pointmtrlist,2)==numberofpoints
        pointmtrlist=pointer(tio.pointmtrlist)
    end
    
    numberoftetrahedra=size(tio.tetrahedronlist,2)
    if numberoftetrahedra>0
        tetrahedronlist=pointer(tio.tetrahedronlist)
        numberoftetrahedronattributes=size(tio.tetrahedronattributelist,1)
        numberofcorners=size(tio.tetrahedronlist,1)
        if numberoftetrahedronattributes>0
            @assert size(tio.tetrahedronattributelist,2)==numberoftetrahedra
            tetrahedronattributes=pointer(tio.tetrahedronattributes)
        end
        if size(tio.tetrahedronvolumelist,1)>0
            @assert size(tio.tetrahedronvolumelist,1)==numberoftetrahedra
            tetrahedronvolumelist=pointer(tio.tetrahedronvolumelist)
        end
    end

    numberoffacets=size(tio.facetlist,2)
    if numberoffacets>0
        facetlist=pointer(tio.facetlist)
    end
    if size(tio.facetmarkerlist,1)>0
        @assert size(tio.facetmarkerlist,1)==numberoffacets
        facetmarkerlist=pointer(tio.facetmarkerlist)
    end

    numberofholes=size(tio.holelist,2)
    if numberofholes>0
        @assert size(tio.holelist,1)==3
        holelist=pointer(tio.holelist)
    end
    
    numberofregions=size(tio.regionlist,2)
    if numberofregions>0
        @assert size(tio.regionlist,1)==5 # coord+attribute + volume
        regionlist=pointer(tio.regionlist)
    end

    if size(tio.facetconstraintlist,2)>0
        @assert size(tio.facetconstraintlist,1) == 2
        numberoffacetconstraints=size(tio.facetconstraintlist,2)
        facetconstraintlist=pointer(tio.facetconstraintlist)
    end

    if size(tio.segmentconstraintlist,2)>0
        @assert size(tio.segmentconstraintlist,1) == 3
        numberofsegmentconstraints=size(tio.segmentconstraintlist,2)
        segmentconstraintlist=pointer(tio.segmentconstraintlist)
    end

    if size(tio.trifacelist,2)>0
        @assert size(tio.trifacelist,1) == 3
        numberoftrifaces=size(tio.trifacelist,2)
        trifacelist=pointer(tio.trifacelist)
        if size(tio.trifacemarkerlist,1) > 0
            @assert size(tio.trifacemarkerlist,1) == numberoftrifaces
            trifacemarkerlist=pointer(tio.trifacemarkerlist)
        end            
    end
    
    if size(tio.edgelist,2)>0
        @assert size(tio.edgelist,1) == 2
        numberofedges=size(tio.edgelist,2)
        edgelist=pointer(tio.edgelist)
        if size(tio.edgemarkerlist,1) > 0
            @assert size(tio.edgemarkerlist,1) == numberofedges
            edgemarkerlist=pointer(tio.edgemarkerlist)
        end            
    end
    
    
    # Convert
    CPPTetGenIO{T}(firstnumber,
                   mesh_dim,
                   pointlist,
                   pointattributelist,
                   pointmtrlist,
                   pointmarkerlist,
                   numberofpoints,
                   numberofpointattributes,
                   numberofpointmtrs,
                   tetrahedronlist,
                   tetrahedronattributelist,
                   tetrahedronvolumelist,
                   neighborlist,
                   numberoftetrahedra,
                   numberofcorners,
                   numberoftetrahedronattributes,
                   facetlist,
                   facetmarkerlist,
                   numberoffacets,
                   holelist,
                   numberofholes,
                   regionlist,
                   numberofregions,
                   facetconstraintlist,
                   numberoffacetconstraints,
                   segmentconstraintlist,
                   numberofsegmentconstraints,
                   trifacelist,
                   trifacemarkerlist,
                   numberoftrifaces,
                   edgelist,
                   edgemarkerlist,
                   numberofedges)
end
