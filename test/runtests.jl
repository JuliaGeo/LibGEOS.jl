
using GeoInterface, GeoInterfaceRecipes, Extents
using GeoInterface, Extents
using Test, LibGEOS, RecipesBase
import Aqua

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
    Aqua.test_all(LibGEOS;
        ambiguities=(exclude=[RecipesBase.apply_recipe],),
    )
    include("test_geos_types.jl")
    include("test_geos_functions.jl")
    include("test_geos_operations.jl")
    include("test_geo_interface.jl")
    include("test_regressions.jl")
    include("test_invalid_geometry.jl")
    include("test_strtree.jl")
    include("test_misc.jl")

end
