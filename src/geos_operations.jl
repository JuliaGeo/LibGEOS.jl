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

writegeom(obj::Geometry, wktwriter::WKTWriter, context::GEOSContext = _context) =
    _writegeom(obj.ptr, wktwriter, context)
writegeom(obj::Geometry, wkbwriter::WKBWriter, context::GEOSContext = _context) =
    _writegeom(obj.ptr, wkbwriter, context)
writegeom(obj::Geometry, context::GEOSContext = _context) = _writegeom(obj.ptr, context)

function geomFromGEOS(ptr::GEOSGeom)
    if geomTypeId(ptr) == GEOS_POINT
        return Point(ptr)
    elseif geomTypeId(ptr) == GEOS_LINESTRING
        return LineString(ptr)
    elseif geomTypeId(ptr) == GEOS_LINEARRING
        return LinearRing(ptr)
    elseif geomTypeId(ptr) == GEOS_POLYGON
        return Polygon(ptr)
    elseif geomTypeId(ptr) == GEOS_MULTIPOINT
        return MultiPoint(ptr)
    elseif geomTypeId(ptr) == GEOS_MULTILINESTRING
        return MultiLineString(ptr)
    elseif geomTypeId(ptr) == GEOS_MULTIPOLYGON
        return MultiPolygon(ptr)
    else
        @assert geomTypeId(ptr) == GEOS_GEOMETRYCOLLECTION
        return GeometryCollection(ptr)
    end
end

readgeom(wktstring::String, wktreader::WKTReader, context::GEOSContext = _context) =
    geomFromGEOS(_readgeom(wktstring, wktreader, context))
readgeom(wktstring::String, context::GEOSContext = _context) =
    readgeom(wktstring, WKTReader(context), context)

readgeom(wkbbuffer::Vector{Cuchar}, wkbreader::WKBReader, context::GEOSContext = _context) =
    geomFromGEOS(_readgeom(wkbbuffer, wkbreader, context))
readgeom(wkbbuffer::Vector{Cuchar}, context::GEOSContext = _context) =
    readgeom(wkbbuffer, WKBReader(context), context)

# -----
# Linear referencing functions -- there are more, but these are probably sufficient for most purposes
# -----
project(line::LineString, point::Point) = project(line.ptr, point.ptr)
projectNormalized(line::LineString, point::Point) = projectNormalized(line.ptr, point.ptr)
interpolate(line::LineString, dist::Real) = Point(interpolate(line.ptr, dist))
interpolateNormalized(line::LineString, dist::Real) =
    Point(interpolateNormalized(line.ptr, dist))

# # -----
# # Topology operations
# # -----

buffer(obj::Geometry, dist::Real, quadsegs::Integer = 8) =
    geomFromGEOS(buffer(obj.ptr, dist, quadsegs))
bufferWithStyle(
    obj::Geometry,
    dist::Real;
    quadsegs::Integer = 8,
    endCapStyle::GEOSBufCapStyles = GEOSBUF_CAP_ROUND,
    joinStyle::GEOSBufJoinStyles = GEOSBUF_JOIN_ROUND,
    mitreLimit::Real = 5.0,
) = geomFromGEOS(
    bufferWithStyle(obj.ptr, dist, quadsegs, endCapStyle, joinStyle, mitreLimit),
)
envelope(obj::Geometry) = geomFromGEOS(envelope(obj.ptr))
minimumRotatedRectangle(obj::Geometry) = geomFromGEOS(minimumRotatedRectangle(obj.ptr))
convexhull(obj::Geometry) = geomFromGEOS(convexhull(obj.ptr))
boundary(obj::Geometry) = geomFromGEOS(boundary(obj.ptr))
unaryUnion(obj::Geometry) = geomFromGEOS(unaryUnion(obj.ptr))
pointOnSurface(obj::Geometry) = Point(pointOnSurface(obj.ptr))
centroid(obj::Geometry) = Point(centroid(obj.ptr))
node(obj::Geometry) = geomFromGEOS(node(obj.ptr))

