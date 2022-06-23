@testset "Geo interface" begin
    pt = LibGEOS.Point(1.0, 2.0)
    @test GeoInterface.coordinates(pt) ≈ [1, 2] atol = 1e-5
    @test GeoInterface.geomtrait(pt) == PointTrait()
    @test GeoInterface.ncoord(pt) == 2
    @test GeoInterface.getcoord(pt, 1) ≈ 1.0
    @test GeoInterface.testgeometry(pt)
    @test GeoInterface.extent(pt) == Extent(X = (1.0, 1.0), Y = (2.0, 2.0))

    pt = LibGEOS.Point(1, 2)
    @test GeoInterface.coordinates(pt) ≈ [1, 2] atol = 1e-5
    @test GeoInterface.geomtrait(pt) == PointTrait()
    @test GeoInterface.testgeometry(pt)

    pt = LibGEOS.readgeom("POINT EMPTY")
    @test GeoInterface.coordinates(pt) ≈ Float64[] atol = 1e-5
    @test GeoInterface.geomtrait(pt) == PointTrait()
    @test GeoInterface.ncoord(pt) == 0
    @test GeoInterface.testgeometry(pt)

    mpt = LibGEOS.readgeom("MULTIPOINT(0 0, 10 0, 10 10, 11 10)")
    @test GeoInterface.coordinates(mpt) ==
          Vector{Float64}[[0, 0], [10, 0], [10, 10], [11, 10]]
    @test GeoInterface.geomtrait(mpt) == MultiPointTrait()
    @test GeoInterface.ngeom(mpt) == 4
    p = GeoInterface.getgeom(mpt, 2)
    @test p isa LibGEOS.Point
    @test GeoInterface.coordinates(p) == [10, 0]
    @test GeoInterface.testgeometry(mpt)

    coords = Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2]]
    ls = LibGEOS.LineString(coords)
    @test GeoInterface.coordinates(ls) == coords
    @test GeoInterface.geomtrait(ls) == LineStringTrait()
    p = GeoInterface.ngeom(ls) == 4
    p = GeoInterface.getgeom(ls, 3)
    @test p isa LibGEOS.Point
    @test GeoInterface.coordinates(p) == [9, 2]
    @test GeoInterface.testgeometry(ls)

    ls = LibGEOS.readgeom("LINESTRING EMPTY")
    @test GeoInterface.coordinates(ls) == []
    @test GeoInterface.geomtrait(ls) == LineStringTrait()
    @test GeoInterface.testgeometry(ls)

    mls = LibGEOS.readgeom("MULTILINESTRING ((5 0, 10 0), (0 0, 5 0))")
    @test GeoInterface.coordinates(mls) == [[[5, 0], [10, 0]], [[0, 0], [5, 0]]]
    @test GeoInterface.geomtrait(mls) == MultiLineStringTrait()
    @test GeoInterface.ngeom(mls) == 2
    @test GeoInterface.testgeometry(mls)

    coords = Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2], [8, 1]]
    lr = LibGEOS.LinearRing(coords)
    @test GeoInterface.coordinates(lr) == coords
    @test GeoInterface.geomtrait(lr) == LinearRingTrait()
    @test GeoInterface.ngeom(lr) == 5
    p = GeoInterface.getgeom(lr, 3)
    @test p isa LibGEOS.Point
    @test GeoInterface.coordinates(p) == [9, 2]
    @test GeoInterface.testgeometry(lr)

    coords = Vector{Vector{Float64}}[
        Vector{Float64}[[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]],
        Vector{Float64}[[1, 8], [2, 8], [2, 9], [1, 9], [1, 8]],
        Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2], [8, 1]],
    ]
    polygon = LibGEOS.Polygon(coords)
    @test GeoInterface.coordinates(polygon) == coords
    @test GeoInterface.geomtrait(polygon) == PolygonTrait()
    @test GeoInterface.ngeom(polygon) == 3
    ls = GeoInterface.getgeom(polygon, 2)
    @test ls isa LibGEOS.LinearRing
    @test GeoInterface.coordinates(ls) == coords[2]
    @test GeoInterface.testgeometry(polygon)

    polygon = LibGEOS.readgeom("POLYGON EMPTY")
    @test GeoInterface.coordinates(polygon) == [[]]
    @test GeoInterface.geomtrait(polygon) == PolygonTrait()
    @test GeoInterface.testgeometry(polygon)

    multipolygon = LibGEOS.readgeom("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
    @test GeoInterface.coordinates(multipolygon) ==
          Vector{Vector{Vector{Float64}}}[Vector{Vector{Float64}}[Vector{Float64}[
        [0, 0],
        [0, 10],
        [10, 10],
        [10, 0],
        [0, 0],
    ]]]
    @test GeoInterface.geomtrait(multipolygon) == MultiPolygonTrait()
    @test GeoInterface.testgeometry(multipolygon)
    @test GeoInterface.extent(multipolygon) == Extent(X = (0.0, 10.0), Y = (0.0, 10.0))

    geomcollection = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (POLYGON ((8 2, 10 10, 8.5 1, 8 2)), POLYGON ((7 8, 10 10, 8 2, 7 8)), POLYGON ((3 8, 10 10, 7 8, 3 8)), POLYGON ((2 2, 8 2, 8.5 1, 2 2)), POLYGON ((2 2, 7 8, 8 2, 2 2)), POLYGON ((2 2, 3 8, 7 8, 2 2)), POLYGON ((0.5 9, 10 10, 3 8, 0.5 9)), POLYGON ((0.5 9, 3 8, 2 2, 0.5 9)), POLYGON ((0 0, 2 2, 8.5 1, 0 0)), POLYGON ((0 0, 0.5 9, 2 2, 0 0)))",
    )
    coords = Vector{Vector{Vector{Float64}}}[
        Vector{Vector{Float64}}[Vector{Float64}[
            [8.0, 2.0],
            [10.0, 10.0],
            [8.5, 1.0],
            [8.0, 2.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [7.0, 8.0],
            [10.0, 10.0],
            [8.0, 2.0],
            [7.0, 8.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [3.0, 8.0],
            [10.0, 10.0],
            [7.0, 8.0],
            [3.0, 8.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [2.0, 2.0],
            [8.0, 2.0],
            [8.5, 1.0],
            [2.0, 2.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [2.0, 2.0],
            [7.0, 8.0],
            [8.0, 2.0],
            [2.0, 2.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [2.0, 2.0],
            [3.0, 8.0],
            [7.0, 8.0],
            [2.0, 2.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [0.5, 9.0],
            [10.0, 10.0],
            [3.0, 8.0],
            [0.5, 9.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [0.5, 9.0],
            [3.0, 8.0],
            [2.0, 2.0],
            [0.5, 9.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [0.0, 0.0],
            [2.0, 2.0],
            [8.5, 1.0],
            [0.0, 0.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [0.0, 0.0],
            [0.5, 9.0],
            [2.0, 2.0],
            [0.0, 0.0],
        ]],
    ]
    for (i, item) in enumerate(GeoInterface.getgeom(geomcollection))
        @test GeoInterface.coordinates(item) == coords[i]
    end
    @test GeoInterface.geomtrait(geomcollection) == GeometryCollectionTrait()
    @test GeoInterface.testgeometry(geomcollection)

    geomcollection = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION(MULTIPOINT(0 0, 0 0, 1 1),LINESTRING(1 1, 2 2, 2 2, 0 0),POLYGON((5 5, 0 0, 0 2, 2 2, 5 5)))",
    )
    coords = Vector[
        Vector{Float64}[[0.0, 0.0], [0.0, 0.0], [1.0, 1.0]],
        Vector{Float64}[[1.0, 1.0], [2.0, 2.0], [2.0, 2.0], [0.0, 0.0]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [5.0, 5.0],
            [0.0, 0.0],
            [0.0, 2.0],
            [2.0, 2.0],
            [5.0, 5.0],
        ]],
    ]
    geotypes = [MultiPointTrait(), LineStringTrait(), PolygonTrait()]
    for (i, item) in enumerate(GeoInterface.getgeom(geomcollection))
        @test GeoInterface.coordinates(item) == coords[i]
        @test GeoInterface.geomtrait(item) == geotypes[i]
    end
    @test GeoInterface.geomtrait(geomcollection) == GeometryCollectionTrait()
    @test GeoInterface.testgeometry(geomcollection)

    geomcollection = LibGEOS.readgeom("GEOMETRYCOLLECTION EMPTY")
    @test GeoInterface.ngeom(geomcollection) == 0
    @test GeoInterface.geomtrait(geomcollection) == GeometryCollectionTrait()
    @test GeoInterface.testgeometry(geomcollection)

    @testset "Conversion" begin
        mp = LibGEOS.readgeom("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
        mp2 = convert(Polygon, mp)
        @test mp2 isa MultiPolygon

        struct XPolygon end
        coords = [[[0.0, 0], [0.0, 10], [10.0, 10], [10.0, 0], [0.0, 0]]]
        GeoInterface.geomtrait(::XPolygon) = GeoInterface.PolygonTrait()
        GeoInterface.coordinates(::XPolygon) = coords
        p = convert(Polygon, XPolygon())
        @test p isa Polygon
        @test GeoInterface.ngeom(p) == 1
        @test GeoInterface.nring(p) == 1
        @test GeoInterface.nhole(p) == 0
        @test GeoInterface.coordinates(p) == coords

        struct XMesh end
        GeoInterface.geomtrait(::XMesh) = GeoInterface.PolyhedralSurfaceTrait()
        @test_throws Exception convert(MultiPolygon, XMesh())

    end

end
