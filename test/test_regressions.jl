@testset "LibGEOS regressions" begin

    # https://github.com/JuliaGeo/LibGEOS.jl/issues/29
    pts = [[0.0, 0.0], [10.0, 0.0], [10.0, 10.0], [0.0, 10.0]]
    @test_throws LibGEOS.GEOSError Polygon([pts])

    # https://github.com/JuliaGeo/LibGEOS.jl/issues/24
    point = Point(2, 3)
    @test GeoInterface.geotype(point) == :Point

    # https://github.com/JuliaGeo/LibGEOS.jl/issues/25
    a = LibGEOS.createCoordSeq([0.0, 2.0])
    @test LibGEOS.getCoordinates(a) == Array{Float64,1}[[0.0, 2.0]]

    # https://github.com/JuliaGeo/LibGEOS.jl/issues/12
    mp = LibGEOS.MultiPoint(Vector{Float64}[[0, 0], [10, 0], [10, 10], [11, 10]])
    @test GeoInterface.geotype(mp) == :MultiPoint

    # https://github.com/JuliaGeo/LibGEOS.jl/issues/20
    # LibGEOS doesn't support Extended WKT
    ewkt = "SRID=32756; POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))"
    # ParseException: Unknown type: 'SRID=32756;'
    @test_throws LibGEOS.GEOSError readgeom(ewkt)

    # https://github.com/JuliaGeo/LibGEOS.jl/issues/40
    # IllegalArgumentException: Points of LinearRing do not form a closed linestring
    @test_throws LibGEOS.GEOSError readgeom("POLYGON((-1. 1., 1. 3., 0. 2., -1. 1.5))")

end
