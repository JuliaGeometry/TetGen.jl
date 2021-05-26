# TetGen

[![Build status](https://github.com/JuliaGeometry/TetGen.jl/workflows/linux-macos-windows/badge.svg)](https://github.com/JuliaGeometry/TetGen.jl/actions)
[![Codecov](https://codecov.io/gh/JuliaGeometry/TetGen.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaGeometry/TetGen.jl)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-orange.svg)](https://github.com/JuliaGeometry/TetGen.jl/blob/master/LICENSE)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaGeometry.github.io/TetGen.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaGeometry.github.io/TetGen.jl/dev)

The `TetGen.jl` package is a Julia wrapper for the C++ project [TetGen](https://wias-berlin.de/software/index.jsp?id=TetGen&lang=1). This wrapper enables TetGen based tetrahedral meshing, and (constrained) 3D Delaunay and Voronoi tesselation.

## Example using GeometryBasics datatypes

```julia
using TetGen
using TetGen: TetgenIO
using GeometryBasics
using GeometryBasics: Mesh, QuadFace

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
mesh = Mesh(points, meta(facets, markers=markers))
result = tetrahedralize(mesh, "vpq1.414a0.1")

using GLMakie, AbstractPlotting

GLMakie.mesh(normal_mesh(result), color=(:blue, 0.1), transparency=true)
GLMakie.wireframe!(result)

```

Plotted with Makie:

![image](https://user-images.githubusercontent.com/1010467/82307971-69252000-99c1-11ea-8b82-e3a206381bd3.png)


## Example using plain Julia arrays

```julia
using TetGen
let
    tetunsuitable() do pa,pb,pc,pd
        vol=det(hcat(pb-pa,pc-pa,pd-pa))/6
        center=0.25*(pa+pb+pc+pd)-[0.5,0.5,0.5]
        vol> 0.05*norm(center)^2.5
    end

    input=TetGen.RawTetGenIO{Cdouble}()
    input.pointlist=[0 0 0;  
                     1 0 0;
                     1 1 0;
                     0 1 0;
                     0 0 1;  
                     1 0 1;
                     1 1 1;
                     0 1 1]'

    TetGen.facetlist!(input,[1 2 3 4;
                             5 6 7 8;
                             1 2 6 5;
                             2 3 7 6;
                             3 4 8 7;
                             4 1 5 8]')
    tetrahedralize(input, "pQa")
end
```

Output:

```julia
RawTetGenIO(
numberofpoints=169,
numberofedges=27,
numberoftrifaces=112,
numberoftetrahedra=809,
pointlist'=[0.0 1.0 … 0.500059730245037 0.4996534431688176; 0.0 0.0 … 0.5074057466787957 0.49707528530503103; 0.0 0.0 … 0.5033015055704277 0.4953177845338027],
tetrahedronlist'=Int32[34 47 … 15 143; 6 24 … 143 15; 58 52 … 154 150; 70 73 … 168 168],
trifacelist'=Int32[3 58 … 99 22; 19 6 … 22 8; 78 70 … 158 158],
trifacemarkerlist'=Int32[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1  …  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
edgelist'=Int32[3 5 … 70 157; 18 24 … 6 32],
edgemarkerlist'=Int32[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1  …  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
)
```


## [Contributing](https://github.com/JuliaGeometry/TetGen.jl/blob/master/CONTRIBUTING.md)   


## [Code of conduct](https://github.com/JuliaGeometry/TetGen.jl/blob/master/CODE_OF_CONDUCT.md)   
