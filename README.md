# TetGen

[![Build status](https://github.com/JuliaGeometry/TetGen.jl/workflows/CI/badge.svg)](https://github.com/JuliaGeometry/TetGen.jl/actions)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/JuliaGeometry/TetGen.jl?svg=true)](https://ci.appveyor.com/project/JuliaGeometry/TetGen-jl)
[![Codecov](https://codecov.io/gh/JuliaGeometry/TetGen.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaGeometry/TetGen.jl)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-orange.svg)](https://github.com/JuliaGeometry/TetGen.jl/blob/master/LICENSE)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaGeometry.github.io/TetGen.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaGeometry.github.io/TetGen.jl/dev)

The `TetGen.jl` package is a Julia wrapper for the C++ project [TetGen](https://wias-berlin.de/software/index.jsp?id=TetGen&lang=1). This wrapper enables TetGen based tetrahedral meshing, and (constrained) 3D Delaunay and Voronoi tesselation.

## Example

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


## [Contributing](https://github.com/JuliaGeometry/TetGen.jl/blob/master/CONTRIBUTING.md)   


## [Code of conduct](https://github.com/JuliaGeometry/TetGen.jl/blob/master/CODE_OF_CONDUCT.md)   
