# TetGen.jl

TetGen  is a  mesh generator  written in  C++.  It  generates Delaunay
tetrahedralizations,  constrained  Delaunay  tetrahedralizations,  and
quality tetrahedral  meshes. TetGen.jl  provides a Julia  interface to
TetGen.

## Mesh based API
This API uses instances of types from [GeometryBasics.jl](https://github.com/JuliaGeometry/GeometryBasics.jl) 
to describe input and output of TetGen.

```@autodocs
Modules = [TetGen]
Pages = ["api.jl"]
```

## Raw API
This API is closer to TetGen's C++ API in the sense that
input and output are described using arrays of integers
and floats, without conversion to any other higher level
data structure.

```@autodocs
Modules = [TetGen]
Pages = [ "rawtetgenio.jl"]
```

```@docs
tetunsuitable!
```


## TetGen C++ code

- [Technical report](http://doi.org/10.20347/WIAS.TECHREPORT.13)
  ([html version](http://wias-berlin.de/software/tetgen/1.5/doc/manual/index.html)).

- H.Si, "TetGen, a Delaunay-Based Quality Tetrahedral Mesh Generator" [ACM Trans. Math. Software, 41 (2015) pp. 11:1--11:36](https://dl.acm.org/doi/abs/10.1145/2629697).
  Please consider citing this paper when publishing results obtained with the use of TetGen.
  Link to preprint  [here](http://doi.org/10.20347/WIAS.PREPRINT.1762). 


