@testset "LibGEOS invalid geometry" begin
    # LibGEOS shouldn't crash but error out
    # on invalid geometry

    # Self intersecting polygon
    # gives unkown function segfault on Travis Linux CI, see #44, revisit after #21
    # polygon = LibGEOS._readgeom("POLYGON((0 0, 10 10, 0 10, 10 0, 0 0))")
    # @test !LibGEOS.isValid(polygon)

    # Hole outside of base
    # gives unkown function segfault on Travis Linux CI, see #44, revisit after #21
    # polygon = LibGEOS._readgeom("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0), (15 15, 15 20, 20 20, 20 15, 15 15))")
    # @test !LibGEOS.isValid(polygon)

end
