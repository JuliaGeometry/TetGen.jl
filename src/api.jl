function voronoi(points::Vector{Point{3, T}}) where T <: AbstractFloat
    result = tetrahedralize(TetgenIO(points), "Qw")
    Mesh{Triangle}(result)
end

function TetGen.tetrahedralize(
        mesh::Mesh{3, Float64, <: TetGen.Ngon}, command = "Qp";
        marker = :markers, holes = Point{3, Float64}[]
    )
    f = faces(mesh)
    kw_args = Any[:facets => metafree(f),:holes => holes]
    if hasproperty(f, marker)
        push!(kw_args, :facetmarkers => getproperty(f, marker))
    end
    tio = TetgenIO(coordinates(mesh); kw_args...)
    result = tetrahedralize(tio, command)
    return Mesh{Tetrahedron}(result)
end


function TetGen.tetrahedralize(mesh::Mesh{3, Float64, <: TetGen.Triangle}, command = "Qp")
    tio = TetgenIO(coordinates(mesh); facets = faces(mesh))
    result = tetrahedralize(tio, command)
    Mesh{Tetrahedron}(result)
end
