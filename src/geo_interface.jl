GeoInterface.isgeometry(::Type{<:AbstractGeometry}) = true

geointerface_geomtype(::PointTrait) = Point
geointerface_geomtype(::MultiPointTrait) = MultiPoint
geointerface_geomtype(::LineStringTrait) = LineString
geointerface_geomtype(::MultiLineStringTrait) = MultiLineString
geointerface_geomtype(::LinearRingTrait) = LinearRing
geointerface_geomtype(::PolygonTrait) = Polygon
geointerface_geomtype(::MultiPolygonTrait) = MultiPolygon
geointerface_geomtype(::GeometryCollectionTrait) = GeometryCollection
geointerface_geomtype(::CircularStringTrait) = CircularString
geointerface_geomtype(::CompoundCurveTrait) = CompoundCurve
geointerface_geomtype(::CurvePolygonTrait) = CurvePolygon
geointerface_geomtype(::MultiSurfaceTrait) = MultiSurface
geointerface_geomtype(::MultiCurveTrait) = MultiCurve

GeoInterface.geomtrait(::Point) = PointTrait()
GeoInterface.geomtrait(::MultiPoint) = MultiPointTrait()
GeoInterface.geomtrait(::LineString) = LineStringTrait()
GeoInterface.geomtrait(::MultiLineString) = MultiLineStringTrait()
GeoInterface.geomtrait(::LinearRing) = LinearRingTrait()
GeoInterface.geomtrait(::Polygon) = PolygonTrait()
GeoInterface.geomtrait(::MultiPolygon) = MultiPolygonTrait()
GeoInterface.geomtrait(::GeometryCollection) = GeometryCollectionTrait()
GeoInterface.geomtrait(::CircularString) = CircularStringTrait()
GeoInterface.geomtrait(::CompoundCurve) = CompoundCurveTrait()
GeoInterface.geomtrait(::CurvePolygon) = CurvePolygonTrait()
GeoInterface.geomtrait(::MultiSurface) = MultiSurfaceTrait()
GeoInterface.geomtrait(::MultiCurve) = MultiCurveTrait()
GeoInterface.geomtrait(geom::PreparedGeometry) = GeoInterface.geomtrait(geom.ownedby)

GeoInterface.isempty(::AbstractGeometryTrait, geom::AbstractGeometry) = isEmpty(geom)

GeoInterface.ngeom(::AbstractGeometryCollectionTrait, geom::AbstractMultiGeometry) =
    isEmpty(geom) ? 0 : Int(numGeometries(geom))
GeoInterface.ngeom(::LineStringTrait, geom::LineString) = Int(numPoints(geom))
GeoInterface.ngeom(::CircularStringTrait, geom::CircularString) = Int(numPoints(geom))
GeoInterface.ngeom(::LinearRingTrait, geom::LinearRing) = Int(numPoints(geom))
GeoInterface.ngeom(::PolygonTrait, geom::Polygon) = Int(numInteriorRings(geom)) + 1
GeoInterface.ngeom(::CurvePolygonTrait, geom::CurvePolygon) =
    Int(numInteriorRings(geom)) + 1
GeoInterface.ngeom(t::AbstractGeometryTrait, geom::PreparedGeometry) =
    GeoInterface.ngeom(t, geom.ownedby)
GeoInterface.ngeom(::AbstractPointTrait, geom::Point) = 0
GeoInterface.ngeom(::AbstractPointTrait, geom::PreparedGeometry) = 0

GI.is3d(::AbstractGeometryTrait, geom::AbstractGeometry) = hasZ(geom)
GI.getexterior(::AbstractPolygonTrait, geom::Union{Polygon,CurvePolygon}) =
    exteriorRing(geom)
GI.gethole(::AbstractPolygonTrait, geom::Union{Polygon,CurvePolygon}, n) =
    interiorRing(geom, n)
GI.ismeasured(::AbstractGeometryTrait, geom::AbstractGeometry) = hasM(geom)
function GI.coordnames(::AbstractGeometryTrait, geom::AbstractGeometry)
    if hasZ(geom)
        return hasM(geom) ? (:X, :Y, :Z, :M) : (:X, :Y, :Z)
    else
        return hasM(geom) ? (:X, :Y, :M) : (:X, :Y)
    end
