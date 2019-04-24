using TetGen
using TetGen: JLPolygon, TetgenIO, JLFacet, Point
using GeometryBasics
using GeometryBasics: Mesh, Triangle, Tetrahedron, TriangleFace, QuadFace,
    PointMeta, NgonFaceMeta, meta, faces, metafree
using GeometryBasics.StructArrays
using Test

# Construct a cube out of Quads
points = Point{3, Float64}[
    (0.0, 0.0, 0.0), (2.0, 0.0, 0.0),
    (2.0, 2.0, 0.0), (0.0, 2.0, 0.0),
    (0.0, 0.0, 12.0), (2.0, 0.0, 12.0),
    (2.0, 2.0, 12.0), (0.0, 2.0, 12.0)
]

facets = QuadFace{Cint}[
    1:4,
    5:8,
    [1,5,6,2],
    [2,6,7,3],
    [3, 7, 8, 4],
    [4, 8, 5, 1]
]

markers = Cint[-1, -2, 0, 0, 0, 0]
# attach some additional information to our faces!
mesh = Mesh(points, meta(facets, markers = markers))
result = tetrahedralize(mesh)
@test result isa Mesh

points = rand(Point{3, Float64}, 100)
result = TetGen.voronoi(points)
@test result isa Mesh

# s = Sphere{Float64}(Point(0.0, 0.0, 0.0), 2.0)
#
# x = PlainMesh{Float64, Triangle{Cint}}(s)
#
# function Mesh{T, Dim, FaceType}(a::AbstractGeometry; resolution = nothing)
#     P = Point{T, Dim}
#     Mesh(
#         coordinates(a, P; resolution = resolution),
#         faces(a, FaceType; resolution = resolution)
#     )
# end
#
# s = Sphere{Float64}(Point(0.0, 0.0, 0.0), 1.0)
#
# y = PlainMesh{Float64, Triangle{Cint}}(s)
