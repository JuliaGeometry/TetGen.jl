using TetGen
using TetGen: JLPolygon, JLFacet, Point
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


tetpoints = Point{3, Float64}[
    (0.0, 0.0, 0.0),
    (1.0, 0.0, 0.0),
    (0.0, 1.0, 0.0),
    (0.0, 0.0, 1.0)
]

tetfacets = TriangleFace{Cint}[
    [1,2,3],
    [1,2,4],
    [1,3,4],
    [2,3,4]
]

tetmesh=Mesh(tetpoints,tetfacets)
result = tetrahedralize(tetmesh,"pQqAa0.01")
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

include("../examples/examples.jl")
function generic_test(result::RawTetGenIO)
    @test volumemesh(result) isa Mesh

    if numberoftrifaces(result)>0
        @test surfacemesh(result) isa Mesh
    end
    
    buf=IOBuffer()
    Base.show(buf,result)
    @test length(buf.data)>0
    
    ctio,flist,plist=TetGen.CPPTetGenIO(result)
    @test ctio.numberofpoints==numberofpoints(result)
    @test ctio.numberoftetrahedra==numberoftetrahedra(result)
    @test ctio.numberoftrifaces==numberoftrifaces(result)
end

result = random_delaunay(npoints=100)
@test numberofpoints(result)==100
generic_test(result)

result = cube()
@test numberofpoints(result)==8
@test numberoftetrahedra(result)==6
@test numberofedges(result)==12
@test numberoftrifaces(result)==12
generic_test(result)

result = prism()
@test numberofpoints(result)==8
@test numberofedges(result)==11
@test numberoftrifaces(result)==12
@test numberoftetrahedra(result)==6
generic_test(result)


# exact numbers depend on FP aritmetic and
# compiler optimizations
result = material_prism()
@test numberoftetrahedra(result)>100
generic_test(result)

result = cutprism()
@test numberoftetrahedra(result)>100
generic_test(result)