end

function GeoInterface.getgeom(
    ::AbstractGeometryCollectionTrait,
    geom::AbstractMultiGeometry,
    i,
)
    getGeometry(geom, i)
end
GeoInterface.getgeom(::MultiPointTrait, geom::MultiPoint, i) = getGeometry(geom, i)::Point
GeoInterface.getgeom(::MultiLineStringTrait, geom::MultiLineString, i) =
    getGeometry(geom, i)::LineString
GeoInterface.getgeom(::MultiPolygonTrait, geom::MultiPolygon, i) =
    getGeometry(geom, i)::Polygon
GeoInterface.getgeom(
    ::Union{LineStringTrait,LinearRingTrait},
    geom::Union{LineString,LinearRing},
    i,
) = getPoint(geom, i)
GeoInterface.getgeom(t::AbstractPointTrait, geom::PreparedGeometry) = nothing
function GeoInterface.getgeom(::PolygonTrait, geom::Polygon, i::Int)
    if i == 1
        exteriorRing(geom)
    else
        interiorRing(geom, i - 1)
    end
end
function GeoInterface.getgeom(::CurvePolygonTrait, geom::CurvePolygon, i::Int)
    if i == 1
        exteriorRing(geom)
    else
        interiorRing(geom, i - 1)
    end
end
GeoInterface.getgeom(t::AbstractGeometryTrait, geom::PreparedGeometry, i) =
    GeoInterface.getgeom(t, geom.ownedby, i)
GeoInterface.getgeom(t::AbstractPointTrait, geom::PreparedGeometry, i) = 0

GeoInterface.coordinates(t::AbstractPointTrait, geom::Point) = collect(getcoord(t, geom))
GeoInterface.coordinates(t::AbstractPointTrait, geom::AbstractGeometry) = nothing
GeoInterface.coordinates(t::AbstractGeometryTrait, geom::AbstractGeometry) =
    [GeoInterface.coordinates(x) for x in getgeom(t, geom)]
GeoInterface.coordinates(t::AbstractGeometryCollectionTrait, geom::AbstractMultiGeometry) =
    [GeoInterface.coordinates(x) for x in getgeom(t, geom)]
# Copy all coordinates in one call, rather than through a Point for each vertex
function GeoInterface.coordinates(
    ::Union{LineStringTrait,LinearRingTrait},
    geom::Union{LineString,LinearRing},
)
    context = get_context(geom)
    coords = GC.@preserve geom begin
        seq = getCoordSeq(geom, context)
        n = getSize(seq, context)
        ndim = getDimensions(seq, context)
        hasz = GEOSCoordSeq_hasZ_r(context, seq) == 1
        hasm = GEOSCoordSeq_hasM_r(context, seq) == 1
        buffer = Vector{Float64}(undef, ndim * n)
        GEOSCoordSeq_copyToBuffer_r(context, seq, buffer, hasz, hasm)
        reshape(buffer, ndim, n)
    end
    return [coords[:, i] for i = 1:size(coords, 2)]
end

GeoInterface.ncoord(::AbstractGeometryTrait, geom::AbstractGeometry) =
    isEmpty(geom) ? 0 : Int(getCoordinateDimension(geom))
GeoInterface.ncoord(t::AbstractGeometryTrait, geom::PreparedGeometry) =
    GeoInterface.ncoord(t, geom.ownedby)

# Read one ordinate of the point, rather than all of its coordinate sequence
function GeoInterface.getcoord(::AbstractPointTrait, geom::Point, i)
    context = get_context(geom)
    i == 1 && return getGeomX(geom, context)
    i == 2 && return getGeomY(geom, context)
    hasz = hasZ(geom, context)
    i == 3 && hasz && return getGeomZ(geom, context)
    # M is the last ordinate
    i == 3 + hasz && GEOSHasM_r(context, geom) == 0x01 && return getGeomM(geom, context)
    throw(BoundsError(geom, i))
