# GENERAL NOTES:
# - Remember to call initGEOS() before any use of this library's
#   functions, and call finishGEOS() when done.
# - Currently you have to explicitly GEOSGeom_destroy() all
#   GEOSGeom objects to avoid memory leaks, and to GEOSFree()
#   all returned char * (unless const).

# Supported geometry types
# This was renamed from GEOSGeomTypeId in GEOS 2.2.X, which might
# break compatibility, this issue is still under investigation.
GEOMTYPE = @compat Dict( GEOS_POINT => :Point,
                         GEOS_LINESTRING => :LineString,
                         GEOS_LINEARRING => :LinearRing,
                         GEOS_POLYGON => :Polygon,
                         GEOS_MULTIPOINT => :MultiPoint,
                         GEOS_MULTILINESTRING => :MultiLineString,
                         GEOS_MULTIPOLYGON => :MultiPolygon,
                         GEOS_GEOMETRYCOLLECTION => :GeometryCollection)

# -----
# Coordinate Sequence functions
# -----

# Create a Coordinate sequence with ``size'' coordinates of ``dims'' dimensions (Return NULL on exception)
createCoordSeq(size::Int, ndim::Int) = GEOSCoordSeq_create(uint32(size), uint32(ndim))

# Clone a Coordinate Sequence (Return NULL on exception)
clone(ptr::GEOSCoordSeq) = GEOSCoordSeq_clone(ptr)
destroy(ptr::GEOSCoordSeq) = GEOSCoordSeq_destroy(ptr)

# Set ordinate values in a Coordinate Sequence (Return 0 on exception)
setX!(ptr::GEOSCoordSeq, i::Int, value::Float64) = GEOSCoordSeq_setX(ptr, uint32(i-1), value)
setY!(ptr::GEOSCoordSeq, i::Int, value::Float64) = GEOSCoordSeq_setY(ptr, uint32(i-1), value)
setZ!(ptr::GEOSCoordSeq, i::Int, value::Float64) = GEOSCoordSeq_setZ(ptr, uint32(i-1), value)

# Get ordinate values from a Coordinate Sequence (Return 0 on exception)
getX!(ptr::GEOSCoordSeq, index::Int, coord::Vector{Float64}) = GEOSCoordSeq_getX(ptr, uint32(index-1), pointer(coord))
getY!(ptr::GEOSCoordSeq, index::Int, coord::Vector{Float64}) = GEOSCoordSeq_getY(ptr, uint32(index-1), pointer(coord)+sizeof(Float64))
getZ!(ptr::GEOSCoordSeq, index::Int, coord::Vector{Float64}) = GEOSCoordSeq_getZ(ptr, uint32(index-1), pointer(coord)+2*sizeof(Float64))

function getSize(ptr::GEOSCoordSeq)
    ncoords = Array(Uint32, 1)
    # Get size info from a Coordinate Sequence (Return 0 on exception)
    GEOSCoordSeq_getSize(ptr, pointer(ncoords))
    int(ncoords[1])
end

function getDimension(ptr::GEOSCoordSeq)
    ndim = Array(Uint32, 1)
    # Get dimensions info from a Coordinate Sequence (Return 0 on exception)
    GEOSCoordSeq_getDimensions(ptr, pointer(ndim))
    int(ndim[1])
end

# convenience functions
function setCoordSeq(ptr::GEOSCoordSeq, i::Int, coords::Vector{Float64})
    setX!(ptr, i, coords[1])
    setY!(ptr, i, coords[2])
    length(coords) >= 3 && setZ!(ptr, i, coords[3])
    ptr
end

function createCoordSeq(coords::Vector{Vector{Float64}})
    ncoords = length(coords)
    if ncoords > 0
        ndim = length(coords[1])
        coordinates = createCoordSeq(ncoords, ndim)
        for (i,coord) in enumerate(coords[:])
            setCoordSeq(coordinates, i, coord)
        end
        return coordinates
    else
        warn("No coordinates provided.")
        return createCoordSeq(0, 0)
    end
end

function getX(ptr::GEOSCoordSeq, i::Int)
    coord = Array(Float64, 1)
    getX!(ptr, i, coord)
    coord[1]
end

