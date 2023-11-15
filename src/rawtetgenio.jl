"""
$(TYPEDEF)

A complex facet as part to the input to TetGen.

$(TYPEDFIELDS)
"""
struct RawFacet{T}
    """
    Polygons given as arrays of indices which point into the 
    pointlist array describing the input points.
    """
    polygonlist::Array{Array{Cint, 1}, 1}

    """
    Array of points given by their coordinates
    marking polygons describing holes in the facet.
    """
    holelist::Array{T, 2}
end

"""
$(TYPEDEF)

A  structure for  transferring  data  into and  out  of TetGen's
internal representation.
                                                                           
The input of TetGen is either a 3D point set, or a 3D piecewise linear
complex (PLC), or  a tetrahedral mesh.  Depending on  the input object
and the specified  options, the output of TetGen is  either a Delaunay
(or weighted Delaunay) tetrahedralization, or a constrained (Delaunay)
tetrahedralization, or a quality tetrahedral mesh.
                                                                           
A piecewise  linear complex  (PLC) represents  a 3D  polyhedral domain
with  possibly internal  boundaries(subdomains). It  is introduced  in
[Miller  et al,  1996].   Basically  it is  a  set  of "cells",  i.e.,
vertices, edges, polygons, and polyhedra,  and the intersection of any
two of its cells is the union of other cells of it.
                                                                           
The 'RawTetGenIO' structure  is a collection of arrays  of data, i.e.,
points, facets, tetrahedra,  and so forth. All data  are compatible to
the representation in C++ and can be used without copying.


$(TYPEDFIELDS)
"""
mutable struct RawTetGenIO{T}
    """
    'pointlist':  Array of point coordinates with `size(pointlist,1)==3`.
    """
    pointlist::Array{T, 2}

    """
    'pointattributelist':  Array of point attributes. The number of 
     attributes per point is determined by  `size(pointattributelist,1)`
    """
    pointattributelist::Array{T, 2}

    """
    'pointmtrlist': An array of metric tensors at points.
    """
    pointmtrlist::Array{T, 2}

    """
    'pointmarkerlist':  An array of point markers; one integer per point.
    """
    pointmarkerlist::Array{Cint, 1}

    """ 'tetrahedronlist': An array of tetrahedron corners represented
    by indices of points in `pointlist`. Unless option `-o2` is given,
    one has  `size(tetrahedronlist,1)==4`, i.e. each  column describes
    the    four     corners    of    a     tetrahedron.     Otherwise,
    `size(tetrahedronlist,1)==10` and the 4  corners are followed by 6
    edge midpoints.  
    """
    tetrahedronlist::Array{Cint, 2}

    """
    'tetrahedronattributelist':  An array of tetrahedron attributes.
    """
    tetrahedronattributelist::Array{T, 2}

    """
    'tetrahedronvolumelist':  An array of constraints, i.e. tetrahedron's
     volume;  Input only. This can be used for triggering local refinement.
    """
    tetrahedronvolumelist::Array{T, 1}

    """
    'neighborlist':  An array of tetrahedron neighbors; 4 ints per element. 
     Output only.
    """
    neighborlist::Array{Cint, 2}

    """
    'facetlist':  An array of facets.  Each entry is a structure of facet.
    """
    facetlist::Array{RawFacet{T}, 1}

    """
    'facetmarkerlist':  An array of facet markers; one int per facet.
    """
    facetmarkerlist::Array{Cint, 1}

    """
    'holelist':  An array of holes (in volume).  Each hole is given by a
     point which lies strictly inside it.
    """
    holelist::Array{T, 2}

    """
     'regionlist': An array of regions (subdomains).  Each region is given by
     a seed (point) which lies strictly inside it. For each column,
     the point coordinates ade  at indices [1], [2] and [3], followed by the regional
     attribute at index [4], followed by the maximum volume at index [5]. 

     ote that each regional attribute is used only if you select the 'A'
     switch, and each volume constraint is used only if you select the
     'a' switch (with no number following).
    """
    regionlist::Array{T, 2}

    """
    'facetconstraintlist':  An array of facet constraints.  Each constraint
    specifies a maximum area bound on the subfaces of that facet.  Each column
    contains  a facet marker at index [1] and its
    maximum area bound at index [2]. Note: the facet marker is
    actually an integer.
    """
    facetconstraintlist::Array{T, 2}

    """
    'segmentconstraintlist': An array of segment constraints. Each constraint 
    specifies a maximum length bound on the subsegments of that segment.
    Each columb consists of the  two endpoints of the segment at
    index [1] and [2], and the maximum length bound at index [3].
    Note the segment endpoints are actually integers.
    """
    segmentconstraintlist::Array{T, 2}

    """
    'trifacelist':  An array of face (triangle) corners.
    """
    trifacelist::Array{Cint, 2}

    """
    'trifacemarkerlist':  An array of face markers; one int per face.
    """
    trifacemarkerlist::Array{Cint, 1}

    """
    'edgelist':  An array of edge endpoints.
    """
    edgelist::Array{Cint, 2}

    """
    'edgemarkerlist':  An array of edge markers.
    """
    edgemarkerlist::Array{Cint}
