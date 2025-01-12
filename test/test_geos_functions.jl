using Test
using LibGEOS
import GeoInterface
using Extents

@testset "WKTWriter" begin
    # default writing options
    p = readgeom("POINT(0.12345 2.000 0.1)")
    @test writegeom(p) == "POINT Z (0.12345 2 0.1)"

    p = readgeom("POINT(0.12345 2.000)")
    @test writegeom(p) == "POINT (0.12345 2)"

    # round to 2 decimals
    writer = LibGEOS.WKTWriter(
        LibGEOS.get_global_context(),
        trim = true,
        outputdim = 3,
        roundingprecision = 2,
    )
    @test_broken writegeom(p, writer) == "POINT (0.12 2)" # Broken in GEOS 3.13.0 https://github.com/libgeos/geos/issues/1198

    # round to 2 decimals and don't trim trailing zeros
    writer = LibGEOS.WKTWriter(
        LibGEOS.get_global_context(),
        trim = false,
        outputdim = 3,
        roundingprecision = 2,
    )
    @test writegeom(p, writer) == "POINT (0.12 2.00)"

    # don't output the Z dimension
    p = readgeom("POINT(0.12345 2.000 0.1)")
    writer = LibGEOS.WKTWriter(
        LibGEOS.get_global_context(),
        trim = false,
        outputdim = 2,
        roundingprecision = 2,
    )
    @test writegeom(p, writer) == "POINT (0.12 2.00)"
end

