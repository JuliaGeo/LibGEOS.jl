
a = LibGEOS.createCoordSeq(Vector{Float64}[[1,2,3],[4,5,6]])
b = LibGEOS.cloneCoordSeq(a)
factcheck_equals(LibGEOS.getCoordinates(b), LibGEOS.getCoordinates(a))
a = LibGEOS.createCoordSeq(Vector{Float64}[[1,2,3],[4,5,6],[7,8,9],[10,11,12]])
b = LibGEOS.cloneCoordSeq(a)
factcheck_equals(LibGEOS.getCoordinates(b), LibGEOS.getCoordinates(a))
LibGEOS.setCoordSeq!(b, 2, [3.0, 3.0, 3.0])
factcheck_equals(LibGEOS.getCoordinates(a), Vector{Float64}[[1,2,3],[4,5,6],[7,8,9],[10,11,12]])
factcheck_equals(LibGEOS.getCoordinates(b), Vector{Float64}[[1,2,3],[3,3,3],[7,8,9],[10,11,12]])
c = LibGEOS.createPoint(LibGEOS.createCoordSeq(Vector{Float64}[[1,2]]))
@fact LibGEOS.getCoordinates(LibGEOS.getCoordSeq(c))[1] --> roughly([1,2], 1e-5)

# Polygons and Holes
shell = LibGEOS.createLinearRing(Vector{Float64}[[0,0],[10,0],[10,10],[0,10],[0,0]])
hole1 = LibGEOS.createLinearRing(Vector{Float64}[[1,8],[2,8],[2,9],[1,9],[1,8]])
hole2 = LibGEOS.createLinearRing(Vector{Float64}[[8,1],[9,1],[9,2],[8,2],[8,1]])
polygon = LibGEOS.createPolygon(shell,LibGEOS.GEOSGeom[hole1,hole2])
@fact LibGEOS.getDimensions(polygon) --> 2
@fact LibGEOS.geomTypeId(polygon) --> LibGEOS.GEOS_POLYGON
@fact LibGEOS.geomArea(polygon) --> roughly(98.0, 1e-5)
exterior = LibGEOS.exteriorRing(polygon)
factcheck_equals(LibGEOS.getCoordinates(LibGEOS.getCoordSeq(exterior)), Vector{Float64}[[0,0],[10,0],[10,10],[0,10],[0,0]])
interiors = LibGEOS.interiorRings(polygon)
factcheck_equals(LibGEOS.getCoordinates(LibGEOS.getCoordSeq(interiors[1])), Vector{Float64}[[1,8],[2,8],[2,9],[1,9],[1,8]])
factcheck_equals(LibGEOS.getCoordinates(LibGEOS.getCoordSeq(interiors[2])), Vector{Float64}[[8,1],[9,1],[9,2],[8,2],[8,1]])

# Interpolation and Projection
ls = LibGEOS.createLineString(Vector{Float64}[[8,1],[9,1],[9,2],[8,2]])
pt = LibGEOS.interpolate(ls, 2.5)
coords = LibGEOS.getCoordinates(LibGEOS.getCoordSeq(pt))
@fact length(coords) --> 1
@fact coords[1] --> roughly([8.5, 2.0], 1e-5)
p1 = LibGEOS.createPoint(Float64[10,1])
p2 = LibGEOS.createPoint(Float64[9,1])
p3 = LibGEOS.createPoint(Float64[10,0])
p4 = LibGEOS.createPoint(Float64[9,2])
p5 = LibGEOS.createPoint(Float64[8.7,1.5])
dist = LibGEOS.project(ls, p1)
@fact dist --> roughly(1, 1e-5)
@fact LibGEOS.equals(LibGEOS.interpolate(ls, dist), p2) --> true
@fact LibGEOS.project(ls, p2) --> roughly(1, 1e-5)
@fact LibGEOS.project(ls, p3) --> roughly(1, 1e-5)
@fact LibGEOS.project(ls, p4) --> roughly(2, 1e-5)
@fact LibGEOS.project(ls, p5) --> roughly(1.5, 1e-5)


