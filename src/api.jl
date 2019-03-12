function voronoi(points::Vector{Point{3, T}}) where T <: AbstractFloat
    result = tetrahedralize(JLTetgenIO(points), "Qw")
    Mesh(result.points, result.trifaces)
end
