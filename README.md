LibGEOS.jl
==========
[![CI](https://github.com/JuliaGeo/LibGEOS.jl/workflows/CI/badge.svg)](https://github.com/JuliaGeo/LibGEOS.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/JuliaGeo/LibGEOS.jl/branch/master/graph/badge.svg?token=wnS3J00ZPH)](https://codecov.io/gh/JuliaGeo/LibGEOS.jl)

LibGEOS is a package for manipulation and analysis of planar geometric objects, based on the libraries [GEOS](https://trac.osgeo.org/geos/) (the engine of PostGIS) and JTS (from which GEOS is ported). This package wraps the [GEOS C API](https://geos.osgeo.org/doxygen/geos__c_8h_source.html).

Among other things, it allows you to parse [Well-known Text (WKT)](https://en.wikipedia.org/wiki/Well-known_text)

```julia
p1 = readgeom("POLYGON((0 0,1 0,1 1,0 0))")
p2 = readgeom("POLYGON((0 0,1 0,1 1,0 1,0 0))")
p3 = readgeom("POLYGON((2 0,3 0,3 1,2 1,2 0))")
```
![Example 1](examples/example1.png)

Add a buffer around them
```julia
g1 = buffer(p1, 0.5)
g2 = buffer(p2, 0.5)
g3 = buffer(p3, 0.5)
```
![Example 2](examples/example2.png)

and take the union of different geometries
```julia
polygon = LibGEOS.union(g1, g3)
```
![Example 3](examples/example3.png)

GEOS functionality is extensive, so coverage is incomplete, but the basic functionality for working with geospatial data is already available. I'm learning as I go along, so documentation is lacking, but if you're interested, you can have a look at the examples in the `examples/` folder, or the tests in `test/test_geo_interface.jl` and `test/test_geos_operations.jl`.

Installation
------------
1. At the Julia prompt, run 
  ```julia
  pkg> add LibGEOS
  ```
  This will install both the Julia package and GEOS shared libraries together. The GEOS build comes from [GEOS_jll](https://github.com/JuliaBinaryWrappers/GEOS_jll.jl/releases), and the build script can be found in [Yggdrasil](https://github.com/JuliaPackaging/Yggdrasil/tree/master/G/GEOS).

2. Test that `LibGEOS` works by runnning
  ```julia
  pkg> test LibGEOS
  ```
