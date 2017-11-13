# GENERAL NOTES:
# - Remember to call initGEOS() before any use of this library's
#   functions, and call finishGEOS() when done.
# - Currently you have to explicitly GEOSGeom_destroy() all
#   GEOSGeom objects to avoid memory leaks, and to GEOSFree()
#   all returned char * (unless const).

GEOMTYPE = Dict( GEOS_POINT => :Point,
                 GEOS_LINESTRING => :LineString,
                 GEOS_LINEARRING => :LinearRing,
                 GEOS_POLYGON => :Polygon,
                 GEOS_MULTIPOINT => :MultiPoint,
                 GEOS_MULTILINESTRING => :MultiLineString,
                 GEOS_MULTIPOLYGON => :MultiPolygon,
                 GEOS_GEOMETRYCOLLECTION => :GeometryCollection)


function geomFromWKT(geom::String)
    result = GEOSGeomFromWKT_r(_context.ptr, geom)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomFromWKT")
    end
    result
end
geomToWKT(geom::Ptr{GEOSGeometry}) = unsafe_string(GEOSGeomToWKT_r(_context.ptr, geom))

# -----
# Coordinate Sequence functions
# -----
"""
    createCoordSeq(size::Integer; ndim::Integer=2) -> Ptr{Ptr{Void}}

Create a Coordinate sequence with ``size'' coordinates of ``dims'' dimensions (Return NULL on exception)
"""
function createCoordSeq(size::Integer; ndim::Integer=2)
    @assert ndim >= 2
    result = GEOSCoordSeq_create_r(_context.ptr, size, ndim)
    if result == C_NULL
        error("LibGEOS: Error in GEOSCoordSeq_create")
    end
    result
end

# Clone a Coordinate Sequence (Return NULL on exception)
function cloneCoordSeq(ptr::GEOSCoordSeq)
    result = GEOSCoordSeq_clone_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSCoordSeq_clone")
    end
    result
end

function destroyCoordSeq(ptr::GEOSCoordSeq)
    result = GEOSCoordSeq_destroy_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSCoordSeq_destroy")
    end
    result
end

# Set ordinate values in a Coordinate Sequence (Return 0 on exception)
function setX!(ptr::GEOSCoordSeq, i::Integer, value::Real)
    result = GEOSCoordSeq_setX_r(_context.ptr, ptr, i-1, value)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_setX")
    end
    result
end

function setY!(ptr::GEOSCoordSeq, i::Integer, value::Real)
    result = GEOSCoordSeq_setY_r(_context.ptr, ptr, i-1, value)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_setY")
    end
    result
end

function setZ!(ptr::GEOSCoordSeq, i::Integer, value::Real)
    result = GEOSCoordSeq_setZ_r(_context.ptr, ptr, i-1, value)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_setZ")
    end
    result
end

# Get ordinate values from a Coordinate Sequence (Return 0 on exception)
function getX!(ptr::GEOSCoordSeq, index::Integer, coord::Vector{Float64})
    result = GEOSCoordSeq_getX_r(_context.ptr, ptr, index-1, pointer(coord))
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getX")
    end
    result
end

function getY!(ptr::GEOSCoordSeq, index::Integer, coord::Vector{Float64})
    result = GEOSCoordSeq_getY_r(_context.ptr, ptr, index-1, pointer(coord))
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getY")
    end
    result
end

function getZ!(ptr::GEOSCoordSeq, index::Integer, coord::Vector{Float64})
    result = GEOSCoordSeq_getZ_r(_context.ptr, ptr, index-1, pointer(coord))
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getZ")
    end
    result
end

let out = Array{UInt32}(1)
    global getSize
    function getSize(ptr::GEOSCoordSeq)
        # Get size info from a Coordinate Sequence (Return 0 on exception)
        result = GEOSCoordSeq_getSize_r(_context.ptr, ptr, pointer(out))
        if result == 0
            error("LibGEOS: Error in GEOSCoordSeq_getSize")
        end
        Int(out[1])
    end
end

let out = Array{UInt32}(1)
    global getDimensions
    function getDimensions(ptr::GEOSCoordSeq)
        # Get dimensions info from a Coordinate Sequence (Return 0 on exception)
        result = GEOSCoordSeq_getDimensions_r(_context.ptr, ptr, pointer(out))
        if result == 0
            error("LibGEOS: Error in GEOSCoordSeq_getDimensions")
        end
        Int(out[1])
    end
end

