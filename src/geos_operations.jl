const GEOMTYPE = Dict{GEOSGeomTypes,Symbol}(
    GEOS_POINT => :Point,
    GEOS_LINESTRING => :LineString,
    GEOS_LINEARRING => :LinearRing,
    GEOS_POLYGON => :Polygon,
    GEOS_MULTIPOINT => :MultiPoint,
    GEOS_MULTILINESTRING => :MultiLineString,
    GEOS_MULTIPOLYGON => :MultiPolygon,
    GEOS_GEOMETRYCOLLECTION => :GeometryCollection,
)

writegeom(obj::Geometry, wktwriter::WKTWriter, context::GEOSContext = get_global_context()) =
    _writegeom(obj.ptr, wktwriter, context)
writegeom(obj::Geometry, wkbwriter::WKBWriter, context::GEOSContext = get_global_context()) =
    _writegeom(obj.ptr, wkbwriter, context)
writegeom(obj::Geometry, context::GEOSContext = get_global_context()) = 
    _writegeom(obj.ptr, context)

function geomFromGEOS(ptr::GEOSGeom, context::GEOSContext = get_global_context())
    id = geomTypeId(ptr, context)
    if id == GEOS_POINT
        return Point(ptr, context)
    elseif id == GEOS_LINESTRING
        return LineString(ptr, context)
    elseif id == GEOS_LINEARRING
        return LinearRing(ptr, context)
    elseif id == GEOS_POLYGON
        return Polygon(ptr, context)
    elseif id == GEOS_MULTIPOINT
        return MultiPoint(ptr, context)
    elseif id == GEOS_MULTILINESTRING
        return MultiLineString(ptr, context)
    elseif id == GEOS_MULTIPOLYGON
        return MultiPolygon(ptr, context)
    else
        @assert id == GEOS_GEOMETRYCOLLECTION
        return GeometryCollection(ptr, context)
    end
end

readgeom(wktstring::String, wktreader::WKTReader, context::GEOSContext = get_global_context()) =
    geomFromGEOS(_readgeom(wktstring, wktreader, context), context)
readgeom(wktstring::String, context::GEOSContext = get_global_context()) =
    readgeom(wktstring, WKTReader(context), context)

readgeom(wkbbuffer::Vector{Cuchar}, wkbreader::WKBReader, context::GEOSContext = get_global_context()) =
    geomFromGEOS(_readgeom(wkbbuffer, wkbreader, context), context)
readgeom(wkbbuffer::Vector{Cuchar}, context::GEOSContext = get_global_context()) =
    readgeom(wkbbuffer, WKBReader(context), context)

# -----
# Linear referencing functions -- there are more, but these are probably sufficient for most purposes
# -----
project(line::LineString, point::Point, context::GEOSContext = get_global_context()) =
    project(line.ptr, point.ptr, context)
projectNormalized(line::LineString, point::Point, context::GEOSContext = get_global_context()) =
    projectNormalized(line.ptr, point.ptr, context)
interpolate(line::LineString, dist::Real, context::GEOSContext = get_global_context()) =
    Point(interpolate(line.ptr, dist, context), context)
interpolateNormalized(line::LineString, dist::Real, context::GEOSContext = get_global_context()) =
    Point(interpolateNormalized(line.ptr, dist, context), context)

# # -----
# # Topology operations
# # -----

buffer(obj::Geometry, dist::Real, quadsegs::Integer = 8, context::GEOSContext = get_global_context()) =
    geomFromGEOS(buffer(obj.ptr, dist, quadsegs, context), context)
bufferWithStyle(
    obj::Geometry,
    dist::Real;
    quadsegs::Integer = 8,
    endCapStyle::GEOSBufCapStyles = GEOSBUF_CAP_ROUND,
    joinStyle::GEOSBufJoinStyles = GEOSBUF_JOIN_ROUND,
    mitreLimit::Real = 5.0,
    context::GEOSContext = get_global_context(),) =
    geomFromGEOS(bufferWithStyle(obj.ptr, dist, quadsegs, endCapStyle, joinStyle, mitreLimit, context), context)