intersection(obj1::Geometry, obj2::Geometry) =
    geomFromGEOS(intersection(obj1.ptr, obj2.ptr))
difference(obj1::Geometry, obj2::Geometry) = geomFromGEOS(difference(obj1.ptr, obj2.ptr))
symmetricDifference(obj1::Geometry, obj2::Geometry) =
    geomFromGEOS(symmetricDifference(obj1.ptr, obj2.ptr))
union(obj1::Geometry, obj2::Geometry) = geomFromGEOS(union(obj1.ptr, obj2.ptr))

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

simplify(obj::Geometry, tol::Real) = geomFromGEOS(simplify(obj.ptr, tol))
topologyPreserveSimplify(obj::Geometry, tol::Real) =
    geomFromGEOS(topologyPreserveSimplify(obj.ptr, tol))
uniquePoints(obj::Geometry) = MultiPoint(uniquePoints(obj.ptr))
delaunayTriangulationEdges(obj::Geometry, tol::Real = 0.0) =
    MultiLineString(delaunayTriangulation(obj.ptr, tol, true))
delaunayTriangulation(obj::Geometry, tol::Real = 0.0) =
    GeometryCollection(delaunayTriangulation(obj.ptr, tol, false))
constrainedDelaunayTriangulation(obj::Geometry) =
    GeometryCollection(constrainedDelaunayTriangulation(obj.ptr))


sharedPaths(obj1::LineString, obj2::LineString) =
    GeometryCollection(sharedPaths(obj1.ptr, obj2.ptr))

# # Snap first geometry on to second with given tolerance
snap(obj1::Geometry, obj2::Geometry, tol::Real) =
    geomFromGEOS(snap(obj1.ptr, obj2.ptr, tol))

# -----
# Binary predicates
# -----

disjoint(obj1::Geometry, obj2::Geometry) = disjoint(obj1.ptr, obj2.ptr)
touches(obj1::Geometry, obj2::Geometry) = touches(obj1.ptr, obj2.ptr)
intersects(obj1::Geometry, obj2::Geometry) = intersects(obj1.ptr, obj2.ptr)
crosses(obj1::Geometry, obj2::Geometry) = crosses(obj1.ptr, obj2.ptr)
within(obj1::Geometry, obj2::Geometry) = within(obj1.ptr, obj2.ptr)
Base.contains(obj1::Geometry, obj2::Geometry) = Base.contains(obj1.ptr, obj2.ptr)
overlaps(obj1::Geometry, obj2::Geometry) = overlaps(obj1.ptr, obj2.ptr)
equals(obj1::Geometry, obj2::Geometry) = equals(obj1.ptr, obj2.ptr)
equalsexact(obj1::Geometry, obj2::Geometry, tol::Real) =
    equalsexact(obj1.ptr, obj2.ptr, tol)
covers(obj1::Geometry, obj2::Geometry) = covers(obj1.ptr, obj2.ptr)
coveredby(obj1::Geometry, obj2::Geometry) = coveredby(obj1.ptr, obj2.ptr)


# # -----
# # Prepared Geometry Binary predicates
# # -----

prepareGeom(obj::Geometry, context::GEOSContext = _context) =
    PreparedGeometry(prepareGeom(obj.ptr, context), obj)
Base.contains(obj1::PreparedGeometry, obj2::Geometry) = prepcontains(obj1.ptr, obj2.ptr)
containsproperly(obj1::PreparedGeometry, obj2::Geometry) =
    prepcontainsproperly(obj1.ptr, obj2.ptr)
