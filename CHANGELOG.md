# Changelog

All notable changes to this project since V1.0 will be documented in this file.

## [2.0]
- Allow for GeometryBasics v0.5 along with 0.4
- Breaking: with GeometryBasics v0.5, a MetaMesh has 
  to be provided as input for Tetrahedralize. 
  The RawTetGenIO based API is not affected. Users who
  rely on the RawTetGenIO based API can use  `TetGen="1,2"` 
  in their `[compat]` section.
- Breaking: remove deprecated `tetunsuitable`. Use `tetunsuitable!` instead

## [1.5.1] - 2024-02-27

- Fix version check for `MemoryRef`
- Add  ci for apple silicon

## [1.5.0] - 2023-11-15

- Fix imports/named using from GeometryBasics
- add juliaformatter
- @deprecate tetunsuitable tetunsuitable!
- Pass pointer to unsafe_convert
- Test for type of return value of unsuitable function
- fix for 1.11 memory handling

## [1.4.0] - 2022-06-02
- allow to input stl files

## [1.3.0] - 2021-10-05

- Switch Julia package to MIT license (after the FFTW model).
- Remove checking of error catching from tests due to problems on windows.
- Point3f0->Point3f (GeometryBasics version)
- Add stl loading functionality
- Switch Julia package to MIT license (after the FFTW model).

## [1.2.1] - 2021-09-13
- allow for GeometryBasics 0.4

## [1.2.0] - 2021-05-26

- Added example for RawTetGenIO and holes
- Created holes for tetrahedralize(::Mesh, ...)
- Added test example for mesh API with holes

## [1.1.1] - 2021-01-02

- Bump version compat for StaticArrays

## [1.1.0] - 2020-12-22

- Thank you travis and bye bye
- Update of upstream patch version of TetGen to "August 18, 2018".
- Formally this still appears to be 1.5.1 , and it is manifest in TetGen_jll 1.5.1+1
- Catch errors thrown by TetGen in a rc variable, throw julia error if rc!=0
- Handle unsuitable callback to allow local refinement.

## [1.0.0] - 2020-11-30
- Dependency on artifacts
- Refactoring. API of API.jl stays the same.
- Provide array based API. and RawTetGenIO
