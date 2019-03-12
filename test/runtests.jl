using TetGen
using TetGen: JLPolygon, TetgenIO, JLFacet, Point
using GeometryBasics: Mesh, Triangle, Tetrahedron

points = Point{3, Float64}[
    (0.0, 0.0, 0.0), (2.0, 0.0, 0.0),
    (2.0, 2.0, 0.0), (0.0, 2.0, 0.0),
    (0.0, 0.0, 12.0), (2.0, 0.0, 12.0),
    (2.0, 2.0, 12.0), (0.0, 2.0, 12.0)
]
# Facet 1. The leftmost JLFacet.
polygons = [
    Cint[1:4;],
    Cint[5:8;],
    Cint[1,5,6,2],
    Cint[2,6,7,3],
    Cint[3, 7, 8, 4],
    Cint[4, 8, 5, 1]
]

facetlist = JLFacet.(polygons)

facetmarkerlist = Cint[-1, -2, 0, 0, 0, 0]

tio = TetgenIO(
    collect(reinterpret(Point{3, Float64}, points)),
    facets = facetlist,
    facetmarkers = facetmarkerlist,
)

<<<<<<< Updated upstream
yy = Base.cconvert(TetGen.CPPTetgenIO{Float64}, tio)
xx = Base.unsafe_convert(TetGen.CPPTetgenIO{Float64}, yy)
GC.gc(true)

result = tetrahedralize(tio, "vpq1.414a0.1")
# Extract surface triangle mesh:
# Extract volume Tetrahedron mesh:
tetra = Mesh{Tetrahedron}(result)
tio = TetgenIO(
    tetra.simplices.points,
    tetrahedrons = tetra.simplices.faces
)
result = tetrahedralize(tio, "p")
tmesh = Mesh{Triangle}(result)
using Makie, GeometryTypes

gmesh = GLNormalMesh(Point3f0.(tmesh.simplices.points), GLTriangle.(tmesh.simplices.faces))
mesh(gmesh)



points = rand(Point{3, Float64}, 100)

result = tetrahedralize(TetgenIO(points), "w")
GC.gc()
result = tetrahedralize(TetgenIO(points), "w")
GC.gc()
Mesh{Triangle}(result)



using GeometryTypes, FileIO, GLMakie
using TetGen
using TetGen: JLPolygon, TetgenIO, JLFacet, Point, CPolygon, CPPTetgenIO
using GeometryBasics: Mesh, Triangle, Tetrahedron, TriangleFace

bmesh = load(GLMakie.GLVisualize.assetpath("cat.obj"), PlainMesh{Float64, Face{3, Cint}})
facetlist = map(faces(bmesh)) do face
    JLFacet([Cint.(face)...])
end

tio = TetgenIO(
    TetGen.Point{3, Float64}.(vertices(bmesh)),
    facets = facetlist,
    facetmarkers = fill(Cint(0), length(facetlist))
)

result = tetrahedralize(tio, "d")
x = Mesh{Triangle}(result)
Mesh{Tetrahedron}(result)
using Makie

GLNormalMesh(Point3f0.(x.simplices.points))
=======
result = tetrahedralize(tio, "pq1.414a0.1")

points = rand(Point{3, Float64}, 100)

result = TetGen.voronoi(points)

using GeometryTypes

s = Sphere{Float64}(Point(0.0, 0.0, 0.0), 2.0)

x = PlainMesh{Float64, Triangle{Cint}}(s)

s = Sphere{Float64}(Point(0.0, 0.0, 0.0), 1.0)

y = PlainMesh{Float64, Triangle{Cint}}(s)


meshy = merge(x, y)

using Statistics
retype(::Type{T}, x) where T = collect(reinterpret(T, x))
attr = [fill(Cint(0), length(vertices(x))); fill(Cint(0), length(vertices(y)));]
p = mean(vertices(meshy))

tio = JLTetgenIO(
    retype(TetGen.Point{3, Float64}, vertices(meshy)),
    trifaces = retype(TetGen.TriangleFace{Cint}, faces(meshy)),
    # pointmarkers = attr,
    # regions = [TetGen.Region(TetGen.Point(p...), -2.0, 0.01)]
)

result = tetrahedralize(tio, "pq")


using Makie

mesh(meshy)
>>>>>>> Stashed changes
