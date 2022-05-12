function _readgeom(wktstring::String, wktreader::WKTReader, context::GEOSContext = _context)
    result = GEOSWKTReader_read_r(context.ptr, wktreader.ptr, pointer(wktstring))
    if result == C_NULL
        error("LibGEOS: Error in GEOSWKTReader_read_r while reading $wktstring")
    end
    result
end
_readgeom(wktstring::String, context::GEOSContext = _context) =
    _readgeom(wktstring, WKTReader(context), context)

function _readgeom(
    wkbbuffer::Vector{Cuchar},
    wkbreader::WKBReader,
    context::GEOSContext = _context,
)
    result = GEOSWKBReader_read_r(
        context.ptr,
        wkbreader.ptr,
        pointer(wkbbuffer),
        length(wkbbuffer),
    )
    if result == C_NULL
        error("LibGEOS: Error in GEOSWKBReader_read_r")
    end
    result
end
_readgeom(wkbbuffer::Vector{Cuchar}, context::GEOSContext = _context) =
    _readgeom(wkbbuffer, WKBReader(context), context)

function _writegeom(geom::GEOSGeom, wktwriter::WKTWriter, context::GEOSContext = _context)
    GEOSWKTWriter_write_r(context.ptr, wktwriter.ptr, geom)
end

function _writegeom(geom::GEOSGeom, wkbwriter::WKBWriter, context::GEOSContext = _context)
    wkbsize = Ref{Csize_t}()
    result = GEOSWKBWriter_write_r(context.ptr, wkbwriter.ptr, geom, wkbsize)
    unsafe_wrap(Array, result, wkbsize[], own = true)
end

_writegeom(geom::GEOSGeom, context::GEOSContext = _context) =
    _writegeom(geom, WKTWriter(context), context)

# -----
# Coordinate Sequence functions
# -----
"""
    createCoordSeq(size::Integer; ndim::Integer=2) -> Ptr{Ptr{Void}}

Create a Coordinate sequence with ``size'' coordinates of ``dims'' dimensions (Return NULL on exception)
"""
function createCoordSeq(size::Integer, context::GEOSContext = _context; ndim::Integer = 2)
    @assert ndim >= 2
    result = GEOSCoordSeq_create_r(context.ptr, size, ndim)
    if result == C_NULL
        error("LibGEOS: Error in GEOSCoordSeq_create")
    end
    result
end