function getX(ptr::GEOSCoordSeq)
    ncoords = getSize(ptr)
    xcoords = Array(Float64, ncoords)
    for i=1:ncoords
        getX!(ptr, i, xcoords)
    end
    xcoords
end

function getY(ptr::GEOSCoordSeq, i::Int)
    coord = Array(Float64, 1)
    getY!(ptr, i, coord)
    coord[1]
end

function getY(ptr::GEOSCoordSeq)
    ncoords = getSize(ptr)
    ycoords = Array(Float64, ncoords)
    for i=1:ncoords
        getY!(ptr, i, ycoords)
    end
    ycoords
end

function getZ(ptr::GEOSCoordSeq, i::Int)
    coord = Array(Float64, 1)
    getZ!(ptr, i, coord)
    coord[1]
end

function getZ(ptr::GEOSCoordSeq)
    ncoords = getSize(ptr)
    zcoords = Array(Float64, ncoords)
    for i=1:ncoords
        getZ!(ptr, i, zcoords)
    end
    zcoords
end

function getCoordinates(ptr::GEOSCoordSeq, i::Int)
    ndim = getDimension(ptr)
    coord = Array(Float64, ndim)
    getX!(ptr, i, coord)
    getY!(ptr, i, coord)
    if ndim == 3
        getZ!(ptr, i, coord)
    end
    coord
end

function getCoordinates(ptr::GEOSCoordSeq)
    ndim = getDimension(ptr)
    ncoords = getSize(ptr)
    coordseq = Vector{Float64}[]
    sizehint(coordseq, ncoords)
    for i=1:ncoords
        push!(coordseq, getCoordinates(ptr, i))
    end
    coordseq
end

# -----
# Linear referencing functions -- there are more, but these are probably sufficient for most purposes
# -----
# (GEOSGeometry ownership is retained by caller)

# Return distance of point 'p' projected on 'g' from origin of 'g'. Geometry 'g' must be a lineal geometry
project(g::GEOSGeom, p::GEOSGeom) = GEOSProject(g, p)
# Return closest point to given distance within geometry (Geometry must be a LineString)
interpolate(ptr::GEOSGeom, d::Float64) = GEOSInterpolate(ptr, d)

projectNormalized(g::GEOSGeom, p::GEOSGeom) = GEOSProjectNormalized(g, p)
interpolateNormalized(ptr::GEOSGeom, d::Float64) = GEOSInterpolateNormalized(ptr, d)

# -----
# Buffer related functions
# -----
buffer(ptr::GEOSGeom, width::Float64, quadsegs::Int) = GEOSBuffer(ptr, width, int32(quadsegs))

# enum GEOSBufCapStyles
# enum GEOSBufJoinStyles

# GEOSBufferParams_create
# GEOSBufferParams_destroy
# GEOSBufferParams_setEndCapStyle
# GEOSBufferParams_setJoinStyle
# GEOSBufferParams_setMitreLimit
# GEOSBufferParams_setQuadrantSegments
# GEOSBufferParams_setSingleSided
# GEOSBufferWithParams
# GEOSBufferWithStyle
# GEOSOffsetCurve

# -----
# Geometry Constructors -- All functions return NULL on exception
# -----
# (GEOSCoordSequence* arguments will become ownership of the returned object.)

createPoint(ptr::GEOSCoordSeq) = GEOSGeom_createPoint(ptr)
createLinearRing(ptr::GEOSCoordSeq) = GEOSGeom_createLinearRing(ptr)
createLineString(ptr::GEOSCoordSeq) = GEOSGeom_createLineString(ptr)

# Second argument is an array of GEOSGeometry* objects.
# The caller remains owner of the array, but pointed-to
# objects become ownership of the returned GEOSGeometry.
createPolygon(shell::GEOSGeom, holes::Vector{GEOSGeom}) = GEOSGeom_createPolygon(shell, pointer(holes), uint32(length(holes)))
createCollection(geomtype::Int, geoms::Vector{GEOSGeom}) = GEOSGeom_createCollection(int32(geomtype), pointer(geoms), length(geoms))
createEmptyCollection(geomtype::Int) = GEOSGeom_createEmptyCollection(int32(geomtype))

