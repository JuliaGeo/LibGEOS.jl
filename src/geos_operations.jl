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

function geomFromGEOS(ptr::Union{Geometry, Ptr{Cvoid}}, context::GEOSContext = get_global_context())
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

# # -----
# # Topology operations
# # -----

intersection(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    geomFromGEOS(intersection(obj1, obj2, context), context)
difference(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    geomFromGEOS(difference(obj1, obj2, context), context)
symmetricDifference(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    geomFromGEOS(symmetricDifference(obj1, obj2, context), context)
union(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    geomFromGEOS(union(obj1, obj2, context), context)

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

simplify(obj::Geometry, tol::Real, context::GEOSContext = get_context(obj)) =
    geomFromGEOS(simplify(obj, tol, context), context)
topologyPreserveSimplify(obj::Geometry, tol::Real, context::GEOSContext = get_context(obj)) =
    geomFromGEOS(topologyPreserveSimplify(obj, tol, context), context)
uniquePoints(obj::Geometry, context::GEOSContext = get_context(obj)) =
    MultiPoint(uniquePoints(obj, context), context)
delaunayTriangulationEdges(obj::Geometry, tol::Real = 0.0, context::GEOSContext = get_context(obj)) =
    MultiLineString(delaunayTriangulation(obj, tol, true, context), context)
delaunayTriangulation(obj::Geometry, tol::Real = 0.0, context::GEOSContext = get_context(obj)) =
    GeometryCollection(delaunayTriangulation(obj, tol, false, context), context)
constrainedDelaunayTriangulation(obj::Geometry, context::GEOSContext = get_context(obj)) =
    GeometryCollection(constrainedDelaunayTriangulation(obj, context), context)


sharedPaths(obj1::LineString, obj2::LineString, context::GEOSContext = get_context(obj1,obj2)) =
    GeometryCollection(sharedPaths(obj1, obj2, context), context)

# # Snap first geometry on to second with given tolerance
snap(obj1::Geometry, obj2::Geometry, tol::Real, context::GEOSContext = get_context(obj1,obj2)) =
    geomFromGEOS(snap(obj1, obj2, tol, context), context)

# -----
# Binary predicates
# -----

disjoint(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    disjoint(obj1, obj2, context)
touches(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    touches(obj1, obj2, context)
intersects(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    intersects(obj1, obj2, context)
crosses(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    crosses(obj1, obj2, context)
within(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    within(obj1, obj2, context)
Base.contains(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    Base.contains(obj1, obj2, context)
overlaps(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    overlaps(obj1, obj2, context)
equalsexact(obj1::Geometry, obj2::Geometry, tol::Real, context::GEOSContext = get_context(obj1,obj2)) =
    equalsexact(obj1, obj2, tol, context)
covers(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    covers(obj1, obj2, context)
coveredby(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    coveredby(obj1, obj2, context)

function equals(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1))
    # We don't check context here, as it is probably safe to compare objects from
    # different contexts
    equals(obj1, obj2, context)
end


# # -----
# # Prepared Geometry Binary predicates
# # -----

prepareGeom(obj::Geometry, context::GEOSContext = get_context(obj)) =
    PreparedGeometry(prepareGeom(obj, context), obj)
Base.contains(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    prepcontains(obj1, obj2, context)
containsproperly(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    prepcontainsproperly(obj1, obj2, context)
coveredby(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    prepcoveredby(obj1, obj2, context)
covers(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2))=
    prepcovers(obj1, obj2, context)
crosses(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    prepcrosses(obj1, obj2, context)
disjoint(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    prepdisjoint(obj1, obj2, context)
intersects(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    prepintersects(obj1, obj2, context)
overlaps(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    prepoverlaps(obj1, obj2, context)
touches(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    preptouches(obj1, obj2, context)
within(obj1::PreparedGeometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    prepwithin(obj1, obj2, context)

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
isEmpty(obj::Geometry, context::GEOSContext = get_context(obj)) =
    isEmpty(obj, context)
isEmpty(obj::PreparedGeometry, context::GEOSContext = get_context(obj)) =
    isEmpty(obj.ownedby, context)
isSimple(obj::Geometry, context::GEOSContext = get_context(obj)) =
    isSimple(obj, context)
isRing(obj::Geometry, context::GEOSContext = get_context(obj)) =
    isRing(obj, context)
isValid(obj::Geometry, context::GEOSContext = get_context(obj)) =
    isValid(obj, context)
hasZ(obj::Geometry, context::GEOSContext = get_context(obj)) =
    hasZ(obj, context)

isClosed(obj::LineString, context::GEOSContext = get_context(obj)) =
    isClosed(obj, context) # Call only on LINESTRING

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
numGeometries(obj::Geometry, context::GEOSContext = get_context(obj)) =
    numGeometries(obj, context)

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
getGeometry(obj::Geometry, n::Integer, context::GEOSContext = get_context(obj)) =
    geomFromGEOS(getGeometry(obj, n, context), context)
getGeometries(obj::Geometry, context::GEOSContext = get_context(obj)) =
    [geomFromGEOS(gptr, context) for gptr in getGeometries(obj, context)]

# Converts Geometry to normal form (or canonical form).
normalize!(obj::Geometry, context::GEOSContext = get_context(obj)) =
    normalize!(obj, context)

# LinearRings in Polygons
numInteriorRings(obj::Polygon, context::GEOSContext = get_context(obj)) =
    numInteriorRings(obj, context)
interiorRing(obj::Polygon, n::Integer, context::GEOSContext = get_context(obj)) =
    LinearRing(interiorRing(obj, n, context), context)
interiorRings(obj::Polygon, context::GEOSContext = get_context(obj)) =
    map(LinearRing, interiorRings(obj, context))
exteriorRing(obj::Polygon, context::GEOSContext = get_context(obj)) =
    LinearRing(exteriorRing(obj, context), context)

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

numPoints(obj::LineString, context::GEOSContext = get_context(obj)) =
    numPoints(obj, context) # Call only on LINESTRING
startPoint(obj::LineString, context::GEOSContext = get_context(obj)) =
    Point(startPoint(obj, context), context) # Call only on LINESTRING
endPoint(obj::LineString, context::GEOSContext = get_context(obj)) =
    Point(endPoint(obj, context), context) # Call only on LINESTRING

# # -----
# # Misc functions
# # -----

area(obj::Geometry, context::GEOSContext = get_context(obj)) =
    geomArea(obj, context)
geomLength(obj::Geometry, context::GEOSContext = get_context(obj)) =
    geomLength(obj, context)

distance(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    geomDistance(obj1, obj2, context)
hausdorffdistance(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2)) =
    hausdorffdistance(obj1, obj2, context)

hausdorffdistance(obj1::Geometry, obj2::Geometry, densify::Real,context::GEOSContext = get_context(obj1,obj2)) =
    hausdorffdistance(obj1, obj2, densify, context)

# Returns the closest points of the two geometries.
# The first point comes from g1 geometry and the second point comes from g2.
function nearestPoints(obj1::Geometry, obj2::Geometry, context::GEOSContext = get_context(obj1,obj2))
    points = nearestPoints(obj1, obj2, context)
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

getPrecision(obj::Geometry, context::GEOSContext = get_context(obj)) =
    getPrecision(obj, context)
setPrecision(
    obj::Geometry,
    grid::Real;
    flags = GEOS_PREC_VALID_OUTPUT,
    context::GEOSContext = get_context(obj),) =
    setPrecision(obj, grid::Real, flags, context)

# ----
#  Geometry information functions
# ----

getXMin(obj::Geometry, context::GEOSContext = get_context(obj)) = getXMin(obj, context)
getYMin(obj::Geometry, context::GEOSContext = get_context(obj)) = getYMin(obj, context)
getXMax(obj::Geometry, context::GEOSContext = get_context(obj)) = getXMax(obj, context)
getYMax(obj::Geometry, context::GEOSContext = get_context(obj)) = getYMax(obj, context)

# TODO 02/2022: wait for libgeos release beyond 3.10.2 which will in include GEOSGeom_getExtent_r