# Taken from https://svn.osgeo.org/geos/trunk/tests/unit/capi/

# GEOSContainsTest
geom1_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
geom2_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
@fact LibGEOS.contains(geom1_, geom2_) --> false
@fact LibGEOS.contains(geom2_, geom1_) --> false
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((1 1,1 5,5 5,5 1,1 1))")
geom2_ = LibGEOS.geomFromWKT("POINT(2 2)")
@fact LibGEOS.contains(geom1_, geom2_) --> true
@fact LibGEOS.contains(geom2_, geom1_) --> false
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
geom2_ = LibGEOS.geomFromWKT("POLYGON((1 1,1 2,2 2,2 1,1 1))")
@fact LibGEOS.contains(geom1_, geom2_) --> true
@fact LibGEOS.contains(geom2_, geom1_) --> false
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

# GEOSConvexHullTest
input_ = LibGEOS.geomFromWKT("MULTIPOINT (130 240, 130 240, 130 240, 570 240, 570 240, 570 240, 650 240)")
expected_ = LibGEOS.geomFromWKT("LINESTRING (130 240, 650 240)")
output_ = LibGEOS.convexhull(input_)
@fact LibGEOS.isEmpty(output_) --> false
@fact LibGEOS.geomToWKT(output_) --> LibGEOS.geomToWKT(expected_)
LibGEOS.destroyGeom(input_)
LibGEOS.destroyGeom(expected_)
LibGEOS.destroyGeom(output_)

# GEOSCoordSeqTest

cs_ = LibGEOS.createCoordSeq(5, 3)
@fact LibGEOS.getSize(cs_) --> 5
@fact LibGEOS.getDimensions(cs_) --> 3

for i=1:5
    x = i*10.0
    y = i*10.0+1.0
    z = i*10.0+2.0

    LibGEOS.setX!(cs_, i, x)
    LibGEOS.setY!(cs_, i, y)
    LibGEOS.setZ!(cs_, i, z)
    @fact LibGEOS.getX(cs_, i) --> roughly(x, 1e-5)
    @fact LibGEOS.getY(cs_, i) --> roughly(y, 1e-5)
    @fact LibGEOS.getZ(cs_, i) --> roughly(z, 1e-5)
end

cs_ = LibGEOS.createCoordSeq(1, 3)
@fact LibGEOS.getSize(cs_) --> 1
@fact LibGEOS.getDimensions(cs_) --> 3
x,y,z = 10.0, 11.0, 12.0

LibGEOS.setX!(cs_, 1, x)
LibGEOS.setY!(cs_, 1, y)
LibGEOS.setZ!(cs_, 1, z)
@fact LibGEOS.getX(cs_, 1) --> roughly(x, 1e-5)
@fact LibGEOS.getY(cs_, 1) --> roughly(y, 1e-5)
@fact LibGEOS.getZ(cs_, 1) --> roughly(z, 1e-5)

cs_ = LibGEOS.createCoordSeq(1, 3)
@fact LibGEOS.getSize(cs_) --> 1
@fact LibGEOS.getDimensions(cs_) --> 3
x,y,z = 10.0, 11.0, 12.0

LibGEOS.setX!(cs_, 1, x)
LibGEOS.setY!(cs_, 1, y)
LibGEOS.setZ!(cs_, 1, z)
@fact LibGEOS.getX(cs_, 1) --> roughly(x, 1e-5)
@fact LibGEOS.getY(cs_, 1) --> roughly(y, 1e-5)
@fact LibGEOS.getZ(cs_, 1) --> roughly(z, 1e-5)