# convenience functions
function setCoordSeq!(ptr::GEOSCoordSeq, i::Integer, coords::Vector{Float64})
    ndim = length(coords)
    @assert ndim >= 2
    setX!(ptr, i, coords[1])
    setY!(ptr, i, coords[2])
    ndim >= 3 && setZ!(ptr, i, coords[3])
    ptr
end

"""
    createCoordSeq(x::Real, y::Real) -> Ptr{Ptr{Void}}

Create a createCoordSeq of a single 2D coordinate
"""
function createCoordSeq(x::Real, y::Real)
    coordinates = createCoordSeq(1, ndim=2)
    setX!(coordinates, 1, x)
    setY!(coordinates, 1, y)
    coordinates
end

"""
    createCoordSeq(x::Real, y::Real, z::Real) -> Ptr{Ptr{Void}}

Create a createCoordSeq of a single 3D coordinate
"""
function createCoordSeq(x::Real, y::Real, z::Real)
    coordinates = createCoordSeq(1, ndim=3)
    setX!(coordinates, 1, x)
    setY!(coordinates, 1, y)
    setZ!(coordinates, 1, z)
    coordinates
end

"""
    createCoordSeq(coords::Vector{Float64}) -> Ptr{Ptr{Void}}

Create a createCoordSeq of a single N dimensional coordinate
"""
function createCoordSeq(coords::Vector{Float64})
    ndim = length(coords)
    @assert ndim >= 2
    coordinates = createCoordSeq(1, ndim=ndim)
    setCoordSeq!(coordinates, 1, coords)
end

"""
    createCoordSeq(coords::Vector{Float64}) -> Ptr{Ptr{Void}}

Create a createCoordSeq of a multiple N dimensional coordinate
"""
function createCoordSeq(coords::Vector{Vector{Float64}})
    ncoords = length(coords)
    @assert ncoords > 0
    ndim = length(coords[1])
    coordinates = createCoordSeq(ncoords, ndim=ndim)
    for (i,coord) in enumerate(coords)
        setCoordSeq!(coordinates, i, coord)
    end
    coordinates
end

let out = Array{Float64}(1)
    global getX
    function getX(ptr::GEOSCoordSeq, i::Integer)
        getX!(ptr, i, out)
        out[1]
    end
end

function getX(ptr::GEOSCoordSeq)
    ncoords = getSize(ptr)
    xcoords = Array{Float64}(ncoords)
    start = pointer(xcoords)
    floatsize = sizeof(Float64)
    for i=0:ncoords-1
        GEOSCoordSeq_getX_r(_context.ptr, ptr, i, start + i*floatsize)
    end
    xcoords
end

let out = Array{Float64}(1)
    global getY
    function getY(ptr::GEOSCoordSeq, i::Integer)
        out = Array{Float64}(1)
        getY!(ptr, i, out)
        out[1]
    end
end

function getY(ptr::GEOSCoordSeq)
    ncoords = getSize(ptr)
    ycoords = Array{Float64}(ncoords)
    start = pointer(ycoords)
    floatsize = sizeof(Float64)
    for i=0:ncoords-1
        GEOSCoordSeq_getY_r(_context.ptr, ptr, i, start + i*floatsize)
    end
    ycoords
end

let out = Array{Float64}(1)
    global getZ
    function getZ(ptr::GEOSCoordSeq, i::Integer)
        getZ!(ptr, i, out)
        out[1]
    end
end

function getZ(ptr::GEOSCoordSeq)
    ncoords = getSize(ptr)
    zcoords = Array{Float64}(ncoords)
    start = pointer(zcoords)
    floatsize = sizeof(Float64)
    for i=0:ncoords-1
        GEOSCoordSeq_getZ_r(_context.ptr, ptr, i, start + i*floatsize)
    end
    zcoords
end

function getCoordinates(ptr::GEOSCoordSeq, i::Integer)
    ndim = getDimensions(ptr)
    coord = Array{Float64}(ndim)
    start = pointer(coord)
    floatsize = sizeof(Float64)
    GEOSCoordSeq_getX_r(_context.ptr, ptr, i-1, start)
    GEOSCoordSeq_getY_r(_context.ptr, ptr, i-1, start+floatsize)
    if ndim == 3
        GEOSCoordSeq_getZ_r(_context.ptr, ptr, i-1, start+2*floatsize)
    end
    coord
end

