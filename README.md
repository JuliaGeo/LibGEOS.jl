LibGEOS.jl
==========

LibGEOS is a LGPL-licensed package for manipulation and analysis of planar geometric objects, based on the libraries [GEOS](https://trac.osgeo.org/geos/) (the engine of PostGIS) and JTS (from which GEOS is ported).

Among other things, it allows you to parse [Well-known Text (WKT)](https://en.wikipedia.org/wiki/Well-known_text)

```julia
p1 = parseWKT("POLYGON((0 0,1 0,1 1,0 0))")
p2 = parseWKT("POLYGON((0 0,1 0,1 1,0 1,0 0))")
p3 = parseWKT("POLYGON((2 0,3 0,3 1,2 1,2 0))")
```
![Example 1](examples/example1.png)

Add a buffer around them
```julia
g1 = buffer(p1,0.5)
g2 = buffer(p2,0.5)
g3 = buffer(p3,0.5)
```
![Example 2](examples/example2.png)

and take the union of different geometries
```julia
polygon = union(buffer(p1,0.5),buffer(p3,0.5))
```
![Example 3](examples/example3.png)

GEOS functionality is extensive, so coverage is incomplete, but the basic functionality for working with geospatial data is already available. I'm learning as I go along, so documentation is lacking, but if you're interested, you can have a look at the examples in the `examples/` folder, or the tests in `test/test_geo_interface.jl` and `test/test_geos_operations.jl`.

Installation (on Linux and OS X)
------------
1. First, install a copy of GEOS, and point the `LD_LIBRARY_PATH` (Linux) or `DYLD_LIBRARY_PATH` (OS X) variable to the GEOS library by adding, e.g.,
  ```bash
  export DYLD_LIBRARY_PATH="/usr/local/Cellar/geos/3.4.2/lib:$DYLD_LIBRARY_PATH"
  ```
to your start-up file (e.g. ``.bash_profile``).

2. At the Julia prompt, run 
  ```julia
  julia> Pkg.add("LibGEOS")
  ```

3. Test that `LibGEOS` works by runnning
  ```julia
  julia> Pkg.test("LibGEOS")
  ```
