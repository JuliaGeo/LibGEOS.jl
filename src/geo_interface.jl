GeoInterface.isgeometry(::Type{<:AbstractGeometry}) = true

GeoInterface.geomtrait(::Point) = PointTrait()
GeoInterface.geomtrait(::MultiPoint) = MultiPointTrait()
GeoInterface.geomtrait(::LineString) = LineStringTrait()
GeoInterface.geomtrait(::MultiLineString) = MultiLineStringTrait()
GeoInterface.geomtrait(::LinearRing) = LinearRingTrait()
GeoInterface.geomtrait(::Polygon) = PolygonTrait()
GeoInterface.geomtrait(::MultiPolygon) = MultiPolygonTrait()
GeoInterface.geomtrait(::GeometryCollection) = GeometryCollectionTrait()
GeoInterface.geomtrait(geom::PreparedGeometry) = GeoInterface.geomtrait(geom.ownedby)

GeoInterface.ngeom(::AbstractGeometryCollectionTrait, geom::T) where {T<:AbstractMultiGeometry} =
    isEmpty(geom) ? 0 : Int(numGeometries(geom))
GeoInterface.ngeom(::LineStringTrait, geom::LineString) = Int(numPoints(geom))
GeoInterface.ngeom(::LinearRingTrait, geom::LinearRing) = Int(numPoints(geom))
GeoInterface.ngeom(::PolygonTrait, geom::Polygon) = Int(numInteriorRings(geom)) + 1
GeoInterface.ngeom(t::AbstractGeometryTrait, geom::PreparedGeometry) =
    GeoInterface.ngeom(t, geom.ownedby)
GeoInterface.ngeom(::AbstractPointTrait, geom::Point) = 0
GeoInterface.ngeom(::AbstractPointTrait, geom::PreparedGeometry) = 0

function GeoInterface.getgeom(::AbstractGeometryCollectionTrait, geom::AbstractMultiGeometry, i)
    getGeometry(geom, i)
end
GeoInterface.getgeom(::MultiPointTrait, geom::MultiPoint, i) = getGeometry(geom, i)::Point
GeoInterface.getgeom(::MultiLineStringTrait, geom::MultiLineString, i) = getGeometry(geom, i)::LineString
GeoInterface.getgeom(::MultiPolygonTrait, geom::MultiPolygon, i) = getGeometry(geom, i)::Polygon
GeoInterface.getgeom(::Union{LineStringTrait,LinearRingTrait}, geom::Union{LineString,LinearRing}, i) =
    Point(getPoint(geom, i))
GeoInterface.getgeom(t::AbstractPointTrait, geom::PreparedGeometry) = nothing
function GeoInterface.getgeom(::PolygonTrait, geom::Polygon, i::Int)
    if i == 1
        LinearRing(exteriorRing(geom))
    else
        LinearRing(interiorRing(geom, i - 1))
    end
end
GeoInterface.getgeom(t::AbstractGeometryTrait, geom::PreparedGeometry, i) =
    GeoInterface.getgeom(t, geom.ownedby, i)
GeoInterface.getgeom(t::AbstractPointTrait, geom::PreparedGeometry, i) = 0

GeoInterface.coordinates(t::AbstractPointTrait, geom::Point) = collect(getcoord(t, geom))
GeoInterface.coordinates(t::AbstractPointTrait, geom::T) where {T<:AbstractGeometry} = nothing
GeoInterface.coordinates(t::AbstractGeometryTrait, geom::T) where {T<:AbstractGeometry} = [GeoInterface.coordinates(x) for x in getgeom(t, geom)]
GeoInterface.coordinates(t::AbstractGeometryCollectionTrait, geom::T) where {T<:AbstractMultiGeometry} = [GeoInterface.coordinates(x) for x in getgeom(t, geom)]

GeoInterface.ncoord(::AbstractGeometryTrait, geom::T) where {T<:AbstractGeometry} =
    isEmpty(geom) ? 0 : Int(getCoordinateDimension(geom))
GeoInterface.ncoord(t::AbstractGeometryTrait, geom::PreparedGeometry) =
    GeoInterface.ncoord(t, geom.ownedby)

GeoInterface.getcoord(::AbstractGeometryTrait, geom::AbstractGeometry, i) =
    getCoordinates(getCoordSeq(geom), 1)[i]
GeoInterface.getcoord(t::AbstractGeometryTrait, geom::PreparedGeometry, i) =
    GeoInterface.getcoord(t, geom.ownedby, i)

function GeoInterface.extent(::AbstractGeometryTrait, geom::T) where {T<:AbstractGeometry}
    # minx, miny, maxx, maxy = getExtent(geom)
    env = envelope(geom)
    return Extent(X=(getXMin(env), getXMax(env)), Y=(getYMin(env), getYMax(env)))
end

function Base.convert(::Type{T}, geom::T) where {T<:AbstractGeometry}
    return geom
end

function Base.convert(::Type{T}, geom::X) where {T<:AbstractGeometry,X}
    return Base.convert(T, GeoInterface.geomtrait(geom), geom)
end

function Base.convert(::Type{Point}, type::PointTrait, geom)
    return Point(GeoInterface.coordinates(geom))
end
function Base.convert(::Type{MultiPoint}, type::MultiPointTrait, geom)
    return MultiPoint(GeoInterface.coordinates(geom))
end
function Base.convert(::Type{LineString}, type::LineStringTrait, geom)
    return LineString(GeoInterface.coordinates(geom))
end
function Base.convert(::Type{MultiLineString}, type::MultiLineStringTrait, geom)
    return MultiLineString(GeoInterface.coordinates(geom))
end
function Base.convert(::Type{Polygon}, type::PolygonTrait, geom)
    return Polygon(GeoInterface.coordinates(geom))
end
function Base.convert(::Type{MultiPolygon}, type::MultiPolygonTrait, geom)
    return MultiPolygon(GeoInterface.coordinates(geom))
end

function Base.convert(t::Type{<:AbstractGeometry}, type::AbstractGeometryTrait, geom)
    error(
        "Cannot convert an object of $(typeof(geom)) with the $(typeof(type)) trait to a $t (yet). Please report an issue.",
    )
    return f(GeoInterface.coordinates(geom))
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

GeoInterfaceRecipes.@enable_geo_plots AbstractGeometry
