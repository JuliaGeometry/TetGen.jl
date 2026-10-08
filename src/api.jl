"""
    voronoi(points::Vector{Point{3, T}})  where {T <: AbstractFloat}

Create voronoi diagram of point set.    

Returns a mesh of triangles.
"""
function voronoi(points::Vector{Point{3, T}}) where {T <: AbstractFloat}
    result = tetrahedralize(JLTetGenIO(points), "Qw")
    return Mesh{Triangle}(result)
end


function JLTetGenIO(mesh; marker = :markers, holes = Point{3, Float64}[])
    f = faces(mesh)
    if pkgversion(GeometryBasics) < v"0.5"
        kw_args = Any[:facets => GeometryBasics.metafree(f), :holes => holes]
    else
        kw_args = Any[:facets => f, :holes => holes]
    end
    if hasproperty(f, marker)
        push!(kw_args, :facetmarkers => getproperty(f, marker))
    end
    return JLTetGenIO(coordinates(mesh); kw_args...)
end

"""
$(SIGNATURES)

Tetrahedralize a mesh of polygons with optional facet markers.
Returns a mesh of tetrahdra. 

With `GeometryBasics` version 0.4, the input mesh has to be a `GeometryBasics.Mesh` with
possible metadata. With `GeometryBasics` version 0.5, the input mesh has to be a `GeometryBasics.MetaMesh`.

Default command is "Qp", creating the Delaunay
triangulation of the point set. See the list of
possible flags in the documentation of [`tetrahedralize(::RawTetGenIO, flags)`](@ref).
"""
function tetrahedralize(
        mesh, command = "Qp";
        marker = :markers, holes = Point{3, Float64}[]
    )
    tio = JLTetGenIO(mesh; marker, holes)
    result = tetrahedralize(tio, command)
    return Mesh{Tetrahedron}(result)
end

function save_tetgen(mesh, fstub; marker = :markers, holes = Point{3, Float64}[])
    return save_tetgen(JLTetGenIO(mesh; marker, holes), fstub)
end

# JF: probably this case is included in the case above
# """
# $(SIGNATURES)
#
# Tetrahedralize a domain described by a mesh of triangles.
# Returns a mesh of tetrahdra.
# """
# function TetGen.tetrahedralize(mesh, command = "Qp")
#     tio = JLTetGenIO(coordinates(mesh); facets = faces(mesh))
#     result = tetrahedralize(tio, command)
#     return Mesh{Tetrahedron}(result)
# end
