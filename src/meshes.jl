using GeometryBasics: Triangle, Tetrahedron, Mesh, Polytope


function GeometryBasics.Mesh{P}(x::TetgenIO{T}) where {P <: Polytope{N, T} where {N, T}, T}
    Mesh{Polytope(P, Point{3, T})}(x)
end

"""
    Mesh{Tetrahedron}(result::TetgenIO)

Extracts the tetrahedral mesh from `tetgenio`.
Can also be called with extra information, e.g.:
```julia
Mesh{Tetrahedron{Float32}}(tetio)
NDim = 3; T = Float64; PointType = MyPoint{3, Float64}; Edges = 4
Mesh{Simplex{NDim, T, Edges, PointType}}(tetio)
```
"""
function GeometryBasics.Mesh{TetrahedronP{ET, P}}(x::TetgenIO) where {ET, P}
    Mesh(convert(Vector{P}, x.points), x.tetrahedra)
end


"""
    Mesh{Triangle}(result::TetgenIO)

Extracts the triangular surface mesh from `tetgenio`.
Can also be called with extra information, e.g.:
```julia
Mesh{Triangle3d{Float32}}(tetio)
NDim = 3; T = Float64; PointType = MyPoint{3, Float64}; Edges = 3
Mesh{Ngon{NDim, T, 3, PointType}}(tetio)
```
"""
function GeometryBasics.Mesh{TriangleP{3, ET, P}}(x::TetgenIO) where {ET, P}
    Mesh(convert(Vector{P}, x.points), x.trifaces)
end
