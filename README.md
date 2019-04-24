# TetGen

[![Build Status](https://travis-ci.com/JuliaGeometry/TetGen.jl.svg?branch=master)](https://travis-ci.com/JuliaGeometry/TetGen.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/JuliaGeometry/TetGen.jl?svg=true)](https://ci.appveyor.com/project/JuliaGeometry/TetGen-jl)
[![Codecov](https://codecov.io/gh/JuliaGeometry/TetGen.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaGeometry/TetGen.jl)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-orange.svg)](https://github.com/JuliaGeometry/TetGen.jl/blob/master/LICENSE)

The `TetGen.jl` package is a Julia wrapper for the C++ project [TetGen](wias-berlin.de/software/tetgen/). This wrapper enables TetGen based tetrahedral meshing, and (constrained) 3D Delaunay and Voronoi tesselation.

## Example

```julia

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
```

Plotted with Makie:

![image](https://user-images.githubusercontent.com/1010467/54118458-5abd9a80-43f3-11e9-99e8-951d36b8a81f.png)


## [Contributing](https://github.com/JuliaGeometry/TetGen.jl/blob/master/CONTRIBUTING.md)   


## [Code of conduct](https://github.com/JuliaGeometry/TetGen.jl/blob/master/CODE_OF_CONDUCT.md)   
