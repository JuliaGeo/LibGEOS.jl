GeoInterface.isgeometry(::Type{<:AbstractGeometry}) = true

geointerface_geomtype(::PointTrait) = Point
geointerface_geomtype(::MultiPointTrait) = MultiPoint
geointerface_geomtype(::LineStringTrait) = LineString
geointerface_geomtype(::MultiLineStringTrait) = MultiLineString
geointerface_geomtype(::LinearRingTrait) = LinearRing
geointerface_geomtype(::PolygonTrait) = Polygon
geointerface_geomtype(::MultiPolygonTrait) = MultiPolygon
geointerface_geomtype(::GeometryCollectionTrait) = GeometryCollection

GeoInterface.geomtrait(::Point) = PointTrait()
GeoInterface.geomtrait(::MultiPoint) = MultiPointTrait()
GeoInterface.geomtrait(::LineString) = LineStringTrait()
GeoInterface.geomtrait(::MultiLineString) = MultiLineStringTrait()
GeoInterface.geomtrait(::LinearRing) = LinearRingTrait()
GeoInterface.geomtrait(::Polygon) = PolygonTrait()
GeoInterface.geomtrait(::MultiPolygon) = MultiPolygonTrait()
GeoInterface.geomtrait(::GeometryCollection) = GeometryCollectionTrait()
GeoInterface.geomtrait(geom::PreparedGeometry) = GeoInterface.geomtrait(geom.ownedby)

GeoInterface.isempty(::AbstractGeometryTrait, geom::AbstractGeometry) = isEmpty(geom)

GeoInterface.ngeom(::AbstractGeometryCollectionTrait, geom::AbstractMultiGeometry) =
    isEmpty(geom) ? 0 : Int(numGeometries(geom))
GeoInterface.ngeom(::LineStringTrait, geom::LineString) = Int(numPoints(geom))
GeoInterface.ngeom(::LinearRingTrait, geom::LinearRing) = Int(numPoints(geom))
GeoInterface.ngeom(::PolygonTrait, geom::Polygon) = Int(numInteriorRings(geom)) + 1
GeoInterface.ngeom(t::AbstractGeometryTrait, geom::PreparedGeometry) =
    GeoInterface.ngeom(t, geom.ownedby)
GeoInterface.ngeom(::AbstractPointTrait, geom::Point) = 0
GeoInterface.ngeom(::AbstractPointTrait, geom::PreparedGeometry) = 0

GI.is3d(::AbstractGeometryTrait, geom::AbstractGeometry) = hasZ(geom)
# Z and M are independent: a three-coordinate geometry can be XYZ or XYM.
GI.ismeasured(::AbstractGeometryTrait, geom::AbstractGeometry) = hasM(geom)
function GI.coordnames(::AbstractGeometryTrait, geom::AbstractGeometry)
    if hasZ(geom)
        return hasM(geom) ? (:X, :Y, :Z, :M) : (:X, :Y, :Z)
    else
        return hasM(geom) ? (:X, :Y, :M) : (:X, :Y)
    end
end
GI.getexterior(::AbstractPolygonTrait, geom::Polygon) = exteriorRing(geom)
GI.gethole(::AbstractPolygonTrait, geom::Polygon, n) = interiorRing(geom, n)

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
# A value point owns its ordinates, so it can outlive the source geometry.
# Runtime flags keep reads inferable even though GEOS dimensions are not in the type.
struct CoordinatePoint
    ordinates::NTuple{4,Float64}
    hasz::Bool
    hasm::Bool
end
GI.isgeometry(::Type{CoordinatePoint}) = true
GI.geomtrait(::CoordinatePoint) = PointTrait()
GI.ncoord(::PointTrait, p::CoordinatePoint) = 2 + p.hasz + p.hasm
GI.is3d(::PointTrait, p::CoordinatePoint) = p.hasz
GI.ismeasured(::PointTrait, p::CoordinatePoint) = p.hasm
GI.coordnames(::PointTrait, p::CoordinatePoint) =
    p.hasz ? (p.hasm ? (:X, :Y, :Z, :M) : (:X, :Y, :Z)) :
    (p.hasm ? (:X, :Y, :M) : (:X, :Y))
