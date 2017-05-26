function equivalent_to_wkt(geom::GeoInterface.AbstractGeometry, wkt::String)
    test_geom = parseWKT(wkt)
    @fact geomToWKT(geom) --> geomToWKT(test_geom)
end

function factcheck(f::Function, geom::String, expected::String)
    result = f(parseWKT(geom))
    equivalent_to_wkt(result, expected)
end

function factcheck(f::Function, geom::String, expected::Bool)
    @fact f(parseWKT(geom)) --> expected
end

function factcheck(f::Function, g1::String, g2::String, expected::String)
    result = f(parseWKT(g1),parseWKT(g2))
    equivalent_to_wkt(result, expected)
end

function factcheck(f::Function, g1::String, g2::String, expected::Bool)
    @fact f(parseWKT(g1),parseWKT(g2)) --> expected
end

facts("GEOS operations") do
    ls = LineString(Vector{Float64}[[8,1],[9,1],[9,2],[8,2]])
    pt = interpolate(ls, 2.5)
    @fact GeoInterface.coordinates(pt) --> roughly([8.5, 2.0], 1e-5)
    for (pt,dist,dest) in [(Point(10.0,1.0), 1.0, Point(9.0,1.0)),
                           (Point( 9.0,1.0), 1.0, Point(9.0,1.0)),
                           (Point(10.0,0.0), 1.0, Point(9.0,1.0)),
                           (Point( 9.0,2.0), 2.0, Point(9.0,2.0)),
                           (Point( 8.7,1.5), 1.5, Point(9.0,1.5))]
        test_dist = project(ls, pt)
        @fact test_dist --> roughly(dist, 1e-5)
        @fact equals(interpolate(ls, test_dist), dest) --> true
    end

    g1 = parseWKT("POLYGON EMPTY")
    g2 = parseWKT("POLYGON EMPTY")
    @fact LibGEOS.contains(g1, g2) --> false
    @fact LibGEOS.contains(g2, g1) --> false

    g1 = parseWKT("POLYGON((1 1,1 5,5 5,5 1,1 1))")
    g2 = parseWKT("POINT(2 2)")
    @fact LibGEOS.contains(g1, g2) --> true
    @fact LibGEOS.contains(g2, g1) --> false

    g1 = parseWKT("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
    g2 = parseWKT("POLYGON((1 1,1 2,2 2,2 1,1 1))")
    @fact LibGEOS.contains(g1, g2) --> true
    @fact LibGEOS.contains(g2, g1) --> false


    # GEOSConvexHullTest
    input = parseWKT("MULTIPOINT (130 240, 130 240, 130 240, 570 240, 570 240, 570 240, 650 240)")
    expected = parseWKT("LINESTRING (130 240, 650 240)")
    output = convexhull(input)
    @fact isEmpty(output) --> false
    @fact geomToWKT(output) --> geomToWKT(expected)

    # LibGEOS.delaunayTriangulationTest
    g1 = parseWKT("POLYGON EMPTY")
    g2 = delaunayTriangulationEdges(g1)
    @fact isEmpty(g1) --> true
    @fact isEmpty(g2) --> true
    @fact GeoInterface.geotype(g2) --> :MultiLineString

    g1 = parseWKT("POINT(0 0)")
    g2 = delaunayTriangulation(g1)
    @fact isEmpty(g2) --> true
    @fact GeoInterface.geotype(g2) --> :GeometryCollection

    g1 = parseWKT("MULTIPOINT(0 0, 5 0, 10 0)")
    g2 = delaunayTriangulation(g1, 0.0)
    @fact isEmpty(g2) --> true
    @fact GeoInterface.geotype(g2) --> :GeometryCollection
    g2 = delaunayTriangulationEdges(g1, 0.0)
    equivalent_to_wkt(g2, "MULTILINESTRING ((5 0, 10 0), (0 0, 5 0))")

    g1 = parseWKT("MULTIPOINT(0 0, 10 0, 10 10, 11 10)")
    g2 = delaunayTriangulationEdges(g1, 2.0)
    equivalent_to_wkt(g2, "MULTILINESTRING ((0 0, 10 10), (0 0, 10 0), (10 0, 10 10))")

    # GEOSDistanceTest
    g1 = parseWKT("POINT(10 10)")
    g2 = parseWKT("POINT(3 6)")
    @fact distance(g1, g2) --> roughly(8.06225774829855, 1e-12)

    # GEOSGeom_extractUniquePointsTest
    g1 = parseWKT("POLYGON EMPTY")
    g2 = uniquePoints(g1)
    @fact isEmpty(g2) --> true

    g1 = parseWKT("MULTIPOINT(0 0, 0 0, 1 1)")
    g2 = uniquePoints(g1)
    @fact equals(g2, parseWKT("MULTIPOINT(0 0, 1 1)")) --> true

    g1 = parseWKT("GEOMETRYCOLLECTION(MULTIPOINT(0 0, 0 0, 1 1),LINESTRING(1 1, 2 2, 2 2, 0 0),POLYGON((5 5, 0 0, 0 2, 2 2, 5 5)))")
    @fact LibGEOS.equals(uniquePoints(g1), parseWKT("MULTIPOINT(0 0, 1 1, 2 2, 5 5, 0 2)")) --> true

    # GEOSGetCentroidTest
    test_centroid(geom::String, expected::String) = factcheck(centroid, geom, expected)
    test_centroid("POINT(10 0)", "POINT (10 0)")
    test_centroid("LINESTRING(0 0, 10 0)", "POINT (5 0)")
    test_centroid("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))", "POINT (5 5)")
    test_centroid("LINESTRING EMPTY", "POINT EMPTY")

    # GEOSIntersectionTest
    test_intersection(g1::String, g2::String, expected::String) = factcheck(intersection, g1, g2, expected)
    test_intersection("POLYGON EMPTY", "POLYGON EMPTY", "GEOMETRYCOLLECTION EMPTY")
    test_intersection("POLYGON((1 1,1 5,5 5,5 1,1 1))", "POINT(2 2)", "POINT(2 2)")
    test_intersection("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))", "POLYGON((-1 1,-1 2,2 2,2 1,-1 1))", "POLYGON ((0 1, 0 2, 2 2, 2 1, 0 1))")
    test_intersection("MULTIPOLYGON(((0 0,5 10,10 0,0 0),(1 1,1 2,2 2,2 1,1 1),(100 100,100 102,102 102,102 100,100 100)))",
                      "POLYGON((0 1,0 2,10 2,10 1,0 1))",
                      "GEOMETRYCOLLECTION (LINESTRING (1 2, 2 2), LINESTRING (2 1, 1 1), POLYGON ((0.5 1, 1 2, 1 1, 0.5 1)), POLYGON ((9 2, 9.5 1, 2 1, 2 2, 9 2)))")

    # GEOSIntersectsTest
    test_intersects(g1::String, g2::String, expected::Bool) = factcheck(intersects, g1, g2, false)
    test_intersects("POLYGON EMPTY", "POLYGON EMPTY", false)
    test_intersects("POLYGON((1 1,1 5,5 5,5 1,1 1))", "POINT(2 2)", true)
    test_intersects("POINT(2 2)", "POLYGON((1 1,1 5,5 5,5 1,1 1))", true)
    test_intersects("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))", "POLYGON((1 1,1 2,2 2,2 1,1 1))", true)
    test_intersects("POLYGON((1 1,1 2,2 2,2 1,1 1))", "MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))", true)

    # LineString_PointTest
    g1 = parseWKT("LINESTRING(0 0, 5 5, 10 10)")
    @fact isClosed(g1) --> false
    @fact GeoInterface.geotype(g1) --> :LineString
    @fact numPoints(g1) --> 3
    @fact geomLength(g1) --> roughly(sqrt(100 + 100), 1e-5)
    @fact GeoInterface.coordinates(startPoint(g1)) --> roughly([0,0], 1e-5)
    @fact GeoInterface.coordinates(endPoint(g1)) --> roughly([10,10], 1e-5)

    # GEOSNearestPointsTest
    g1 = parseWKT("POLYGON EMPTY")
    g2 = parseWKT("POLYGON EMPTY")
    @fact length(nearestPoints(g1, g2)) --> 0

    g1 = parseWKT("POLYGON((1 1,1 5,5 5,5 1,1 1))")
    g2 = parseWKT("POLYGON((8 8, 9 9, 9 10, 8 8))")
    points = nearestPoints(g1, g2)
    @fact length(points) --> 2
    @fact GeoInterface.coordinates(points[1]) --> roughly([5.0,5.0], 1e-5)
    @fact GeoInterface.coordinates(points[2]) --> roughly([8.0,8.0], 1e-5)

    # GEOSNodeTest
    g1 = node(parseWKT("LINESTRING(0 0, 10 10, 10 0, 0 10)"))
    normalize!(g1)
    equivalent_to_wkt(g1, "MULTILINESTRING ((5 5, 10 0, 10 10, 5 5), (0 10, 5 5), (0 0, 5 5))")

    g1 = node(parseWKT("MULTILINESTRING((0 0, 2 0, 4 0),(5 0, 3 0, 1 0))"))
    normalize!(g1)
    equivalent_to_wkt(g1, "MULTILINESTRING ((4 0, 5 0), (3 0, 4 0), (2 0, 3 0), (1 0, 2 0), (0 0, 1 0))")

    g1 = node(parseWKT("MULTILINESTRING((0 0, 2 0, 4 0),(0 0, 2 0, 4 0))"))
    normalize!(g1)
    equivalent_to_wkt(g1, "MULTILINESTRING ((2 0, 4 0), (0 0, 2 0))")

    # GEOSPointOnSurfaceTest
    test_pointonsurface(geom::String, expected::String) = factcheck(pointOnSurface, geom, expected)
    test_pointonsurface("POINT(10 0)", "POINT (10 0)")
    test_pointonsurface("LINESTRING(0 0, 5 0, 10 0)", "POINT (5 0)")
    test_pointonsurface("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))", "POINT (5 5)")
    test_pointonsurface("LINESTRING EMPTY", "POINT EMPTY")
    test_pointonsurface("LINESTRING(0 0, 0 0)", "POINT (0 0)")

    g1 = parseWKT(
    """POLYGON(( \
    56.528666666700 25.2101666667, \
    56.529000000000 25.2105000000, \
    56.528833333300 25.2103333333, \
    56.528666666700 25.2101666667))""")
    @fact GeoInterface.coordinates(pointOnSurface(g1)) --> roughly([56.528917,25.210417], 1e-5)

    # GEOSSharedPathsTest
    factcheck(sharedPaths,
              "LINESTRING (-30 -20, 50 60, 50 70, 50 0)",
              "LINESTRING (-29 -20, 50 60, 50 70, 51 0)",
              "GEOMETRYCOLLECTION (MULTILINESTRING ((50 60, 50 70)), MULTILINESTRING EMPTY)")

    # GEOSSimplifyTest
    g1 = parseWKT("POLYGON EMPTY")
    @fact isEmpty(g1) --> true
    g2 = simplify(g1, 43.2)
    @fact isEmpty(g2) --> true
    g1 = parseWKT(
    """POLYGON(( \
    56.528666666700 25.2101666667, \
    56.529000000000 25.2105000000, \
    56.528833333300 25.2103333333, \
    56.528666666700 25.2101666667))""")
    equivalent_to_wkt(simplify(g1, 0.0), "POLYGON EMPTY")
    @fact equals(g1, topologyPreserveSimplify(g1, 43.2)) --> true

    # GEOSSnapTest
    function test_snap(g1::String, g2::String, expected::String, tol::Float64=0.0)
        equivalent_to_wkt(snap(parseWKT(g1), parseWKT(g2), tol), expected)
    end
    test_snap("POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0))", "POINT(0.5 0)",
              "POLYGON ((0.5 0, 10 0, 10 10, 0 10, 0.5 0))", 1.0)
    test_snap("LINESTRING (-30 -20, 50 60, 50 0)", "LINESTRING (-29 -20, 40 60, 51 0)",
              "LINESTRING (-29 -20, 50 60, 51 0)", 2.0)
    test_snap("LINESTRING (-20 -20, 50 50, 100 100)", "LINESTRING (-10 -9, 40 20, 80 79)",
              "LINESTRING (-20 -20, -10 -9, 50 50, 80 79, 100 100)", 2.0)
    test_snap("LINESTRING(0 0, 10 0)", "LINESTRING(0 0, 9 0)",
              "LINESTRING(0 0, 9 0)", 2.0)
    test_snap("LINESTRING(0 0, 10 0)", "LINESTRING(0 0, 9 0, 10 0, 11 0)",
              "LINESTRING(0 0, 9 0, 10 0, 11 0)", 2.0)
    test_snap("LINESTRING(0 3,4 1,0 1)", "MULTIPOINT(5 0,4 1)",
              "LINESTRING (0 3, 4 1, 5 0, 0 1)", 2.0)
    test_snap("LINESTRING(0 3,4 1,0 1)", "MULTIPOINT(4 1,5 0)",
              "LINESTRING (0 3, 4 1, 5 0, 0 1)", 2.0)
    test_snap("LINESTRING(0 0,10 0,10 10,0 10,0 0)", "MULTIPOINT(0 0,-1 0)",
              "LINESTRING (-1 0, 0 0, 10 0, 10 10, 0 10, -1 0)", 3.0)
    test_snap("LINESTRING(0 2,5 2,9 2,5 0)", "POINT(5 0)",
              "LINESTRING (0 2, 5 2, 9 2, 5 0)", 3.0)
    test_snap("LINESTRING(-71.1317 42.2511,-71.1317 42.2509)", "MULTIPOINT(-71.1261 42.2703,-71.1257 42.2703,-71.1261 42.2702)",
              "LINESTRING (-71.1257 42.2703, -71.1261 42.2703, -71.1261 42.2702, -71.1317 42.2509)", .5)

    # GEOSUnaryUnionTest
    test_unaryunion(geom::String, expected::String) = factcheck(unaryUnion, geom, expected)
    test_unaryunion("POINT EMPTY", "GEOMETRYCOLLECTION EMPTY")
    test_unaryunion("POINT (6 3)", "POINT (6 3)")
    test_unaryunion("POINT (4 5 6)", "POINT Z (4 5 6)")
    test_unaryunion("MULTIPOINT (4 5, 6 7, 4 5, 6 5, 6 7)", "MULTIPOINT (4 5, 6 5, 6 7)")
    test_unaryunion("GEOMETRYCOLLECTION (POINT(4 5), MULTIPOINT(6 7, 6 5, 6 7), LINESTRING(0 5, 10 5), LINESTRING(4 -10, 4 10))",
                    "GEOMETRYCOLLECTION (POINT (6 7), LINESTRING (4 -10, 4 5), LINESTRING (4 5, 4 10), LINESTRING (0 5, 4 5), LINESTRING (4 5, 10 5))")
    test_unaryunion("GEOMETRYCOLLECTION (POINT(4 5), MULTIPOINT(6 7, 6 5, 6 7), POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(5 6, 7 6, 7 8, 5 8, 5 6)))",
                    "GEOMETRYCOLLECTION (POINT (6 7), POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0), (5 6, 7 6, 7 8, 5 8, 5 6)))")
    test_unaryunion("GEOMETRYCOLLECTION (MULTILINESTRING((5 7, 12 7), (4 5, 6 5), (5.5 7.5, 6.5 7.5)), POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(5 6, 7 6, 7 8, 5 8, 5 6)))",
                    "GEOMETRYCOLLECTION (LINESTRING (5 7, 7 7), LINESTRING (10 7, 12 7), LINESTRING (5.5 7.5, 6.5 7.5), POLYGON ((10 7, 10 0, 0 0, 0 10, 10 10, 10 7), (5 6, 7 6, 7 7, 7 8, 5 8, 5 7, 5 6)))")
    test_unaryunion("GEOMETRYCOLLECTION (MULTILINESTRING((5 7, 12 7), (4 5, 6 5), (5.5 7.5, 6.5 7.5)), POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(5 6, 7 6, 7 8, 5 8, 5 6)), MULTIPOINT(6 6.5, 6 1, 12 2, 6 1))",
                    "GEOMETRYCOLLECTION (POINT (6 6.5), POINT (12 2), LINESTRING (5 7, 7 7), LINESTRING (10 7, 12 7), LINESTRING (5.5 7.5, 6.5 7.5), POLYGON ((10 7, 10 0, 0 0, 0 10, 10 10, 10 7), (5 6, 7 6, 7 7, 7 8, 5 8, 5 7, 5 6)))")

    # GEOSWithinTest
    test_within(g1::String, g2::String, expected::Bool) = factcheck(within, g1, g2, expected)
    test_within("POLYGON EMPTY", "POLYGON EMPTY", false)
    test_within("POLYGON((1 1,1 5,5 5,5 1,1 1))", "POINT(2 2)", false)
    test_within("POINT(2 2)", "POLYGON((1 1,1 5,5 5,5 1,1 1))", true)
    test_within("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))", "POLYGON((1 1,1 2,2 2,2 1,1 1))", false)
    test_within("POLYGON((1 1,1 2,2 2,2 1,1 1))", "MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))", true)

    # GEOSisClosedTest
    @fact isClosed(parseWKT("LINESTRING(0 0, 1 0, 1 1)")) --> false
    @fact isClosed(parseWKT("LINESTRING(0 0, 0 1, 1 1, 0 0)")) --> true

    # Buffer should return Polygon or MultiPolygon
    @fact typeof(buffer(MultiPoint([[1.0, 1.0], [2.0, 2.0], [2.0, 0.0]]), 0.1)) --> LibGEOS.MultiPolygon
    @fact typeof(buffer(MultiPoint([[1.0, 1.0], [2.0, 2.0], [2.0, 0.0]]), 10)) --> LibGEOS.Polygon
end