coveredby(obj1::PreparedGeometry, obj2::Geometry) = prepcoveredby(obj1.ptr, obj2.ptr)
covers(obj1::PreparedGeometry, obj2::Geometry) = prepcovers(obj1.ptr, obj2.ptr)
crosses(obj1::PreparedGeometry, obj2::Geometry) = prepcrosses(obj1.ptr, obj2.ptr)
disjoint(obj1::PreparedGeometry, obj2::Geometry) = prepdisjoint(obj1.ptr, obj2.ptr)
intersects(obj1::PreparedGeometry, obj2::Geometry) = prepintersects(obj1.ptr, obj2.ptr)
overlaps(obj1::PreparedGeometry, obj2::Geometry) = prepoverlaps(obj1.ptr, obj2.ptr)
touches(obj1::PreparedGeometry, obj2::Geometry) = preptouches(obj1.ptr, obj2.ptr)
within(obj1::PreparedGeometry, obj2::Geometry) = prepwithin(obj1.ptr, obj2.ptr)

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
isEmpty(obj::Geometry) = isEmpty(obj.ptr)
isSimple(obj::Geometry) = isSimple(obj.ptr)
isRing(obj::Geometry) = isRing(obj.ptr)
isValid(obj::Geometry) = isValid(obj.ptr)
hasZ(obj::Geometry) = hasZ(obj.ptr)

isClosed(obj::LineString) = isClosed(obj.ptr) # Call only on LINESTRING

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
numGeometries(obj::Geometry, context::GEOSContext = _context) =
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
getGeometry(obj::Geometry, n::Integer, context::GEOSContext = _context) =
    geomFromGEOS(getGeometry(obj.ptr, n, context))
getGeometries(obj::Geometry, context::GEOSContext = _context) =
    geomFromGEOS.(getGeometries(obj.ptr, context))

# Converts Geometry to normal form (or canonical form).
normalize!(obj::Geometry) = normalize!(obj.ptr)

interiorRings(obj::Polygon) = map(LinearRing, interiorRings(obj.ptr))
exteriorRing(obj::Polygon) = LinearRing(exteriorRing(obj.ptr))

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

numPoints(obj::LineString) = numPoints(obj.ptr) # Call only on LINESTRING
startPoint(obj::LineString) = Point(startPoint(obj.ptr)) # Call only on LINESTRING
endPoint(obj::LineString) = Point(endPoint(obj.ptr)) # Call only on LINESTRING

# # -----
# # Misc functions
# # -----

area(obj::Geometry) = geomArea(obj.ptr)
geomLength(obj::Geometry) = geomLength(obj.ptr)

distance(obj1::Geometry, obj2::Geometry) = geomDistance(obj1.ptr, obj2.ptr)
hausdorffdistance(obj1::Geometry, obj2::Geometry) = hausdorffdistance(obj1.ptr, obj2.ptr)
hausdorffdistance(obj1::Geometry, obj2::Geometry, densify::Real) =
    hausdorffdistance(obj1.ptr, obj2.ptr, densify)

# Returns the closest points of the two geometries.
# The first point comes from g1 geometry and the second point comes from g2.
function nearestPoints(obj1::Geometry, obj2::Geometry)
    points = nearestPoints(obj1.ptr, obj2.ptr)
    if points == C_NULL
        return Point[]
    else
        return Point[Point(getCoordinates(points, 1)), Point(getCoordinates(points, 2))]
    end
end

# # -----
# # Precision functions
# # -----

getPrecision(obj::Geometry, context::GEOSContext = _context) =
    getPrecision(obj.ptr, context)
setPrecision(
    obj::Geometry,
    grid::Real;
    flags = GEOS_PREC_VALID_OUTPUT,
    context::GEOSContext = _context,
) = setPrecision(obj.ptr, grid::Real, flags, context)

# ----
#  Geometry information functions
# ----

getXMin(obj::Geometry, context::GEOSContext = _context) = getXMin(obj.ptr, context)
getYMin(obj::Geometry, context::GEOSContext = _context) = getYMin(obj.ptr, context)
getXMax(obj::Geometry, context::GEOSContext = _context) = getXMax(obj.ptr, context)
getYMax(obj::Geometry, context::GEOSContext = _context) = getYMax(obj.ptr, context)

# TODO 02/2022: wait for libgeos release beyond 3.10.2 which will in include GEOSGeom_getExtent_r
