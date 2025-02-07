var documenterSearchIndex = {"docs":
[{"location":"#TetGen.jl","page":"Home","title":"TetGen.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"TetGen  is a  mesh generator  written in  C++.  It  generates Delaunay tetrahedralizations,  constrained  Delaunay  tetrahedralizations,  and quality tetrahedral  meshes. TetGen.jl  provides a Julia  interface to TetGen.","category":"page"},{"location":"","page":"Home","title":"Home","text":"TetGen","category":"page"},{"location":"#TetGen","page":"Home","title":"TetGen","text":"TetGen\n\nTetGen\n\n(Image: linux-macos-windows) (Image: Codecov) (Image: License: MIT) (Image: ) (Image: ) (Image: Aqua QA)\n\nThe TetGen.jl package is a Julia wrapper for the C++ project TetGen. This wrapper enables TetGen based tetrahedral meshing, and (constrained) 3D Delaunay and Voronoi tesselation.\n\nIf you find TetGen useful, please consider citing Hang Si: \"TetGen, a Delaunay-Based Quality Tetrahedral Mesh Generator\" ACM Trans. on Mathematical Software. 41 (2), 2015 http://doi.acm.org/10.1145/2629697.\n\nLicense\n\nWhen installing TetGen.jl, a compiled library version of the TetGen library will be downloaded from the TetGen_jll.jl repository.  This library is bound to the  Affero Gnu Public License v3 (AGPL),  but the bindings to the library in this package, TetGen.jl, are licensed under MIT. This means that code using the TetGen library via the TetGen.jl bindings is subject to TetGen's licensing terms. If you distribute covered work, i.e. a program that links to and is distributed with the TetGen library, then that distribution falls under the terms of the AGPLv3.\n\nSee the TetGen Licensing FAQ for other options.\n\nExample using GeometryBasics v0.5 datatypes\n\nusing TetGen\nusing GeometryBasics\nusing GeometryBasics: Mesh, QuadFace\n\n# Construct a cube out of Quads\npoints = Point{3, Float64}[\n    (0.0, 0.0, 0.0), (2.0, 0.0, 0.0),\n    (2.0, 2.0, 0.0), (0.0, 2.0, 0.0),\n    (0.0, 0.0, 12.0), (2.0, 0.0, 12.0),\n    (2.0, 2.0, 12.0), (0.0, 2.0, 12.0)\n]\n\nfacets = QuadFace{Cint}[\n    1:4,\n    5:8,\n    [1,5,6,2],\n    [2,6,7,3],\n    [3, 7, 8, 4],\n    [4, 8, 5, 1]\n]\n\nmarkers = Cint[-1, -2, 0, 0, 0, 0]\n# attach some additional information to our faces!\nmymesh = GeometryBasics.MetaMesh(points, facets; markers)\nresult = tetrahedralize(mymesh, \"vpq1.414a0.1\")\n\nusing GLMakie\n\nGLMakie.mesh(result, color=(:blue, 0.05), transparency=true, shading=NoShading)\n\nGLMakie.wireframe!(result, color=:black)\n\nPlotted with Makie:\n\n(Image: image)\n\nExample using plain Julia arrays\n\nusing TetGen\nlet\n    tetunsuitable!() do pa,pb,pc,pd\n        vol=det(hcat(pb-pa,pc-pa,pd-pa))/6\n        center=0.25*(pa+pb+pc+pd)-[0.5,0.5,0.5]\n        vol> 0.05*norm(center)^2.5\n    end\n\n    input=TetGen.RawTetGenIO{Cdouble}()\n    input.pointlist=[0 0 0;  \n                     1 0 0;\n                     1 1 0;\n                     0 1 0;\n                     0 0 1;  \n                     1 0 1;\n                     1 1 1;\n                     0 1 1]'\n\n    TetGen.facetlist!(input,[1 2 3 4;\n                             5 6 7 8;\n                             1 2 6 5;\n                             2 3 7 6;\n                             3 4 8 7;\n                             4 1 5 8]')\n    tetrahedralize(input, \"pQa\")\nend\n\nOutput:\n\nRawTetGenIO(\nnumberofpoints=169,\nnumberofedges=27,\nnumberoftrifaces=112,\nnumberoftetrahedra=809,\npointlist'=[0.0 1.0 … 0.500059730245037 0.4996534431688176; 0.0 0.0 … 0.5074057466787957 0.49707528530503103; 0.0 0.0 … 0.5033015055704277 0.4953177845338027],\ntetrahedronlist'=Int32[34 47 … 15 143; 6 24 … 143 15; 58 52 … 154 150; 70 73 … 168 168],\ntrifacelist'=Int32[3 58 … 99 22; 19 6 … 22 8; 78 70 … 158 158],\ntrifacemarkerlist'=Int32[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1  …  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],\nedgelist'=Int32[3 5 … 70 157; 18 24 … 6 32],\nedgemarkerlist'=Int32[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1  …  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],\n)\n\nContributing\n\nCode of conduct\n\n\n\n\n\n","category":"module"},{"location":"#Mesh-based-API","page":"Home","title":"Mesh based API","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This API uses instances of types from GeometryBasics.jl  to describe input and output of TetGen.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [TetGen]\nPages = [\"api.jl\"]","category":"page"},{"location":"#TetGen.tetrahedralize","page":"Home","title":"TetGen.tetrahedralize","text":"tetrahedralize(mesh; ...)\ntetrahedralize(mesh, command; marker, holes)\n\n\nTetrahedralize a mesh of polygons with optional facet markers. Returns a mesh of tetrahdra. \n\nWith GeometryBasics version 0.4, the input mesh has to be a GeometryBasics.Mesh with possible metadata. With GeometryBasics version 0.5, the input mesh has to be a GeometryBasics.MetaMesh.\n\nDefault command is \"Qp\", creating the Delaunay triangulation of the point set. See the list of possible flags in the documentation of tetrahedralize(::RawTetGenIO, flags).\n\n\n\n\n\n","category":"function"},{"location":"#TetGen.voronoi-Union{Tuple{Array{GeometryBasics.Point3{T}, 1}}, Tuple{T}} where T<:AbstractFloat","page":"Home","title":"TetGen.voronoi","text":"voronoi(points::Vector{Point{3, T}})  where {T <: AbstractFloat}\n\nCreate voronoi diagram of point set.    \n\nReturns a mesh of triangles.\n\n\n\n\n\n","category":"method"},{"location":"#Raw-API","page":"Home","title":"Raw API","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This API is closer to TetGen's C++ API in the sense that input and output are described using arrays of integers and floats, without conversion to any other higher level data structure.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [TetGen]\nPages = [ \"rawtetgenio.jl\"]","category":"page"},{"location":"#TetGen.RawFacet","page":"Home","title":"TetGen.RawFacet","text":"struct RawFacet{T}\n\nA complex facet as part to the input to TetGen.\n\npolygonlist::Vector{Vector{Int32}}: Polygons given as arrays of indices which point into the pointlist array describing the input points.\n\nholelist::Matrix: Array of points given by their coordinates marking polygons describing holes in the facet.\n\n\n\n\n\n","category":"type"},{"location":"#TetGen.RawTetGenIO","page":"Home","title":"TetGen.RawTetGenIO","text":"mutable struct RawTetGenIO{T}\n\nA  structure for  transferring  data  into and  out  of TetGen's internal representation.\n\nThe input of TetGen is either a 3D point set, or a 3D piecewise linear complex (PLC), or  a tetrahedral mesh.  Depending on  the input object and the specified  options, the output of TetGen is  either a Delaunay (or weighted Delaunay) tetrahedralization, or a constrained (Delaunay) tetrahedralization, or a quality tetrahedral mesh.\n\nA piecewise  linear complex  (PLC) represents  a 3D  polyhedral domain with  possibly internal  boundaries(subdomains). It  is introduced  in [Miller  et al,  1996].   Basically  it is  a  set  of \"cells\",  i.e., vertices, edges, polygons, and polyhedra,  and the intersection of any two of its cells is the union of other cells of it.\n\nThe 'RawTetGenIO' structure  is a collection of arrays  of data, i.e., points, facets, tetrahedra,  and so forth. All data  are compatible to the representation in C++ and can be used without copying.\n\npointlist::Matrix: 'pointlist':  Array of point coordinates with size(pointlist,1)==3.\n\npointattributelist::Matrix: 'pointattributelist':  Array of point attributes. The number of  attributes per point is determined by  size(pointattributelist,1)\n\npointmtrlist::Matrix: 'pointmtrlist': An array of metric tensors at points.\n\npointmarkerlist::Vector{Int32}: 'pointmarkerlist':  An array of point markers; one integer per point.\n\ntetrahedronlist::Matrix{Int32}:  'tetrahedronlist': An array of tetrahedron corners represented by indices of points in pointlist. Unless option -o2 is given, one has  size(tetrahedronlist,1)==4, i.e. each  column describes the    four     corners    of    a     tetrahedron.     Otherwise, size(tetrahedronlist,1)==10 and the 4  corners are followed by 6 edge midpoints.\n\ntetrahedronattributelist::Matrix: 'tetrahedronattributelist':  An array of tetrahedron attributes.\n\ntetrahedronvolumelist::Vector: 'tetrahedronvolumelist':  An array of constraints, i.e. tetrahedron's  volume;  Input only. This can be used for triggering local refinement.\n\nneighborlist::Matrix{Int32}: 'neighborlist':  An array of tetrahedron neighbors; 4 ints per element.  Output only.\n\nfacetlist::Array{RawFacet{T}, 1} where T: 'facetlist':  An array of facets.  Each entry is a structure of facet.\n\nfacetmarkerlist::Vector{Int32}: 'facetmarkerlist':  An array of facet markers; one int per facet.\n\nholelist::Matrix: 'holelist':  An array of holes (in volume).  Each hole is given by a  point which lies strictly inside it.\n\nregionlist::Matrix:  'regionlist': An array of regions (subdomains).  Each region is given by  a seed (point) which lies strictly inside it. For each column,  the point coordinates are  at indices [1], [2] and [3], followed by the regional  attribute at index [4], followed by the maximum volume at index [5].\note that each regional attribute is used only if you select the 'A'  switch, and each volume constraint is used only if you select the  'a' switch (with no number following).\n\nfacetconstraintlist::Matrix: 'facetconstraintlist':  An array of facet constraints.  Each constraint specifies a maximum area bound on the subfaces of that facet.  Each column contains  a facet marker at index [1] and its maximum area bound at index [2]. Note: the facet marker is actually an integer.\n\nsegmentconstraintlist::Matrix: 'segmentconstraintlist': An array of segment constraints. Each constraint specifies a maximum length bound on the subsegments of that segment. Each columb consists of the  two endpoints of the segment at index [1] and [2], and the maximum length bound at index [3]. Note the segment endpoints are actually integers.\n\ntrifacelist::Matrix{Int32}: 'trifacelist':  An array of face (triangle) corners.\n\ntrifacemarkerlist::Vector{Int32}: 'trifacemarkerlist':  An array of face markers; one int per face.\n\nedgelist::Matrix{Int32}: 'edgelist':  An array of edge endpoints.\n\nedgemarkerlist::Array{Int32}: 'edgemarkerlist':  An array of edge markers.\n\n\n\n\n\n","category":"type"},{"location":"#TetGen.RawTetGenIO-Union{Tuple{}, Tuple{T}} where T","page":"Home","title":"TetGen.RawTetGenIO","text":"Create RawTetGenIO structure with empty data.\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.facetlist!-Union{Tuple{T}, Tuple{RawTetGenIO{T}, AbstractMatrix}} where T","page":"Home","title":"TetGen.facetlist!","text":"facetlist!(\n    tio::RawTetGenIO{T},\n    facets::AbstractMatrix\n) -> RawTetGenIO\n\n\nSet list of input facets from AbstractMatrix desribing polygons of the same\nsize (e.g. triangles)\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.facetlist!-Union{Tuple{T}, Tuple{RawTetGenIO{T}, Vector}} where T","page":"Home","title":"TetGen.facetlist!","text":"facetlist!(\n    tio::RawTetGenIO{T},\n    facets::Vector\n) -> RawTetGenIO\n\n\nSet list of input facets from a vector of polygons of different size\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.numberofedges-Union{Tuple{RawTetGenIO{T}}, Tuple{T}} where T","page":"Home","title":"TetGen.numberofedges","text":"numberofedges(tio::RawTetGenIO{T}) -> Int64\n\n\nNumber of edges in tetrahedralization\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.numberofpoints-Union{Tuple{RawTetGenIO{T}}, Tuple{T}} where T","page":"Home","title":"TetGen.numberofpoints","text":"numberofpoints(tio::RawTetGenIO{T}) -> Int64\n\n\nNumber of points in tetrahedralization\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.numberoftetrahedra-Union{Tuple{RawTetGenIO{T}}, Tuple{T}} where T","page":"Home","title":"TetGen.numberoftetrahedra","text":"numberoftetrahedra(tio::RawTetGenIO{T}) -> Int64\n\n\nNumber of tetrahedra in tetrahedralization\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.numberoftrifaces-Union{Tuple{RawTetGenIO{T}}, Tuple{T}} where T","page":"Home","title":"TetGen.numberoftrifaces","text":"numberoftrifaces(tio::RawTetGenIO{T}) -> Int64\n\n\nNumber of triangle faces in tetrahedralization\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.surfacemesh-Tuple{RawTetGenIO}","page":"Home","title":"TetGen.surfacemesh","text":"surfacemesh(tgio::RawTetGenIO) -> GeometryBasics.Mesh\n\n\nCreate GeometryBasics.Mesh from the triface list (for quick visualization purposes using Makie's wireframe).\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.tetrahedralize-Tuple{RawTetGenIO{Float64}, String}","page":"Home","title":"TetGen.tetrahedralize","text":"tetrahedralize(\n    input::RawTetGenIO{Float64},\n    flags::String\n) -> RawTetGenIO{Float64}\n\n\nTetrahedralize input.\n\n  flags: -pYrq_Aa_miO_S_T_XMwcdzfenvgkJBNEFICQVh \n    -p  Tetrahedralizes a piecewise linear complex (PLC).\n    -Y  Preserves the input surface mesh (does not modify it).\n    -r  Reconstructs a previously generated mesh.\n    -q  Refines mesh (to improve mesh quality).\n    -R  Mesh coarsening (to reduce the mesh elements).\n    -A  Assigns attributes to tetrahedra in different regions.\n    -a  Applies a maximum tetrahedron volume constraint.\n    -m  Applies a mesh sizing function.\n    -i  Inserts a list of additional points.\n    -O  Specifies the level of mesh optimization.\n    -S  Specifies maximum number of added points.\n    -T  Sets a tolerance for coplanar test (default 1e-8).\n    -X  Suppresses use of exact arithmetic.\n    -M  No merge of coplanar facets or very close vertices.\n    -w  Generates weighted Delaunay (regular) triangulation.\n    -c  Retains the convex hull of the PLC.\n    -d  Detects self-intersections of facets of the PLC.\n    -z  Numbers all output items starting from zero.\n    -f  Outputs all faces to .face file.\n    -e  Outputs all edges to .edge file.\n    -n  Outputs tetrahedra neighbors to .neigh file.\n    -v  Outputs Voronoi diagram to files.\n    -g  Outputs mesh to .mesh file for viewing by Medit.\n    -k  Outputs mesh to .vtk file for viewing by Paraview.\n    -J  No jettison of unused vertices from output .node file.\n    -B  Suppresses output of boundary information.\n    -N  Suppresses output of .node file.\n    -E  Suppresses output of .ele file.\n    -F  Suppresses output of .face and .edge file.\n    -I  Suppresses mesh iteration numbers.\n    -C  Checks the consistency of the final mesh.\n    -Q  Quiet:  No terminal output except errors.\n    -V  Verbose:  Detailed information, more terminal output.\n    -h  Help:  A brief instruction for using TetGen.\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.tetrahedralize-Tuple{String, String}","page":"Home","title":"TetGen.tetrahedralize","text":"tetrahedralize(stlfile, flags)\n\n\nTetrahedralize stl file.\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.volumemesh-Tuple{RawTetGenIO}","page":"Home","title":"TetGen.volumemesh","text":"volumemesh(\n    tgio::RawTetGenIO\n) -> GeometryBasics.Mesh{_A, _B, GeometryBasics.TriangleFace{Int32}, _C, _D, Vector{GeometryBasics.TriangleFace{Int32}}} where {_A, _B<:Real, _C, _D<:(Tuple{var\"#s11\", Vararg{Union{AbstractVector{T}, GeometryBasics.FaceView{T, AVT} where AVT<:AbstractVector{T}} where T}} where var\"#s11\"<:AbstractArray{GeometryBasics.Point{_A, _B}, 1})}\n\n\nCreate GeometryBasics.Mesh of all tetrahedron faces (for quick visualization purposes using Makie's wireframe).\n\n\n\n\n\n","category":"method"},{"location":"","page":"Home","title":"Home","text":"tetunsuitable!","category":"page"},{"location":"#TetGen.tetunsuitable!","page":"Home","title":"TetGen.tetunsuitable!","text":"tetunsuitable!(unsuitable; check_signature)\n\n\nSet tetunsuitable function called from C wrapper. Setting this function is valid only for one subsequent call to tetrahedralize. The function to be passed has the signature\n\nunsuitable(p1::Vector{Float64},p2::Vector{Float64},p3::Vector{Float64},p4::Vector{Float64})::Bool\n\nwhere p1...p4 are 3-Vectors describing the corners of a tetrahedron, and the return value is true if its volume is seen as too large.\n\n\n\n\n\n","category":"function"},{"location":"#TetGen-C-code","page":"Home","title":"TetGen C++ code","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Technical report (html version).\nH.Si, \"TetGen, a Delaunay-Based Quality Tetrahedral Mesh Generator\" ACM Trans. Math. Software, 41 (2015) pp. 11:1–11:36. Please consider citing this paper when publishing results obtained with the use of TetGen. Link to preprint  here. ","category":"page"},{"location":"#Internal-API","page":"Home","title":"Internal API","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Modules = [TetGen]\nPages = [\"meshes.jl\", \"jltetgenio.jl\", \"cpptetgenio.jl\"]","category":"page"},{"location":"#GeometryBasics.Mesh-Union{Tuple{TetGen.JLTetGenIO{T}}, Tuple{T}, Tuple{P}} where {P<:(GeometryBasics.Polytope), T}","page":"Home","title":"GeometryBasics.Mesh","text":"Mesh{Tetrahedron}(result::JLTetGenIO)\n\nExtracts the tetrahedral mesh from tetgenio. Can also be called with extra information, e.g.:\n\n    Mesh{Tetrahedron{Float32}}(tetio)\n    NDim = 3; T = Float64; PointType = MyPoint{3, Float64}; Edges = 4\n    Mesh{Simplex{NDim, T, Edges, PointType}}(tetio)\n\nMesh{Triangle}(result::JLTetGenIO)\n\nExtracts the triangular surface mesh from tetgenio. Can also be called with extra information, e.g.:\n\n    Mesh{Triangle3d{Float32}}(tetio)\n    NDim = 3; T = Float64; PointType = MyPoint{3, Float64}; Edges = 3\n    Mesh{Ngon{NDim, T, 3, PointType}}(tetio)\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.TetGenError","page":"Home","title":"TetGen.TetGenError","text":"Error struct for TetGen\n\n\n\n\n\n","category":"type"},{"location":"#Base.show-Tuple{IO, TetGenError}","page":"Home","title":"Base.show","text":"Show TetGen error, messages have been lifted    from TetGen \n\n\n\n\n\n","category":"method"},{"location":"#TetGen.jl_wrap_tetunsuitable-NTuple{4, Ptr{Float64}}","page":"Home","title":"TetGen.jl_wrap_tetunsuitable","text":"Tetunsuitable function called from C wrapper\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.my_jl_tetunsuitable","page":"Home","title":"TetGen.my_jl_tetunsuitable","text":"Trivial Julia tetunsuitable function\n\n\n\n\n\n","category":"function"},{"location":"#TetGen.tetrahedralize-Tuple{TetGen.CPPTetGenIO{Float64}, String}","page":"Home","title":"TetGen.tetrahedralize","text":"tetrahedralize(input, command)\n\n\nTetrahedralization with error handling\n\n\n\n\n\n","category":"method"},{"location":"#TetGen.tetunsuitable!-Tuple{Function}","page":"Home","title":"TetGen.tetunsuitable!","text":"tetunsuitable!(unsuitable; check_signature)\n\n\nSet tetunsuitable function called from C wrapper. Setting this function is valid only for one subsequent call to tetrahedralize. The function to be passed has the signature\n\nunsuitable(p1::Vector{Float64},p2::Vector{Float64},p3::Vector{Float64},p4::Vector{Float64})::Bool\n\nwhere p1...p4 are 3-Vectors describing the corners of a tetrahedron, and the return value is true if its volume is seen as too large.\n\n\n\n\n\n","category":"method"}]
}
