import GeoInterface
using FactCheck, LibGEOS

include("test_geos_functions.jl")
include("test_geos_operations.jl")
include("test_geo_interface.jl")
include("test_regressions.jl")

FactCheck.exitstatus()