end
GeoInterface.getcoord(t::AbstractPointTrait, geom::PreparedGeometry, i) =
    GeoInterface.getcoord(t, geom.ownedby, i)

GeoInterface.x(::AbstractPointTrait, point::AbstractGeometry) = getGeomX(point)
GeoInterface.y(::AbstractPointTrait, point::AbstractGeometry) = getGeomY(point)
GeoInterface.z(::AbstractPointTrait, point::AbstractGeometry) = getGeomZ(point)

# FIXME this doesn't work for 3d geoms, Z is missing
function GeoInterface.extent(::AbstractGeometryTrait, geom::AbstractGeometry)
    # minx, miny, maxx, maxy = getExtent(geom)
    env = envelope(geom)
    return Extent(; X = (getXMin(env), getXMax(env)), Y = (getYMin(env), getYMax(env)))
end

GI.convert(::Type{Point}, ::PointTrait, geom::Point; context = nothing) = geom
function GI.convert(::Type{Point}, ::PointTrait, geom; context = get_global_context())
    seq = _coord_seq((geom,), 1, GI.is3d(geom), GI.ismeasured(geom), context)
    return Point(createPoint(seq, context), context)
end
# Parent geometries are built from their converted parts with `_convert_part` and
# `_take_ptr`. Copying the parts into the parent instead would leave them to the
# garbage collector, which doesn't see GEOS memory. All parts are converted before
# any pointer is taken, so if a part fails to convert, the others are still freed.

# Convert `geom` to a new LibGEOS `T`, cloning it if it already is one.
function _convert_part(T, trait, geom, context)
    converted = GI.convert(T, trait, geom; context)
    return converted === geom ? T(cloneGeom(geom, context), context) : converted
end

# Take the pointer of a converted part, which the parent geometry takes over.
function _take_ptr(part)
    ptr = part.ptr
    part.ptr = C_NULL  # so that its finalizer doesn't free the part
    return ptr
end

GI.convert(::Type{MultiPoint}, ::MultiPointTrait, geom::MultiPoint; context = nothing) =
    geom
function GI.convert(
    ::Type{MultiPoint},
    t::MultiPointTrait,
    geom;
    context = get_global_context(),
)
    points = [_convert_part(Point, PointTrait(), p, context) for p in GI.getpoint(t, geom)]
    ptrs = GEOSGeom[_take_ptr(p) for p in points]
    return MultiPoint(createCollection(GEOS_MULTIPOINT, ptrs, context), context)
end
GI.convert(::Type{LineString}, ::LineStringTrait, geom::LineString; context = nothing) =
    geom
function GI.convert(
    ::Type{LineString},
    ::LineStringTrait,
    geom;
    context = get_global_context(),
)
    # Faster to make a CoordSeq directly here
    seq = _geom_to_coord_seq(geom, context)
    return LineString(createLineString(seq, context), context)
end
GI.convert(::Type{LinearRing}, ::LinearRingTrait, geom::LinearRing; context = nothing) =
    geom
function GI.convert(
    ::Type{LinearRing},
    ::LinearRingTrait,
    geom;
    context = get_global_context(),
)
    # Faster to make a CoordSeq directly here
    seq = _geom_to_coord_seq(geom, context)
    return LinearRing(createLinearRing(seq, context), context)
end
GI.convert(
    ::Type{MultiLineString},
    ::MultiLineStringTrait,
    geom::MultiLineString;
    context = nothing,
) = geom
function GI.convert(
    ::Type{MultiLineString},
    ::MultiLineStringTrait,
    geom;
    context = get_global_context(),
)
    linestrings =
        [_convert_part(LineString, LineStringTrait(), g, context) for g in getgeom(geom)]
    ptrs = GEOSGeom[_take_ptr(g) for g in linestrings]
    return MultiLineString(createCollection(GEOS_MULTILINESTRING, ptrs, context), context)