# LibGEOS.delaunayTriangulationTest
geom1_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
@fact LibGEOS.isEmpty(geom1_) --> true
geom2_ = LibGEOS.delaunayTriangulation(geom1_,0.0,true)
@fact LibGEOS.isEmpty(geom2_) --> true
@fact LibGEOS.geomTypeId(geom2_) --> LibGEOS.GEOS_MULTILINESTRING
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("POINT(0 0)")
geom2_ = LibGEOS.delaunayTriangulation(geom1_, 0.0, false)
@fact LibGEOS.isEmpty(geom2_) --> true
@fact LibGEOS.geomTypeId(geom2_) --> LibGEOS.GEOS_GEOMETRYCOLLECTION
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("MULTIPOINT(0 0, 5 0, 10 0)")
geom2_ = LibGEOS.delaunayTriangulation(geom1_, 0.0, false)
@fact LibGEOS.isEmpty(geom2_) --> true
@fact LibGEOS.geomTypeId(geom2_) --> LibGEOS.GEOS_GEOMETRYCOLLECTION
LibGEOS.destroyGeom(geom2_)
geom2_ = LibGEOS.delaunayTriangulation(geom1_, 0.0, true)
geom3_ = LibGEOS.geomFromWKT("MULTILINESTRING ((5 0, 10 0), (0 0, 5 0))")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("MULTIPOINT(0 0, 10 0, 10 10, 11 10)")
geom2_ = LibGEOS.delaunayTriangulation(geom1_, 2.0, true)
geom3_ = LibGEOS.geomFromWKT("MULTILINESTRING ((0 0, 10 10), (0 0, 10 0), (10 0, 10 10))")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

# GEOSDistanceTest
geom1_ = LibGEOS.geomFromWKT("POINT(10 10)")
geom2_ = LibGEOS.geomFromWKT("POINT(3 6)")
@fact LibGEOS.geomDistance(geom1_, geom2_) --> roughly(8.06225774829855, 1e-12)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

# GEOSGeom_extractUniquePointsTest
geom1_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
geom2_ = LibGEOS.uniquePoints(geom1_)
@fact LibGEOS.isEmpty(geom2_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("MULTIPOINT(0 0, 0 0, 1 1)")
geom2_ = LibGEOS.geomFromWKT("MULTIPOINT(0 0, 1 1)")
geom3_ = LibGEOS.uniquePoints(geom1_)
@fact LibGEOS.equals(geom3_, geom2_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION(MULTIPOINT(0 0, 0 0, 1 1),LINESTRING(1 1, 2 2, 2 2, 0 0),POLYGON((5 5, 0 0, 0 2, 2 2, 5 5)))")
geom2_ = LibGEOS.geomFromWKT("MULTIPOINT(0 0, 1 1, 2 2, 5 5, 0 2)")
geom3_ = LibGEOS.uniquePoints(geom1_)
@fact LibGEOS.equals(geom3_, geom2_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

# GEOSGetCentroidTest
geom1_ = LibGEOS.geomFromWKT("POINT(10 0)")
geom2_ = LibGEOS.centroid(geom1_)
geom3_ = LibGEOS.geomFromWKT("POINT (10 0)")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 10 0)")
geom2_ = LibGEOS.centroid(geom1_)
geom3_ = LibGEOS.geomFromWKT("POINT (5 0)")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))")
geom2_ = LibGEOS.centroid(geom1_)
geom3_ = LibGEOS.geomFromWKT("POINT (5 5)")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING EMPTY")
geom2_ = LibGEOS.centroid(geom1_)
geom3_ = LibGEOS.geomFromWKT("POINT EMPTY")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

