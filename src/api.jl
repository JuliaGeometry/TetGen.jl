function voronoi(points::Vector{Point{3, T}}) where T <: AbstractFloat
    result = tetrahedralize(JLTetgenIO(points), "Qw")
    Mesh(result.points, result.trifaces)
end

function TetGen.tetrahedralize(mesh::Mesh{3, Float64, <: TetGen.Triangle}, command = "Qp")
    tio = TetgenIO(coordinates(mesh); facets = faces(mesh))
    result = tetrahedralize(tio, command)
    Mesh{Tetrahedron}(result)
end