@testset "GEOS functions" begin
    a = LibGEOS.createCoordSeq(Vector{Float64}[[1, 2, 3], [4, 5, 6]])
    b = LibGEOS.cloneCoordSeq(a)
    @test LibGEOS.getCoordinates(b) == LibGEOS.getCoordinates(a)
    a = LibGEOS.createCoordSeq(
        Vector{Float64}[[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]],
    )
    b = LibGEOS.cloneCoordSeq(a)
    @test LibGEOS.getCoordinates(b) == LibGEOS.getCoordinates(a)
    LibGEOS.setCoordSeq!(b, 2, [3.0, 3.0, 3.0])
    @test_throws ErrorException LibGEOS.setCoordSeq!(b, 0, [3.0, 3.0, 3.0])
    @test_throws ErrorException LibGEOS.setCoordSeq!(b, 5, [3.0, 3.0, 3.0])
    @test LibGEOS.getCoordinates(a) ==
          Vector{Float64}[[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
    @test LibGEOS.getCoordinates(b) ==
          Vector{Float64}[[1, 2, 3], [3, 3, 3], [7, 8, 9], [10, 11, 12]]
    @test_throws ErrorException LibGEOS.getCoordinates(b, 0)
    @test_throws ErrorException LibGEOS.getCoordinates(b, 5)
    c = LibGEOS.Point(1, 2)
    @test LibGEOS.getCoordinates(LibGEOS.getCoordSeq(c))[1] ≈ [1, 2] atol = 1e-5

    # isCCW
    seq = Vector{Float64}[[-1, 0], [0, 0], [10, 0], [10, 10], [0, 10], [-1, 0]]
    a = LibGEOS.createCoordSeq(seq)
    @test LibGEOS.isCCW(a)
    a = LibGEOS.createCoordSeq(Base.reverse(seq))
    @test !LibGEOS.isCCW(a)

    # Polygons and Holes
    shell = LibGEOS.LinearRing(Vector{Float64}[[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]])
    hole1 = LibGEOS.LinearRing(Vector{Float64}[[1, 8], [2, 8], [2, 9], [1, 9], [1, 8]])
    hole2 = LibGEOS.LinearRing(Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2], [8, 1]])
    polygon = LibGEOS.Polygon(shell, [hole1, hole2])
    @test LibGEOS.getGeomDimensions(polygon) == 2
    @test LibGEOS.geomTypeId(polygon) == LibGEOS.GEOS_POLYGON
    @test LibGEOS.area(polygon) ≈ 98.0 atol = 1e-5
    exterior = LibGEOS.exteriorRing(polygon)
    @test LibGEOS.getCoordinates(LibGEOS.getCoordSeq(exterior)) ==
          Vector{Float64}[[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]]
    @test LibGEOS.getCoordinates(LibGEOS.getCoordSeq(LibGEOS.interiorRing(polygon, 1))) ==
          Vector{Float64}[[1, 8], [2, 8], [2, 9], [1, 9], [1, 8]]
    @test LibGEOS.getCoordinates(LibGEOS.getCoordSeq(LibGEOS.interiorRing(polygon, 2))) ==
          Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2], [8, 1]]
    @test_throws ErrorException LibGEOS.interiorRing(polygon, 0)
    @test_throws ErrorException LibGEOS.interiorRing(polygon, 3)
    interiors = LibGEOS.interiorRings(polygon)
    @test LibGEOS.getCoordinates(LibGEOS.getCoordSeq(interiors[1])) ==
          Vector{Float64}[[1, 8], [2, 8], [2, 9], [1, 9], [1, 8]]
    @test LibGEOS.getCoordinates(LibGEOS.getCoordSeq(interiors[2])) ==
          Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2], [8, 1]]

    exterior_poly = LibGEOS.Polygon(exterior)
    @test LibGEOS.getGeomDimensions(exterior_poly) == 2
    @test LibGEOS.geomTypeId(exterior_poly) == LibGEOS.GEOS_POLYGON
    @test LibGEOS.area(exterior_poly) ≈ 100.0 atol = 1e-5
    @test_throws ErrorException LibGEOS.interiorRing(exterior_poly, 1)
    @test LibGEOS.equals(LibGEOS.exteriorRing(exterior_poly), exterior)


    # Interpolation and Projection
    ls = LibGEOS.LineString(Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2]])
    pt = LibGEOS.interpolate(ls, 2.5)
    coords = LibGEOS.getCoordinates(LibGEOS.getCoordSeq(pt))
    @test length(coords) == 1
    @test coords[1] ≈ [8.5, 2.0] atol = 1e-5
    p1 = Point(10, 1)
    p2 = Point(9, 1)
    p3 = Point(10, 0)
    p4 = Point(9, 2)
    p5 = Point(8.7, 1.5)
    dist = LibGEOS.project(ls, p1)
    @test dist ≈ 1 atol = 1e-5
    @test LibGEOS.equals(LibGEOS.interpolate(ls, dist), p2)
    @test LibGEOS.project(ls, p2) ≈ 1 atol = 1e-5
    @test LibGEOS.project(ls, p3) ≈ 1 atol = 1e-5
    @test LibGEOS.project(ls, p4) ≈ 2 atol = 1e-5
    @test LibGEOS.project(ls, p5) ≈ 1.5 atol = 1e-5


    # Taken from https://svn.osgeo.org/geos/trunk/tests/unit/capi/

    # GEOSContainsTest
    geom1_ = LibGEOS.readgeom("POLYGON EMPTY")
    geom2_ = LibGEOS.readgeom("POLYGON EMPTY")
    @test !Base.contains(geom1_, geom2_)
    @test !Base.contains(geom2_, geom1_)
    @test !LibGEOS.contains(geom1_, geom2_)
    @test !LibGEOS.contains(geom2_, geom1_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    geom1_ = LibGEOS.readgeom("POLYGON((1 1,1 5,5 5,5 1,1 1))")
    geom2_ = LibGEOS.readgeom("POINT(2 2)")
    @test Base.contains(geom1_, geom2_)
    @test !Base.contains(geom2_, geom1_)
    @test LibGEOS.contains(geom1_, geom2_)
    @test !LibGEOS.contains(geom2_, geom1_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    geom1_ = LibGEOS.readgeom("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
    geom2_ = LibGEOS.readgeom("POLYGON((1 1,1 2,2 2,2 1,1 1))")
    @test Base.contains(geom1_, geom2_)
    @test !Base.contains(geom2_, geom1_)
    @test LibGEOS.contains(geom1_, geom2_)
    @test !LibGEOS.contains(geom2_, geom1_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    # GEOSConvexHullTest
    input_ = LibGEOS.readgeom(
        "MULTIPOINT (130 240, 130 240, 130 240, 570 240, 570 240, 570 240, 650 240)",
    )
    expected_ = LibGEOS.readgeom("LINESTRING (130 240, 650 240)")
    output_ = LibGEOS.convexhull(input_)
    @test !LibGEOS.isEmpty(output_)
    @test LibGEOS.equals(output_, expected_)
    LibGEOS.destroyGeom(input_)
    LibGEOS.destroyGeom(expected_)
    LibGEOS.destroyGeom(output_)

    # GEOSCoordSeqTest
    cs_ = LibGEOS.createCoordSeq(5, 3)
    @test LibGEOS.getSize(cs_) == 1
    @test LibGEOS.getDimensions(cs_) == 2
    @test LibGEOS.getCoordinates(cs_) == [[5.0, 3.0]]
    # z coordinate stays NaN for 2D geometry
    @test isnan(LibGEOS.getZ(cs_, 1))
    LibGEOS.setZ!(cs_, 1, 2.0)
    @test isnan(LibGEOS.getZ(cs_, 1))

    cs_2 = LibGEOS.createCoordSeq([5.0, 3.0])
    @test LibGEOS.getSize(cs_2) == 1
    @test LibGEOS.getDimensions(cs_2) == 2
    @test LibGEOS.getCoordinates(cs_2) == [[5.0, 3.0]]

    cs_3 = LibGEOS.createCoordSeq(Vector{Float64}[[5.0, 3.0], [1.0, 2.0], [1.0, 3.0]])
    @test LibGEOS.getSize(cs_3) == 3
    @test LibGEOS.getDimensions(cs_3) == 2
    @test LibGEOS.getCoordinates(cs_3)[1] == [5.0, 3.0]
    @test LibGEOS.getCoordinates(cs_3)[2] == [1.0, 2.0]
    @test LibGEOS.getCoordinates(cs_3)[3] == [1.0, 3.0]
    @test LibGEOS.getCoordinates(cs_3, 1) == [5.0, 3.0]
    @test LibGEOS.getCoordinates(cs_3, 2) == [1.0, 2.0]
    @test LibGEOS.getCoordinates(cs_3, 3) == [1.0, 3.0]

    cs_ = LibGEOS.createCoordSeq(0, 0, 0)
    for i = 1:5
        x = i * 10.0
        y = i * 10.0 + 1.0
        z = i * 10.0 + 2.0

        LibGEOS.setX!(cs_, 1, x)
        LibGEOS.setY!(cs_, 1, y)
        LibGEOS.setZ!(cs_, 1, z)
        @test LibGEOS.getX(cs_, 1) ≈ x atol = 1e-5
        @test LibGEOS.getY(cs_, 1) ≈ y atol = 1e-5
        @test LibGEOS.getZ(cs_, 1) ≈ z atol = 1e-5
    end

    cs_ = LibGEOS.createCoordSeq(1, ndim = 3)
    @test LibGEOS.getSize(cs_) == 1
    @test LibGEOS.getDimensions(cs_) == 3
    x, y, z = 10.0, 11.0, 12.0

    LibGEOS.setX!(cs_, 1, x)
    LibGEOS.setY!(cs_, 1, y)
    LibGEOS.setZ!(cs_, 1, z)
    @test_throws ErrorException LibGEOS.setX!(cs_, 0, x)
    @test_throws ErrorException LibGEOS.setX!(cs_, 2, x)
    @test_throws ErrorException LibGEOS.setY!(cs_, 0, y)
    @test_throws ErrorException LibGEOS.setY!(cs_, 2, y)
    @test_throws ErrorException LibGEOS.setZ!(cs_, 0, z)
    @test_throws ErrorException LibGEOS.setZ!(cs_, 2, z)
    @test LibGEOS.getX(cs_, 1) ≈ x atol = 1e-5
    @test LibGEOS.getY(cs_, 1) ≈ y atol = 1e-5
    @test LibGEOS.getZ(cs_, 1) ≈ z atol = 1e-5
    @test_throws ErrorException LibGEOS.getX(cs_, 0)
    @test_throws ErrorException LibGEOS.getX(cs_, 2)
    @test_throws ErrorException LibGEOS.getY(cs_, 0)
    @test_throws ErrorException LibGEOS.getY(cs_, 2)
    @test_throws ErrorException LibGEOS.getZ(cs_, 0)
    @test_throws ErrorException LibGEOS.getZ(cs_, 2)

    cs_ = LibGEOS.createCoordSeq(1, ndim = 3)
    @test LibGEOS.getSize(cs_) == 1
    @test LibGEOS.getDimensions(cs_) == 3
    x, y, z = 10.0, 11.0, 12.0

    LibGEOS.setX!(cs_, 1, x)
    LibGEOS.setY!(cs_, 1, y)
    LibGEOS.setZ!(cs_, 1, z)
    @test LibGEOS.getX(cs_, 1) ≈ x atol = 1e-5
    @test LibGEOS.getY(cs_, 1) ≈ y atol = 1e-5
    @test LibGEOS.getZ(cs_, 1) ≈ z atol = 1e-5

    # LibGEOS.delaunayTriangulationTest
    geom1_ = LibGEOS.readgeom("POLYGON EMPTY")
    @test LibGEOS.isEmpty(geom1_)
    geom2_ = LibGEOS.delaunayTriangulation(geom1_, 0.0, true)
    @test LibGEOS.isEmpty(geom2_)
    @test LibGEOS.geomTypeId(geom2_) == LibGEOS.GEOS_MULTILINESTRING
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    geom1_ = LibGEOS.readgeom("POINT(0 0)")
    geom2_ = LibGEOS.delaunayTriangulation(geom1_, 0.0, false)
    @test LibGEOS.isEmpty(geom2_)
    @test LibGEOS.geomTypeId(geom2_) == LibGEOS.GEOS_GEOMETRYCOLLECTION
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    geom1_ = LibGEOS.readgeom("MULTIPOINT(0 0, 5 0, 10 0)")
    geom2_ = LibGEOS.delaunayTriangulation(geom1_, 0.0, false)
    @test LibGEOS.isEmpty(geom2_)
    @test LibGEOS.geomTypeId(geom2_) == LibGEOS.GEOS_GEOMETRYCOLLECTION
    LibGEOS.destroyGeom(geom2_)
    geom2_ = LibGEOS.delaunayTriangulation(geom1_, 0.0, true)
    geom3_ = LibGEOS.readgeom("MULTILINESTRING ((5 0, 10 0), (0 0, 5 0))")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("MULTIPOINT(0 0, 10 0, 10 10, 11 10)")
    geom2_ = LibGEOS.delaunayTriangulation(geom1_, 2.0, true)
    geom3_ = LibGEOS.readgeom("MULTILINESTRING ((0 0, 10 10), (0 0, 10 0), (10 0, 10 10))")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    # GEOSDistanceTest
    geom1_ = LibGEOS.readgeom("POINT(10 10)")
    geom2_ = LibGEOS.readgeom("POINT(3 6)")
    @test LibGEOS.distance(geom1_, geom2_) ≈ 8.06225774829855 atol = 1e-12
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    # GEOSGeom_extractUniquePointsTest
    geom1_ = LibGEOS.readgeom("POLYGON EMPTY")
    geom2_ = LibGEOS.uniquePoints(geom1_)
    @test LibGEOS.isEmpty(geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    geom1_ = LibGEOS.readgeom("MULTIPOINT(0 0, 0 0, 1 1)")
    geom2_ = LibGEOS.readgeom("MULTIPOINT(0 0, 1 1)")
    geom3_ = LibGEOS.uniquePoints(geom1_)
    @test LibGEOS.equals(geom3_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION(MULTIPOINT(0 0, 0 0, 1 1),LINESTRING(1 1, 2 2, 2 2, 0 0),POLYGON((5 5, 0 0, 0 2, 2 2, 5 5)))",
    )
    geom2_ = LibGEOS.readgeom("MULTIPOINT(0 0, 1 1, 2 2, 5 5, 0 2)")
    geom3_ = LibGEOS.uniquePoints(geom1_)
    @test LibGEOS.equals(geom3_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    # GEOSGetCentroidTest
    geom1_ = LibGEOS.readgeom("POINT(10 0)")
    geom2_ = LibGEOS.centroid(geom1_)
    geom3_ = LibGEOS.readgeom("POINT (10 0)")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("LINESTRING(0 0, 10 0)")
    geom2_ = LibGEOS.centroid(geom1_)
    geom3_ = LibGEOS.readgeom("POINT (5 0)")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))")
    geom2_ = LibGEOS.centroid(geom1_)
    geom3_ = LibGEOS.readgeom("POINT (5 5)")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("LINESTRING EMPTY")
    geom2_ = LibGEOS.centroid(geom1_)
    geom3_ = LibGEOS.readgeom("POINT EMPTY")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    # GEOSIntersectionTest
    geom1_ = LibGEOS.readgeom("POLYGON EMPTY")
    geom2_ = LibGEOS.readgeom("POLYGON EMPTY")
    geom3_ = LibGEOS.intersection(geom1_, geom2_)
    geom4_ = LibGEOS.readgeom("GEOMETRYCOLLECTION EMPTY")
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    geom1_ = LibGEOS.readgeom("POLYGON((1 1,1 5,5 5,5 1,1 1))")
    geom2_ = LibGEOS.readgeom("POINT(2 2)")
    geom3_ = LibGEOS.intersection(geom1_, geom2_)
    @test LibGEOS.equals(geom3_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
    geom2_ = LibGEOS.readgeom("POLYGON((-1 1,-1 2,2 2,2 1,-1 1))")
    geom3_ = LibGEOS.intersection(geom1_, geom2_)
    geom4_ = LibGEOS.readgeom("POLYGON ((0 1, 0 2, 2 2, 2 1, 0 1))")
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    geom1_ = LibGEOS.readgeom(
        "MULTIPOLYGON(((0 0,5 10,10 0,0 0),(1 1,1 2,2 2,2 1,1 1),(100 100,100 102,102 102,102 100,100 100)))",
    )
    geom2_ = LibGEOS.readgeom("POLYGON((0 1,0 2,10 2,10 1,0 1))")
    geom3_ = LibGEOS.intersection(geom1_, geom2_)
    geom4_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (LINESTRING (1 2, 2 2), LINESTRING (2 1, 1 1), POLYGON ((0.5 1, 1 2, 1 1, 0.5 1)), POLYGON ((9 2, 9.5 1, 2 1, 2 2, 9 2)))",
    )
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    # GEOSIntersectsTest
    geom1_ = LibGEOS.readgeom("POLYGON EMPTY")
    geom2_ = LibGEOS.readgeom("POLYGON EMPTY")
    @test !LibGEOS.intersects(geom1_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    geom1_ = LibGEOS.readgeom("POLYGON((1 1,1 5,5 5,5 1,1 1))")
    geom2_ = LibGEOS.readgeom("POINT(2 2)")
    @test LibGEOS.intersects(geom1_, geom2_)
    @test LibGEOS.intersects(geom2_, geom1_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    geom1_ = LibGEOS.readgeom("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
    geom2_ = LibGEOS.readgeom("POLYGON((1 1,1 2,2 2,2 1,1 1))")
    @test LibGEOS.intersects(geom1_, geom2_)
    @test LibGEOS.intersects(geom2_, geom1_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    # LineString_PointTest
    geom1 = LibGEOS.readgeom("LINESTRING(0 0, 5 5, 10 10)")
    @test !LibGEOS.isClosed(geom1)
    @test LibGEOS.geomTypeId(geom1) == LibGEOS.GEOS_LINESTRING
    @test LibGEOS.numPoints(geom1) == 3
    @test_throws ErrorException LibGEOS.getPoint(geom1, 0)
    @test_throws ErrorException LibGEOS.getPoint(geom1, 4)
    @test LibGEOS.geomLength(geom1) ≈ sqrt(100 + 100) atol = 1e-5
    geom2 = LibGEOS.getPoint(geom1, 1)
    @test LibGEOS.getGeomX(geom2) ≈ 0.0 atol = 1e-5
    @test LibGEOS.getGeomY(geom2) ≈ 0.0 atol = 1e-5
    geom2 = LibGEOS.getPoint(geom1, 2)
    @test LibGEOS.getGeomX(geom2) ≈ 5.0 atol = 1e-5
    @test LibGEOS.getGeomY(geom2) ≈ 5.0 atol = 1e-5
    LibGEOS.destroyGeom(geom2)
    geom2 = LibGEOS.getPoint(geom1, 3)
    @test LibGEOS.getGeomX(geom2) ≈ 10.0 atol = 1e-5
    @test LibGEOS.getGeomY(geom2) ≈ 10.0 atol = 1e-5
    geom2 = LibGEOS.startPoint(geom1)
    @test LibGEOS.getGeomX(geom2) ≈ 0.0 atol = 1e-5
    @test LibGEOS.getGeomY(geom2) ≈ 0.0 atol = 1e-5
    LibGEOS.destroyGeom(geom2)
    geom2 = LibGEOS.endPoint(geom1)
    @test LibGEOS.getGeomX(geom2) ≈ 10.0 atol = 1e-5
    @test LibGEOS.getGeomY(geom2) ≈ 10.0 atol = 1e-5
    LibGEOS.destroyGeom(geom2)

    # GEOSNearestPointsTest
    geom1_ = LibGEOS.readgeom("POLYGON EMPTY")
    geom2_ = LibGEOS.readgeom("POLYGON EMPTY")
    prepGeom1_ = LibGEOS.prepareGeom(geom1_)
    @test LibGEOS.nearestPoints(geom1_, geom2_) == Point[]
    @test LibGEOS.nearestPoints(prepGeom1_, geom2_) == Point[]
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyPreparedGeom(prepGeom1_)

    for (wkt1_, wkt2_, wkt3_, wkt4_) in [
        [
            "POLYGON((1 1,1 5,5 5,5 1,1 1))",
            "POLYGON((8 8, 9 9, 9 10, 8 8))",
            "POINT(5 5)",
            "POINT(8 8)",
        ],
        ["POLYGON((1 1,1 5,5 5,5 1,1 1))", "POINT(2 2)", "POINT(2 2)", "POINT(2 2)"],
        ["LINESTRING(1 5,5 5,5 1,1 1)", "POINT(2 2)", "POINT(2 1)", "POINT(2 2)"],
        ["LINESTRING(0 0,10 10)", "LINESTRING(0 10,10 0)", "POINT(5 5)", "POINT(5 5)"],
        [
            "POLYGON((0 0,10 0,10 10,0 10,0 0))",
            "LINESTRING(8 5,12 5)",
            "POINT(8 5)",
            "POINT(8 5)",
        ],
    ]
        geom1_ = LibGEOS.readgeom(wkt1_)
        geom2_ = LibGEOS.readgeom(wkt2_)
        geom3_ = LibGEOS.readgeom(wkt3_)
        geom4_ = LibGEOS.readgeom(wkt4_)
        prepGeom1_ = LibGEOS.prepareGeom(geom1_)

        coords_ = LibGEOS.nearestPoints(geom1_, geom2_)
        @test coords_ isa Vector{Point}
        @test length(coords_) == 2
        @test LibGEOS.equals(coords_[1], geom3_)
        @test LibGEOS.equals(coords_[2], geom4_)

        prepCoords_ = LibGEOS.nearestPoints(prepGeom1_, geom2_)
        @test prepCoords_ isa Vector{Point}
        @test length(prepCoords_) == 2
        @test LibGEOS.equals(prepCoords_[1], geom3_)
        @test LibGEOS.equals(prepCoords_[2], geom4_)

        LibGEOS.destroyGeom(geom1_)
        LibGEOS.destroyGeom(geom2_)
        LibGEOS.destroyGeom(geom3_)
        LibGEOS.destroyGeom(geom4_)
        LibGEOS.destroyGeom(coords_[1])
        LibGEOS.destroyGeom(coords_[2])
        LibGEOS.destroyGeom(prepCoords_[1])
        LibGEOS.destroyGeom(prepCoords_[2])
        LibGEOS.destroyPreparedGeom(prepGeom1_)
    end

    # GEOSNodeTest
    geom1_ = LibGEOS.readgeom("LINESTRING(0 0, 10 10, 10 0, 0 10)")
    geom2_ = LibGEOS.node(geom1_)
    LibGEOS.normalize!(geom2_)
    geom3_ = LibGEOS.readgeom(
        "MULTILINESTRING ((5 5, 10 0, 10 10, 5 5), (0 10, 5 5), (0 0, 5 5))",
    )
    @test equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("MULTILINESTRING((0 0, 2 0, 4 0),(5 0, 3 0, 1 0))")
    geom2_ = LibGEOS.node(geom1_)
    LibGEOS.normalize!(geom2_)
    geom3_ = LibGEOS.readgeom(
        "MULTILINESTRING ((4 0, 5 0), (3 0, 4 0), (2 0, 3 0), (1 0, 2 0), (0 0, 1 0))",
    )
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("MULTILINESTRING((0 0, 2 0, 4 0),(0 0, 2 0, 4 0))")
    geom2_ = LibGEOS.node(geom1_)
    LibGEOS.normalize!(geom2_)
    geom3_ = LibGEOS.readgeom("MULTILINESTRING ((2 0, 4 0), (0 0, 2 0))")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    # GEOSPointOnSurfaceTest
    geom1_ = LibGEOS.readgeom("POINT(10 0)")
    geom2_ = LibGEOS.pointOnSurface(geom1_)
    geom3_ = LibGEOS.readgeom("POINT (10 0)")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("LINESTRING(0 0, 5 0, 10 0)")
    geom2_ = LibGEOS.pointOnSurface(geom1_)
    geom3_ = LibGEOS.readgeom("POINT (5 0)")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))")
    geom2_ = LibGEOS.pointOnSurface(geom1_)
    geom3_ = LibGEOS.readgeom("POINT (5 5)")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("""POLYGON((
                               56.528666666700 25.2101666667,
                               56.529000000000 25.2105000000,
                               56.528833333300 25.2103333333,
                               56.528666666700 25.2101666667))""")
    geom2_ = LibGEOS.pointOnSurface(geom1_)
    @test LibGEOS.getCoordinates(LibGEOS.getCoordSeq(geom2_))[1] ≈
          [56.5286666667, 25.2101666667] atol = 1e-5
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    geom1_ = LibGEOS.readgeom("LINESTRING EMPTY")
    geom2_ = LibGEOS.pointOnSurface(geom1_)
    geom3_ = LibGEOS.readgeom("POINT EMPTY")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("LINESTRING(0 0, 0 0)")
    geom2_ = LibGEOS.pointOnSurface(geom1_)
    geom3_ = LibGEOS.readgeom("POINT (0 0)")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    # GEOSPreparedGeometryTest

    geom1_ = LibGEOS.readgeom("POLYGON EMPTY")
    prepGeom1_ = LibGEOS.prepareGeom(geom1_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyPreparedGeom(prepGeom1_)

    geom1_ = LibGEOS.readgeom("POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))")
    geom2_ = LibGEOS.readgeom("POLYGON((2 2, 2 3, 3 3, 3 2, 2 2))")
    prepGeom1_ = LibGEOS.prepareGeom(geom1_)
    @test LibGEOS.containsproperly(prepGeom1_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyPreparedGeom(prepGeom1_)

    geom1_ = LibGEOS.readgeom("POLYGON((2 2, 2 3, 3 3, 3 2, 2 2))")
    geom2_ = LibGEOS.readgeom("POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))")
    prepGeom1_ = LibGEOS.prepareGeom(geom1_)
    @test !LibGEOS.containsproperly(prepGeom1_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyPreparedGeom(prepGeom1_)

    geom1_ = LibGEOS.readgeom("LINESTRING(0 0, 10 10)")
    geom2_ = LibGEOS.readgeom("LINESTRING(0 10, 10 0)")
    prepGeom1_ = LibGEOS.prepareGeom(geom1_)
    @test LibGEOS.intersects(prepGeom1_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyPreparedGeom(prepGeom1_)

    geom1_ = LibGEOS.readgeom("POLYGON((0 0, 0 10, 10 11, 10 0, 0 0))")
    geom2_ = LibGEOS.readgeom("POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))")
    prepGeom1_ = LibGEOS.prepareGeom(geom1_)
    @test LibGEOS.covers(prepGeom1_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyPreparedGeom(prepGeom1_)

    geom1_ = LibGEOS.readgeom("POLYGON((0 0, 0 10, 10 11, 10 0, 0 0))")
    geom2_ = LibGEOS.readgeom("POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))")
    prepGeom1_ = LibGEOS.prepareGeom(geom1_)
    @test LibGEOS.contains(prepGeom1_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyPreparedGeom(prepGeom1_)

    # GEOSSharedPathsTest
    geom1_ = LibGEOS.readgeom("LINESTRING (-30 -20, 50 60, 50 70, 50 0)")
    geom2_ = LibGEOS.readgeom("LINESTRING (-29 -20, 50 60, 50 70, 51 0)")
    geom3_ = LibGEOS.sharedPaths(geom1_, geom2_)
    geom4_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (MULTILINESTRING ((50 60, 50 70)), MULTILINESTRING EMPTY)",
    )
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    # /// Illegal case (point-poly)
    # void object::test<1>()
    # {
    #     geom1_ = GEOSGeomFromWKT("POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0))")
    #     geom2_ = GEOSGeomFromWKT("POINT(0.5 0)")
    #     geom3_ = GEOSSharedPaths(geom1_, geom2_)

    #     ensure(!geom3_)
    # }

    # http://trac.osgeo.org/postgis/ticket/670#comment:3
    # geom1_ = LibGEOS.readgeom("POINT(-11.1111111 40)")
    # geom2_ = LibGEOS.readgeom("POLYGON((-8.1111111 60,-8.16875525879031 59.4147290339516,-8.33947250246614 58.8519497029047,-8.61670226309236 58.3332893009412,-8.98979075644036 57.8786796564404,-9.44440040094119 57.5055911630924,-9.96306080290473 57.2283614024661,-10.5258401339516 57.0576441587903,-11.1111111 57,-11.6963820660484 57.0576441587903,-12.2591613970953 57.2283614024661,-12.7778217990588 57.5055911630924,-13.2324314435596 57.8786796564404,-13.6055199369076 58.3332893009412,-13.8827496975339 58.8519497029047,-14.0534669412097 59.4147290339516,-14.1111111 60,-14.0534669412097 60.5852709660484,-13.8827496975339 61.1480502970953,-13.6055199369076 61.6667106990588,-13.2324314435597 62.1213203435596,-12.7778217990588 62.4944088369076,-12.2591613970953 62.7716385975339,-11.6963820660484 62.9423558412097,-11.1111111 63,-10.5258401339516 62.9423558412097,-9.96306080290474 62.7716385975339,-9.4444004009412 62.4944088369076,-8.98979075644036 62.1213203435596,-8.61670226309237 61.6667106990588,-8.33947250246614 61.1480502970953,-8.16875525879031 60.5852709660484,-8.1111111 60))")
    # geom3_ = LibGEOS.sharedPaths(geom1_, geom2_)
    # ensure(!geom3_)

    # GEOSSimplifyTest
    geom1_ = LibGEOS.readgeom("POLYGON EMPTY")
    @test LibGEOS.isEmpty(geom1_)
    geom2_ = LibGEOS.simplify(geom1_, 43.2)
    @test LibGEOS.isEmpty(geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    # GEOSSnapTest

    geom1_ = LibGEOS.readgeom("POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0))")
    geom2_ = LibGEOS.readgeom("POINT(0.5 0)")
    geom3_ = LibGEOS.snap(geom1_, geom2_, 1.0)
    geom4_ = LibGEOS.readgeom("POLYGON ((0.5 0, 10 0, 10 10, 0 10, 0.5 0))")
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    geom1_ = LibGEOS.readgeom("LINESTRING (-30 -20, 50 60, 50 0)")
    geom2_ = LibGEOS.readgeom("LINESTRING (-29 -20, 40 60, 51 0)")
    geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
    geom4_ = LibGEOS.readgeom("LINESTRING (-29 -20, 50 60, 51 0)")
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    geom1_ = LibGEOS.readgeom("LINESTRING (-20 -20, 50 50, 100 100)")
    geom2_ = LibGEOS.readgeom("LINESTRING (-10 -9, 40 20, 80 79)")
    geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
    geom4_ = LibGEOS.readgeom("LINESTRING (-20 -20, -10 -9, 50 50, 80 79, 100 100)")
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    geom1_ = LibGEOS.readgeom("LINESTRING(0 0, 10 0)")
    geom2_ = LibGEOS.readgeom("LINESTRING(0 0, 9 0)")
    geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
    @test LibGEOS.equals(geom3_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("LINESTRING(0 0, 10 0)")
    geom2_ = LibGEOS.readgeom("LINESTRING(0 0, 9 0, 10 0, 11 0)")
    geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
    @test LibGEOS.equals(geom3_, geom2_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("LINESTRING(0 3,4 1,0 1)")
    geom2_ = LibGEOS.readgeom("MULTIPOINT(5 0,4 1)")
    geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
    geom4_ = LibGEOS.readgeom("LINESTRING (0 3, 4 1, 5 0, 0 1)")
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    geom1_ = LibGEOS.readgeom("LINESTRING(0 3,4 1,0 1)")
    geom2_ = LibGEOS.readgeom("MULTIPOINT(4 1,5 0)")
    geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
    geom4_ = LibGEOS.readgeom("LINESTRING (0 3, 4 1, 5 0, 0 1)")
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    geom1_ = LibGEOS.readgeom("LINESTRING(0 0,10 0,10 10,0 10,0 0)")
    geom2_ = LibGEOS.readgeom("MULTIPOINT(0 0,-1 0)")
    geom3_ = LibGEOS.snap(geom1_, geom2_, 3.0)
    geom4_ = LibGEOS.readgeom("LINESTRING (-1 0, 0 0, 10 0, 10 10, 0 10, -1 0)")
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    geom1_ = LibGEOS.readgeom("LINESTRING(0 2,5 2,9 2,5 0)")
    geom2_ = LibGEOS.readgeom("POINT(5 0)")
    geom3_ = LibGEOS.snap(geom1_, geom2_, 3.0)
    geom4_ = LibGEOS.readgeom("LINESTRING (0 2, 5 2, 9 2, 5 0)")
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    geom1_ = LibGEOS.readgeom("LINESTRING(-71.1317 42.2511,-71.1317 42.2509)")
    geom2_ =
        LibGEOS.readgeom("MULTIPOINT(-71.1261 42.2703,-71.1257 42.2703,-71.1261 42.2702)")
    geom3_ = LibGEOS.snap(geom1_, geom2_, 0.5)
    geom4_ = LibGEOS.readgeom(
        "LINESTRING (-71.1257 42.2703, -71.1261 42.2703, -71.1261 42.2702, -71.1317 42.2509)",
    )
    @test LibGEOS.equals(geom3_, geom4_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(geom4_)

    # GEOSUnaryUnionTest
    geom1_ = LibGEOS.readgeom("POINT EMPTY")
    geom2_ = LibGEOS.unaryUnion(geom1_)
    geom3_ = LibGEOS.readgeom("POINT EMPTY")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("POINT (6 3)")
    geom2_ = LibGEOS.unaryUnion(geom1_)
    geom3_ = LibGEOS.readgeom("POINT (6 3)")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("POINT (4 5 6)")
    geom2_ = LibGEOS.unaryUnion(geom1_)
    geom3_ = LibGEOS.readgeom("POINT Z (4 5 6)")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom("MULTIPOINT (4 5, 6 7, 4 5, 6 5, 6 7)")
    geom2_ = LibGEOS.unaryUnion(geom1_)
    geom3_ = LibGEOS.readgeom("MULTIPOINT (4 5, 6 5, 6 7)")
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (POINT(4 5), MULTIPOINT(6 7, 6 5, 6 7), LINESTRING(0 5, 10 5), LINESTRING(4 -10, 4 10))",
    )
    geom2_ = LibGEOS.unaryUnion(geom1_)
    geom3_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (POINT (6 7), LINESTRING (0 5, 4 5), LINESTRING (4 5, 10 5), LINESTRING (4 -10, 4 5), LINESTRING (4 5, 4 10))",
    )
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (POINT(4 5), MULTIPOINT(6 7, 6 5, 6 7), POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(5 6, 7 6, 7 8, 5 8, 5 6)))",
    )
    geom2_ = LibGEOS.unaryUnion(geom1_)
    geom3_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (POINT (6 7), POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0), (5 6, 7 6, 7 8, 5 8, 5 6)))",
    )
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (MULTILINESTRING((5 7, 12 7), (4 5, 6 5), (5.5 7.5, 6.5 7.5)), POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(5 6, 7 6, 7 8, 5 8, 5 6)))",
    )
    geom2_ = LibGEOS.unaryUnion(geom1_)
    geom3_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (LINESTRING (5 7, 7 7), LINESTRING (10 7, 12 7), LINESTRING (5.5 7.5, 6.5 7.5), POLYGON ((10 7, 10 0, 0 0, 0 10, 10 10, 10 7), (5 6, 7 6, 7 7, 7 8, 5 8, 5 7, 5 6)))",
    )
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    geom1_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (MULTILINESTRING((5 7, 12 7), (4 5, 6 5), (5.5 7.5, 6.5 7.5)), POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(5 6, 7 6, 7 8, 5 8, 5 6)), MULTIPOINT(6 6.5, 6 1, 12 2, 6 1))",
    )
    geom2_ = LibGEOS.unaryUnion(geom1_)
    geom3_ = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (POINT (6 6.5), POINT (12 2), LINESTRING (5 7, 7 7), LINESTRING (10 7, 12 7), LINESTRING (5.5 7.5, 6.5 7.5), POLYGON ((10 7, 10 0, 0 0, 0 10, 10 10, 10 7), (5 6, 7 6, 7 7, 7 8, 5 8, 5 7, 5 6)))",
    )
    @test LibGEOS.equals(geom2_, geom3_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)

    # GEOSWithinTest
    geom1_ = LibGEOS.readgeom("POLYGON EMPTY")
    geom2_ = LibGEOS.readgeom("POLYGON EMPTY")
    @test !LibGEOS.within(geom1_, geom2_)
    @test !LibGEOS.within(geom2_, geom1_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    geom1_ = LibGEOS.readgeom("POLYGON((1 1,1 5,5 5,5 1,1 1))")
    geom2_ = LibGEOS.readgeom("POINT(2 2)")
    @test !LibGEOS.within(geom1_, geom2_)
    @test LibGEOS.within(geom2_, geom1_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    geom1_ = LibGEOS.readgeom("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
    geom2_ = LibGEOS.readgeom("POLYGON((1 1,1 2,2 2,2 1,1 1))")
    @test !LibGEOS.within(geom1_, geom2_)
    @test LibGEOS.within(geom2_, geom1_)
    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)

    # GEOSisClosedTest
    geom_ = LibGEOS.readgeom("LINESTRING(0 0, 1 0, 1 1)")
    @test !LibGEOS.isClosed(geom_)
    LibGEOS.destroyGeom(geom_)
    geom_ = LibGEOS.readgeom("LINESTRING(0 0, 0 1, 1 1, 0 0)")
    @test LibGEOS.isClosed(geom_)
    LibGEOS.destroyGeom(geom_)

    # setPrecision, getPrecision
    # Taken from https://git.osgeo.org/gitea/geos/geos/src/branch/master/tests/unit/capi/GEOSGeom_setPrecisionTest.cpp

    geom1_ = readgeom("LINESTRING(2 10, 4 30)")
    geom2_ = readgeom("LINESTRING(4 10, 2 30)")
    geom3_ = intersection(geom1_, geom2_)
    @test equals(geom3_, readgeom("POINT(3 20)"))

    g = setPrecision(geom1_, 2.0)
    LibGEOS.destroyGeom(geom1_)
    geom1_ = g
    g = setPrecision(geom2_, 2.0)
    LibGEOS.destroyGeom(geom2_)
    geom2_ = g
    geom3_ = intersection(geom1_, geom2_)
    @test equals(geom3_, readgeom("POINT(4 20)"))

    g = setPrecision(geom1_, 0.5)
    LibGEOS.destroyGeom(geom1_)
    geom1_ = g
    geom3_ = intersection(geom1_, geom2_)
    @test equals(geom3_, readgeom("POINT(3 20)"))
    @test getPrecision(geom1_) == 0.5
    @test getPrecision(geom2_) == 2.0

    geom1_ = readgeom("POLYGON((10 10,20 10,16 15,20 20, 10 20, 14 15, 10 10))")
    geom2_ = setPrecision(geom1_, 5.0)
    @test equals(
        geom2_,
        readgeom(
            "MULTIPOLYGON (((10 10, 15 15, 20 10, 10 10)), ((15 15, 10 20, 20 20, 15 15)))",
        ),
    )
    geom3_ = setPrecision(geom1_, 5.0; flags = 1)
    @test equals(
        geom3_,
        readgeom("POLYGON ((10 10, 20 10, 15 15, 20 20, 10 20, 15 15, 10 10))"),
    )

    geom1_ = readgeom("LINESTRING(1 0, 2 0)")
    geom2_ = setPrecision(geom1_, 5.0)
    @test equals(geom2_, readgeom("LINESTRING EMPTY"))
    geom3_ = setPrecision(geom1_, 5.0; flags = 2)
    @test writegeom(geom3_) == "LINESTRING (0 0, 0 0)"

    @test writegeom(setPrecision(geom1_, 5.0; flags = LibGEOS.GEOS_PREC_VALID_OUTPUT)) ==
          writegeom(setPrecision(geom1_, 5.0; flags = 0))
    @test writegeom(setPrecision(geom1_, 5.0; flags = LibGEOS.GEOS_PREC_NO_TOPO)) ==
          writegeom(setPrecision(geom1_, 5.0; flags = 1))
    @test writegeom(setPrecision(geom1_, 5.0; flags = LibGEOS.GEOS_PREC_KEEP_COLLAPSED)) ==
          writegeom(setPrecision(geom1_, 5.0; flags = 2))
    bitwise_or_flag = LibGEOS.GEOS_PREC_NO_TOPO | LibGEOS.GEOS_PREC_KEEP_COLLAPSED
    @test writegeom(setPrecision(geom1_, 5.0; flags = bitwise_or_flag)) ==
          writegeom(setPrecision(geom1_, 5.0; flags = 0x03))

    LibGEOS.destroyGeom(geom1_)
    LibGEOS.destroyGeom(geom2_)
    LibGEOS.destroyGeom(geom3_)
    LibGEOS.destroyGeom(g)

    # GEOSMinimumRotatedRectangleTest
    input_ = readgeom("POLYGON ((1 6, 6 11, 11 6, 6 1, 1 6))")
    output_ = minimumRotatedRectangle(input_)
    expected_ = readgeom("POLYGON ((6 1, 11 6, 6 11, 1 6, 6 1))")
    @test LibGEOS.equals(output_, expected_)
    LibGEOS.destroyGeom(input_)
    LibGEOS.destroyGeom(output_)
    LibGEOS.destroyGeom(expected_)

    @testset "getExtent" begin
        geom = LibGEOS.readgeom("LINESTRING(0 0, 1 0, 1 1)")
        # LibGEOS.getExtent(geom) == [0, 0, 1, 1]
        GeoInterface.extent(geom) == Extent(X = (0, 1), Y = (0, 1))
    end

    p = LibGEOS.createEmptyPolygon()
    @test p == readgeom("POLYGON EMPTY")
    @test p isa Polygon

    lss = readgeom("MULTILINESTRING((0 0, 0 1), (0 1, 0 2))")
    @test lineMerge(lss) == readgeom("LINESTRING (0 0, 0 1, 0 2)")

    lss = readgeom("MULTILINESTRING((0 0, 0 1), (0 2, 0 3), (0 3, 0 4))")
    @test lineMerge(lss) == readgeom("MULTILINESTRING ((0 0, 0 1), (0 2, 0 3, 0 4))")

    lss = readgeom("MULTILINESTRING EMPTY")
    @test lineMerge(lss) == readgeom("GEOMETRYCOLLECTION EMPTY")

    lss = readgeom("LINESTRING EMPTY")
    @test lineMerge(lss) == readgeom("GEOMETRYCOLLECTION EMPTY")

    @test LibGEOS.reverse(readgeom("LINESTRING(0 0, 1 1)")) ==
          readgeom("LINESTRING(1 1, 0 0)")

    geo = readgeom("POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))")
    mic = LibGEOS.maximumInscribedCircle(geo, 1e-4)
    @test mic == readgeom("LINESTRING (0.5 0.5, 0 0.5)")
end