# GEOSIntersectionTest
geom1_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
geom2_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
geom3_ = LibGEOS.intersection(geom1_, geom2_)
@fact LibGEOS.geomToWKT(geom3_) --> "GEOMETRYCOLLECTION EMPTY"
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((1 1,1 5,5 5,5 1,1 1))")
geom2_ = LibGEOS.geomFromWKT("POINT(2 2)")
geom3_ = LibGEOS.intersection(geom1_, geom2_)
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom2_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
geom2_ = LibGEOS.geomFromWKT("POLYGON((-1 1,-1 2,2 2,2 1,-1 1))")
geom3_ = LibGEOS.intersection(geom1_, geom2_)
geom4_ = LibGEOS.geomFromWKT("POLYGON ((0 1, 0 2, 2 2, 2 1, 0 1))")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)
LibGEOS.destroyGeom(geom4_)

geom1_ = LibGEOS.geomFromWKT("MULTIPOLYGON(((0 0,5 10,10 0,0 0),(1 1,1 2,2 2,2 1,1 1),(100 100,100 102,102 102,102 100,100 100)))")
geom2_ = LibGEOS.geomFromWKT("POLYGON((0 1,0 2,10 2,10 1,0 1))")
geom3_ = LibGEOS.intersection(geom1_, geom2_)
geom4_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (LINESTRING (1 2, 2 2), LINESTRING (2 1, 1 1), POLYGON ((0.5 1, 1 2, 1 1, 0.5 1)), POLYGON ((9 2, 9.5 1, 2 1, 2 2, 9 2)))")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)
LibGEOS.destroyGeom(geom4_)