function getCoordinates(ptr::GEOSCoordSeq)
    ndim = getDimensions(ptr)
    ncoords = getSize(ptr)
    coordseq = Vector{Float64}[]
    sizehint!(coordseq, ncoords)
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
project(g::GEOSGeom, p::GEOSGeom) = GEOSProject_r(_context.ptr, g, p)
# Return closest point to given distance within geometry (Geometry must be a LineString)
function interpolate(ptr::GEOSGeom, d::Real)
    result = GEOSInterpolate_r(_context.ptr, ptr, d)
    if result == C_NULL
        error("LibGEOS: Error in GEOSInterpolate")
    end
    result
end

projectNormalized(g::GEOSGeom, p::GEOSGeom) = GEOSProjectNormalized_r(_context.ptr, g, p)

function interpolateNormalized(ptr::GEOSGeom, d::Real)
    result = GEOSInterpolateNormalized_r(_context.ptr, ptr, d)
    if result == C_NULL
        error("LibGEOS: Error in GEOSInterpolateNormalized")
    end
    result
end

# -----
# Buffer related functions
# -----
# Computes the buffer of a geometry, for both positive and negative buffer distances.
# Since true buffer curves may contain circular arcs, computed buffer polygons can only be approximations to the true geometry.
# The user can control the accuracy of the curve approximation by specifying the number of linear segments with which to approximate a curve.

# Always returns a polygon. The negative or zero-distance buffer of lines and points is always an empty Polygon.
buffer(ptr::GEOSGeom, width::Real, quadsegs::Integer=8) = GEOSBuffer_r(_context.ptr, ptr, width, Int32(quadsegs))

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
    result = GEOSGeom_createPoint_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createPoint")
    end
    result
end
createPoint(x::Real, y::Real) = createPoint(createCoordSeq(x,y))
createPoint(x::Real, y::Real, z::Real) = createPoint(createCoordSeq(x,y,z))
createPoint(coords::Vector{Vector{Float64}}) = createPoint(createCoordSeq(coords))
createPoint(coords::Vector{Float64}) = createPoint(createCoordSeq(Vector{Float64}[coords]))

function createLinearRing(ptr::GEOSCoordSeq)
    result = GEOSGeom_createLinearRing_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createLinearRing")
    end
    result
end
createLinearRing(coords::Vector{Vector{Float64}}) = GEOSGeom_createLinearRing_r(_context.ptr, createCoordSeq(coords))

function createLineString(ptr::GEOSCoordSeq)
    result = GEOSGeom_createLineString_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createLineString")
    end
    result
end
createLineString(coords::Vector{Vector{Float64}}) = GEOSGeom_createLineString_r(_context.ptr, createCoordSeq(coords))

# Second argument is an array of GEOSGeometry* objects.
# The caller remains owner of the array, but pointed-to
# objects become ownership of the returned GEOSGeometry.
function createPolygon(shell::GEOSGeom, holes::Vector{GEOSGeom})
    result = GEOSGeom_createPolygon_r(_context.ptr, shell, pointer(holes), length(holes))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createPolygon")
    end
    result
end

function createCollection(geomtype::Integer, geoms::Vector{GEOSGeom})
    result = GEOSGeom_createCollection_r(_context.ptr, geomtype, pointer(geoms), length(geoms))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createCollection")
    end
    result
end

function createEmptyCollection(geomtype::Integer)
    result = GEOSGeom_createEmptyCollection_r(_context.ptr, geomtype)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createEmptyCollection")
    end
    result
end

# Memory management
function cloneGeom(ptr::GEOSGeom)
    result = GEOSGeom_clone_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_clone")
    end
    result
end

destroyGeom(ptr::GEOSGeom) = GEOSGeom_destroy_r(_context.ptr, ptr)

# -----
# Topology operations - return NULL on exception.
# -----

function envelope(ptr::GEOSGeom)
    result = GEOSEnvelope_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSEnvelope")
    end
    result
end

