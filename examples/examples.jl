using TetGen
using LinearAlgebra

"""
     random_delaunay(;npoints=20)

Create a Delaunay tetrahedralization  from a random set of points.
This is  a tetrahedralization of the convex hull of the points.
If the points are in general position (which we assume here),
it is unique.
"""
function random_delaunay(; npoints = 20)
    input = TetGen.RawTetGenIO{Cdouble}(; pointlist = rand(3, npoints))
    return tetrahedralize(input, "Q")
end

"""
   cube(;vol=1)

Tetrahedralization of cube with maximum tetrahedron volume.
"""
function cube(; vol = 1)
    input = TetGen.RawTetGenIO{Cdouble}()
    input.pointlist = [
        0 0 0;
        1 0 0;
        1 1 0;
        0 1 0;
        0 0 1;
        1 0 1;
        1 1 1;
        0 1 1
    ]'

    TetGen.facetlist!(
        input, [
            1 2 3 4;
            5 6 7 8;
            1 2 6 5;
            2 3 7 6;
            3 4 8 7;
            4 1 5 8
        ]'
    )
    return tetrahedralize(input, "pQa$(vol)")
end

"""
   cubewithhole(;vol=1)

Tetrahedralization of cube with maximum tetrahedron volume.
"""
function cubewithhole(; vol = 1)
    input = TetGen.RawTetGenIO{Cdouble}()
    outerpoints = [
        -1 -1 -1;
        1 -1 -1;
        1 1 -1;
        -1 1 -1;
        -1 -1 1;
        1 -1 1;
        1 1 1;
        -1 1 1
    ]'

    input.pointlist = hcat(outerpoints, outerpoints / 2)

    outerfacets = [
        1 2 3 4;
        5 6 7 8;
        1 2 6 5;
        2 3 7 6;
        3 4 8 7;
        4 1 5 8
    ]'

    input.holelist = [0 0 0;]'

    TetGen.facetlist!(input, hcat(outerfacets, outerfacets .+ 8))
    return tetrahedralize(input, "pQa$(vol)")
end

"""
   cube_localref()

   Tetrahedralization of cube with local refinement callback
"""
function cube_localref()
    tetunsuitable!() do pa, pb, pc, pd
        vol = det(hcat(pb - pa, pc - pa, pd - pa)) / 6
        center = 0.25 * (pa + pb + pc + pd) - [0.5, 0.5, 0.5]
        vol > 0.05 * norm(center)^2.5
    end

    input = TetGen.RawTetGenIO{Cdouble}()
    input.pointlist = [
        0 0 0;
        1 0 0;
        1 1 0;
        0 1 0;
        0 0 1;
        1 0 1;
        1 1 1;
        0 1 1
    ]'

    TetGen.facetlist!(
        input, [
            1 2 3 4;
            5 6 7 8;
            1 2 6 5;
            2 3 7 6;
            3 4 8 7;
            4 1 5 8
        ]'
    )
    return tetrahedralize(input, "pQa")
end

"""
   cube_stl()

   Tetrahedralization of cube from an stl file
"""
function cube_stl()
    modeldir = joinpath(dirname(pathof(TetGen)), "..", "test", "surfaceModels")
    modelfile = joinpath(modeldir, "cube.stl")
    return tetrahedralize(modelfile, "pQa1.0")
end

function interior_mesh_stl()
    modeldir = joinpath(dirname(pathof(TetGen)), "..", "test", "surfaceModels")
    modelfile = joinpath(modeldir, "interior_mesh.stl")
    tetrahedralize(modelfile, "pQq1.4")
end



"""
   prism(;vol=1)

Tetrahedralization of a prism with maximum tetrahedron volume.
"""
function prism(vol = 2)
    input = TetGen.RawTetGenIO{Cdouble}()
    input.pointlist = [
        0 0 0;
        1 0 0;
        0 1 0;
        0 0 1;
        1 0 1;
        0 1 1
    ]'

    TetGen.facetlist!(
        input, [
            [1, 2, 3],
            [4, 5, 6],
            [1, 2, 5, 4],
            [2, 3, 6, 5],
            [3, 1, 4, 6],
        ]
    )

    return tetrahedralize(input, "pQa$(vol)")
end

"""
   prism(;vol1=0.01, vol2=0.2)

Tetrahedralization of a prism with two regions with different tet volumes
"""
function material_prism(; vol1 = 0.01, vol2 = 0.1)
    input = TetGen.RawTetGenIO{Cdouble}()

    input.pointlist = [
        0 0 0;
        1 0 0;
        0 1 0;
        0 0 1;
        1 0 1;
        0 1 1;
        0 0 2;
        1 0 2;
        0 1 2
    ]'

    TetGen.facetlist!(
        input,
        [
            [1, 2, 3],
            [7, 8, 9],
            [1, 2, 5, 4],
            [2, 3, 6, 5],
            [3, 1, 4, 6],
            [1, 2, 5, 4] .+ 3,
            [2, 3, 6, 5] .+ 3,
            [3, 1, 4, 6] .+ 3,
        ]
    )

    input.facetmarkerlist = [1, 2, 3, 3, 3, 3, 3, 3]
    input.regionlist = [
        0.1 0.1 0.5 1 vol1;
        0.1 0.1 1.5 2 vol2
    ]'

    return tetrahedralize(input, "paAqQ")
end

"""
   cutprism(;vol=0.05)

Tetrahedralization of a prism with  a prism cut out in the middle.
This tests the use of facet holes.
"""
function cutprism(; vol = 0.05)
    input = TetGen.RawTetGenIO{Cdouble}()
    input.pointlist = [
        0 0 0;
        1 0 0;
        0 1 0;
        0 0 10;
        1 0 10;
        0 1 10;
        -1 -1 0;  # 7
        2 -1 0;
        2 2 0;
        -1 2 0;
        -1 -1 10;  # 11
        2 -1 10;
        2 2 10;
        -1 2 10
    ]'

    push!(input.facetlist, RawFacet([Cint[1, 2, 3], Cint[7, 8, 9, 10]], [0.1 0.1 0.0;]))
    push!(input.facetlist, RawFacet([Cint[4, 5, 6], Cint[11, 12, 13, 14]], [0.1 0.1 1.0;]))
    push!(input.facetlist, RawFacet([Cint[1, 2, 5, 4]], Array{Cdouble, 2}(undef, 0, 0)))
    push!(input.facetlist, RawFacet([Cint[2, 3, 6, 5]], Array{Cdouble, 2}(undef, 0, 0)))
    push!(input.facetlist, RawFacet([Cint[3, 1, 4, 6]], Array{Cdouble, 2}(undef, 0, 0)))
    push!(input.facetlist, RawFacet([Cint[7, 8, 12, 11]], Array{Cdouble, 2}(undef, 0, 0)))
    push!(input.facetlist, RawFacet([Cint[8, 9, 13, 12]], Array{Cdouble, 2}(undef, 0, 0)))
    push!(input.facetlist, RawFacet([Cint[9, 10, 14, 13]], Array{Cdouble, 2}(undef, 0, 0)))
    push!(input.facetlist, RawFacet([Cint[10, 7, 11, 14]], Array{Cdouble, 2}(undef, 0, 0)))

    input.facetmarkerlist = [1, 2, 3, 3, 3, 4, 5, 6, 7]
    input.regionlist = [-0.1 -0.1 0.1 1 vol;]'
    return tetrahedralize(input, "paqAQ")
end