# Memory management
clone(ptr::GEOSGeom) = GEOSGeom_clone(ptr)
destroy(ptr::GEOSGeom) = GEOSGeom_destroy(ptr)

# -----
# Topology operations - return NULL on exception.
# -----

envelope(ptr::GEOSGeom) = GEOSEnvelope(ptr)
intersection(ptr::GEOSGeom) = GEOSIntersection(ptr)
convexhull(ptr::GEOSGeom) = GEOSConvexHull(ptr)
difference(g1::GEOSGeom, g2::GEOSGeom) = GEOSDifference(g1, g2)
symmetricDifference(g1::GEOSGeom, g2::GEOSGeom) = GEOSSymDifference(g1, g2)
boundary(ptr::GEOSGeom) = GEOSBoundary(ptr)
union(g1::GEOSGeom, g2::GEOSGeom) = GEOSUnion(g1, g2)
unaryUnion(ptr::GEOSGeom) = GEOSUnaryUnion(ptr)
pointOnSurface(ptr::GEOSGeom) = GEOSPointOnSurface(ptr)
centroid(ptr::GEOSGeom) = GEOSGetCentroid(ptr)
node(ptr::GEOSGeom) = GEOSNode(ptr)

# all arguments remain ownership of the caller (both Geometries and pointers)
polygonize(geoms::Vector{GEOSGeom}) = GEOSPolygonize(pointer(geoms), length(geoms))
# GEOSPolygonizer_getCutEdges
# GEOSPolygonize_full

lineMerge(ptr::GEOSGeom) = GEOSLineMerge(ptr)
simplify(ptr::GEOSGeom, tol::Float64) = GEOSSimplify(ptr, tol)
topologyPreserveSimplify(ptr::GEOSGeom, tol::Float64) = GEOSTopologyPreserveSimplify(ptr, tol)

# Return all distinct vertices of input geometry as a MULTIPOINT.
# (Note that only 2 dimensions of the vertices are considered when testing for equality)
uniquePoints(ptr::GEOSGeom) = GEOSGeom_extractUniquePoints(ptr)

# Find paths shared between the two given lineal geometries.
# Returns a GEOMETRYCOLLECTION having two elements:
# - first element is a MULTILINESTRING containing shared paths
#    having the _same_ direction on both inputs
#  - second element is a MULTILINESTRING containing shared paths
#    having the _opposite_ direction on the two inputs
# (Returns NULL on exception)
sharedPaths(g1::GEOSGeom, g2::GEOSGeom) = GEOSSharedPaths(g1, g2)

# Snap first geometry on to second with given tolerance
# (Returns a newly allocated geometry, or NULL on exception)
snap(g1::GEOSGeom, g2::GEOSGeom, tol::Float64) = GEOSSnap(g1, g2, tol)

# Return a Delaunay triangulation of the vertex of the given geometry
#
# @param g the input geometry whose vertex will be used as "sites"
# @param tolerance optional snapping tolerance to use for improved robustness
# @param onlyEdges if non-zero will return a MULTILINESTRING, otherwise it will
#                  return a GEOMETRYCOLLECTION containing triangular POLYGONs.
#
# @return  a newly allocated geometry, or NULL on exception
delaunayTriangulation(ptr::GEOSGeom, tol::Float64, onlyEdges::Int) = GEOSDelaunayTriangulation(ptr, tol, int32(onlyEdges))

# -----
# Binary predicates - return 2 on exception, 1 on true, 0 on false
# -----
disjoint(g1::GEOSGeom, g2::GEOSGeom) = GEOSDisjoint(g1, g2)
touches(g1::GEOSGeom, g2::GEOSGeom) = GEOSTouches(g1, g2)
intersects(g1::GEOSGeom, g2::GEOSGeom) = GEOSIntersects(g1, g2)
crosses(g1::GEOSGeom, g2::GEOSGeom) = GEOSCrosses(g1, g2)
within(g1::GEOSGeom, g2::GEOSGeom) = GEOSWithin(g1, g2)
contains(g1::GEOSGeom, g2::GEOSGeom) = GEOSContains(g1, g2)
overlaps(g1::GEOSGeom, g2::GEOSGeom) = GEOSOverlaps(g1, g2)
equals(g1::GEOSGeom, g2::GEOSGeom) = GEOSEquals(g1, g2)
equalsexact(g1::GEOSGeom, g2::GEOSGeom, tol) = GEOSEqualsExact(g1, g2, tol)
covers(g1::GEOSGeom, g2::GEOSGeom) = GEOSCovers(g1, g2)
coveredby(g1::GEOSGeom, g2::GEOSGeom) = GEOSCoveredBy(g1, g2)

