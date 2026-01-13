# TetGen
[![linux-macos-windows](https://github.com/JuliaGeometry/TetGen.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/JuliaGeometry/TetGen.jl/actions/workflows/ci.yml)
[![Codecov](https://codecov.io/gh/JuliaGeometry/TetGen.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaGeometry/TetGen.jl)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/JuliaGeometry/TetGen.jl/blob/master/LICENSE)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaGeometry.github.io/TetGen.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaGeometry.github.io/TetGen.jl/dev)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

The `TetGen.jl` package is a Julia wrapper for the C++ project [TetGen](https://wias-berlin.de/software/index.jsp?id=TetGen&lang=1). This wrapper enables TetGen based tetrahedral meshing, and (constrained) 3D Delaunay and Voronoi tessellation.

If you find TetGen useful, please consider citing
Hang Si: "TetGen, a Delaunay-Based Quality Tetrahedral Mesh Generator" ACM Trans. on Mathematical Software. 41 (2), 2015
[http://doi.acm.org/10.1145/2629697](http://doi.acm.org/10.1145/2629697).

## License

When installing TetGen.jl, a compiled library version of the TetGen library will be downloaded from the [TetGen_jll.jl](https://github.com/JuliaBinaryWrappers/TetGen_jll.jl) repository.  This library is bound to the  [Affero Gnu Public License v3 (AGPL)](https://www.gnu.org/licenses/agpl-3.0.html),  but the bindings to the library in this package, TetGen.jl, are licensed under MIT. This means that code using the TetGen library via the TetGen.jl bindings is subject to TetGen's licensing terms. If you distribute covered work, i.e. a program that links to and is distributed with the TetGen library, then that distribution falls under the terms of the AGPLv3.

See the [TetGen Licensing FAQ](http://wias-berlin.de/software/tetgen/1.5/FAQ-license.html) for other options.

## Example using GeometryBasics v0.5 datatypes

```julia
using TetGen
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
mymesh = GeometryBasics.MetaMesh(points, facets; markers)
result = tetrahedralize(mymesh, "vpq1.414a0.1")

using GLMakie

GLMakie.mesh(result, color=(:blue, 0.05), transparency=true, shading=NoShading)

GLMakie.wireframe!(result, color=:black)
```

Plotted with Makie:

![image](https://user-images.githubusercontent.com/1010467/82307971-69252000-99c1-11ea-8b82-e3a206381bd3.png)


## Example using plain Julia arrays

```julia
using TetGen
let
    tetunsuitable!() do pa,pb,pc,pd
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
 
