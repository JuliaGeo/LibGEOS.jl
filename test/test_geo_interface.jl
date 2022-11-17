using Plots

@testset "Geo interface" begin
    pt = LibGEOS.Point(1.0, 2.0)
    @test GeoInterface.coordinates(pt) ≈ [1, 2] atol = 1e-5
    @test GeoInterface.geomtrait(pt) == PointTrait()
    @test GeoInterface.ncoord(pt) == 2
    @test GeoInterface.getcoord(pt, 1) ≈ 1.0
    @test GeoInterface.testgeometry(pt)
    @test GeoInterface.extent(pt) == Extent(X = (1.0, 1.0), Y = (2.0, 2.0))
    plot(pt)

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
    plot(mpt)

    coords = Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2]]
    ls = LibGEOS.LineString(coords)
    @test GeoInterface.coordinates(ls) == coords
    @test GeoInterface.geomtrait(ls) == LineStringTrait()
    p = GeoInterface.ngeom(ls) == 4
    p = GeoInterface.getgeom(ls, 3)
    @test p isa LibGEOS.Point
    @test GeoInterface.coordinates(p) == [9, 2]
    @test GeoInterface.testgeometry(ls)
    plot(ls)

    ls = LibGEOS.readgeom("LINESTRING EMPTY")
    @test GeoInterface.coordinates(ls) == []
    @test GeoInterface.geomtrait(ls) == LineStringTrait()
    @test GeoInterface.testgeometry(ls)

    mls = LibGEOS.readgeom("MULTILINESTRING ((5 0, 10 0), (0 0, 5 0))")
    @test GeoInterface.coordinates(mls) == [[[5, 0], [10, 0]], [[0, 0], [5, 0]]]
    @test GeoInterface.geomtrait(mls) == MultiLineStringTrait()
    @test GeoInterface.ngeom(mls) == 2
    @test GeoInterface.testgeometry(mls)
    plot(mls)

    coords = Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2], [8, 1]]
    lr = LibGEOS.LinearRing(coords)
    @test GeoInterface.coordinates(lr) == coords
    @test GeoInterface.geomtrait(lr) == LinearRingTrait()
    @test GeoInterface.ngeom(lr) == 5
    p = GeoInterface.getgeom(lr, 3)
    @test p isa LibGEOS.Point
    @test GeoInterface.coordinates(p) == [9, 2]
    @test GeoInterface.testgeometry(lr)
    # Cannot convert LinearRingTrait to series data for plotting
    # plot(lr)

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
    plot(polygon)

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
    plot(multipolygon)

    pmultipolygon = LibGEOS.prepareGeom(multipolygon)
    @test GeoInterface.geomtrait(pmultipolygon) == MultiPolygonTrait()
    @test GeoInterface.testgeometry(pmultipolygon)
    @test GeoInterface.extent(pmultipolygon) == Extent(X = (0.0, 10.0), Y = (0.0, 10.0))
    LibGEOS.destroyGeom(pmultipolygon)

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
    plot(geomcollection)

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
        @test_throws Exception convert(Polygon, mp)
        mp2 = convert(MultiPolygon, mp)
        @test mp2 isa MultiPolygon
        @test mp === mp2

        struct XPoint end
        coords = [0.0, 0]
        GeoInterface.geomtrait(::XPoint) = GeoInterface.PointTrait()
        GeoInterface.coordinates(::XPoint) = coords
        geom = GeoInterface.convert(Point, XPoint())
        @test geom isa Point
        @test GeoInterface.coordinates(geom) == coords

        struct XMultiPoint end
        coords = [[0.0, 0], [0.0, 10]]
        GeoInterface.geomtrait(::XMultiPoint) = GeoInterface.MultiPointTrait()
        GeoInterface.coordinates(::XMultiPoint) = coords
        geom = GeoInterface.convert(MultiPoint, XMultiPoint())
        @test geom isa MultiPoint
        @test GeoInterface.coordinates(geom) == coords

        struct XLineString end
        coords = [[0.0, 0], [0.0, 10], [10.0, 10], [10.0, 0], [0.0, 0]]
        GeoInterface.geomtrait(::XLineString) = GeoInterface.LineStringTrait()
        GeoInterface.coordinates(::XLineString) = coords
        geom = GeoInterface.convert(LineString, XLineString())
        @test geom isa LineString
        @test GeoInterface.coordinates(geom) == coords

        struct XMultiLineString end
        coords = [[[0.0, 0], [0.0, 10], [10.0, 10], [10.0, 0], [0.0, 0]]]
        GeoInterface.geomtrait(::XMultiLineString) = GeoInterface.MultiLineStringTrait()
        GeoInterface.coordinates(::XMultiLineString) = coords
        geom = GeoInterface.convert(MultiLineString, XMultiLineString())
        @test geom isa MultiLineString
        @test GeoInterface.coordinates(geom) == coords

        struct XPolygon end
        coords = [[[0.0, 0], [0.0, 10], [10.0, 10], [10.0, 0], [0.0, 0]]]
        GeoInterface.geomtrait(::XPolygon) = GeoInterface.PolygonTrait()
        GeoInterface.coordinates(::XPolygon) = coords
        geom = GeoInterface.convert(Polygon, XPolygon())
        @test geom isa Polygon
        @test GeoInterface.ngeom(geom) == 1
        @test GeoInterface.nring(geom) == 1
        @test GeoInterface.nhole(geom) == 0
        @test GeoInterface.coordinates(geom) == coords

        pgeom = LibGEOS.prepareGeom(geom)
        @test GeoInterface.coordinates(pgeom) == coords
        LibGEOS.destroyGeom(pgeom)

        struct XMultiPolygon end
        coords = [[[[0.0, 0], [0.0, 10], [10.0, 10], [10.0, 0], [0.0, 0]]]]
        GeoInterface.geomtrait(::XMultiPolygon) = GeoInterface.MultiPolygonTrait()
        GeoInterface.coordinates(::XMultiPolygon) = coords
        geom = GeoInterface.convert(MultiPolygon, XMultiPolygon())
        @test geom isa MultiPolygon
        @test GeoInterface.coordinates(geom) == coords

        struct XMesh end
        GeoInterface.geomtrait(::XMesh) = GeoInterface.PolyhedralSurfaceTrait()
        @test_throws Exception GeoInterface.convert(MultiPolygon, XMesh())

    end

    @testset "Operations" begin
        a, b = readgeom("POLYGON((1 1,1 5,5 5,5 1,1 1))"), readgeom("POINT(2 2)")

        c = geom -> GeoInterface.coordinates(geom)

        @test GeoInterface.distance(a, b) == LibGEOS.distance(a, b)
        @test c(GeoInterface.buffer(a, 1)) == c(LibGEOS.buffer(a, 1))
        @test c(GeoInterface.convexhull(a)) == c(LibGEOS.convexhull(a))

        @test GeoInterface.equals(a, b) == LibGEOS.equals(a, b)
        @test GeoInterface.disjoint(a, b) == LibGEOS.disjoint(a, b)
        @test GeoInterface.intersects(a, b) == LibGEOS.intersects(a, b)
        @test GeoInterface.touches(a, b) == LibGEOS.touches(a, b)
        @test GeoInterface.within(a, b) == LibGEOS.within(a, b)
        @test GeoInterface.contains(a, b) == LibGEOS.contains(a, b)
        @test GeoInterface.overlaps(a, b) == LibGEOS.overlaps(a, b)
        @test GeoInterface.crosses(a, b) == LibGEOS.crosses(a, b)

        @test c(GeoInterface.symdifference(a, b)) == c(LibGEOS.symmetricDifference(a, b))
        @test c(GeoInterface.difference(a, b)) == c(LibGEOS.difference(a, b))
        @test c(GeoInterface.intersection(a, b)) == c(LibGEOS.intersection(a, b))
        @test c(GeoInterface.union(a, b)) == c(LibGEOS.union(a, b))

    end

end