# GEOSIntersectsTest
geom1_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
geom2_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
@fact LibGEOS.intersects(geom1_, geom2_) --> false
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((1 1,1 5,5 5,5 1,1 1))")
geom2_ = LibGEOS.geomFromWKT("POINT(2 2)")
@fact LibGEOS.intersects(geom1_, geom2_) --> true
@fact LibGEOS.intersects(geom2_, geom1_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
geom2_ = LibGEOS.geomFromWKT("POLYGON((1 1,1 2,2 2,2 1,1 1))")
@fact LibGEOS.intersects(geom1_, geom2_) --> true
@fact LibGEOS.intersects(geom2_, geom1_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

# LineString_PointTest
geom1 = LibGEOS.geomFromWKT("LINESTRING(0 0, 5 5, 10 10)")
@fact LibGEOS.isClosed(geom1) --> false
@fact LibGEOS.geomTypeId(geom1) --> LibGEOS.GEOS_LINESTRING
@fact LibGEOS.numPoints(geom1) --> 3
@fact LibGEOS.getLength(geom1) --> roughly(sqrt(100 + 100), 1e-5)
geom2 = LibGEOS.getPoint(geom1, 1)
@fact LibGEOS.getGeomX(geom2) --> roughly(0.0, 1e-5)
@fact LibGEOS.getGeomY(geom2) --> roughly(0.0, 1e-5)
geom2 = LibGEOS.getPoint(geom1, 2)
@fact LibGEOS.getGeomX(geom2) --> roughly(5.0, 1e-5)
@fact LibGEOS.getGeomY(geom2) --> roughly(5.0, 1e-5)
LibGEOS.destroyGeom(geom2)
geom2 = LibGEOS.getPoint(geom1, 3)
@fact LibGEOS.getGeomX(geom2) --> roughly(10.0, 1e-5)
@fact LibGEOS.getGeomY(geom2) --> roughly(10.0, 1e-5)
geom2 = LibGEOS.startPoint(geom1)
@fact LibGEOS.getGeomX(geom2) --> roughly(0.0, 1e-5)
@fact LibGEOS.getGeomY(geom2) --> roughly(0.0, 1e-5)
LibGEOS.destroyGeom(geom2)
geom2 = LibGEOS.endPoint(geom1)
@fact LibGEOS.getGeomX(geom2) --> roughly(10.0, 1e-5)
@fact LibGEOS.getGeomY(geom2) --> roughly(10.0, 1e-5)
LibGEOS.destroyGeom(geom2)

# GEOSNearestPointsTest
geom1_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
geom2_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
@fact LibGEOS.nearestPoints(geom1_, geom2_) --> C_NULL
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((1 1,1 5,5 5,5 1,1 1))")
geom2_ = LibGEOS.geomFromWKT("POLYGON((8 8, 9 9, 9 10, 8 8))")
coords_ = LibGEOS.nearestPoints(geom1_, geom2_)
@fact LibGEOS.getSize(coords_) --> 2
@fact LibGEOS.getCoordinates(coords_,1)[1:2] --> roughly([5.0,5.0], 1e-5)
@fact LibGEOS.getCoordinates(coords_,2)[1:2] --> roughly([8.0,8.0], 1e-5)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyCoordSeq(coords_)

# GEOSNodeTest
geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 10 10, 10 0, 0 10)")
geom2_ = LibGEOS.node(geom1_)
normalize!(geom2_)
geom3_ = LibGEOS.geomFromWKT("MULTILINESTRING ((5 5, 10 0, 10 10, 5 5), (0 10, 5 5), (0 0, 5 5))")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("MULTILINESTRING((0 0, 2 0, 4 0),(5 0, 3 0, 1 0))")
geom2_ = LibGEOS.node(geom1_)
normalize!(geom2_)
geom3_ = LibGEOS.geomFromWKT("MULTILINESTRING ((4 0, 5 0), (3 0, 4 0), (2 0, 3 0), (1 0, 2 0), (0 0, 1 0))")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("MULTILINESTRING((0 0, 2 0, 4 0),(0 0, 2 0, 4 0))")
geom2_ = LibGEOS.node(geom1_)
normalize!(geom2_)
geom3_ = LibGEOS.geomFromWKT("MULTILINESTRING ((2 0, 4 0), (0 0, 2 0))")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

# GEOSPointOnSurfaceTest
geom1_ = LibGEOS.geomFromWKT("POINT(10 0)")
geom2_ = LibGEOS.pointOnSurface(geom1_)
geom3_ = LibGEOS.geomFromWKT("POINT (10 0)")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 5 0, 10 0)")
geom2_ = LibGEOS.pointOnSurface(geom1_)
geom3_ = LibGEOS.geomFromWKT("POINT (5 0)")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))")
geom2_ = LibGEOS.pointOnSurface(geom1_)
geom3_ = LibGEOS.geomFromWKT("POINT (5 5)")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT(
"""POLYGON(( \
56.528666666700 25.2101666667, \
56.529000000000 25.2105000000, \
56.528833333300 25.2103333333, \
56.528666666700 25.2101666667))""")
geom2_ = LibGEOS.pointOnSurface(geom1_)
@fact LibGEOS.getCoordinates(LibGEOS.getCoordSeq(geom2_))[1] --> roughly([56.528917,25.210417], 1e-5)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING EMPTY")
geom2_ = LibGEOS.pointOnSurface(geom1_)
@fact LibGEOS.geomToWKT(geom2_) --> "POINT EMPTY"

geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 0 0)")
geom2_ = LibGEOS.pointOnSurface(geom1_)
geom3_ = LibGEOS.geomFromWKT("POINT (0 0)")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

# GEOSPreparedGeometryTest

