LibGEOS.jl
==========
LibGEOS is a GPL-licensed package for manipulation and analysis of planar geometric objects, based on the libraries [GEOS](https://trac.osgeo.org/geos/) (the engine of PostGIS) and JTS (from which GEOS is ported). GEOS functionality is extensive, so coverage is incomplete, but the basic functionality for working with geospatial data is already available.

Installation (on Linux and OS X)
------------
1. First, install a copy of GEOS, and point the `LD_LIBRARY_PATH` (Linux) or `DYLD_LIBRARY_PATH` (OS X) variable to the GEOS library by adding, e.g.,
  ```bash
  export DYLD_LIBRARY_PATH="/usr/local/Cellar/geos/3.4.2/lib:$DYLD_LIBRARY_PATH"
  ```
to your start-up file (e.g. ``.bash_profile``).

2. At the Julia prompt, run 
  ```julia
  julia> Pkg.clone("https://github.com/yeesian/LibGEOS.jl.git")
  ```

3. Test that `LibGEOS` works by runnning
  ```julia
  julia> Pkg.test("LibGEOS")
  ```
