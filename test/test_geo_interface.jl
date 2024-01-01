using Test, Plots, GeoInterface, LibGEOS, Extents
const GI = GeoInterface
const LG = LibGEOS

@testset "Geo interface" begin
    pt = LibGEOS.Point(1.0, 2.0)
    @test GeoInterface.x(pt) == 1.0
    @test GeoInterface.y(pt) == 2.0
    @test GeoInterface.coordinates(pt) ≈ [1, 2] atol = 1e-5
    @test GeoInterface.geomtrait(pt) == PointTrait()
    @test GeoInterface.ncoord(pt) == 2
    @test GeoInterface.getcoord(pt, 1) ≈ 1.0
    @test GeoInterface.testgeometry(pt)
    @test GeoInterface.extent(pt) == Extent(X=(1.0, 1.0), Y=(2.0, 2.0))
    plot(pt)

    pt = LibGEOS.Point(1.0, 2.0, 3.0)
    @test GeoInterface.x(pt) == 1.0
    @test GeoInterface.y(pt) == 2.0
    @test GeoInterface.z(pt) == 3.0
    @test GeoInterface.coordinates(pt) ≈ [1, 2, 3] atol = 1e-5
    @test GeoInterface.ncoord(pt) == 3
    @test GeoInterface.getcoord(pt, 3) ≈ 3.0
    @test GeoInterface.testgeometry(pt)
    # This doesn't return the Z extent
    @test_broken GeoInterface.extent(pt) ==
                 Extent(X = (1.0, 1.0), Y = (2.0, 2.0), Z = (3.0, 3.0))
    plot(pt)

    pt = LibGEOS.Point(1, 2)
    @test GeoInterface.coordinates(pt) ≈ [1, 2] atol = 1e-5
    @test GeoInterface.geomtrait(pt) == PointTrait()
    @test GeoInterface.testgeometry(pt)
    @test GeoInterface.x(pt) == 1
    @test GeoInterface.y(pt) == 2
    @test isnan(GeoInterface.z(pt))

    @inferred GeoInterface.ncoord(pt)
    @inferred GeoInterface.ngeom(pt)
    @inferred GeoInterface.getgeom(pt)
    @inferred GeoInterface.coordinates(pt)
    @inferred GeoInterface.x(pt)
    @inferred GeoInterface.y(pt)
    @inferred GeoInterface.z(pt)

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

    @inferred GeoInterface.ncoord(mpt)
    @inferred GeoInterface.ngeom(mpt)
    @inferred GeoInterface.getgeom(mpt)
    @inferred GeoInterface.coordinates(mpt)

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

    @inferred GeoInterface.ncoord(ls)
    @inferred GeoInterface.ngeom(ls)
    @inferred GeoInterface.getgeom(ls)
    @inferred GeoInterface.coordinates(ls)

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

    @inferred GeoInterface.ncoord(mls)
    @inferred GeoInterface.ngeom(mls)
    @inferred GeoInterface.getgeom(mls)
    @inferred GeoInterface.coordinates(mls)

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

    @inferred GeoInterface.ncoord(lr)
    @inferred GeoInterface.ngeom(lr)
    @inferred GeoInterface.getgeom(lr)
    @inferred GeoInterface.coordinates(lr)

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

    @inferred GeoInterface.ncoord(polygon)
    @inferred GeoInterface.ngeom(polygon)
    @inferred GeoInterface.getgeom(polygon)
    @inferred GeoInterface.coordinates(polygon)

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
    @test GeoInterface.extent(multipolygon) == Extent(X=(0.0, 10.0), Y=(0.0, 10.0))
    plot(multipolygon)

    @inferred GeoInterface.ncoord(multipolygon)
    @inferred GeoInterface.ngeom(multipolygon)
    @inferred GeoInterface.getgeom(multipolygon)
    @inferred GeoInterface.coordinates(multipolygon)

    pmultipolygon = LibGEOS.prepareGeom(multipolygon)
    @test GeoInterface.geomtrait(pmultipolygon) == MultiPolygonTrait()
    @test GeoInterface.testgeometry(pmultipolygon)
    @test GeoInterface.extent(pmultipolygon) == Extent(X=(0.0, 10.0), Y=(0.0, 10.0))
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

    @inferred GeoInterface.ncoord(geomcollection)
    @inferred GeoInterface.ngeom(geomcollection)
    @inferred GeoInterface.getgeom(geomcollection)
    # @inferred GeoInterface.coordinates(geomcollection)  # can't be inferred

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
        one_arg_functions = (
            LG.area,
            LG.geomLength,
            LG.envelope,
            LG.minimumRotatedRectangle,
            LG.convexhull,
            LG.boundary,
            LG.uniquePoints,
            LG.unaryUnion,
            LG.pointOnSurface,
            LG.centroid,
            LG.node,
            LG.delaunayTriangulationEdges,
            LG.delaunayTriangulation,
            LG.constrainedDelaunayTriangulation,
            # these have different signatures
            # LG.simplify, LG.topologyPreserveSimplify,
        )
        two_arg_functions = (
            LG.intersection,
            LG.difference,
            LG.symmetricDifference,
            LG.union,
            LG.distance,
            LG.hausdorffdistance,
            LG.nearestPoints,
            LG.disjoint,
            LG.touches,
            LG.intersects,
            LG.crosses,
            LG.within,
            LG.overlaps,
            LG.covers,
            LG.coveredby,
            LG.equals,
            # these have different signatures
            # LG.project, LG.projectNormalized, LG.sharedPaths, LG.snap, LG.contains, LG.equalsexact,
        )

        mp = LibGEOS.readgeom("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
        @test_throws Exception GeoInterface.convert(Polygon, mp)
        mp2 = GeoInterface.convert(MultiPolygon, mp)
        @test mp2 isa MultiPolygon
        @test mp === mp2

        coords = [0.0, 1.0]
        geom = GeoInterface.convert(Point, GeoInterface.Point(coords))
        @test geom isa Point
        @test GeoInterface.coordinates(geom) == coords

        coords = [[0.0, 0.0], [0.0, 10.0]]
        geom = GeoInterface.convert(MultiPoint, GeoInterface.MultiPoint(coords))
        @test geom isa MultiPoint
        @test GeoInterface.coordinates(geom) == coords
        for f in one_arg_functions
            @test f(LibGEOS.MultiPoint(coords)) == f(GeoInterface.MultiPoint(coords))
        end
        coords2 = [[0.0, 10], [0.5, 10], [20.0, 20], [10.0, 10], [0.0, 10]]
        for f in two_arg_functions
            @test f(LibGEOS.LineString(coords), LibGEOS.LineString(coords)) ==
                  f(GeoInterface.LineString(coords), GeoInterface.LineString(coords))
        end

        coords = [[0.0, 0], [0.0, 10], [10.0, 10], [10.0, 0], [0.0, 0]]
        geom = GeoInterface.convert(LineString, GeoInterface.LineString(coords))
        @test geom isa LineString
        @test GeoInterface.coordinates(geom) == coords
        for f in one_arg_functions
            @test f(LibGEOS.LineString(coords)) == f(GeoInterface.LineString(coords))
        end
        coords2 = [[0.0, 10], [0.5, 10], [20.0, 20], [10.0, 10], [0.0, 10]]
        for f in two_arg_functions
            @test f(LibGEOS.LineString(coords), LibGEOS.LineString(coords)) ==
                  f(GeoInterface.LineString(coords), GeoInterface.LineString(coords))
        end

        coords = [[[0.0, 0], [0.0, 10], [10.0, 10], [10.0, 0], [0.0, 0]]]
        geom = GeoInterface.convert(MultiLineString, GeoInterface.MultiLineString(coords))
        @test geom isa MultiLineString
        @test GeoInterface.coordinates(geom) == coords
        for f in one_arg_functions
            @test f(LibGEOS.MultiLineString(coords)) ==
                  f(GeoInterface.MultiLineString(coords))
        end
        coords2 = [[[0.0, 10], [0.5, 10], [20.0, 20], [10.0, 10], [0.0, 10]]]
        for f in two_arg_functions
            @test f(LibGEOS.MultiLineString(coords), LibGEOS.MultiLineString(coords2)) ==
                  f(GeoInterface.MultiLineString(coords), LibGEOS.MultiLineString(coords2))
        end

        coords = [[[0.0, 0], [0.0, 10], [10.0, 10], [10.0, 0], [0.0, 0]]]
        geom = GeoInterface.convert(Polygon, Polygon(coords))
        @test geom isa Polygon
        @test GeoInterface.ngeom(geom) == 1
        @test GeoInterface.nring(geom) == 1
        @test GeoInterface.nhole(geom) == 0
        @test GeoInterface.coordinates(geom) == coords
        for f in one_arg_functions
            @test f(LibGEOS.Polygon(coords)) == f(GeoInterface.Polygon(coords))
        end
        coords2 = [[[0.0, 10], [0.5, 10], [20.0, 20], [10.0, 10], [0.0, 10]]]
        for f in two_arg_functions
            @test f(LibGEOS.Polygon(coords), LibGEOS.Polygon(coords2)) ==
                  f(GeoInterface.Polygon(coords), LibGEOS.Polygon(coords2))
        end

        pgeom = LibGEOS.prepareGeom(geom)
        @test GeoInterface.coordinates(pgeom) == coords
        LibGEOS.destroyGeom(pgeom)

        coords = [[[[0.0, 0], [0.0, 10], [10.0, 10], [10.0, 0], [0.0, 0]]]]
        geom = GeoInterface.convert(MultiPolygon, GeoInterface.MultiPolygon(coords))
        @test geom isa MultiPolygon
        @test GeoInterface.coordinates(geom) == coords
        for f in one_arg_functions
            @test f(LibGEOS.MultiPolygon(coords)) == f(GeoInterface.MultiPolygon(coords))
        end
        coords2 = [[[[0.0, 10], [0.5, 10], [20.0, 20], [10.0, 10], [0.0, 10]]]]
        for f in two_arg_functions
            @test f(LibGEOS.MultiPolygon(coords), LibGEOS.MultiPolygon(coords2)) ==
                  f(GeoInterface.MultiPolygon(coords), LibGEOS.MultiPolygon(coords2))
        end
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
