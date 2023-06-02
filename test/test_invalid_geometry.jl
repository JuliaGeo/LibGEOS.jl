using Test
using LibGEOS

@testset "LibGEOS invalid geometry" begin
    # LibGEOS shouldn't crash but error out on invalid geometry

    # Self intersecting polygon
    polygon = LibGEOS.readgeom("POLYGON((0 0, 10 10, 0 10, 10 0, 0 0))")
    @test !LibGEOS.isValid(polygon)

    # Hole outside of base
    polygon = LibGEOS.readgeom("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),
        (15 15, 15 20, 20 20, 20 15, 15 15))")
    @test !LibGEOS.isValid(polygon)
    @test LibGEOS.GEOSisValidReason_r(LibGEOS.get_global_context(), polygon) ==
          "Hole lies outside shell[15 15]"
    @test LibGEOS.isValidReason(polygon) == "Hole lies outside shell[15 15]"

    geo_valid = LibGEOS.makeValid(polygon)
    @test geo_valid isa LibGEOS.MultiPolygon
    @test LibGEOS.isValid(geo_valid)
    @test LibGEOS.isValidReason(geo_valid) == "Valid Geometry"
end