end

"""
$(TYPEDSIGNATURES)

Create RawTetGenIO structure with empty data.
"""
function RawTetGenIO{T}(;
                        pointlist = Array{T, 2}(undef, 0, 0),
                        pointattributelist = Array{T, 2}(undef, 0, 0),
                        pointmtrlist = Array{T, 2}(undef, 0, 0),
                        pointmarkerlist = Array{Cint, 1}(undef, 0),
                        tetrahedronlist = Array{Cint, 2}(undef, 0, 0),
                        tetrahedronattributelist = Array{T, 2}(undef, 0, 0),
                        tetrahedronvolumelist = Array{T, 1}(undef, 0),
                        neighborlist = Array{Cint, 2}(undef, 0, 0),
                        facetlist = Array{RawFacet{T}, 1}(undef, 0),
                        facetmarkerlist = Array{Cint, 1}(undef, 0),
                        holelist = Array{T, 2}(undef, 0, 0),
                        regionlist = Array{T, 2}(undef, 0, 0),
                        facetconstraintlist = Array{T, 2}(undef, 0, 0),
                        segmentconstraintlist = Array{T, 2}(undef, 0, 0),
                        trifacelist = Array{Cint, 2}(undef, 0, 0),
                        trifacemarkerlist = Array{Cint, 1}(undef, 0),
                        edgelist = Array{Cint, 2}(undef, 0, 0),
                        edgemarkerlist = Array{Cint}(undef, 0)) where {T}
    RawTetGenIO{T}(pointlist,
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
                   edgemarkerlist)
end

function Base.show(io::IO, tio::RawTetGenIO)
    nonempty(a) = size(a, ndims(a)) > 0
    println(io, "RawTetGenIO(")
    print(io, "numberofpoints=")
    print(io, numberofpoints(tio))
    println(io, ",")
    print(io, "numberofedges=")
    print(io, numberofedges(tio))
    println(io, ",")
    print(io, "numberoftrifaces=")
    print(io, numberoftrifaces(tio))
    println(io, ",")
    print(io, "numberoftetrahedra=")
    print(io, numberoftetrahedra(tio))
    println(io, ",")
    for name in fieldnames(typeof(tio))
        #        a=round.(getfield(tio,name),sigdigits=3)'
        a = getfield(tio, name)
        if nonempty(a)
            print(io, "$(name)'=")
            print(io, a)
            println(io, ",")
        end
    end
    println(io, ")")
end

"""
    $(TYPEDSIGNATURES)
    Set list of input facets from AbstractMatrix desribing polygons of the same
    size (e.g. triangles)
"""
function facetlist!(tio::RawTetGenIO{T}, facets::AbstractMatrix) where {T}
    numberoffacets = size(facets, 2)
    tio.facetlist = Array{RawFacet{T}, 1}(undef, numberoffacets)
    for ifacet = 1:numberoffacets
        tio.facetlist[ifacet] = RawFacet{T}([Vector{Cint}(facets[:, ifacet])], Array{T, 2}(undef, 0, 0))
    end
    tio
end

"""
    $(TYPEDSIGNATURES)
    Set list of input facets from a vector of polygons of different size
"""
function facetlist!(tio::RawTetGenIO{T}, facets::Vector) where {T}
    numberoffacets = size(facets, 1)
    tio.facetlist = Array{RawFacet{T}, 1}(undef, numberoffacets)
    for ifacet = 1:numberoffacets
        tio.facetlist[ifacet] = RawFacet{T}([Vector{Cint}(facets[ifacet])], Array{T, 2}(undef, 0, 0))
    end
    tio