# -----
# Prepared Geometry Binary predicates - return 2 on exception, 1 on true, 0 on false
# -----

# GEOSGeometry ownership is retained by caller
prepare(ptr::GEOSGeom) = GEOSPrepare(ptr)
destroy(ptr::Ptr{GEOSPreparedGeometry}) = GEOSPreparedGeom_destroy(ptr)

contains(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom) = GEOSPreparedContains(g1, g2)
containsproperly(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom) = GEOSPreparedContainsProperly(g1, g2)
coveredby(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom) = GEOSPreparedCoveredBy(g1, g2)
covers(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom) = GEOSPreparedCovers(g1, g2)
crosses(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom) = GEOSPreparedCrosses(g1, g2)
disjoint(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom) = GEOSPreparedDisjoint(g1, g2)
intersects(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom) = GEOSPreparedIntersects(g1, g2)
overlaps(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom) = GEOSPreparedOverlaps(g1, g2)
touches(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom) = GEOSPreparedTouches(g1, g2)
within(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom) = GEOSPreparedWithin(g1, g2)

# -----
# STRtree functions
# -----
# GEOSSTRtree_create
# GEOSSTRtree_insert
# GEOSSTRtree_query
# GEOSSTRtree_iterate
# GEOSSTRtree_remove
# GEOSSTRtree_destroy

# -----
# Unary predicate - return 2 on exception, 1 on true, 0 on false
# -----
isEmpty(ptr::GEOSGeom) = bool(GEOSisEmpty(ptr))
isSimple(ptr::GEOSGeom) = bool(GEOSisSimple(ptr))
isRing(ptr::GEOSGeom) = bool(GEOSisRing(ptr))
hasZ(ptr::GEOSGeom) = bool(GEOSHasZ(ptr))

# Call only on LINESTRING (return 2 on exception, 1 on true, 0 on false)
isClosed(ptr::GEOSGeom) = bool(GEOSisClosed(ptr))

# -----
# Dimensionally Extended 9 Intersection Model related
# -----

# GEOSRelatePattern (return 2 on exception, 1 on true, 0 on false)
# GEOSRelate (return NULL on exception, a string to GEOSFree otherwise)
# GEOSRelatePatternMatch (return 2 on exception, 1 on true, 0 on false)
# GEOSRelateBoundaryNodeRule (return NULL on exception, a string to GEOSFree otherwise)

# -----
# Validity checking -- return 2 on exception, 1 on true, 0 on false
# -----

# /* These are for use with GEOSisValidDetail (flags param) */
# enum GEOSValidFlags {
#     GEOSVALID_ALLOW_SELFTOUCHING_RING_FORMING_HOLE=1
# };

isValid(ptr::GEOSGeom) = bool(GEOSisValid(ptr))

# * return NULL on exception, a string to GEOSFree otherwise
# GEOSisValidReason

# * Caller has the responsibility to destroy 'reason' (GEOSFree)
# * and 'location' (GEOSGeom_destroy) params
# * return 2 on exception, 1 when valid, 0 when invalid
# GEOSisValidDetail

# -----
# Geometry info
# -----

# Return NULL on exception, result must be freed by caller
geomType(ptr::GEOSGeom) = GEOSGeomType(ptr)
# Return -1 on exception
geomTypeId(ptr::GEOSGeom) = GEOSGeomTypeId(ptr)
# Return 0 on exception
getSRID(ptr::GEOSGeom) = GEOSGetSRID(ptr)
setSRID(ptr::GEOSGeom) = GEOSSetSRID(ptr)

