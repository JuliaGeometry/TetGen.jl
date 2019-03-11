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
    JLPolygon(Cint[1:4;]),
    JLPolygon(Cint[5:8;]),
    JLPolygon(Cint[1,5,6,2]),
    JLPolygon(Cint[2,6,7,3]),
    JLPolygon(Cint[3, 7, 8, 4]),
    JLPolygon(Cint[4, 8, 5, 1])
]

facetlist = JLFacet.(polygons)

facetmarkerlist = Cint[-1, -2, 0, 0, 0, 0]

tio = TetgenIO(
    collect(reinterpret(Point{3, Float64}, points)),
    facets = facetlist,
    facetmarkers = facetmarkerlist,
)

result = tetrahedralize(tio, "vpq1.414a0.1")
GC.gc()
# Extract surface triangle mesh:
Mesh{Triangle}(result)
# Extract volume Tetrahedron mesh:
Mesh{Tetrahedron}(result)

points = rand(Point{3, Float64}, 100)

result = tetrahedralize(TetgenIO(points), "w")
GC.gc()
result = tetrahedralize(TetgenIO(points), "w")
GC.gc()
Mesh{Triangle}(result)



using GeometryTypes

s1 = Sphere{Float64}(Point{3}(0.0), 1.0)
s2 = Sphere{Float64}(Point{3}(0.0), 2.0)

a, b = PlainMesh{Float64, Face{3, Cint}}.((s1, s2))
bmesh = merge(a, b)

facetlist = map(faces(bmesh)) do face
    JLFacet(JLPolygon([face...]))
end

markers = [fill(Cint(0), length(faces(a))); fill(Cint(1), length(faces(b)));]
tio = TetgenIO(
    collect(reinterpret(TetGen.Point{3, Float64}, vertices(bmesh))),
    facets = facetlist,
    facetmarkers = markers,
)
result = tetrahedralize(tio, "vpq1.414a0.1")
Mesh{Triangle}(result)
Mesh{Tetrahedron}(result)