end

#
# Create CPPTetGenIO from RawTetGenIO
#
function CPPTetGenIO(tio::RawTetGenIO{T}) where {T}
    firstnumber = 1
    mesh_dim = 3

    # Set dummy defaults
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

    facetlist = C_NULL
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

    # these need to be returned in order
    # to prevent their content  from being garbage collected
    facetlist_array = Array{CFacet{T}, 1}(undef, numberoffacets)
    polygonlist_array = Array{Array{CPolygon, 1}, 1}(undef, 0)

    # Override defaults
    numberofpoints = size(tio.pointlist, 2)
    @assert numberofpoints > zero(Cint)
    @assert size(tio.pointlist, 1) == 3
    pointlist = pointer(tio.pointlist)

    numberofpointattributes = size(tio.pointattributelist, 1)
    if numberofpointattributes > 0
        @assert size(tio.pointattributelist, 2) == numberofpoints
        pointattributelist = pointer(tio.pointattributelist)
    end

    numberofpointmtrs = size(tio.pointmtrlist, 1)
    if numberofpointmtrs > 0
        @assert size(tio.pointmtrlist, 2) == numberofpoints
        pointmtrlist = pointer(tio.pointmtrlist)
    end

    numberoftetrahedra = size(tio.tetrahedronlist, 2)
    if numberoftetrahedra > 0
        tetrahedronlist = pointer(tio.tetrahedronlist)
        numberoftetrahedronattributes = size(tio.tetrahedronattributelist, 1)
        numberofcorners = size(tio.tetrahedronlist, 1)
        if numberoftetrahedronattributes > 0
            @assert size(tio.tetrahedronattributelist, 2) == numberoftetrahedra
            tetrahedronattributelist = pointer(tio.tetrahedronattributelist)
        end
        if size(tio.tetrahedronvolumelist, 1) > 0
            @assert size(tio.tetrahedronvolumelist, 1) == numberoftetrahedra
            tetrahedronvolumelist = pointer(tio.tetrahedronvolumelist)
        end
    end

    numberoffacets = size(tio.facetlist, 1)
    if numberoffacets > 0
        for ifacet = 1:numberoffacets
            facet = tio.facetlist[ifacet]
            numberofpolygons = size(facet.polygonlist, 1)
            polygonlist = Array{CPolygon, 1}(undef, numberofpolygons)
            for ipolygon = 1:numberofpolygons
                polygonlist[ipolygon] = CPolygon(pointer(facet.polygonlist[ipolygon]), size(facet.polygonlist[ipolygon], 1))
            end
            numberofholes = size(facet.holelist, 2)
            push!(polygonlist_array, polygonlist)
            push!(facetlist_array,
                  CFacet(pointer(polygonlist), Cint(numberofpolygons), pointer(facet.holelist), Cint(numberofholes)))
        end
        facetlist = pointer(facetlist_array)
    end

    if size(tio.facetmarkerlist, 1) > 0
        @assert size(tio.facetmarkerlist, 1) == numberoffacets
        facetmarkerlist = pointer(tio.facetmarkerlist)
    end

    numberofholes = size(tio.holelist, 2)
    if numberofholes > 0
        @assert size(tio.holelist, 1) == 3
        holelist = pointer(tio.holelist)
    end

    numberofregions = size(tio.regionlist, 2)
    if numberofregions > 0
        @assert size(tio.regionlist, 1) == 5 # coord+attribute + volume
        regionlist = pointer(tio.regionlist)
    end

    if size(tio.facetconstraintlist, 2) > 0
        @assert size(tio.facetconstraintlist, 1) == 2
        numberoffacetconstraints = size(tio.facetconstraintlist, 2)
        facetconstraintlist = pointer(tio.facetconstraintlist)
    end

    if size(tio.segmentconstraintlist, 2) > 0
        @assert size(tio.segmentconstraintlist, 1) == 3
        numberofsegmentconstraints = size(tio.segmentconstraintlist, 2)
        segmentconstraintlist = pointer(tio.segmentconstraintlist)
    end

    if size(tio.trifacelist, 2) > 0
        @assert size(tio.trifacelist, 1) == 3
        numberoftrifaces = size(tio.trifacelist, 2)
        trifacelist = pointer(tio.trifacelist)
        if size(tio.trifacemarkerlist, 1) > 0
            @assert size(tio.trifacemarkerlist, 1) == numberoftrifaces
            trifacemarkerlist = pointer(tio.trifacemarkerlist)
        end
    end

    if size(tio.edgelist, 2) > 0
        @assert size(tio.edgelist, 1) == 2
        numberofedges = size(tio.edgelist, 2)
        edgelist = pointer(tio.edgelist)
        if size(tio.edgemarkerlist, 1) > 0
            @assert size(tio.edgemarkerlist, 1) == numberofedges
            edgemarkerlist = pointer(tio.edgemarkerlist)
        end
    end

    # Create struct
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
                   numberofedges), facetlist_array, polygonlist_array