geom1_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
prepGeom1_ = LibGEOS.prepareGeom(geom1_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyPreparedGeom(prepGeom1_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))")
geom2_ = LibGEOS.geomFromWKT("POLYGON((2 2, 2 3, 3 3, 3 2, 2 2))")
prepGeom1_ = LibGEOS.prepareGeom(geom1_)
@fact LibGEOS.prepcontainsproperly(prepGeom1_, geom2_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyPreparedGeom(prepGeom1_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((2 2, 2 3, 3 3, 3 2, 2 2))")
geom2_ = LibGEOS.geomFromWKT("POLYGON((0 0, 0 10, 10 10, 10 0, 0 0))")
prepGeom1_ = LibGEOS.prepareGeom(geom1_)
@fact LibGEOS.prepcontainsproperly(prepGeom1_, geom2_) --> false
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyPreparedGeom(prepGeom1_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 10 10)")
geom2_ = LibGEOS.geomFromWKT("LINESTRING(0 10, 10 0)")
prepGeom1_ = LibGEOS.prepareGeom(geom1_)
@fact LibGEOS.prepintersects(prepGeom1_, geom2_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyPreparedGeom(prepGeom1_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((0 0, 0 10, 10 11, 10 0, 0 0))")
geom2_ = LibGEOS.geomFromWKT("POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))")
prepGeom1_ = LibGEOS.prepareGeom(geom1_)
@fact LibGEOS.prepcovers(prepGeom1_, geom2_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyPreparedGeom(prepGeom1_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((0 0, 0 10, 10 11, 10 0, 0 0))")
geom2_ = LibGEOS.geomFromWKT("POLYGON((0 0, 2 0, 2 2, 0 2, 0 0))")
prepGeom1_ = LibGEOS.prepareGeom(geom1_)
@fact LibGEOS.prepcontains(prepGeom1_, geom2_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyPreparedGeom(prepGeom1_)

# GEOSSharedPathsTest
geom1_ = LibGEOS.geomFromWKT("LINESTRING (-30 -20, 50 60, 50 70, 50 0)")
geom2_ = LibGEOS.geomFromWKT("LINESTRING (-29 -20, 50 60, 50 70, 51 0)")
geom3_ = LibGEOS.sharedPaths(geom1_, geom2_)
geom4_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (MULTILINESTRING ((50 60, 50 70)), MULTILINESTRING EMPTY)")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
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
# geom1_ = LibGEOS.geomFromWKT("POINT(-11.1111111 40)")
# geom2_ = LibGEOS.geomFromWKT("POLYGON((-8.1111111 60,-8.16875525879031 59.4147290339516,-8.33947250246614 58.8519497029047,-8.61670226309236 58.3332893009412,-8.98979075644036 57.8786796564404,-9.44440040094119 57.5055911630924,-9.96306080290473 57.2283614024661,-10.5258401339516 57.0576441587903,-11.1111111 57,-11.6963820660484 57.0576441587903,-12.2591613970953 57.2283614024661,-12.7778217990588 57.5055911630924,-13.2324314435596 57.8786796564404,-13.6055199369076 58.3332893009412,-13.8827496975339 58.8519497029047,-14.0534669412097 59.4147290339516,-14.1111111 60,-14.0534669412097 60.5852709660484,-13.8827496975339 61.1480502970953,-13.6055199369076 61.6667106990588,-13.2324314435597 62.1213203435596,-12.7778217990588 62.4944088369076,-12.2591613970953 62.7716385975339,-11.6963820660484 62.9423558412097,-11.1111111 63,-10.5258401339516 62.9423558412097,-9.96306080290474 62.7716385975339,-9.4444004009412 62.4944088369076,-8.98979075644036 62.1213203435596,-8.61670226309237 61.6667106990588,-8.33947250246614 61.1480502970953,-8.16875525879031 60.5852709660484,-8.1111111 60))")
# geom3_ = LibGEOS.sharedPaths(geom1_, geom2_)
# ensure(!geom3_)

# GEOSSimplifyTest
geom1_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
@fact LibGEOS.isEmpty(geom1_) --> true
geom2_ = LibGEOS.simplify(geom1_, 43.2)
@fact LibGEOS.isEmpty(geom2_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

# GEOSSnapTest

geom1_ = LibGEOS.geomFromWKT("POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0))")
geom2_ = LibGEOS.geomFromWKT("POINT(0.5 0)")
geom3_ = LibGEOS.snap(geom1_, geom2_, 1.0)
geom4_ = LibGEOS.geomFromWKT("POLYGON ((0.5 0, 10 0, 10 10, 0 10, 0.5 0))")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)
LibGEOS.destroyGeom(geom4_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING (-30 -20, 50 60, 50 0)")
geom2_ = LibGEOS.geomFromWKT("LINESTRING (-29 -20, 40 60, 51 0)")
geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
geom4_ = LibGEOS.geomFromWKT("LINESTRING (-29 -20, 50 60, 51 0)")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)
LibGEOS.destroyGeom(geom4_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING (-20 -20, 50 50, 100 100)")
geom2_ = LibGEOS.geomFromWKT("LINESTRING (-10 -9, 40 20, 80 79)")
geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
geom4_ = LibGEOS.geomFromWKT("LINESTRING (-20 -20, -10 -9, 50 50, 80 79, 100 100)")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)
LibGEOS.destroyGeom(geom4_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 10 0)")
geom2_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 9 0)")
geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom2_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 10 0)")
geom2_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 9 0, 10 0, 11 0)")
geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom2_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 3,4 1,0 1)")
geom2_ = LibGEOS.geomFromWKT("MULTIPOINT(5 0,4 1)")
geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
geom4_ = LibGEOS.geomFromWKT("LINESTRING (0 3, 4 1, 5 0, 0 1)")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)
LibGEOS.destroyGeom(geom4_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 3,4 1,0 1)")
geom2_ = LibGEOS.geomFromWKT("MULTIPOINT(4 1,5 0)")
geom3_ = LibGEOS.snap(geom1_, geom2_, 2.0)
geom4_ = LibGEOS.geomFromWKT("LINESTRING (0 3, 4 1, 5 0, 0 1)")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)
LibGEOS.destroyGeom(geom4_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 0,10 0,10 10,0 10,0 0)")
geom2_ = LibGEOS.geomFromWKT("MULTIPOINT(0 0,-1 0)")
geom3_ = LibGEOS.snap(geom1_, geom2_, 3.0)
geom4_ = LibGEOS.geomFromWKT("LINESTRING (-1 0, 0 0, 10 0, 10 10, 0 10, -1 0)")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)
LibGEOS.destroyGeom(geom4_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING(0 2,5 2,9 2,5 0)")
geom2_ = LibGEOS.geomFromWKT("POINT(5 0)")
geom3_ = LibGEOS.snap(geom1_, geom2_, 3.0)
geom4_ = LibGEOS.geomFromWKT("LINESTRING (0 2, 5 2, 9 2, 5 0)")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)
LibGEOS.destroyGeom(geom4_)