end
GI.convert(::Type{Polygon}, ::PolygonTrait, geom::Polygon; context = nothing) = geom
function GI.convert(::Type{Polygon}, ::PolygonTrait, geom; context = get_global_context())
    exterior = _convert_part(LinearRing, LinearRingTrait(), GI.getexterior(geom), context)
    holes =
        [_convert_part(LinearRing, LinearRingTrait(), g, context) for g in GI.gethole(geom)]
    ptrs = GEOSGeom[_take_ptr(g) for g in holes]
    return Polygon(createPolygon(_take_ptr(exterior), ptrs, context), context)
end
GI.convert(
    ::Type{MultiPolygon},
    ::MultiPolygonTrait,
    geom::MultiPolygon;
    context = nothing,
) = geom
function GI.convert(
    ::Type{MultiPolygon},
    ::MultiPolygonTrait,
    geom;
    context = get_global_context(),
)
    polygons =
        [_convert_part(Polygon, PolygonTrait(), g, context) for g in GI.getgeom(geom)]
    ptrs = GEOSGeom[_take_ptr(g) for g in polygons]
    return MultiPolygon(createCollection(GEOS_MULTIPOLYGON, ptrs, context), context)
end
GI.convert(
    ::Type{GeometryCollection},
    ::GeometryCollectionTrait,
    geom::GeometryCollection;
    context = nothing,
) = geom
function GI.convert(
    ::Type{GeometryCollection},
    ::GeometryCollectionTrait,
    geom;
    context = get_global_context(),
)
    geometries = [
        _convert_part(geointerface_geomtype(GI.trait(g)), GI.trait(g), g, context) for
        g in GI.getgeom(geom)
    ]
    ptrs = GEOSGeom[_take_ptr(g) for g in geometries]
    return GeometryCollection(
        createCollection(GEOS_GEOMETRYCOLLECTION, ptrs, context),
        context,
    )
end

function GI.convert(
    t::Type{<:AbstractGeometry},
    tr::AbstractGeometryTrait,
    geom;
    context = nothing,
)
    error(
        "Cannot convert an object of $(typeof(geom)) with the $(typeof(tr)) trait to a $t (yet). Please report an issue.",
    )
end

# Collect the coordinates of `points` and copy them to GEOS in one call
function _coord_seq(points, npoint, hasz, hasm, context)
    ndim = 2 + hasz + hasm
    coords = Vector{Float64}(undef, ndim * npoint)
    i = 0
    for p in points
        coords[i+1] = GI.x(p)
        coords[i+2] = GI.y(p)
        hasz && (coords[i+3] = GI.z(p))
        hasm && (coords[i+ndim] = GI.m(p))
        i += ndim
    end
    seq = GEOSCoordSeq_copyFromBuffer_r(context, coords, i ÷ ndim, hasz, hasm)
    if seq == C_NULL
        error("LibGEOS: Error in GEOSCoordSeq_copyFromBuffer")
    end
    return seq
end
function _geom_to_coord_seq(geom, context)
    npoint = GI.npoint(geom)
    # Keep M only if the points have it.
    # ArchGDAL lines are measured, but their points aren't.
    hasm = GI.ismeasured(geom) && npoint > 0 && GI.ismeasured(GI.getpoint(geom, 1))
    return _coord_seq(GI.getpoint(geom), npoint, GI.is3d(geom), hasm, context)
end