end

#
# Create  RawTetGenIO from CPPTetGenIO
#
function RawTetGenIO(ctio::CPPTetGenIO{T}) where {T}
    tio = RawTetGenIO{T}()
    if ctio.numberofpoints > 0 && ctio.pointlist != C_NULL
        tio.pointlist = convert(Array{T, 2}, Base.unsafe_wrap(Array, ctio.pointlist, (3, Int(ctio.numberofpoints)); own = true))
    end
    if ctio.numberofpointattributes > 0 && ctio.pointattributelist != C_NULL
        tio.pointattributelist = convert(Array{T, 2},
                                         Base.unsafe_wrap(Array, ctio.pointattributelist,
                                                          (Int(ctio.numberofpointattributes), Int(ctio.numberofpoints));
                                                          own = true))
    end
    if ctio.numberofpointmtrs > 0 && ctio.pointmtrlist != C_NULL
        tio.pointmtrlist = convert(Array{T, 2},
                                   Base.unsafe_wrap(Array, ctio.pointmtrlist,
                                                    (Int(ctio.numberofpointmtrs), Int(ctio.numberofpoints)); own = true))
    end
    if ctio.pointmarkerlist != C_NULL
        tio.pointmarkerlist = convert(Array{Cint, 1},
                                      Base.unsafe_wrap(Array, ctio.pointmarkerlist, (Int(ctio.numberofpoints)); own = true))
    end
    @assert ctio.numberofcorners == 4
    if ctio.numberoftetrahedra > 0 && ctio.tetrahedronlist != C_NULL
        tio.tetrahedronlist = convert(Array{Cint, 2},
                                      Base.unsafe_wrap(Array, ctio.tetrahedronlist, (4, Int(ctio.numberoftetrahedra)); own = true))
    end
    if ctio.numberoftetrahedronattributes > 0 && ctio.tetrahedronattributelist != C_NULL
        tio.tetrahedronattributelist = convert(Array{T, 2},
                                               Base.unsafe_wrap(Array, ctio.tetrahedronattributelist,
                                                                (Int(ctio.numberoftetrahedronattributes),
                                                                 Int(ctio.numberoftetrahedra)); own = true))
    end
    if ctio.tetrahedronvolumelist != C_NULL
        tio.tetrahedronvolumelist = convert(Array{T, 1},
                                            Base.unsafe_wrap(Array, ctio.tetrahedronvolumelist, (Int(ctio.numberoftetrahedra));
                                                             own = true))
    end
    if ctio.numberoftetrahedra > 0 && ctio.neighborlist != C_NULL
        tio.neighborlist = convert(Array{Cint, 2},
                                   Base.unsafe_wrap(Array, ctio.neighborlist, (4, Int(ctio.numberoftetrahedra)); own = true))
    end

    # Essentially, facetlist appears to be used only during input, so we can skip the
    # conversion here (and increase test coverage...).
    # The created facets are in the trifacelist further down this code.
    # When uncommenting, test...
    # if ctio.numberoffacets>0
    #     facetlist=convert(Array{CFacet,1}, Base.unsafe_wrap(Array, ctio.facetlist, (Int(ctio.numberoffacets)), own=true))
    #     tio.facetlist=Array{RawFacet{T},1}(undef,ctio.numberoffacets)
    #     for ifacet=1:numberoffacets
    #         # Possibly this is copied from the input, so we
    #         # might not want to own the pointers here.
    #         facet=facetlist[i]
    #         polygonlist=Array{Array{Cint,1},1}(undef,facet.numberofpolygons)
    #         for ipolygon=1:facet.numberofpolygons
    #             polygonlist[ipolygon]=convert(Array{Cint,1},Base.unsafe_wrap(Array, facet.polygonlist[i].vertexlist , (Int(facet.polygonlist[i].numberofvertices)), own=true))
    #         end
    #         holelist=convert(Array{T,1},Base.unsafe_wrap(Array, facet.holelist , (Int(facet.numberofholes)), own=true))
    #         tio.facetlist=RawFacet{T}(polygonlist,holelist)
    #     end
    #     if ctio.facetmarkerlist != C_NULL
    #         tio.facetmarkerlist=convert(Array{Cint,1}, Base.unsafe_wrap(Array, ctio.facetmarkerlist, (Int(ctio.numberoffacets)), own=true))
    #     end
    # end

    # Usually, this ctio comes from the output of tetrahedralize(). In this case, the holelist pointer is copied from the input
    # so we would get a double free corruption if we own it here.
    if ctio.numberofholes > 0 && ctio.holelist != C_NULL
        tio.holelist = convert(Array{T, 2}, Base.unsafe_wrap(Array, ctio.holelist, (3, Int(ctio.numberofholes)); own = false))
    end

    # Usually, this ctio comes from the output of tetrahedralize(). In this case, the regionlist pointer is copied from the input
    # so we would get a double free corruption if we own it here.
    if ctio.numberofregions > 0 && ctio.regionlist != C_NULL
        tio.regionlist = convert(Array{T, 2}, Base.unsafe_wrap(Array, ctio.regionlist, (5, Int(ctio.numberofregions)); own = false))
    end

    # own ? May be comes from input
    if ctio.numberoffacetconstraints > 0
        tio.facetconstraintlist = convert(Array{T, 1},
                                          Base.unsafe_wrap(Array, ctio.facetconstraintlist, (2, ctio.numberoffacetconstraints);
                                                           own = false))
    end

    # own ? May be comes from input
    if ctio.numberofsegmentconstraints > 0
        tio.segmentconstraintlist = convert(Array{T, 1},
                                            Base.unsafe_wrap(Array, ctio.segmentconstraintlist,
                                                             (3, ctio.numberofsegmentconstraints); own = false))
    end

    if ctio.numberoftrifaces > 0 && ctio.trifacelist != C_NULL && ctio.trifacemarkerlist != C_NULL
        tio.trifacelist = convert(Array{Cint, 2},
                                  Base.unsafe_wrap(Array, ctio.trifacelist, (3, Int(ctio.numberoftrifaces)); own = true))
        tio.trifacemarkerlist = convert(Array{Cint, 1},
                                        Base.unsafe_wrap(Array, ctio.trifacemarkerlist, (Int(ctio.numberoftrifaces)); own = true))
    end

    if ctio.numberofedges > 0 && ctio.edgelist != C_NULL && ctio.edgemarkerlist != C_NULL
        tio.edgelist = convert(Array{Cint, 2}, Base.unsafe_wrap(Array, ctio.edgelist, (2, Int(ctio.numberofedges)); own = true))
        tio.edgemarkerlist = convert(Array{Cint, 1},
                                     Base.unsafe_wrap(Array, ctio.edgemarkerlist, (Int(ctio.numberofedges)); own = true))
    end

    return tio