# Clone a Coordinate Sequence (Return NULL on exception)
function cloneCoordSeq(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    result = GEOSCoordSeq_clone_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSCoordSeq_clone")
    end
    result
end

function destroyCoordSeq(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    result = GEOSCoordSeq_destroy_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSCoordSeq_destroy")
    end
    result
end

# Set ordinate values in a Coordinate Sequence (Return 0 on exception)
function setX!(ptr::GEOSCoordSeq, i::Integer, value::Real, context::GEOSContext = _context)
    result = GEOSCoordSeq_setX_r(context.ptr, ptr, i - 1, value)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_setX")
    end
    result
end

function setY!(ptr::GEOSCoordSeq, i::Integer, value::Real, context::GEOSContext = _context)
    result = GEOSCoordSeq_setY_r(context.ptr, ptr, i - 1, value)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_setY")
    end
    result
end

function setZ!(ptr::GEOSCoordSeq, i::Integer, value::Real, context::GEOSContext = _context)
    result = GEOSCoordSeq_setZ_r(context.ptr, ptr, i - 1, value)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_setZ")
    end
    result
end

"Get size info from a Coordinate Sequence (Return 0 on exception)"
function getSize(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    out = Ref{UInt32}()
    result = GEOSCoordSeq_getSize_r(context.ptr, ptr, out)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getSize")
    end
    Int(out[])
end

"Get dimensions info from a Coordinate Sequence (Return 0 on exception)"
function getDimensions(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    out = Ref{UInt32}()
    result = GEOSCoordSeq_getDimensions_r(context.ptr, ptr, out)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getDimensions")
    end
    Int(out[])
end

# convenience functions
function setCoordSeq!(
    ptr::GEOSCoordSeq,
    i::Integer,
    coords::Vector{Float64},
    context::GEOSContext = _context,
)
    ndim = length(coords)
    @assert ndim >= 2
    setX!(ptr, i, coords[1], context)
    setY!(ptr, i, coords[2], context)
    ndim >= 3 && setZ!(ptr, i, coords[3], context)
    ptr
end

"""
    createCoordSeq(x::Real, y::Real) -> Ptr{Ptr{Void}}

Create a createCoordSeq of a single 2D coordinate
"""
function createCoordSeq(x::Real, y::Real, context::GEOSContext = _context)
    coordinates = createCoordSeq(1, context, ndim = 2)
    setX!(coordinates, 1, x, context)
    setY!(coordinates, 1, y, context)
    coordinates
end

"""
    createCoordSeq(x::Real, y::Real, z::Real) -> Ptr{Ptr{Void}}

Create a createCoordSeq of a single 3D coordinate
"""
function createCoordSeq(x::Real, y::Real, z::Real, context::GEOSContext = _context)
    coordinates = createCoordSeq(1, context, ndim = 3)
    setX!(coordinates, 1, x, context)
    setY!(coordinates, 1, y, context)
    setZ!(coordinates, 1, z, context)
    coordinates
end

"""
    createCoordSeq(coords::Vector{Float64}) -> Ptr{Ptr{Void}}

Create a createCoordSeq of a single N dimensional coordinate
"""
function createCoordSeq(coords::Vector{Float64}, context::GEOSContext = _context)
    ndim = length(coords)
    @assert ndim >= 2
    coordinates = createCoordSeq(1, context, ndim = ndim)
    setCoordSeq!(coordinates, 1, coords, context)
end

"""
    createCoordSeq(coords::Vector{Float64}) -> Ptr{Ptr{Void}}

Create a createCoordSeq of a multiple N dimensional coordinate
"""
function createCoordSeq(coords::Vector{Vector{Float64}}, context::GEOSContext = _context)
    ncoords = length(coords)
    @assert ncoords > 0
    ndim = length(coords[1])
    coordinates = createCoordSeq(ncoords, context, ndim = ndim)
    for (i, coord) in enumerate(coords)
        setCoordSeq!(coordinates, i, coord, context)
    end
    coordinates
end

function getX(ptr::GEOSCoordSeq, i::Integer, context::GEOSContext = _context)
    out = Ref{Float64}()
    result = GEOSCoordSeq_getX_r(context.ptr, ptr, i - 1, out)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getX")
    end
    out[]
end

function getX(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    ncoords = getSize(ptr, context)
    xcoords = Array{Float64}(ncoords)
    start = pointer(xcoords)
    floatsize = sizeof(Float64)
    for i = 0:ncoords-1
        GEOSCoordSeq_getX_r(context.ptr, ptr, i, start + i * floatsize)
    end
    xcoords
end

function getY(ptr::GEOSCoordSeq, i::Integer, context::GEOSContext = _context)
    out = Ref{Float64}()
    result = GEOSCoordSeq_getY_r(context.ptr, ptr, i - 1, out)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getY")
    end
    out[]
end

function getY(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    ncoords = getSize(ptr, context)
    ycoords = Array{Float64}(ncoords)
    start = pointer(ycoords)
    floatsize = sizeof(Float64)
    for i = 0:ncoords-1
        GEOSCoordSeq_getY_r(context.ptr, ptr, i, start + i * floatsize)
    end
    ycoords
end

function getZ(ptr::GEOSCoordSeq, i::Integer, context::GEOSContext = _context)
    out = Ref{Float64}()
    result = GEOSCoordSeq_getZ_r(context.ptr, ptr, i - 1, out)
    if result == 0
        error("LibGEOS: Error in GEOSCoordSeq_getZ")
    end
    out[]
end

function getZ(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    ncoords = getSize(ptr, context)
    zcoords = Array{Float64}(ncoords)
    start = pointer(zcoords)
    floatsize = sizeof(Float64)
    for i = 0:ncoords-1
        GEOSCoordSeq_getZ_r(context.ptr, ptr, i, start + i * floatsize)
    end
    zcoords
end

function getCoordinates(ptr::GEOSCoordSeq, i::Integer, context::GEOSContext = _context)
    ndim = getDimensions(ptr, context)
    coord = Array{Float64}(undef, ndim)
    start = pointer(coord)
    floatsize = sizeof(Float64)
    GEOSCoordSeq_getX_r(context.ptr, ptr, i - 1, start)
    GEOSCoordSeq_getY_r(context.ptr, ptr, i - 1, start + floatsize)
    if ndim == 3
        GEOSCoordSeq_getZ_r(context.ptr, ptr, i - 1, start + 2 * floatsize)
    end
    coord
end

function getCoordinates(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    ndim = getDimensions(ptr, context)
    ncoords = getSize(ptr, context)
    coordseq = Vector{Float64}[]
    sizehint!(coordseq, ncoords)
    for i = 1:ncoords
        push!(coordseq, getCoordinates(ptr, i, context))
    end
    coordseq
end

# -----
# Linear referencing functions -- there are more, but these are probably sufficient for most purposes
# -----
# (GEOSGeometry ownership is retained by caller)

# Return distance of point 'p' projected on 'g' from origin of 'g'. Geometry 'g' must be a lineal geometry
project(g::GEOSGeom, p::GEOSGeom, context::GEOSContext = _context) =
    GEOSProject_r(context.ptr, g, p)

# Return closest point to given distance within geometry (Geometry must be a LineString)
function interpolate(ptr::GEOSGeom, d::Real, context::GEOSContext = _context)
    result = GEOSInterpolate_r(context.ptr, ptr, d)
    if result == C_NULL
        error("LibGEOS: Error in GEOSInterpolate")
    end
    result
end

projectNormalized(g::GEOSGeom, p::GEOSGeom, context::GEOSContext = _context) =
    GEOSProjectNormalized_r(context.ptr, g, p)

function interpolateNormalized(ptr::GEOSGeom, d::Real, context::GEOSContext = _context)
    result = GEOSInterpolateNormalized_r(context.ptr, ptr, d)
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
buffer(ptr::GEOSGeom, width::Real, quadsegs::Integer = 8, context::GEOSContext = _context) =
    GEOSBuffer_r(context.ptr, ptr, width, Int32(quadsegs))

bufferWithStyle(
    ptr::GEOSGeom,
    width::Real,
    quadsegs::Integer = 8,
    endCapStyle::GEOSBufCapStyles = GEOSBUF_CAP_ROUND,
    joinStyle::GEOSBufJoinStyles = GEOSBUF_JOIN_ROUND,
    mitreLimit::Real = 5.0,
    context::GEOSContext = _context,
) = GEOSBufferWithStyle_r(
    context.ptr,
    ptr,
    width,
    Int32(quadsegs),
    Int32(endCapStyle),
    Int32(joinStyle),
    mitreLimit,
)

# GEOSBufferParams_create
# GEOSBufferParams_destroy
# GEOSBufferParams_setEndCapStyle
# GEOSBufferParams_setJoinStyle
# GEOSBufferParams_setMitreLimit
# GEOSBufferParams_setQuadrantSegments
# GEOSBufferParams_setSingleSided
# GEOSBufferWithParams
# GEOSOffsetCurve

# -----
# Geometry Constructors -- All functions return NULL on exception
# -----
# (GEOSCoordSequence* arguments will become ownership of the returned object.)

function createPoint(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    result = GEOSGeom_createPoint_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createPoint")
    end
    result
end
createPoint(x::Real, y::Real, context::GEOSContext = _context) =
    createPoint(createCoordSeq(x, y, context), context)
createPoint(x::Real, y::Real, z::Real, context::GEOSContext = _context) =
    createPoint(createCoordSeq(x, y, z, context), context)
createPoint(coords::Vector{Vector{Float64}}, context::GEOSContext = _context) =
    createPoint(createCoordSeq(coords, context), context)
createPoint(coords::Vector{Float64}, context::GEOSContext = _context) =
    createPoint(createCoordSeq(Vector{Float64}[coords], context), context)

function createLinearRing(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    result = GEOSGeom_createLinearRing_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createLinearRing")
    end
    result
end
createLinearRing(coords::Vector{Vector{Float64}}, context::GEOSContext = _context) =
    GEOSGeom_createLinearRing_r(context.ptr, createCoordSeq(coords, context))

function createLineString(ptr::GEOSCoordSeq, context::GEOSContext = _context)
    result = GEOSGeom_createLineString_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createLineString")
    end
    result
end
createLineString(coords::Vector{Vector{Float64}}, context::GEOSContext = _context) =
    GEOSGeom_createLineString_r(context.ptr, createCoordSeq(coords, context))

# Second argument is an array of GEOSGeometry* objects.
# The caller remains owner of the array, but pointed-to
# objects become ownership of the returned GEOSGeometry.
function createPolygon(
    shell::GEOSGeom,
    holes::Vector{GEOSGeom},
    context::GEOSContext = _context,
)
    result = GEOSGeom_createPolygon_r(context.ptr, shell, pointer(holes), length(holes))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createPolygon")
    end
    result
end

function createCollection(
    geomtype::GEOSGeomTypes,
    geoms::Vector{GEOSGeom},
    context::GEOSContext = _context,
)
    result =
        GEOSGeom_createCollection_r(context.ptr, geomtype, pointer(geoms), length(geoms))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createCollection")
    end
    result
end

function createEmptyCollection(geomtype::GEOSGeomTypes, context::GEOSContext = _context)
    result = GEOSGeom_createEmptyCollection_r(context.ptr, geomtype)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_createEmptyCollection")
    end
    result
end

# Memory management
function cloneGeom(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGeom_clone_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_clone")
    end
    result
end

destroyGeom(ptr::GEOSGeom, context::GEOSContext = _context) =
    GEOSGeom_destroy_r(context.ptr, ptr)

# -----
# Topology operations - return NULL on exception.
# -----

function envelope(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSEnvelope_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSEnvelope")
    end
    result
end


"""
    minimumRotatedRectangle(geom)

Returns the minimum rotated rectangular POLYGON which encloses the input geometry. The rectangle
has width equal to the minimum diameter, and a longer length. If the convex hill of the input is
degenerate (a line or point) a LINESTRING or POINT is returned. The minimum rotated rectangle can
be used as an extremely generalized representation for the given geometry.
"""
function minimumRotatedRectangle(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSMinimumRotatedRectangle_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSMinimumRotatedRectangle")
    end
    result
end


function intersection(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSIntersection_r(context.ptr, g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSIntersection")
    end
    result
end

# Returns a Geometry that represents the convex hull of the input geometry. The returned geometry contains the minimal number of points needed to represent the convex hull. In particular, no more than two consecutive points will be collinear.

# Returns:
# if the convex hull contains 3 or more points, a Polygon; 2 points, a LineString; 1 point, a Point; 0 points, an empty GeometryCollection.
function convexhull(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSConvexHull_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSConvexHull")
    end
    result
end

function difference(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSDifference_r(context.ptr, g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSDifference")
    end
    result
end

function symmetricDifference(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSSymDifference_r(context.ptr, g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSSymDifference")
    end
    result
end

function boundary(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSBoundary_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSBoundary")
    end
    result
end

function union(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSUnion_r(context.ptr, g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSUnion")
    end
    result
end

function unaryUnion(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSUnaryUnion_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSUnaryUnion")
    end
    result
end

function pointOnSurface(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSPointOnSurface_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSPointOnSurface")
    end
    result
end

function centroid(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGetCentroid_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetCentroid")
    end
    result
end

function node(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSNode_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSNode")
    end
    result
end

# all arguments remain ownership of the caller (both Geometries and pointers)
function polygonize(geoms::Vector{GEOSGeom}, context::GEOSContext = _context)
    result = GEOSPolygonize_r(context.ptr, pointer(geoms), length(geoms))
    if result == C_NULL
        error("LibGEOS: Error in GEOSPolygonize")
    end
    result
end
# GEOSPolygonizer_getCutEdges
# GEOSPolygonize_full

function lineMerge(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSLineMerge_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSLineMerge")
    end
    result
end

function simplify(ptr::GEOSGeom, tol::Real, context::GEOSContext = _context)
    result = GEOSSimplify_r(context.ptr, ptr, tol)
    if result == C_NULL
        error("LibGEOS: Error in GEOSSimplify")
    end
    result
end

function topologyPreserveSimplify(ptr::GEOSGeom, tol::Real, context::GEOSContext = _context)
    result = GEOSTopologyPreserveSimplify_r(context.ptr, ptr, tol)
    if result == C_NULL
        error("LibGEOS: Error in GEOSTopologyPreserveSimplify")
    end
    result
end

# Return all distinct vertices of input geometry as a MULTIPOINT.
# (Note that only 2 dimensions of the vertices are considered when testing for equality)
function uniquePoints(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGeom_extractUniquePoints_r(context.ptr, ptr)
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
function sharedPaths(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSSharedPaths_r(context.ptr, g1, g2)
    if result == C_NULL
        error("LibGEOS: Error in GEOSSharedPaths")
    end
    result
end

# Snap first geometry on to second with given tolerance
# (Returns a newly allocated geometry, or NULL on exception)
function snap(g1::GEOSGeom, g2::GEOSGeom, tol::Real, context::GEOSContext = _context)
    result = GEOSSnap_r(context.ptr, g1, g2, tol)
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
function delaunayTriangulation(
    ptr::GEOSGeom,
    tol::Real = 0.0,
    onlyEdges::Bool = false,
    context::GEOSContext = _context,
)
    result = GEOSDelaunayTriangulation_r(context.ptr, ptr, tol, Int32(onlyEdges))
    if result == C_NULL
        error("LibGEOS: Error in GEOSDelaunayTriangulation")
    end
    result
end

# -----
# Binary predicates - return 2 on exception, 1 on true, 0 on false
# -----
function disjoint(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSDisjoint_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSDisjoint")
    end
    result != 0x00
end

function touches(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSTouches_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSTouches")
    end
    result != 0x00
end

function intersects(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSIntersects_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSIntersects")
    end
    result != 0x00
end

function crosses(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSCrosses_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSCrosses")
    end
    result != 0x00
end

function within(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSWithin_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSWithin")
    end
    result != 0x00
end

function Base.contains(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSContains_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSContains")
    end
    result != 0x00
end

function overlaps(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSOverlaps_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSOverlaps")
    end
    result != 0x00
end

function equals(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSEquals_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSEquals")
    end
    result != 0x00
end

function equalsexact(g1::GEOSGeom, g2::GEOSGeom, tol::Real, context::GEOSContext = _context)
    result = GEOSEqualsExact_r(context.ptr, g1, g2, tol)
    if result == 0x02
        error("LibGEOS: Error in GEOSEqualsExact")
    end
    result != 0x00
end

function covers(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSCovers_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSCovers")
    end
    result != 0x00
end

function coveredby(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    result = GEOSCoveredBy_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSCoveredBy")
    end
    result != 0x00
end

# -----
# Prepared Geometry Binary predicates - return 2 on exception, 1 on true, 0 on false
# -----

# GEOSGeometry ownership is retained by caller
function prepareGeom(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSPrepare_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSPrepare")
    end
    result
end

destroyPreparedGeom(ptr::Ptr{GEOSPreparedGeometry}, context::GEOSContext = _context) =
    GEOSPreparedGeom_destroy_r(context.ptr, ptr)

function prepcontains(
    g1::Ptr{GEOSPreparedGeometry},
    g2::GEOSGeom,
    context::GEOSContext = _context,
)
    result = GEOSPreparedContains_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedContains")
    end
    result != 0x00
end

function prepcontainsproperly(
    g1::Ptr{GEOSPreparedGeometry},
    g2::GEOSGeom,
    context::GEOSContext = _context,
)
    result = GEOSPreparedContainsProperly_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedContainsProperly")
    end
    result != 0x00
end

function prepcoveredby(
    g1::Ptr{GEOSPreparedGeometry},
    g2::GEOSGeom,
    context::GEOSContext = _context,
)
    result = GEOSPreparedCoveredBy_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedCoveredBy")
    end
    result != 0x00
end

function prepcovers(
    g1::Ptr{GEOSPreparedGeometry},
    g2::GEOSGeom,
    context::GEOSContext = _context,
)
    result = GEOSPreparedCovers_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedCovers")
    end
    result != 0x00
end

function prepcrosses(
    g1::Ptr{GEOSPreparedGeometry},
    g2::GEOSGeom,
    context::GEOSContext = _context,
)
    result = GEOSPreparedCrosses_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedCrosses")
    end
    result != 0x00
end

function prepdisjoint(
    g1::Ptr{GEOSPreparedGeometry},
    g2::GEOSGeom,
    context::GEOSContext = _context,
)
    result = GEOSPreparedDisjoint_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedDisjoint")
    end
    result != 0x00
end

function prepintersects(
    g1::Ptr{GEOSPreparedGeometry},
    g2::GEOSGeom,
    context::GEOSContext = _context,
)
    result = GEOSPreparedIntersects_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedIntersects")
    end
    result != 0x00
end

function prepoverlaps(
    g1::Ptr{GEOSPreparedGeometry},
    g2::GEOSGeom,
    context::GEOSContext = _context,
)
    result = GEOSPreparedOverlaps_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedOverlaps")
    end
    result != 0x00
end

function preptouches(
    g1::Ptr{GEOSPreparedGeometry},
    g2::GEOSGeom,
    context::GEOSContext = _context,
)
    result = GEOSPreparedTouches_r(context.ptr, g1, g2)
    if result == 0x02
        error("LibGEOS: Error in GEOSPreparedTouches")
    end
    result != 0x00
end

function prepwithin(
    g1::Ptr{GEOSPreparedGeometry},
    g2::GEOSGeom,
    context::GEOSContext = _context,
)
    result = GEOSPreparedWithin_r(context.ptr, g1, g2)
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
function isEmpty(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSisEmpty_r(context.ptr, ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisEmpty")
    end
    result != 0x00
end

function isSimple(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSisSimple_r(context.ptr, ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisSimple")
    end
    result != 0x00
end

function isRing(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSisRing_r(context.ptr, ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSisRing")
    end
    result != 0x00
end

function hasZ(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSHasZ_r(context.ptr, ptr)
    if result == 0x02
        error("LibGEOS: Error in GEOSHasZ")
    end
    result != 0x00
end

# Call only on LINESTRING (return 2 on exception, 1 on true, 0 on false)
function isClosed(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSisClosed_r(context.ptr, ptr)
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

function isValid(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSisValid_r(context.ptr, ptr)
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
function geomTypeId(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGeomTypeId_r(context.ptr, ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGeomTypeId")
    end
    result
end

# Return 0 on exception
function getSRID(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGetSRID_r(context.ptr, ptr)
    if result == 0
        error("LibGEOS: Error in GEOSGeomTypeId")
    end
    result
end

setSRID(ptr::GEOSGeom, context::GEOSContext = _context) = GEOSSetSRID_r(context.ptr, ptr)

# May be called on all geometries in GEOS 3.x, returns -1 on error and 1
# for non-multi geometries. Older GEOS versions only accept
# GeometryCollections or Multi* geometries here, and are likely to crash
# when fed simple geometries, so beware if you need compatibility with
# old GEOS versions.
"""
    numGeometries(geom, context=_context)

Returns the number of sub-geometries immediately under a
multi-geometry or collection or 1 for a simple geometry.
For nested collections, remember to check if returned
sub-geometries are **themselves** also collections.
"""
function numGeometries(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGetNumGeometries_r(context.ptr, ptr)
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
"""
    getGeometry(geom, n)

Returns a copy of the specified sub-geometry of a collection.
Numbering in one-based
For a simple geometry, returns a copy of the input.
"""
function getGeometry(ptr::GEOSGeom, n::Integer, context::GEOSContext = _context)
    n in 1:numGeometries(ptr, context) || error(
        "GEOSGetGeometryN: $(numGeometries(ptr, context)) sub-geometries in geom, therefore n should be in 1:$(numGeometries(ptr, context))",
    )
    result = GEOSGetGeometryN_r(context.ptr, ptr, n - 1)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetGeometryN")
    end
    cloneGeom(result, context)
end

"""
    getGeometries(geom)

Returns a vector of copy of the sub-geometries of a collection.
For a simple geometry, returns the geometry in a vector of length one.
"""
getGeometries(ptr::GEOSGeom, context::GEOSContext = _context) =
    GEOSGeom[getGeometry(ptr, i, context) for i = 1:numGeometries(ptr, context)]

# Converts Geometry to normal form (or canonical form).
# Return -1 on exception, 0 otherwise.
function normalize!(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSNormalize_r(context.ptr, ptr)
    if result == -1
        error("LibGEOS: Error in GEOSNormalize")
    end
    result
end

# Return -1 on exception
function numInteriorRings(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGetNumInteriorRings_r(context.ptr, ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGetNumInteriorRings")
    end
    result
end

# Call only on LINESTRING (returns -1 on exception)
function numPoints(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGeomGetNumPoints_r(context.ptr, ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGeomGetNumPoints")
    end
    result
end

# Return -1 on exception, Geometry must be a Point.
function getGeomX(ptr::GEOSGeom, context::GEOSContext = _context)
    out = Ref{Float64}()
    result = GEOSGeomGetX_r(context.ptr, ptr, out)
    if result == -1
        error("LibGEOS: Error in GEOSGeomGetX")
    end
    out[]
end

function getGeomY(ptr::GEOSGeom, context::GEOSContext = _context)
    out = Ref{Float64}()
    result = GEOSGeomGetY_r(context.ptr, ptr, out)
    if result == -1
        error("LibGEOS: Error in GEOSGeomGetY")
    end
    out[]
end

# Return NULL on exception, Geometry must be a Polygon.
# Returned object is a pointer to internal storage: it must NOT be destroyed directly.
function interiorRing(ptr::GEOSGeom, n::Integer, context::GEOSContext = _context)
    result = GEOSGetInteriorRingN_r(context.ptr, ptr, n - 1)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetInteriorRingN")
    end
    cloneGeom(result, context)
end

function interiorRings(ptr::GEOSGeom, context::GEOSContext = _context)
    n = numInteriorRings(ptr, context)
    if n == 0
        return GEOSGeom[]
    else
        return GEOSGeom[interiorRing(ptr, i, context) for i = 1:n]
    end
end

# Return NULL on exception, Geometry must be a Polygon.
# Returned object is a pointer to internal storage: it must NOT be destroyed directly.
function exteriorRing(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGetExteriorRing_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGetExteriorRing")
    end
    cloneGeom(result, context)
end

# Return -1 on exception
function numCoordinates(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGetNumCoordinates_r(context.ptr, ptr)
    if result == -1
        error("LibGEOS: Error in GEOSGetNumCoordinates")
    end
    result
end

# Geometry must be a LineString, LinearRing or Point (Return NULL on exception)
function getCoordSeq(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGeom_getCoordSeq_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_getCoordSeq")
    end
    result
end
# getGeomCoordinates(ptr::GEOSGeom) = getCoordinates(getCoordSeq(ptr))

# Return 0 on exception (or empty geometry)
getGeomDimensions(ptr::GEOSGeom, context::GEOSContext = _context) =
    GEOSGeom_getDimensions_r(context.ptr, ptr)

# Return 2 or 3.
getCoordinateDimension(ptr::GEOSGeom, context::GEOSContext = _context) =
    GEOSGeom_getCoordinateDimension_r(context.ptr, ptr)

"""
    getXMin(geom, context=_context)

Finds the minimum X value in the geometry
"""
function getXMin(ptr::GEOSGeom, context::GEOSContext = _context)
    out = Ref{Float64}()
    result = GEOSGeom_getXMin_r(context.ptr, ptr, out)
    if result == 0
        error("LibGEOS: Error in GEOSGeom_getXMin_r")
    end
    return out[]
end

"""
    getYMin(geom, context=_context)

Finds the minimum Y value in the geometry
"""
function getYMin(ptr::GEOSGeom, context::GEOSContext = _context)
    out = Ref{Float64}()
    result = GEOSGeom_getYMin_r(context.ptr, ptr, out)
    if result == 0
        error("LibGEOS: Error in GEOSGeom_getYMin_r")
    end
    return out[]
end

"""
    getXMax(geom, context=_context)

Finds the maximum X value in the geometry
"""
function getXMax(ptr::GEOSGeom, context::GEOSContext = _context)
    out = Ref{Float64}()
    result = GEOSGeom_getXMax_r(context.ptr, ptr, out)
    if result == 0
        error("LibGEOS: Error in GEOSGeom_getXMax_r")
    end
    return out[]
end

"""
    getYMax(geom, context=_context)

Finds the maximum Y value in the geometry
"""
function getYMax(ptr::GEOSGeom, context::GEOSContext = _context)
    out = Ref{Float64}()
    result = GEOSGeom_getYMax_r(context.ptr, ptr, out)
    if result == 0
        error("LibGEOS: Error in GEOSGeom_getYMax_r")
    end
    return out[]
end


# TODO 02/2022: wait for libgeos release beyond 3.10.2 which will in include GEOSGeom_getExtent_r
# # Finds the extent (minimum and maximum X and Y value) of the geometry
# function getExtent(ptr::GEOSGeom, context::GEOSContext = _context)
#     out = Vector{Float64}(undef, 4)
#     result = GEOSGeom_getExtent_r(context.ptr, ptr, Ref(out, 1), Ref(out, 2), Ref(out, 3), Ref(out, 4))
#     if result == 0
#         error("LibGEOS: Error in GEOSGeom_getExtent_r")
#     end
#     return out
# end

# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
function getPoint(ptr::GEOSGeom, n::Integer, context::GEOSContext = _context)
    result = GEOSGeomGetPointN_r(context.ptr, ptr, n - 1)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomGetPointN")
    end
    result
end

# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
function startPoint(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGeomGetStartPoint_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomGetStartPoint")
    end
    result
end

# Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
function endPoint(ptr::GEOSGeom, context::GEOSContext = _context)
    result = GEOSGeomGetEndPoint_r(context.ptr, ptr)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomGetEndPoint")
    end
    result
end

# -----
# Misc functions
# -----
function geomArea(ptr::GEOSGeom, context::GEOSContext = _context)
    out = Ref{Float64}()
    # Return 0 on exception, 1 otherwise
    result = GEOSArea_r(context.ptr, ptr, out)
    if result == 0
        error("LibGEOS: Error in GEOSArea")
    end
    out[]
end

function geomLength(ptr::GEOSGeom, context::GEOSContext = _context)
    out = Ref{Float64}()
    # Return 0 on exception, 1 otherwise
    result = GEOSLength_r(context.ptr, ptr, out)
    if result == 0
        error("LibGEOS: Error in GEOSLength")
    end
    out[]
end

function geomDistance(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    out = Ref{Float64}()
    # Return 0 on exception, 1 otherwise
    result = GEOSDistance_r(context.ptr, g1, g2, out)
    if result == 0
        error("LibGEOS: Error in GEOSDistance")
    end
    out[]
end

function hausdorffdistance(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context)
    out = Ref{Float64}()
    # Return 0 on exception, 1 otherwise
    result = GEOSHausdorffDistance_r(context.ptr, g1, g2, out)
    if result == 0
        error("LibGEOS: Error in GEOSHausdorffDistance")
    end
    out[]
end

function hausdorffdistance(
    g1::GEOSGeom,
    g2::GEOSGeom,
    densifyFrac::Real,
    context::GEOSContext = _context,
)
    out = Ref{Float64}()
    # Return 0 on exception, 1 otherwise
    result = GEOSHausdorffDistanceDensify_r(context.ptr, g1, g2, densifyFrac, out)
    if result == 0
        error("LibGEOS: Error in GEOSHausdorffDistanceDensify")
    end
    out[]
end

# Return 0 on exception, the closest points of the two geometries otherwise.
# The first point comes from g1 geometry and the second point comes from g2.
nearestPoints(g1::GEOSGeom, g2::GEOSGeom, context::GEOSContext = _context) =
    GEOSNearestPoints_r(context.ptr, g1, g2)

# -----
# Precision functions
# -----

"""
    getPrecision(geom)

Return the size of the geometry's precision grid, 0 for FLOATING precision.
"""
function getPrecision(geom::GEOSGeom, context::GEOSContext = _context)
    GEOSGeom_getPrecision_r(context.ptr, geom)
end

"""
    setPrecision(geom, gridSize; flags = GEOS_PREC_VALID_OUTPUT)

Change the rounding precision on a geometry. This will affect the precision of the existing geometry as well as any geometries derived from this geometry using overlay functions. The output will be a valid GEOSGeometry.

Note that operations will always be performed in the precision of the geometry with higher precision (smaller "gridSize"). That same precision will be attached to the operation outputs.

In the Default and `GEOS_PREC_KEEP_COLLAPSED` modes invalid input may cause an error to occur, unless the invalidity is below the scale of the requested precision

There are only 3 modes. The `GEOS_PREC_NO_TOPO` mode takes precedence over `GEOS_PREC_KEEP_COLLAPSED`. So the combination `GEOS_PREC_NO_TOPO || GEOS_PREC_KEEP_COLLAPSED` has the same semantics as `GEOS_PREC_NO_TOPO`

# Parameters
* `g`	Input geometry
* `gridSize`	cell size of grid to round coordinates to, or 0 for FLOATING precision
* `flags`	The bitwise OR of members of the `GEOSPrecisionRules` enum

# Returns
The precision reduced result. Caller must free with `GEOSGeom_destroy()` NULL on exception.

"""
function setPrecision(
    geom::GEOSGeom,
    gridSize::Real,
    flags::GEOSPrecisionRules,
    context::GEOSContext = _context,
)
    result = geomFromGEOS(GEOSGeom_setPrecision_r(context.ptr, geom, gridSize, flags))
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeom_setPrecision_r")
    end
    result
end
@eval function setPrecision(
    geom::GEOSGeom,
    gridSize::Real,
    flags::Int,
    context::GEOSContext = _context,
)
    !(flags in $(Int.(instances(GEOSPrecisionRules)))) && error(
        "flags value should be in $(Int.(instances(GEOSPrecisionRules))) or use GEOSPrecisionRules enum members",
    )
    return setPrecision(geom, gridSize, GEOSPrecisionRules(flags), context)
end