function intersection(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSIntersection_r(_context.ptr, g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSIntersection")
    end
    result
end

# Returns a Geometry that represents the convex hull of the input geometry. The returned geometry contains the minimal number of points needed to represent the convex hull. In particular, no more than two consecutive points will be collinear.

# Returns:
# if the convex hull contains 3 or more points, a Polygon; 2 points, a LineString; 1 point, a Point; 0 points, an empty GeometryCollection.
function convexhull(ptr::GEOSGeom)
    result = GEOSConvexHull_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSConvexHull")
    end
    result
end

function difference(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSDifference_r(_context.ptr, g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSDifference")
    end
    result
end

function symmetricDifference(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSSymDifference_r(_context.ptr, g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSSymDifference")
    end
    result
end

function boundary(ptr::GEOSGeom)
    result = GEOSBoundary_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSBoundary")
    end
    result
end

function union(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSUnion_r(_context.ptr, g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSUnion")
    end
    result
end

function unaryUnion(ptr::GEOSGeom)
    result = GEOSUnaryUnion_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSUnaryUnion")
    end
    result
end

function pointOnSurface(ptr::GEOSGeom)
    result = GEOSPointOnSurface_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSPointOnSurface")
    end
    result
end

function centroid(ptr::GEOSGeom)
    result = GEOSGetCentroid_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetCentroid")
    end
    result
end

function node(ptr::GEOSGeom)
    result = GEOSNode_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSNode")
    end
    result
end

# all arguments remain ownership of the caller (both Geometries and pointers)
function polygonize(geoms::Vector{GEOSGeom})
    result = GEOSPolygonize_r(_context.ptr, pointer(geoms), length(geoms))
    if result == C_NULL
        error("LibGEOS: Error in GEOSPolygonize")
    end
    result
end
# GEOSPolygonizer_getCutEdges
# GEOSPolygonize_full

function lineMerge(ptr::GEOSGeom)
    result = GEOSLineMerge_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSLineMerge")
    end
    result
end

function simplify(ptr::GEOSGeom, tol::Real)
    result = GEOSSimplify_r(_context.ptr, ptr, tol)
    if result == C_NULL
        error("LibGEOS: Error in GEOSSimplify")
    end
    result
end

function topologyPreserveSimplify(ptr::GEOSGeom, tol::Real)
    result = GEOSTopologyPreserveSimplify_r(_context.ptr, ptr, tol)
    if result == C_NULL
        error("LibGEOS: Error in GEOSTopologyPreserveSimplify")
    end
    result
end

# Return all distinct vertices of input geometry as a MULTIPOINT.
# (Note that only 2 dimensions of the vertices are considered when testing for equality)
function uniquePoints(ptr::GEOSGeom)
    result = GEOSGeom_extractUniquePoints_r(_context.ptr, ptr)
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
    result = GEOSSharedPaths_r(_context.ptr, g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSSharedPaths")
    end
    result
end

# Snap first geometry on to second with given tolerance
# (Returns a newly allocated geometry, or NULL on exception)
function snap(g1::GEOSGeom, g2::GEOSGeom, tol::Real)
    result = GEOSSnap_r(_context.ptr, g1, g2, tol)
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
function delaunayTriangulation(ptr::GEOSGeom, tol::Real=0.0, onlyEdges::Bool=false)
    result = GEOSDelaunayTriangulation_r(_context.ptr, ptr, tol, Int32(onlyEdges))
    if result == C_NULL
        error("LibGEOS: Error in GEOSDelaunayTriangulation")
    end
    result
end

# -----
# Binary predicates - return 2 on exception, 1 on true, 0 on false
# -----
function disjoint(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSDisjoint_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSDisjoint")
    end
    result != 0x00
end

function touches(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSTouches_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSTouches")
    end
    result != 0x00
end

function intersects(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSIntersects_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSIntersects")
    end
    result != 0x00
end

function crosses(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSCrosses_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSCrosses")
    end
    result != 0x00
end

function within(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSWithin_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSWithin")
    end
    result != 0x00
end

function contains(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSContains_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSContains")
    end
    result != 0x00
end

function overlaps(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSOverlaps_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSOverlaps")
    end
    result != 0x00
end

function equals(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSEquals_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSEquals")
    end
    result != 0x00
end

function equalsexact(g1::GEOSGeom, g2::GEOSGeom, tol::Real)
    result = GEOSEqualsExact_r(_context.ptr, g1, g2, tol)
    if result == 0x02
        error("LibGEOS: Error in GEOSEqualsExact")
    end
    result != 0x00
end

function covers(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSCovers_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSCovers")
    end
    result != 0x00
end

function coveredby(g1::GEOSGeom, g2::GEOSGeom)
    result = GEOSCoveredBy_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSCoveredBy")
    end
    result != 0x00
end

# -----
# Prepared Geometry Binary predicates - return 2 on exception, 1 on true, 0 on false
# -----

# GEOSGeometry ownership is retained by caller
function prepareGeom(ptr::GEOSGeom)
    result = GEOSPrepare_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSPrepare")
    end
    result
end

destroyPreparedGeom(ptr::Ptr{GEOSPreparedGeometry}) = GEOSPreparedGeom_destroy_r(_context.ptr, ptr)

function prepcontains(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedContains_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedContains")
    end
    result != 0x00
end

function prepcontainsproperly(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedContainsProperly_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedContainsProperly")
    end
    result != 0x00
end

function prepcoveredby(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedCoveredBy_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedCoveredBy")
    end
    result != 0x00
end

function prepcovers(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedCovers_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedCovers")
    end
    result != 0x00
end

function prepcrosses(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedCrosses_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedCrosses")
    end
    result != 0x00
end

function prepdisjoint(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedDisjoint_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedDisjoint")
    end
    result != 0x00
end

function prepintersects(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedIntersects_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedIntersects")
    end
    result != 0x00
end

function prepoverlaps(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedOverlaps_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedOverlaps")
    end
    result != 0x00
end

function preptouches(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedTouches_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedTouches")
    end
    result != 0x00
end

function prepwithin(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
    result = GEOSPreparedWithin_r(_context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedWithin")
    end
    result != 0x00
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
    result = GEOSisEmpty_r(_context.ptr, ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisEmpty")
    end
    result != 0x00
end

function isSimple(ptr::GEOSGeom)
    result = GEOSisSimple_r(_context.ptr, ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisSimple")
    end
    result != 0x00
end

function isRing(ptr::GEOSGeom)
    result = GEOSisRing_r(_context.ptr, ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisRing")
    end
    result != 0x00
end

function hasZ(ptr::GEOSGeom)
    result = GEOSHasZ_r(_context.ptr, ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSHasZ")
    end
    result != 0x00
end

# Call only on LINESTRING (return 2 on exception, 1 on true, 0 on false)
function isClosed(ptr::GEOSGeom)
    result = GEOSisClosed_r(_context.ptr, ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisClosed")
    end
    result != 0x00
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
    result = GEOSisValid_r(_context.ptr, ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisValid")
    end
    result != 0x00
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
    result = GEOSGeomTypeId_r(_context.ptr, ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGeomTypeId")
    end
    result
end

# Return 0 on exception
function getSRID(ptr::GEOSGeom)
    result = GEOSGetSRID_r(_context.ptr, ptr)
    if result == 0
        error("LibGEOS: Error in GEOSGeomTypeId")
    end
    result
end

setSRID(ptr::GEOSGeom) = GEOSSetSRID_r(_context.ptr, ptr)

# May be called on all geometries in GEOS 3.x, returns -1 on error and 1
# for non-multi geometries. Older GEOS versions only accept
# GeometryCollections or Multi* geometries here, and are likely to crash
# when fed simple geometries, so beware if you need compatibility with
# old GEOS versions.
function numGeometries(ptr::GEOSGeom)
    result = GEOSGetNumGeometries_r(_context.ptr, ptr)
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
function getGeometry(ptr::GEOSGeom, n::Integer)
    result = GEOSGetGeometryN_r(_context.ptr, ptr, n-1)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetGeometryN")
    end
    cloneGeom(result)
end
getGeometries(ptr::GEOSGeom) = GEOSGeom[getGeometry(ptr, i) for i=1:numGeometries(ptr)]

# Converts Geometry to normal form (or canonical form).
# Return -1 on exception, 0 otherwise.
function Base.normalize!(ptr::GEOSGeom)
    result = GEOSNormalize_r(_context.ptr, ptr)
    if result == -1
        error("LibGEOS: Error in GEOSNormalize")
    end
    result
end

# Return -1 on exception
function numInteriorRings(ptr::GEOSGeom)
    result = GEOSGetNumInteriorRings_r(_context.ptr, ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGetNumInteriorRings")
    end
    result
end

# Call only on LINESTRING (returns -1 on exception)
function numPoints(ptr::GEOSGeom)
    result = GEOSGeomGetNumPoints_r(_context.ptr, ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGeomGetNumPoints")
    end
    result
end

# Return -1 on exception, Geometry must be a Point.
let out = Array{Float64}(1)
    global getGeomX
    function getGeomX(ptr::GEOSGeom)
        result = GEOSGeomGetX_r(_context.ptr, ptr, pointer(out))
        if result == -1
            error("LibGEOS: Error in GEOSGeomGetX")
        end
        out[1]
    end
end

let out = Array{Float64}(1)
    global getGeomY
    function getGeomY(ptr::GEOSGeom)
        result = GEOSGeomGetY_r(_context.ptr, ptr, pointer(out))
        if result == -1
            error("LibGEOS: Error in GEOSGeomGetY")
        end
        out[1]
    end
end

# Return NULL on exception, Geometry must be a Polygon.
# Returned object is a pointer to internal storage: it must NOT be destroyed directly.
function interiorRing(ptr::GEOSGeom, n::Integer)
    result = GEOSGetInteriorRingN_r(_context.ptr, ptr, n-1)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetInteriorRingN")
    end
    cloneGeom(result)
end

function interiorRings(ptr::GEOSGeom)
    n = numInteriorRings(ptr)
    if n == 0
        return GEOSGeom[]
    else
        return GEOSGeom[interiorRing(ptr, i) for i=1:n]
    end
end

# Return NULL on exception, Geometry must be a Polygon.
# Returned object is a pointer to internal storage: it must NOT be destroyed directly.
function exteriorRing(ptr::GEOSGeom)
    result = GEOSGetExteriorRing_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetExteriorRing")
    end
    cloneGeom(result)
end

# Return -1 on exception
function numCoordinates(ptr::GEOSGeom)
    result = GEOSGetNumCoordinates_r(_context.ptr, ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGetNumCoordinates")
    end
    result
end

# Geometry must be a LineString, LinearRing or Point (Return NULL on exception)
function getCoordSeq(ptr::GEOSGeom)
    result = GEOSGeom_getCoordSeq_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_getCoordSeq")
    end
    result
end
# getGeomCoordinates(ptr::GEOSGeom) = getCoordinates(getCoordSeq(ptr))

# Return 0 on exception (or empty geometry)
getGeomDimensions(ptr::GEOSGeom) = GEOSGeom_getDimensions_r(_context.ptr, ptr)

# Return 2 or 3.
getCoordinateDimension(ptr::GEOSGeom) = GEOSGeom_getCoordinateDimension_r(_context.ptr, ptr)

# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
function getPoint(ptr::GEOSGeom, n::Integer)
    result = GEOSGeomGetPointN_r(_context.ptr, ptr, n-1)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomGetPointN")
    end
    result
end

# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
function startPoint(ptr::GEOSGeom)
    result = GEOSGeomGetStartPoint_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomGetStartPoint")
    end
    result
end

# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
function endPoint(ptr::GEOSGeom)
    result = GEOSGeomGetEndPoint_r(_context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomGetEndPoint")
    end
    result
end

# -----
# Misc functions
# -----
let out = Array{Float64}(1)
    global geomArea
    function geomArea(ptr::GEOSGeom)
        # Return 0 on exception, 1 otherwise
        result = GEOSArea_r(_context.ptr, ptr, pointer(out))
        if result == 0
            error("LibGEOS: Error in GEOSArea")
        end
        out[1]
    end
end

let out = Array{Float64}(1)
    global geomLength
    function geomLength(ptr::GEOSGeom)
        # Return 0 on exception, 1 otherwise
        result = GEOSLength_r(_context.ptr, ptr, pointer(out))
        if result == 0
            error("LibGEOS: Error in GEOSLength")
        end
        out[1]
    end
end

let out = Array{Float64}(1)
    global geomDistance
    function geomDistance(g1::GEOSGeom, g2::GEOSGeom)
        # Return 0 on exception, 1 otherwise
        result = GEOSDistance_r(_context.ptr, g1, g2, pointer(out))
        if result == 0
            error("LibGEOS: Error in GEOSDistance")
        end
        out[1]
    end
end

let out = Array{Float64}(1)
    global hausdorffdistance
    function hausdorffdistance(g1::GEOSGeom, g2::GEOSGeom)
        # Return 0 on exception, 1 otherwise
        result = GEOSHausdorffDistance_r(_context.ptr, g1, g2, pointer(out))
        if result == 0
            error("LibGEOS: Error in GEOSHausdorffDistance")
        end
        out[1]
    end
end

let out = Array{Float64}(1)
    global hausdorffdistance
    function hausdorffdistance(g1::GEOSGeom, g2::GEOSGeom, densifyFrac::Real)
        # Return 0 on exception, 1 otherwise
        result = GEOSHausdorffDistanceDensify_r(_context.ptr, g1, g2, densifyFrac, pointer(out))
        if result == 0
            error("LibGEOS: Error in GEOSHausdorffDistanceDensify")
        end
        out[1]
    end
end

# Return 0 on exception, the closest points of the two geometries otherwise.
# The first point comes from g1 geometry and the second point comes from g2.
nearestPoints(g1::GEOSGeom, g2::GEOSGeom) = GEOSNearestPoints_r(_context.ptr, g1, g2)