GeoInterface.distance(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = distance(a, b)
GeoInterface.buffer(::AbstractGeometryTrait, geom::AbstractGeometry, distance) =
    buffer(geom, distance)
GeoInterface.convexhull(::AbstractGeometryTrait, geom::AbstractGeometry) = convexhull(geom)

GeoInterface.equals(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = equals(a, b)
GeoInterface.disjoint(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = disjoint(a, b)
GeoInterface.intersects(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = intersects(a, b)
GeoInterface.touches(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = touches(a, b)
GeoInterface.within(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = within(a, b)
GeoInterface.contains(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = contains(a, b)
GeoInterface.overlaps(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = overlaps(a, b)
GeoInterface.crosses(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = crosses(a, b)
# GeoInterface.relate(::AbstractGeometryTrait, ::AbstractGeometryTrait, a, b, relationmatrix) = relate(a, b)  # not yet implemented

GeoInterface.symdifference(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = symmetricDifference(a, b)
GeoInterface.difference(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = difference(a, b)
GeoInterface.intersection(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = intersection(a, b)
GeoInterface.union(
    ::AbstractGeometryTrait,
    ::AbstractGeometryTrait,
    a::AbstractGeometry,
    b::AbstractGeometry,
) = union(a, b)

# -----
# LibGeos operations for any GeoInterface.jl compatible geometries
# -----

# Internal convert method that avoids the overhead of `convert(LibGEOS, geom)`
to_geos(geom) = to_geos(GI.geomtrait(geom), geom)
to_geos(trait, geom) = GI.convert(geointerface_geomtype(trait), trait, geom)

# These methods are all the same with 1 or two geometries, some arguments, and maybe keywords.
# We define them with `@eval` to avoid all the boilerplate code.

# Convert `geom` for one call of `f`, and free the converted geometry when it returns,
# rather than leaving it to the garbage collector, which doesn't see GEOS memory.
# `destroyGeom` sets the pointer to C_NULL, so the finalizer does nothing later.
# Don't use `finalize` here: it searches the list of all finalizers, so each call
# would take time proportional to the number of live geometries.
function with_geos(f, geom)
    converted = to_geos(geom)
    try
        return f(converted)
    finally
        converted === geom || destroyGeom(converted)
    end
end

buffer(obj, dist::Real, args...; kw...) =
    with_geos(g -> buffer(g, dist, args...; kw...), obj)
bufferWithStyle(obj, dist::Real; kw...) =
    with_geos(g -> bufferWithStyle(g, dist; kw...), obj)

# 1 geom methods
for f in (
    :area,
    :geomLength,
    :envelope,
    :minimumRotatedRectangle,
    :convexhull,
    :boundary,
    :unaryUnion,
    :pointOnSurface,
    :centroid,
    :node,
    :simplify,
    :topologyPreserveSimplify,
    :uniquePoints,
    :delaunayTriangulationEdges,
    :delaunayTriangulation,
    :constrainedDelaunayTriangulation,
)
    # We convert the geometry to a GEOS geometry and forward it to the geos method
    @eval $f(geom, args...; kw...) = with_geos(g -> $f(g, args...; kw...), geom)
    @eval $f(geom::AbstractGeometry, args...; kw...) =
        throw(MethodError($f, (geom, args...)))
end

# Concave hulls accept a context keyword, including for input conversion.
for f in (:concavehull, :concavehull_of_polygons)
    @eval function $f(geom, args...; context::GEOSContext = get_global_context(), kw...)
        trait = GI.geomtrait(geom)
        obj = GI.convert(geointerface_geomtype(trait), trait, geom; context)
        try
            return $f(obj, args...; context, kw...)
        finally
            # the hull is a new geometry, so free the converted input now,
            # unless it is the caller's own geometry
            obj === geom || destroyGeom(obj, context)
        end
    end
    @eval $f(geom::AbstractGeometry, args...; kw...) =
        throw(MethodError($f, (geom, args...)))
end

# 2 geom methods
for f in (
    :project,
    :projectNormalized,
    :intersection,
    :difference,
    :symmetricDifference,
    :union,
    :sharedPaths,
    :snap,
    :distance,
    :hausdorffdistance,
    :nearestPoints,
    :disjoint,
    :touches,
    :intersects,
    :crosses,
    :within,
    :contains,
    :overlaps,
    :equalsexact,
    :covers,
    :coveredby,
    :equals,
)
    # We convert the geometries to GEOS geometries and forward them to the geos method
    @eval $f(geom1, geom2, args...; kw...) =
        with_geos(g1 -> with_geos(g2 -> $f(g1, g2, args...; kw...), geom2), geom1)
    @eval $f(geom1::AbstractGeometry, geom2::AbstractGeometry, args...; kw...) =
        throw(MethodError($f, (geom1, geom2, args...)))
end

# LibGEOS always uses Float64 for coordinates
GeoInterface.coordtype(::GeoInterface.AbstractGeometryTrait, ::AbstractGeometry) = Float64
GeoInterface.coordtype(::GeoInterface.PointTrait, ::AbstractGeometry) = Float64
