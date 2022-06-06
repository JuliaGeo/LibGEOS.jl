using GeoInterface
using Test, LibGEOS

version = LibGEOS.GEOSversion()
@info "GEOS version $version"

if version != LibGEOS.GEOS_CAPI_VERSION
    @warn string(
        "The GEOS version in use is different from the version used to ",
        "generate libgeos_api.jl. Consider regenerating if the difference is more than a ",
        "patch release.",
    ) run_version = version gen_version = LibGEOS.GEOS_CAPI_VERSION
end

@testset "LibGEOS" begin
    include("test_geos_functions.jl")
    include("test_geos_operations.jl")
    include("test_geo_interface.jl")
    include("test_regressions.jl")
    include("test_invalid_geometry.jl")
end