end

"""
$(TYPEDSIGNATURES)

Number of points in tetrahedralization
"""
numberofpoints(tio::RawTetGenIO{T}) where {T} = size(tio.pointlist, 2)

"""
$(TYPEDSIGNATURES)

Number of tetrahedra in tetrahedralization
"""
numberoftetrahedra(tio::RawTetGenIO{T}) where {T} = size(tio.tetrahedronlist, 2)

"""
$(TYPEDSIGNATURES)

Number of triangle faces in tetrahedralization
"""
numberoftrifaces(tio::RawTetGenIO{T}) where {T} = size(tio.trifacelist, 2)

"""
$(TYPEDSIGNATURES)

Number of edges in tetrahedralization
"""
numberofedges(tio::RawTetGenIO{T}) where {T} = size(tio.edgelist, 2)

"""
$(TYPEDSIGNATURES)

Tetrahedralize input.

````
  flags: -pYrq_Aa_miO_S_T_XMwcdzfenvgkJBNEFICQVh 
    -p  Tetrahedralizes a piecewise linear complex (PLC).
    -Y  Preserves the input surface mesh (does not modify it).
    -r  Reconstructs a previously generated mesh.
    -q  Refines mesh (to improve mesh quality).
    -R  Mesh coarsening (to reduce the mesh elements).
    -A  Assigns attributes to tetrahedra in different regions.
    -a  Applies a maximum tetrahedron volume constraint.
    -m  Applies a mesh sizing function.
    -i  Inserts a list of additional points.
    -O  Specifies the level of mesh optimization.
    -S  Specifies maximum number of added points.
    -T  Sets a tolerance for coplanar test (default 1e-8).
    -X  Suppresses use of exact arithmetic.
    -M  No merge of coplanar facets or very close vertices.
    -w  Generates weighted Delaunay (regular) triangulation.
    -c  Retains the convex hull of the PLC.
    -d  Detects self-intersections of facets of the PLC.
    -z  Numbers all output items starting from zero.
    -f  Outputs all faces to .face file.
    -e  Outputs all edges to .edge file.
    -n  Outputs tetrahedra neighbors to .neigh file.
    -v  Outputs Voronoi diagram to files.
    -g  Outputs mesh to .mesh file for viewing by Medit.
    -k  Outputs mesh to .vtk file for viewing by Paraview.
    -J  No jettison of unused vertices from output .node file.
    -B  Suppresses output of boundary information.
    -N  Suppresses output of .node file.
    -E  Suppresses output of .ele file.
    -F  Suppresses output of .face and .edge file.
    -I  Suppresses mesh iteration numbers.
    -C  Checks the consistency of the final mesh.
    -Q  Quiet:  No terminal output except errors.
    -V  Verbose:  Detailed information, more terminal output.
    -h  Help:  A brief instruction for using TetGen.
````
"""
function tetrahedralize(input::RawTetGenIO{Float64}, flags::String)
    cinput, flist, plist = CPPTetGenIO(input)
    rc = Cint[0]
    coutput = ccall((:tetrahedralize2_f64, libtet), CPPTetGenIO{Float64}, (CPPTetGenIO{Float64}, Cstring, Ptr{Cint}),
                    cinput, flags, rc)
    if rc[1] != 0
        throw(TetGenError(rc[1]))
    end
    RawTetGenIO(coutput)