geom1_ = LibGEOS.geomFromWKT("LINESTRING(-71.1317 42.2511,-71.1317 42.2509)")
geom2_ = LibGEOS.geomFromWKT("MULTIPOINT(-71.1261 42.2703,-71.1257 42.2703,-71.1261 42.2702)")
geom3_ = LibGEOS.snap(geom1_, geom2_, 0.5)
geom4_ = LibGEOS.geomFromWKT("LINESTRING (-71.1257 42.2703, -71.1261 42.2703, -71.1261 42.2702, -71.1317 42.2509)")
@fact LibGEOS.geomToWKT(geom3_) --> LibGEOS.geomToWKT(geom4_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)
LibGEOS.destroyGeom(geom4_)

# GEOSUnaryUnionTest
geom1_ = LibGEOS.geomFromWKT("POINT EMPTY")
geom2_ = LibGEOS.unaryUnion(geom1_)
@fact LibGEOS.geomToWKT(geom2_) --> "GEOMETRYCOLLECTION EMPTY"
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("POINT (6 3)")
geom2_ = LibGEOS.unaryUnion(geom1_)
geom3_ = LibGEOS.geomFromWKT("POINT (6 3)")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("POINT (4 5 6)")
geom2_ = LibGEOS.unaryUnion(geom1_)
geom3_ = LibGEOS.geomFromWKT("POINT Z (4 5 6)")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("MULTIPOINT (4 5, 6 7, 4 5, 6 5, 6 7)")
geom2_ = LibGEOS.unaryUnion(geom1_)
geom3_ = LibGEOS.geomFromWKT("MULTIPOINT (4 5, 6 5, 6 7)")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (POINT(4 5), MULTIPOINT(6 7, 6 5, 6 7), LINESTRING(0 5, 10 5), LINESTRING(4 -10, 4 10))")
geom2_ = LibGEOS.unaryUnion(geom1_)
geom3_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (POINT (6 7), LINESTRING (4 -10, 4 5), LINESTRING (4 5, 4 10), LINESTRING (0 5, 4 5), LINESTRING (4 5, 10 5))")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (POINT(4 5), MULTIPOINT(6 7, 6 5, 6 7), POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(5 6, 7 6, 7 8, 5 8, 5 6)))")
geom2_ = LibGEOS.unaryUnion(geom1_)
geom3_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (POINT (6 7), POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0), (5 6, 7 6, 7 8, 5 8, 5 6)))")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (MULTILINESTRING((5 7, 12 7), (4 5, 6 5), (5.5 7.5, 6.5 7.5)), POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(5 6, 7 6, 7 8, 5 8, 5 6)))")
geom2_ = LibGEOS.unaryUnion(geom1_)
geom3_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (LINESTRING (5 7, 7 7), LINESTRING (10 7, 12 7), LINESTRING (5.5 7.5, 6.5 7.5), POLYGON ((10 7, 10 0, 0 0, 0 10, 10 10, 10 7), (5 6, 7 6, 7 7, 7 8, 5 8, 5 7, 5 6)))")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