GI.coordtype(::PointTrait, ::CoordinatePoint) = Float64
function GI.getcoord(::PointTrait, p::CoordinatePoint, i::Integer)
    1 <= i <= GI.ncoord(p) || throw(BoundsError(p, i))
    return p.ordinates[i == 3 && !p.hasz ? 4 : i]
end
GI.x(::PointTrait, p::CoordinatePoint) = p.ordinates[1]
GI.y(::PointTrait, p::CoordinatePoint) = p.ordinates[2]
GI.z(::PointTrait, p::CoordinatePoint) = p.ordinates[3]
GI.m(::PointTrait, p::CoordinatePoint) = p.ordinates[4]
GI.coordinates(::PointTrait, p::CoordinatePoint) =
    [GI.getcoord(p, i) for i in 1:GI.ncoord(p)]
getGeomX(p::CoordinatePoint, ::GEOSContext = get_global_context()) = GI.x(p)
getGeomY(p::CoordinatePoint, ::GEOSContext = get_global_context()) = GI.y(p)
getGeomZ(p::CoordinatePoint, ::GEOSContext = get_global_context()) = GI.z(p)

function Point(p::CoordinatePoint, context::GEOSContext = get_global_context())
    coords = GI.coordinates(p)
    seq = GEOSCoordSeq_copyFromBuffer_r(context, coords, 1, p.hasz, p.hasm)
    seq == C_NULL && error("LibGEOS: Error creating point coordinate sequence")
    return Point(createPoint(seq, context), context)
end
GI.convert(::Type{Point}, ::PointTrait, p::CoordinatePoint; context = get_global_context()) =
    Point(p, context)

# Inline the C wrappers so temporary refs stay on the stack.
@inline function _read_xy(seq, i, context)
    x, y = Ref{Float64}(), Ref{Float64}()
    (@inline GEOSCoordSeq_getXY_r(context, seq, i - 1, x, y)) == 1 ||
        error("LibGEOS: Error reading XY coordinates")
    return (x[], y[], NaN)
end
# Inline the C wrappers so temporary refs stay on the stack.
@inline function _read_xyz(seq, i, context)
    x, y, z = Ref{Float64}(), Ref{Float64}(), Ref{Float64}()
    (@inline GEOSCoordSeq_getXYZ_r(context, seq, i - 1, x, y, z)) == 1 ||
        error("LibGEOS: Error reading XYZ coordinates")
    return (x[], y[], z[])
end
@inline function _coordinate_point(geom, seq, i, hasz, hasm)
    context = get_context(geom)
    # The sequence is borrowed from geom, which must survive every coordinate read.
    GC.@preserve geom begin
        x, y, z = hasz ? _read_xyz(seq, i, context) : _read_xy(seq, i, context)
        m = if hasm
            value = Ref{Float64}()
            (@inline GEOSCoordSeq_getM_r(context, seq, i - 1, value)) == 1 ||
                error("LibGEOS: Error reading point measure")
            value[]
        else
            NaN
        end
    end
    return CoordinatePoint((x, y, z, m), hasz, hasm)
end
function GI.getgeom(
    ::Union{LineStringTrait,LinearRingTrait},
    geom::Union{LineString,LinearRing},
    i::Integer,
)
    context = get_context(geom)
    GC.@preserve geom begin
        seq = getCoordSeq(geom, context)
        1 <= i <= getSize(seq, context) || throw(BoundsError(geom, i))
        hasm = GEOSCoordSeq_hasM_r(context, seq) == 1
        hasz = getDimensions(seq, context) - hasm == 3
        return _coordinate_point(geom, seq, i, hasz, hasm)
    end
end
function GI.getgeom(
    ::Union{LineStringTrait,LinearRingTrait},
    geom::Union{LineString,LinearRing},
)
    context = get_context(geom)
    GC.@preserve geom begin
        seq = getCoordSeq(geom, context)
        n = Int(getSize(seq, context))
        hasm = GEOSCoordSeq_hasM_r(context, seq) == 1
        hasz = getDimensions(seq, context) - hasm == 3
        return (_coordinate_point(geom, seq, i, hasz, hasm) for i in 1:n)
    end