envelope(obj::Geometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(envelope(obj.ptr, context), context)
envelope(obj::PreparedGeometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(envelope(obj.ownedby.ptr, context), context)
minimumRotatedRectangle(obj::Geometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(minimumRotatedRectangle(obj.ptr, context), context)
convexhull(obj::Geometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(convexhull(obj.ptr, context), context)
boundary(obj::Geometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(boundary(obj.ptr, context), context)
unaryUnion(obj::Geometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(unaryUnion(obj.ptr, context), context)
pointOnSurface(obj::Geometry, context::GEOSContext = get_global_context()) =
    Point(pointOnSurface(obj.ptr, context), context)
centroid(obj::Geometry, context::GEOSContext = get_global_context()) =
    Point(centroid(obj.ptr, context), context)
node(obj::Geometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(node(obj.ptr, context), context)

intersection(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(intersection(obj1.ptr, obj2.ptr, context), context)
difference(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(difference(obj1.ptr, obj2.ptr, context), context)
symmetricDifference(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(symmetricDifference(obj1.ptr, obj2.ptr, context), context)
union(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    geomFromGEOS(union(obj1.ptr, obj2.ptr, context), context)

# # all arguments remain ownership of the caller (both Geometries and pointers)
# function polygonize(geoms::Vector{GEOSGeom})
#     result = GEOSPolygonize(pointer(geoms), length(geoms))
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSPolygonize")
#     end
#     result
# end
# # GEOSPolygonizer_getCutEdges
# # GEOSPolygonize_full

# function lineMerge(ptr::GEOSGeom)
#     result = GEOSLineMerge(ptr)
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSLineMerge")
#     end
#     result
# end

simplify(obj::Geometry, tol::Real, context::GEOSContext = get_global_context()) =
    geomFromGEOS(simplify(obj.ptr, tol, context), context)
topologyPreserveSimplify(obj::Geometry, tol::Real, context::GEOSContext = get_global_context()) =
    geomFromGEOS(topologyPreserveSimplify(obj.ptr, tol, context), context)
uniquePoints(obj::Geometry, context::GEOSContext = get_global_context()) =
    MultiPoint(uniquePoints(obj.ptr, context), context)
delaunayTriangulationEdges(obj::Geometry, tol::Real = 0.0, context::GEOSContext = get_global_context()) =
    MultiLineString(delaunayTriangulation(obj.ptr, tol, true, context), context)
delaunayTriangulation(obj::Geometry, tol::Real = 0.0, context::GEOSContext = get_global_context()) =
    GeometryCollection(delaunayTriangulation(obj.ptr, tol, false, context), context)
constrainedDelaunayTriangulation(obj::Geometry, context::GEOSContext = get_global_context()) =
    GeometryCollection(constrainedDelaunayTriangulation(obj.ptr, context), context)


sharedPaths(obj1::LineString, obj2::LineString, context::GEOSContext = get_global_context()) =
    GeometryCollection(sharedPaths(obj1.ptr, obj2.ptr, context), context)

# # Snap first geometry on to second with given tolerance
snap(obj1::Geometry, obj2::Geometry, tol::Real, context::GEOSContext = get_global_context()) =
    geomFromGEOS(snap(obj1.ptr, obj2.ptr, tol, context), context)

# -----
# Binary predicates
# -----

disjoint(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    disjoint(obj1.ptr, obj2.ptr, context)
touches(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    touches(obj1.ptr, obj2.ptr, context)
intersects(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    intersects(obj1.ptr, obj2.ptr, context)
crosses(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    crosses(obj1.ptr, obj2.ptr, context)
within(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    within(obj1.ptr, obj2.ptr, context)
Base.contains(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    Base.contains(obj1.ptr, obj2.ptr, context)
overlaps(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    overlaps(obj1.ptr, obj2.ptr, context)
equals(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    equals(obj1.ptr, obj2.ptr, context)
equalsexact(obj1::Geometry, obj2::Geometry, tol::Real, context::GEOSContext = get_global_context()) =
    equalsexact(obj1.ptr, obj2.ptr, tol, context)
covers(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    covers(obj1.ptr, obj2.ptr, context)
coveredby(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    coveredby(obj1.ptr, obj2.ptr, context)


# # -----
# # Prepared Geometry Binary predicates
# # -----

prepareGeom(obj::Geometry, context::GEOSContext = get_global_context()) =
    PreparedGeometry(prepareGeom(obj.ptr, context), obj)
Base.contains(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    prepcontains(obj1.ptr, obj2.ptr, context)
containsproperly(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    prepcontainsproperly(obj1.ptr, obj2.ptr, context)
coveredby(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    prepcoveredby(obj1.ptr, obj2.ptr, context)
covers(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_global_context())= 
    prepcovers(obj1.ptr, obj2.ptr, context)
crosses(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    prepcrosses(obj1.ptr, obj2.ptr, context)
disjoint(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    prepdisjoint(obj1.ptr, obj2.ptr, context)
intersects(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    prepintersects(obj1.ptr, obj2.ptr, context)
overlaps(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    prepoverlaps(obj1.ptr, obj2.ptr, context)
touches(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    preptouches(obj1.ptr, obj2.ptr, context)
within(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    prepwithin(obj1.ptr, obj2.ptr, context)

# # -----
# # STRtree functions
# # -----
# # GEOSSTRtree_create
# # GEOSSTRtree_insert
# # GEOSSTRtree_query
# # GEOSSTRtree_iterate
# # GEOSSTRtree_remove
# # GEOSSTRtree_destroy

# # -----
# # Unary predicate - return 2 on exception, 1 on true, 0 on false
# # -----
isEmpty(obj::Geometry, context::GEOSContext = get_global_context()) =
    isEmpty(obj.ptr, context)
isEmpty(obj::PreparedGeometry, context::GEOSContext = get_global_context()) =
    isEmpty(obj.ownedby.ptr, context)
isSimple(obj::Geometry, context::GEOSContext = get_global_context()) =
    isSimple(obj.ptr, context)
isRing(obj::Geometry, context::GEOSContext = get_global_context()) =
    isRing(obj.ptr, context)
isValid(obj::Geometry, context::GEOSContext = get_global_context()) =
    isValid(obj.ptr, context)
hasZ(obj::Geometry, context::GEOSContext = get_global_context()) =
    hasZ(obj.ptr, context)

isClosed(obj::LineString, context::GEOSContext = get_global_context()) =
    isClosed(obj.ptr, context) # Call only on LINESTRING

# # -----
# # Dimensionally Extended 9 Intersection Model related
# # -----

# # GEOSRelatePattern (return 2 on exception, 1 on true, 0 on false)
# # GEOSRelate (return NULL on exception, a string to GEOSFree otherwise)
# # GEOSRelatePatternMatch (return 2 on exception, 1 on true, 0 on false)
# # GEOSRelateBoundaryNodeRule (return NULL on exception, a string to GEOSFree otherwise)

# # -----
# # Validity checking -- return 2 on exception, 1 on true, 0 on false
# # -----

# # /* These are for use with GEOSisValidDetail (flags param) */
# # enum GEOSValidFlags {
# #     GEOSVALID_ALLOW_SELFTOUCHING_RING_FORMING_HOLE=1
# # };

# # * return NULL on exception, a string to GEOSFree otherwise
# # GEOSisValidReason

# # * Caller has the responsibility to destroy 'reason' (GEOSFree)
# # * and 'location' (GEOSGeom_destroy) params
# # * return 2 on exception, 1 when valid, 0 when invalid
# # GEOSisValidDetail

# # -----
# # Geometry info
# # -----

# Gets the number of sub-geometries
numGeometries(obj::Geometry, context::GEOSContext = get_global_context()) =
    numGeometries(obj.ptr, context)

# # Call only on GEOMETRYCOLLECTION or MULTI*
# # (Return a pointer to the internal Geometry. Return NULL on exception.)
# # Returned object is a pointer to internal storage:
# # it must NOT be destroyed directly.
# # Up to GEOS 3.2.0 the input geometry must be a Collection, in
# # later version it doesn't matter (i.e. getGeometryN(0) for a single will return the input).
# function getGeometry(ptr::GEOSGeom, n::Integer)
#     result = GEOSGetGeometryN(ptr, Int32(n-1))
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSGetGeometryN")
#     end
#     result
# end
# getGeometries(ptr::GEOSGeom) = GEOSGeom[getGeometry(ptr, i) for i=1:numGeometries(ptr)]
# Gets sub-geomtry at index n or a vector of all sub-geometries
getGeometry(obj::Geometry, n::Integer, context::GEOSContext = get_global_context()) =
    geomFromGEOS(getGeometry(obj.ptr, n, context), context)
getGeometries(obj::Geometry, context::GEOSContext = get_global_context()) =
    [geomFromGEOS(gptr, context) for gptr in getGeometries(obj.ptr, context)]

# Converts Geometry to normal form (or canonical form).
normalize!(obj::Geometry, context::GEOSContext = get_global_context()) =
    normalize!(obj.ptr, context)

# LinearRings in Polygons
numInteriorRings(obj::Polygon, context::GEOSContext = get_global_context()) =
    numInteriorRings(obj.ptr, context)
interiorRing(obj::Polygon, n::Integer, context::GEOSContext = get_global_context()) =
    LinearRing(interiorRing(obj.ptr, n, context), context)
interiorRings(obj::Polygon, context::GEOSContext = get_global_context()) =
    map(LinearRing, interiorRings(obj.ptr, context))
exteriorRing(obj::Polygon, context::GEOSContext = get_global_context()) =
    LinearRing(exteriorRing(obj.ptr, context), context)

# # Geometry must be a LineString, LinearRing or Point (Return NULL on exception)
# function getCoordSeq(ptr::GEOSGeom)
#     result = GEOSGeom_getCoordSeq(ptr)
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSGeom_getCoordSeq")
#     end
#     result
# end
# # getGeomCoordinates(ptr::GEOSGeom) = getCoordinates(getCoordSeq(ptr))

# # Return 0 on exception (or empty geometry)
# getGeomDimensions(ptr::GEOSGeom) = GEOSGeom_getDimensions(ptr)

# # Return 2 or 3.
# getCoordinateDimension(ptr::GEOSGeom) = int(GEOSGeom_getCoordinateDimension(ptr))

# # Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
# function getPoint(ptr::GEOSGeom, n::Integer)
#     result = GEOSGeomGetPointN(ptr, Int32(n-1))
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSGeomGetPointN")
#     end
#     result
# end

numPoints(obj::LineString, context::GEOSContext = get_global_context()) =
    numPoints(obj.ptr, context) # Call only on LINESTRING
startPoint(obj::LineString, context::GEOSContext = get_global_context()) =
    Point(startPoint(obj.ptr, context), context) # Call only on LINESTRING
endPoint(obj::LineString, context::GEOSContext = get_global_context()) =
    Point(endPoint(obj.ptr, context), context) # Call only on LINESTRING

# # -----
# # Misc functions
# # -----

area(obj::Geometry, context::GEOSContext = get_global_context()) =
    geomArea(obj.ptr, context)
geomLength(obj::Geometry, context::GEOSContext = get_global_context()) =
    geomLength(obj.ptr, context)

distance(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) =
    geomDistance(obj1.ptr, obj2.ptr, context)
hausdorffdistance(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context()) = 
    hausdorffdistance(obj1.ptr, obj2.ptr, context)

hausdorffdistance(obj1::Geometry, obj2::Geometry, densify::Real,context::GEOSContext = get_global_context()) =
    hausdorffdistance(obj1.ptr, obj2.ptr, densify, context)

# Returns the closest points of the two geometries.
# The first point comes from g1 geometry and the second point comes from g2.
function nearestPoints(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_global_context())
    points = nearestPoints(obj1.ptr, obj2.ptr, context)
    if points == C_NULL
        return Point[]
    else
        return Point[Point(getCoordinates(points, 1, context), context), 
                     Point(getCoordinates(points, 2, context), context)]
    end
end

# # -----
# # Precision functions
# # -----

getPrecision(obj::Geometry, context::GEOSContext = get_global_context()) =
    getPrecision(obj.ptr, context)
setPrecision(
    obj::Geometry,
    grid::Real;
    flags = GEOS_PREC_VALID_OUTPUT,
    context::GEOSContext = get_global_context(),) =
    setPrecision(obj.ptr, grid::Real, flags, context)

# ----
#  Geometry information functions
# ----

getXMin(obj::Geometry, context::GEOSContext = get_global_context()) = getXMin(obj.ptr, context)
getYMin(obj::Geometry, context::GEOSContext = get_global_context()) = getYMin(obj.ptr, context)
getXMax(obj::Geometry, context::GEOSContext = get_global_context()) = getXMax(obj.ptr, context)
getYMax(obj::Geometry, context::GEOSContext = get_global_context()) = getYMax(obj.ptr, context)

# TODO 02/2022: wait for libgeos release beyond 3.10.2 which will in include GEOSGeom_getExtent_r
