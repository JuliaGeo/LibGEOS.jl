import GeoInterface
using Base.Test, LibGEOS

@testset "LibGEOS" begin
    include("test_geos_functions.jl")
    include("test_geos_operations.jl")
    include("test_geo_interface.jl")
    include("test_regressions.jl")
    include("test_invalid_geometry.jl")
end
