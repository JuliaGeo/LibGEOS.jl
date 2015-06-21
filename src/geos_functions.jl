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


function geomFromWKT(geom::ASCIIString)
    result = GEOSGeomFromWKT(pointer(geom))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomFromWKT")
    end
    result
end
geomToWKT(geom::Ptr{GEOSGeometry}) = bytestring(GEOSGeomToWKT(geom))

# -----
# Coordinate Sequence functions
# -----

# Create a Coordinate sequence with ``size'' coordinates of ``dims'' dimensions (Return NULL on exception)
function createCoordSeq(size::Int, ndim::Int)
    @assert ndim >= 2
    result = GEOSCoordSeq_create(uint32(size), uint32(ndim))
    if result == C_NULL
        error("LibGEOS: Error in GEOSCoordSeq_create")
    end
    result
end

# Clone a Coordinate Sequence (Return NULL on exception)
function cloneCoordSeq(ptr::GEOSCoordSeq)
    result = GEOSCoordSeq_clone(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSCoordSeq_clone")
    end
    result
end

function destroyCoordSeq(ptr::GEOSCoordSeq)
    result = GEOSCoordSeq_destroy(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSCoordSeq_destroy")
    end
    result
end

# Set ordinate values in a Coordinate Sequence (Return 0 on exception)
function setX!(ptr::GEOSCoordSeq, i::Int, value::Float64)
    result = GEOSCoordSeq_setX(ptr, uint32(i-1), value)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_setX")
    end
    result
end

function setY!(ptr::GEOSCoordSeq, i::Int, value::Float64)
    result = GEOSCoordSeq_setY(ptr, uint32(i-1), value)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_setY")
    end
    result
end

function setZ!(ptr::GEOSCoordSeq, i::Int, value::Float64)
    result = GEOSCoordSeq_setZ(ptr, uint32(i-1), value)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_setZ")
    end
    result
end

# Get ordinate values from a Coordinate Sequence (Return 0 on exception)
function getX!(ptr::GEOSCoordSeq, index::Int, coord::Vector{Float64})
    result = GEOSCoordSeq_getX(ptr, uint32(index-1), pointer(coord))
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getX")
    end
    result
end

function getY!(ptr::GEOSCoordSeq, index::Int, coord::Vector{Float64})
    result = GEOSCoordSeq_getY(ptr, uint32(index-1), pointer(coord))
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getY")
    end
    result
end

function getZ!(ptr::GEOSCoordSeq, index::Int, coord::Vector{Float64})
    result = GEOSCoordSeq_getZ(ptr, uint32(index-1), pointer(coord))
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getZ")
    end
    result
end

function getSize(ptr::GEOSCoordSeq)
    ncoords = Array(Uint32, 1)
    # Get size info from a Coordinate Sequence (Return 0 on exception)
    result = GEOSCoordSeq_getSize(ptr, pointer(ncoords))
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getSize")
    end
    int(ncoords[1])
end

function getDimension(ptr::GEOSCoordSeq)
    ndim = Array(Uint32, 1)
    # Get dimensions info from a Coordinate Sequence (Return 0 on exception)
    result = GEOSCoordSeq_getDimensions(ptr, pointer(ndim))
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getDimensions")
    end
    int(ndim[1])
end

# convenience functions
function setCoordSeq!(ptr::GEOSCoordSeq, i::Int, coords::Vector{Float64})
    ndim = length(coords)
    @assert ndim >= 2
    setX!(ptr, i, coords[1])
    setY!(ptr, i, coords[2])
    ndim >= 3 && setZ!(ptr, i, coords[3])
    ptr
end

function createCoordSeq(x::Float64, y::Float64)
    coordinates = createCoordSeq(1, 2)
    setX!(coordinates, 1, x)
    setY!(coordinates, 1, y)
    coordinates
end

function createCoordSeq(x::Float64, y::Float64, z::Float64)
    coordinates = createCoordSeq(1, 3)
    setX!(coordinates, 1, x)
    setY!(coordinates, 1, y)
    setZ!(coordinates, 1, z)
    coordinates
end

function createCoordSeq(coords::Vector{Float64})
    ndim = length(coords)
    @assert ndim >= 2
    coordinates = createCoordSeq(1, ndim)
    setCoordSeq!(coordinates, 1, coord)
end

function createCoordSeq(coords::Vector{Vector{Float64}})
    ncoords = length(coords)
    @assert ncoords > 0
    ndim = length(coords[1])
    coordinates = createCoordSeq(ncoords, ndim)
    for (i,coord) in enumerate(coords)
        setCoordSeq!(coordinates, i, coord)
    end
    coordinates
end

function getX(ptr::GEOSCoordSeq, i::Int)
    coord = Array(Float64, 1)
    getX!(ptr, i, coord)
    coord[1]
end

function getX(ptr::GEOSCoordSeq)
    ncoords = getSize(ptr)
    xcoords = Array(Float64, ncoords)
    start = pointer(xcoords)
    floatsize = sizeof(Float64)
    for i=0:ncoords-1
        GEOSCoordSeq_getX(ptr, uint32(i), start + i*floatsize)
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
    start = pointer(ycoords)
    floatsize = sizeof(Float64)
    for i=0:ncoords-1
        GEOSCoordSeq_getY(ptr, uint32(i), start + i*floatsize)
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
    start = pointer(zcoords)
    floatsize = sizeof(Float64)
    for i=0:ncoords-1
        GEOSCoordSeq_getZ(ptr, uint32(i), start + i*floatsize)
    end
    zcoords
end

function getCoordinates(ptr::GEOSCoordSeq, i::Int)
    ndim = getDimension(ptr)
    coord = Array(Float64, ndim)
    start = pointer(coord)
    floatsize = sizeof(Float64)
    GEOSCoordSeq_getX(ptr, uint32(i-1), start)
    GEOSCoordSeq_getY(ptr, uint32(i-1), start+floatsize)
    if ndim == 3
        GEOSCoordSeq_getZ(ptr, uint32(i-1), start+2*floatsize)
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
function interpolate(ptr::GEOSGeom, d::Float64)
    result = GEOSInterpolate(ptr, d)
    if result == C_NULL
        error("LibGEOS: Error in GEOSInterpolate")
    end
    result
end

projectNormalized(g::GEOSGeom, p::GEOSGeom) = GEOSProjectNormalized(g, p)

function interpolateNormalized(ptr::GEOSGeom, d::Float64)
    result = GEOSInterpolateNormalized(ptr, d)
    if result == C_NULL
        error("LibGEOS: Error in GEOSInterpolateNormalized")
    end
    result
end

# -----
# Buffer related functions
# -----

# always returns a polygon
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

function createPoint(ptr::GEOSCoordSeq)
    result = GEOSGeom_createPoint(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createPoint")
    end
    result
end
createPoint(x::Float64, y::Float64) = createPoint(createCoordSeq(x,y))
createPoint(x::Float64, y::Float64, z::Float64) = createPoint(createCoordSeq(x,y,z))
createPoint(coords::Vector{Vector{Float64}}) = createPoint(createCoordSeq(coords))
createPoint(coords::Vector{Float64}) = createPoint(createCoordSeq(Vector{Float64}[coords]))

function createLinearRing(ptr::GEOSCoordSeq)
    result = GEOSGeom_createLinearRing(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createLinearRing")
    end
    result
end
createLinearRing(coords::Vector{Vector{Float64}}) = GEOSGeom_createLinearRing(createCoordSeq(coords))

function createLineString(ptr::GEOSCoordSeq)
    result = GEOSGeom_createLineString(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createLineString")
    end
    result
end
createLineString(coords::Vector{Vector{Float64}}) = GEOSGeom_createLineString(createCoordSeq(coords))

# Second argument is an array of GEOSGeometry* objects.
# The caller remains owner of the array, but pointed-to
# objects become ownership of the returned GEOSGeometry.
function createPolygon(shell::GEOSGeom, holes::Vector{GEOSGeom})
    result = GEOSGeom_createPolygon(shell, pointer(holes), uint32(length(holes)))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createPolygon")
    end
    result
end

createPolygon(coords::Vector{Vector{Vector{Float64}}}) = createPolygon(createLinearRing(coords[1]), map(createLinearRing, coords[2:end]))

function createCollection(geomtype::Int, geoms::Vector{GEOSGeom})
    result = GEOSGeom_createCollection(int32(geomtype), pointer(geoms), length(geoms))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createCollection")
    end
    result
end

function createEmptyCollection(geomtype::Int)
    result = GEOSGeom_createEmptyCollection(int32(geomtype))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createEmptyCollection")
    end
    result
end

# Memory management
function cloneGeom(ptr::GEOSGeom)
    result = GEOSGeom_clone(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_clone")
    end
    result
end

destroyGeom(ptr::GEOSGeom) = GEOSGeom_destroy(ptr)

# -----
# Topology operations - return NULL on exception.
# -----

function envelope(ptr::GEOSGeom)
    result = GEOSEnvelope(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSEnvelope")
    end
    result
end

function intersection(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSIntersection(g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSIntersection")
    end
    result
end

function convexhull(ptr::GEOSGeom)
    result = GEOSConvexHull(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSConvexHull")
    end
    result
end

function difference(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSDifference(g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSDifference")
    end
    result
end

function symmetricDifference(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSSymDifference(g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSSymDifference")
    end
    result
end

function boundary(ptr::GEOSGeom)
    result = GEOSBoundary(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSBoundary")
    end
    result
end

function union(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSUnion(g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSUnion")
    end
    result
end

function unaryUnion(ptr::GEOSGeom)
    result = GEOSUnaryUnion(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSUnaryUnion")
    end
    result
end

function pointOnSurface(ptr::GEOSGeom)
    result = GEOSPointOnSurface(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSPointOnSurface")
    end
    result
end

function centroid(ptr::GEOSGeom)
    result = GEOSGetCentroid(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetCentroid")
    end
    result
end

function node(ptr::GEOSGeom)
    result = GEOSNode(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSNode")
    end
    result
end

# all arguments remain ownership of the caller (both Geometries and pointers)
function polygonize(geoms::Vector{GEOSGeom})
    result = GEOSPolygonize(pointer(geoms), length(geoms))
    if result == C_NULL
        error("LibGEOS: Error in GEOSPolygonize")
    end
    result
end
# GEOSPolygonizer_getCutEdges
# GEOSPolygonize_full

function lineMerge(ptr::GEOSGeom)
    result = GEOSLineMerge(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSLineMerge")
    end
    result
end

function simplify(ptr::GEOSGeom, tol::Float64)
    result = GEOSSimplify(ptr, tol)
    if result == C_NULL
        error("LibGEOS: Error in GEOSSimplify")
    end
    result
end

function topologyPreserveSimplify(ptr::GEOSGeom, tol::Float64)
    result = GEOSTopologyPreserveSimplify(ptr, tol)
    if result == C_NULL
        error("LibGEOS: Error in GEOSTopologyPreserveSimplify")
    end
    result
end

# Return all distinct vertices of input geometry as a MULTIPOINT.
# (Note that only 2 dimensions of the vertices are considered when testing for equality)
function uniquePoints(ptr::GEOSGeom)
    result = GEOSGeom_extractUniquePoints(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_extractUniquePoints")
    end
    result
end

# Find paths shared between the two given lineal geometries.
# Returns a GEOMETRYCOLLECTION having two elements:
# - first element is a MULTILINESTRING containing shared paths
#    having the _same_ direction on both inputs
#  - second element is a MULTILINESTRING containing shared paths
#    having the _opposite_ direction on the two inputs
# (Returns NULL on exception)
function sharedPaths(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSSharedPaths(g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSSharedPaths")
    end
    result
end

# Snap first geometry on to second with given tolerance
# (Returns a newly allocated geometry, or NULL on exception)
function snap(g1::GEOSGeom, g2::GEOSGeom, tol::Float64)
    result = GEOSSnap(g1, g2, tol)
    if result == C_NULL
        error("LibGEOS: Error in GEOSSnap")
    end
    result
end

# Return a Delaunay triangulation of the vertex of the given geometry
#
# @param g the input geometry whose vertex will be used as "sites"
# @param tolerance optional snapping tolerance to use for improved robustness
# @param onlyEdges if non-zero will return a MULTILINESTRING, otherwise it will
#                  return a GEOMETRYCOLLECTION containing triangular POLYGONs.
#
# @return  a newly allocated geometry, or NULL on exception
function delaunayTriangulation(ptr::GEOSGeom, tol::Float64=0.0, onlyEdges::Bool=false)
    result = GEOSDelaunayTriangulation(ptr, tol, int32(onlyEdges))
    if result == C_NULL
        error("LibGEOS: Error in GEOSDelaunayTriangulation")
    end
    result
end

# -----
# Binary predicates - return 2 on exception, 1 on true, 0 on false
# -----
function disjoint(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSDisjoint(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSDisjoint")
    end
    bool(result)
end

function touches(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSTouches(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSTouches")
    end
    bool(result)
end

function intersects(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSIntersects(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSIntersects")
    end
    bool(result)
end

function crosses(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSCrosses(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSCrosses")
    end
    bool(result)
end

function within(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSWithin(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSWithin")
    end
    bool(result)
end

function contains(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSContains(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSContains")
    end
    bool(result)
end

function overlaps(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSOverlaps(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSOverlaps")
    end
    bool(result)
end

function equals(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSEquals(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSEquals")
    end
    bool(result)
end

function equalsexact(g1::GEOSGeom, g2::GEOSGeom, tol)
    result = GEOSEqualsExact(g1, g2, tol)
    if result == 0x02
        error("LibGEOS: Error in GEOSEqualsExact")
    end
    bool(result)
end

function covers(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSCovers(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSCovers")
    end
    bool(result)
end

function coveredby(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSCoveredBy(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSCoveredBy")
    end
    bool(result)
end

# -----
# Prepared Geometry Binary predicates - return 2 on exception, 1 on true, 0 on false
# -----

# GEOSGeometry ownership is retained by caller
function prepareGeom(ptr::GEOSGeom)
    result = GEOSPrepare(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSPrepare")
    end
    result
end

destroyPreparedGeom(ptr::Ptr{GEOSPreparedGeometry}) = GEOSPreparedGeom_destroy(ptr)

function prepcontains(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedContains(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedContains")
    end
    bool(result)
end

function prepcontainsproperly(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedContainsProperly(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedContainsProperly")
    end
    bool(result)
end

function prepcoveredby(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedCoveredBy(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedCoveredBy")
    end
    bool(result)
end

function prepcovers(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedCovers(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedCovers")
    end
    bool(result)
end

function prepcrosses(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedCrosses(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedCrosses")
    end
    bool(result)
end

function prepdisjoint(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedDisjoint(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedDisjoint")
    end
    bool(result)
end

function prepintersects(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedIntersects(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedIntersects")
    end
    bool(result)
end

function prepoverlaps(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedOverlaps(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedOverlaps")
    end
    bool(result)
end

function preptouches(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedTouches(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedTouches")
    end
    bool(result)
end

function prepwithin(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedWithin(g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedWithin")
    end
    bool(result)
end

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
function isEmpty(ptr::GEOSGeom)
    result = GEOSisEmpty(ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisEmpty")
    end
    bool(result)
end

function isSimple(ptr::GEOSGeom)
    result = GEOSisSimple(ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisSimple")
    end
    bool(result)
end

function isRing(ptr::GEOSGeom)
    result = GEOSisRing(ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisRing")
    end
    bool(result)
end

function hasZ(ptr::GEOSGeom)
    result = GEOSHasZ(ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSHasZ")
    end
    bool(result)
end

# Call only on LINESTRING (return 2 on exception, 1 on true, 0 on false)
function isClosed(ptr::GEOSGeom)
    result = GEOSisClosed(ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisClosed")
    end
    bool(result)
end

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

function isValid(ptr::GEOSGeom)
    result = GEOSisValid(ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisValid")
    end
    bool(result)
end

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
# function geomType(ptr::GEOSGeom)
#     result = GEOSGeomType(ptr)
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSGeomType")
#     end
#     result
# end

# Return -1 on exception
function geomTypeId(ptr::GEOSGeom)
    result = GEOSGeomTypeId(ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGeomTypeId")
    end
    result
end

# Return 0 on exception
function getSRID(ptr::GEOSGeom)
    result = GEOSGetSRID(ptr)
    if result == 0
        error("LibGEOS: Error in GEOSGeomTypeId")
    end
    result
end

setSRID(ptr::GEOSGeom) = GEOSSetSRID(ptr)

# May be called on all geometries in GEOS 3.x, returns -1 on error and 1
# for non-multi geometries. Older GEOS versions only accept
# GeometryCollections or Multi* geometries here, and are likely to crash
# when fed simple geometries, so beware if you need compatibility with
# old GEOS versions.
function numGeometries(ptr::GEOSGeom)
    result = GEOSGetNumGeometries(ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGeomTypeId")
    end
    result
end

# Call only on GEOMETRYCOLLECTION or MULTI*
# (Return a pointer to the internal Geometry. Return NULL on exception.)
# Returned object is a pointer to internal storage:
# it must NOT be destroyed directly.
# Up to GEOS 3.2.0 the input geometry must be a Collection, in
# later version it doesn't matter (i.e. getGeometryN(0) for a single will return the input).
function getGeometry(ptr::GEOSGeom, n::Int)
    result = GEOSGetGeometryN(ptr, int32(n-1))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetGeometryN")
    end
    result
end
getGeometries(ptr::GEOSGeom) = GEOSGeom[getGeometry(ptr, i) for i=1:numGeometries(ptr)]


# Converts Geometry to normal form (or canonical form).
# Return -1 on exception, 0 otherwise.
function normalize(ptr::GEOSGeom)
    result = GEOSNormalize(ptr)
    if result == -1
        error("LibGEOS: Error in GEOSNormalize")
    end
    result
end

# Return -1 on exception
function numInteriorRings(ptr::GEOSGeom)
    result = GEOSGetNumInteriorRings(ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGetNumInteriorRings")
    end
    result
end

# Call only on LINESTRING (returns -1 on exception)
function numPoints(ptr::GEOSGeom)
    result = GEOSGeomGetNumPoints(ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGeomGetNumPoints")
    end
    result
end

# Return -1 on exception, Geometry must be a Point.
function getGeomX(ptr::GEOSGeom)
    x = Array(Float64, 1)
    result = GEOSGeomGetX(ptr, pointer(x))
    if result == -1
        error("LibGEOS: Error in GEOSGeomGetX")
    end
    x[1]
end

function getGeomY(ptr::GEOSGeom)
    y = Array(Float64, 1)
    result = GEOSGeomGetY(ptr, pointer(y))
    if result == -1
        error("LibGEOS: Error in GEOSGeomGetY")
    end
    y[1]
end

# Return NULL on exception, Geometry must be a Polygon.
# Returned object is a pointer to internal storage: it must NOT be destroyed directly.
function interiorRing(ptr::GEOSGeom, n::Int)
    result = GEOSGetInteriorRingN(ptr, int32(n))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetInteriorRingN")
    end
    result
end

function interiorRings(ptr::GEOSGeom)
    n = numInteriorRings(ptr)
    if n == 0
        return GEOSGeom[]
    else
        return GEOSGeom[GEOSGetInteriorRingN(ptr, int32(i)) for i=0:n-1]
    end
end

# Return NULL on exception, Geometry must be a Polygon.
# Returned object is a pointer to internal storage: it must NOT be destroyed directly.
function exteriorRing(ptr::GEOSGeom)
    result = GEOSGetExteriorRing(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetExteriorRing")
    end
    result
end

# Return -1 on exception
function numCoordinates(ptr::GEOSGeom)
    result = GEOSGetNumCoordinates(ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGetNumCoordinates")
    end
    result
end

# Geometry must be a LineString, LinearRing or Point (Return NULL on exception)
function getCoordSeq(ptr::GEOSGeom)
    result = GEOSGeom_getCoordSeq(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_getCoordSeq")
    end
    result
end
getGeomCoordinates(ptr::GEOSGeom) = getCoordinates(getCoordSeq(ptr))

# Return 0 on exception (or empty geometry)
getDimensions(ptr::GEOSGeom) = GEOSGeom_getDimensions(ptr)

# Return 2 or 3.
getCoordinateDimension(ptr::GEOSGeom) = int(GEOSGeom_getCoordinateDimension(ptr))

# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
function getPoint(ptr::GEOSGeom, n::Int)
    result = GEOSGeomGetPointN(ptr, int32(n-1))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomGetPointN")
    end
    result
end

# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
function startPoint(ptr::GEOSGeom)
    result = GEOSGeomGetStartPoint(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomGetStartPoint")
    end
    result
end

# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
function endPoint(ptr::GEOSGeom)
    result = GEOSGeomGetEndPoint(ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomGetEndPoint")
    end
    result
end

# -----
# Misc functions
# -----
function geomArea(ptr::GEOSGeom)
    area = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    result = GEOSArea(ptr, pointer(area))
    if result == 0
        error("LibGEOS: Error in GEOSArea")
    end
    area[1]
end

function geomLength(ptr::GEOSGeom)
    len = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    result = GEOSLength(ptr, pointer(len))
    if result == 0
        error("LibGEOS: Error in GEOSLength")
    end
    len[1]
end

function geomDistance(g1::GEOSGeom, g2::GEOSGeom)
    dist = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    result = GEOSDistance(g1, g2, pointer(dist))
    if result == 0
        error("LibGEOS: Error in GEOSDistance")
    end
    dist[1]
end

function hausdorffdistance(g1::GEOSGeom, g2::GEOSGeom)
    dist = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    result = GEOSHausdorffDistance(g1, g2, pointer(dist))
    if result == 0
        error("LibGEOS: Error in GEOSHausdorffDistance")
    end
    dist[1]
end

function hausdorffdistance(g1::GEOSGeom, g2::GEOSGeom, densifyFrac::Float64)
    dist = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    result = GEOSHausdorffDistanceDensify(g1, g2, densifyFrac, pointer(dist))
    if result == 0
        error("LibGEOS: Error in GEOSHausdorffDistanceDensify")
    end
    dist[1]
end

# Call only on LINESTRING
function getLength(ptr::GEOSGeom)
    len = Array(Float64, 1)
    # Return 0 on exception, 1 otherwise
    result = GEOSGeomGetLength(ptr, pointer(len))
    if result == 0
        error("LibGEOS: Error in GEOSGeomGetLength")
    end
    len[1]
end

# Return 0 on exception, the closest points of the two geometries otherwise.
# The first point comes from g1 geometry and the second point comes from g2.
nearestPoints(g1::GEOSGeom, g2::GEOSGeom) = GEOSNearestPoints(g1, g2)

