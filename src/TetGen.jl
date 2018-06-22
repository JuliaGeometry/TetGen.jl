module TetGen

const depsfile = joinpath(@__DIR__, "..", "deps", "deps.jl")
using GeometryTypes

if isfile(depsfile)
    include(depsfile)
else
    error("Tetgen not build correctly. Please run Pkg.build(\"TetGen\")")
end

function __init__()
    check_deps()
end

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

export meshit, export_smesh, read_mesh

end # module
