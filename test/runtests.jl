using TetGen
using Base.Test
using Base.Iterators
using GeometryTypes

tetgen = TetGen.tetgen



cd(@__DIR__)

meshfile = abspath("sphere.smesh")
sphere = GLNormalMesh(Sphere(Point3f0(0), 1f0))
using Colors

spheres = [
    (Sphere(Point3f0(0), 2f0), RGBA(0, 1, 0, 0.1)),
    (Sphere(Point3f0(0), 1f0), RGBA(0, 0, 0, 0.4))
]

mesh1 = map(GLNormalMesh, spheres)
combined = merge(mesh1...)
#
# scene = Scene()
# Makie.wireframe(GLNormalMesh(combined))
#
# mesh2 = HomogenousMesh(Sphere(Point3f0(0), 1f0), color = RGBA(0, 0, 0, 1))

open(meshfile, "w") do io
    export_smesh(io, sphere)
end

run(`$tetgen -pq1.2AaY $(abspath(meshfile))`)
nodes, elements = read_mesh(pwd(), "sphere.1")

@test length(nodes) == 1014
@test length(elements) == 4621

# function to_triangle(triangles, tetra)
#     tetra = tetra
#     push!(triangles, GLTriangle(tetra[1], tetra[2], tetra[3]))
#     push!(triangles, GLTriangle(tetra[2], tetra[3], tetra[4]))
#     push!(triangles, GLTriangle(tetra[2], tetra[3], tetra[4]))
#     push!(triangles, GLTriangle(tetra[3], tetra[1], tetra[4]))
# end
#
#
# function to_lines(lines, tetra)
#     tetra = tetra
#     push!(lines, tetra[1], tetra[2])
#     push!(lines, tetra[2], tetra[3])
#     push!(lines, tetra[3], tetra[4])
#     push!(lines, tetra[2], tetra[4])
#     push!(lines, tetra[1], tetra[4])
# end

#
# triangles = GLTriangle[]
#
# for elem in elements
#     if nodes[elem[1]][1] > 0
#         to_triangle(triangles, elem)
#     end
# end
#
# using Makie
#
# scene = Scene()
# mesh = GLPlainMesh(nodes, triangles)
# Makie.wireframe(mesh, color = (:black, 0.4))
# Makie.mesh(mesh, color = (:red, 0.1))
#
#
# Makie.scatter(nodes, markersize = 0.01)
# Makie.lines(nodes)