end
GeoInterface.getgeom(t::AbstractPointTrait, geom::PreparedGeometry) = nothing
function GeoInterface.getgeom(::PolygonTrait, geom::Polygon, i::Int)
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

GeoInterface.ncoord(::AbstractGeometryTrait, geom::AbstractGeometry) =
    isEmpty(geom) ? 0 : Int(getCoordinateDimension(geom))
GeoInterface.ncoord(t::AbstractGeometryTrait, geom::PreparedGeometry) =
    GeoInterface.ncoord(t, geom.ownedby)

GeoInterface.getcoord(::AbstractPointTrait, geom::Point, i) =
    getCoordinates(getCoordSeq(geom), 1)[i]
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
    if GI.is3d(geom)
        return Point(GI.x(geom), GI.y(geom), GI.z(geom), context)
    else
        return Point(GI.x(geom), GI.y(geom), context)
    end
end
GI.convert(::Type{MultiPoint}, ::MultiPointTrait, geom::MultiPoint; context = nothing) =
    geom
function GI.convert(
    ::Type{MultiPoint},
    t::MultiPointTrait,
    geom;
    context = get_global_context(),
)
    points = Point[GI.convert(Point, PointTrait(), p; context) for p in GI.getpoint(t, geom)]
    return MultiPoint(points, context)
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
    linestrings = LineString[
        GI.convert(LineString, LineStringTrait(), g; context) for g in getgeom(geom)
    ]
    return MultiLineString(linestrings, context)
end
GI.convert(::Type{Polygon}, ::PolygonTrait, geom::Polygon; context = nothing) = geom
function GI.convert(::Type{Polygon}, ::PolygonTrait, geom; context = get_global_context())
    exterior = GI.convert(LinearRing, GI.LinearRingTrait(), GI.getexterior(geom); context)
    holes = LinearRing[
        GI.convert(LinearRing, GI.LinearRingTrait(), g; context) for g in GI.gethole(geom)
    ]
    return Polygon(exterior, holes, context)
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
        Polygon[GI.convert(Polygon, PolygonTrait(), g; context) for g in GI.getgeom(geom)]
    return MultiPolygon(polygons, context)
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
    geometries = map(GI.getgeom(geom)) do g
        t = GI.trait(g)
        lg = geointerface_geomtype(t)
        # We call the full invocation for LibGEOS directly,
        # so the context can be passed through, since
        # `GI.convert(Mod, x)` does not allow kwargs.
        GI.convert(lg, t, g; context)
    end
    return GeometryCollection(geometries, context)
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

function _geom_to_coord_seq(geom, context)
    npoint = GI.npoint(geom)
    ndim = GI.is3d(geom) ? 3 : 2
    seq = createCoordSeq(npoint, context; ndim)
    for (i, p) in enumerate(GI.getpoint(geom))
        if ndim == 2
            setCoordSeq!(seq, i, (GI.x(p), GI.y(p)), context)
        else
            setCoordSeq!(seq, i, (GI.x(p), GI.y(p), GI.z(p)), context)
        end
    end
    return seq
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

buffer(obj, dist::Real, args...; kw...) = buffer(to_geos(obj), dist::Real, args...; kw...)
bufferWithStyle(obj, dist::Real; kw...) = bufferWithStyle(to_geos(obj), dist; kw...)

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
    @eval $f(geom, args...; kw...) = $f(to_geos(geom), args...; kw...)
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
        $f(to_geos(geom1), to_geos(geom2), args...; kw...)
    @eval $f(geom1::AbstractGeometry, geom2::AbstractGeometry, args...; kw...) =
        throw(MethodError($f, (geom1, geom2, args...)))
end

# LibGEOS always uses Float64 for coordinates
GeoInterface.coordtype(::GeoInterface.AbstractGeometryTrait, ::AbstractGeometry) = Float64
GeoInterface.coordtype(::GeoInterface.PointTrait, ::AbstractGeometry) = Float64