geom1_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (MULTILINESTRING((5 7, 12 7), (4 5, 6 5), (5.5 7.5, 6.5 7.5)), POLYGON((0 0, 10 0, 10 10, 0 10, 0 0),(5 6, 7 6, 7 8, 5 8, 5 6)), MULTIPOINT(6 6.5, 6 1, 12 2, 6 1))")
geom2_ = LibGEOS.unaryUnion(geom1_)
geom3_ = LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (POINT (6 6.5), POINT (12 2), LINESTRING (5 7, 7 7), LINESTRING (10 7, 12 7), LINESTRING (5.5 7.5, 6.5 7.5), POLYGON ((10 7, 10 0, 0 0, 0 10, 10 10, 10 7), (5 6, 7 6, 7 7, 7 8, 5 8, 5 7, 5 6)))")
@fact LibGEOS.geomToWKT(geom2_) --> LibGEOS.geomToWKT(geom3_)
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)
LibGEOS.destroyGeom(geom3_)

# GEOSWithinTest
geom1_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
geom2_ = LibGEOS.geomFromWKT("POLYGON EMPTY")
@fact LibGEOS.within(geom1_, geom2_) --> false
@fact LibGEOS.within(geom2_, geom1_) --> false
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("POLYGON((1 1,1 5,5 5,5 1,1 1))")
geom2_ = LibGEOS.geomFromWKT("POINT(2 2)")
@fact LibGEOS.within(geom1_, geom2_) --> false
@fact LibGEOS.within(geom2_, geom1_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

geom1_ = LibGEOS.geomFromWKT("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
geom2_ = LibGEOS.geomFromWKT("POLYGON((1 1,1 2,2 2,2 1,1 1))")
@fact LibGEOS.within(geom1_, geom2_) --> false
@fact LibGEOS.within(geom2_, geom1_) --> true
LibGEOS.destroyGeom(geom1_)
LibGEOS.destroyGeom(geom2_)

# GEOSisClosedTest
geom_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 1 0, 1 1)")
@fact LibGEOS.isClosed(geom_) --> false
LibGEOS.destroyGeom(geom_)
geom_ = LibGEOS.geomFromWKT("LINESTRING(0 0, 0 1, 1 1, 0 0)")
@fact LibGEOS.isClosed(geom_) --> true
LibGEOS.destroyGeom(geom_)