end

"""
$(SIGNATURES)

Tetrahedralize stl file.
"""
function tetrahedralize(stlfile::String, flags::String)
    base = rsplit(stlfile, "."; limit = 2)[1]
    rc = Cint[0]
    coutput = ccall((:tetrahedralize2_stl_f64, libtet), CPPTetGenIO{Float64}, (Cstring, Cstring, Ptr{Cint}), base, flags, rc)
    if rc[1] != 0
        throw(TetGenError(rc[1]))
    end
    RawTetGenIO(coutput)
end

"""
$(TYPEDSIGNATURES)

Create GeometryBasics.Mesh from the triface list
(for quick visualization purposes using Makie's wireframe).
"""
function surfacemesh(tgio::RawTetGenIO)
    points = [Point3f(tgio.pointlist[:, i]...) for i = 1:size(tgio.pointlist, 2)]
    faces = [TriangleFace(tgio.trifacelist[:, i]...) for i = 1:size(tgio.trifacelist, 2)]
    mesh = GeometryBasics.Mesh(points, faces)
end

"""
$(TYPEDSIGNATURES)

Create GeometryBasics.Mesh of all tetrahedron faces
(for quick visualization purposes using Makie's wireframe).
"""
function volumemesh(tgio::RawTetGenIO)
    points = [Point3f(tgio.pointlist[:, i]...) for i = 1:size(tgio.pointlist, 2)]
    faces = Array{NgonFace{3, Int32}, 1}(undef, 0)
    tetlist = tgio.tetrahedronlist
    for itet = 1:size(tetlist, 2)
        tet = view(tetlist, :, itet)
        push!(faces, TriangleFace(tet[1], tet[2], tet[3]))
        push!(faces, TriangleFace(tet[1], tet[2], tet[4]))
        push!(faces, TriangleFace(tet[2], tet[3], tet[4]))
        push!(faces, TriangleFace(tet[3], tet[1], tet[4]))
    end
    mesh = GeometryBasics.Mesh(points, faces)
end
