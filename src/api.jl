"""
$(SIGNATURES)

Create voronoi diagram of point set.    

Returns a mesh of triangles.
"""
function voronoi(points::Vector{Point{3, T}}) where T <: AbstractFloat
    result = tetrahedralize(JLTetGenIO(points), "Qw")
    Mesh{Triangle}(result)
end


"""
$(SIGNATURES)

Tetrahedralize a mesh of polygons with optimal facet markers.
Returns a mesh of tetrahdra.
"""
function TetGen.tetrahedralize(
        mesh::Mesh{3, Float64, <: TetGen.Ngon}, command = "Qp";
        marker = :markers
    )
    f = faces(mesh)
    kw_args = Any[:facets => metafree(f)]
    if hasproperty(f, marker)
        push!(kw_args, :facetmarkers => getproperty(f, marker))
    end
    tio = JLTetGenIO(coordinates(mesh); kw_args...)
    result = tetrahedralize(tio, command)
    return Mesh{Tetrahedron}(result)
end


"""
$(SIGNATURES)

Tetrahedralize a domain described by a mesh of triangles.
Returns a mesh of tetrahdra.
"""
function TetGen.tetrahedralize(mesh::Mesh{3, Float64, <: TetGen.Triangle}, command = "Qp")
    tio = JLTetGenIO(coordinates(mesh); facets = faces(mesh))
    result = tetrahedralize(tio, command)
    Mesh{Tetrahedron}(result)
end
