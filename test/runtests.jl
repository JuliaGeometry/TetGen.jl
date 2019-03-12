using TetGen
using TetGen: JLPolygon, TetgenIO, JLFacet, Point
using GeometryBasics: Mesh, Triangle, Tetrahedron

points = zeros(8 * 3)
points[[4, 7, 8, 11]]  .= 2;  # node 2.
# Set node 5, 6, 7, 8.
for i in 4:7
  points[i * 3 + 1] = points[(i - 4) * 3 + 1];
  points[i * 3 + 1 + 1] = points[(i - 4) * 3 + 1 + 1];
  points[i * 3 + 2 + 1] = 12;
end

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
