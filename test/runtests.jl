using TetGen
using Base.Test
using Base.Iterators
using GeometryTypes

tetgen = TetGen.tetgen


# Holes
# Region
# Field of points of local densities

# Seems like we forgotten this in GeometryTypes
"""
#  4 nodes, 3 dim., no attr. no mark
4  3  0  0

0  0  0  0
1  1  0  0
2  0  1  0
3  0  0  1

# part 2 - facet list
#  4 facets, have mark
4  1

3  0 1 2  10
3  0 1 3  11
3  0 2 3  13
3  1 2 3  12

# part 3 - hole list
0

# part 4 - region list
0
"""
function export_smesh(io::IO, mesh::AbstractMesh, holes = Point3f0[])
    nodes = vertices(mesh)
    println(io, length(nodes), ' ', length(eltype(nodes)), " 0 0")
    ids = mesh.attribute_id
    for (i, v) in enumerate(nodes)
        print(io, i - 1, ' ', join(v, ' '))
        !isempty(ids) && print(io, ' ', ids[i])
        println(io)
    end
    facets = faces(mesh)

    println(io, length(facets), ' ', 1)
    for f in facets
        println(io, length(f), ' ', join(Int.(f) .- 1, ' '), ' ', 1)
    end
    println(io, length(holes))
    for elem in holes

    end
    println(io, length(holes))
    p = mean(nodes)
    println(io, "1 $(join(p, ' ')) -2 0.01")
end
function read_mesh(folder, name)
    vertpath = joinpath(folder, name * ".node")
    nodes = Point{3, Float64}[]
    open(vertpath) do io
        header = readline(io)
        nnodes, dim, mesha1, mesha2 = parse.(Int, split(header))
        for i = 1:nnodes
            line = readline(io)
            xyz = Point3f0(parse.(Float64, split(line))[2:end])
            push!(nodes, xyz)
        end
    end

    vertpath = joinpath(folder, name * ".ele")
    elements = Face{4, Int}[]
    open(vertpath) do io
        header = readline(io)
        nnodes, dim, mesha1 = parse.(Int, split(header))
        for i = 1:nnodes
            line = readline(io)
            f = Face{4, Int}(parse.(Int, split(line))[2:end])
            push!(elements, f)
        end
    end
    nodes, elements
end

function meshit(smesh)
    mktempdir() do folder
        meshfile = joinpath(folder, "tmp.smesh")
        open(meshfile, "w") do io
            export_smesh(io, smesh)
        end
        run(`$tetgen -pq1.2AaY $meshfile`)
        read_mesh(folder, "tmp")
    end
end

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