# May be called on all geometries in GEOS 3.x, returns -1 on error and 1
# for non-multi geometries. Older GEOS versions only accept
# GeometryCollections or Multi* geometries here, and are likely to crash
# when fed simple geometries, so beware if you need compatibility with
# old GEOS versions.
numGeometries(ptr::GEOSGeom) = GEOSGetNumGeometries(ptr)

# Call only on GEOMETRYCOLLECTION or MULTI*
# (Return a pointer to the internal Geometry. Return NULL on exception.)
# Returned object is a pointer to internal storage:
# it must NOT be destroyed directly.
# Up to GEOS 3.2.0 the input geometry must be a Collection, in
# later version it doesn't matter (i.e. getGeometryN(0) for a single will return the input).
getGeometry(ptr::GEOSGeom, n::Int) = GEOSGetGeometryN(ptr, int32(n))

# Converts Geometry to normal form (or canonical form).
# Return -1 on exception, 0 otherwise.
normalize(ptr::GEOSGeom) = GEOSNormalize(ptr)
# Return -1 on exception
numInteriorRings(ptr::GEOSGeom) = GEOSGetNumInteriorRings(ptr)
# Call only on LINESTRING (returns -1 on exception)
numPoints(ptr::GEOSGeom) = GEOSGeomGetNumPoints(ptr)
# Return -1 on exception, Geometry must be a Point.
getX(ptr::GEOSGeom, x::Vector{Float64}) = GEOSGeomGetX(ptr, pointer(x))
getY(ptr::GEOSGeom, y::Vector{Float64}) = GEOSGeomGetX(ptr, pointer(y))

# Return NULL on exception, Geometry must be a Polygon.
# Returned object is a pointer to internal storage: it must NOT be destroyed directly.
interiorRing(ptr::GEOSGeom, n::Int) = GEOSGetInteriorRingN(ptr, int32(n))
# Return NULL on exception, Geometry must be a Polygon.
# Returned object is a pointer to internal storage: it must NOT be destroyed directly.
exteriorRing(ptr::GEOSGeom) = GEOSGetExteriorRing(ptr)
# Return -1 on exception
numCoordinates(ptr::GEOSGeom) = GEOSGetNumCoordinates(ptr)
# Geometry must be a LineString, LinearRing or Point (Return NULL on exception)
getCoordSeq(ptr::GEOSGeom) = GEOSGeom_getCoordSeq(ptr)
# Return 0 on exception (or empty geometry)
getDimensions(ptr::GEOSGeom) = GEOSGeom_getDimensions(ptr)
# Return 2 or 3.
getCoordinateDimension(ptr::GEOSGeom) = GEOSGeom_getCoordinateDimension(ptr)
# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
getPoint(ptr::GEOSGeom, n::Int) = GEOSGeomGetPointN(ptr, int32(n))
# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
startPoint(ptr::GEOSGeom) = GEOSGeomGetStartPoint(ptr)
# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
endPoint(ptr::GEOSGeom) = GEOSGeomGetEndPoint(ptr)

# -----
# Misc functions
# -----
function geomArea(ptr::GEOSGeom)
    result = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    GEOSArea(ptr, pointer(result))
    result[1]
end

function geomLength(ptr::GEOSGeom)
    result = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    GEOSLength(ptr, pointer(result))
    result[1]
end

function geomDistance(g1::GEOSGeom, g2::GEOSGeom)
    dist = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    GEOSDistance(g1, g2, pointer(dist))
    dist[1]
end

function hausdorffdistance(g1::GEOSGeom, g2::GEOSGeom)
    dist = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    GEOSHausdorffDistance(g1, g2, pointer(dist))
    dist[1]
end

function hausdorffdistance(g1::GEOSGeom, g2::GEOSGeom, densifyFrac::Float64)
    dist = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    GEOSHausdorffDistanceDensify(g1, g2, densifyFrac, pointer(dist))
    dist[1]
end

# Call only on LINESTRING
function getLength(ptr::GEOSGeom)
    len = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    result = GEOSGeomGetLength(ptr, pointer(result))
    len[1]
end

# Return 0 on exception, the closest points of the two geometries otherwise.
# The first point comes from g1 geometry and the second point comes from g2.
nearestPoints(g1::GEOSGeom, g2::GEOSGeom) = GEOSNearestPoints(g1, g2)

