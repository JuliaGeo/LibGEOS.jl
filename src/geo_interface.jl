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

GeoInterface.ngeom(::AbstractGeometryTrait, geom::AbstractGeometry) =
    isEmpty(geom.ptr) ? 0 : numGeometries(geom.ptr)
function GeoInterface.getgeom(::AbstractGeometryTrait, geom::AbstractGeometry, i)
    clone = getGeometry(geom.ptr, i)
    id = geomTypeId(clone) + 1
    0 < id <= length(geomtypes) || error("Unknown geometry type id $id")
    geomtypes[id](clone)
end
GeoInterface.ngeom(::AbstractGeometryTrait, geom::Union{LineString,LinearRing}) =
    numPoints(geom.ptr)
GeoInterface.getgeom(::AbstractGeometryTrait, geom::Union{LineString,LinearRing}, i) =
    Point(getPoint(geom.ptr, i))

GeoInterface.ngeom(::AbstractGeometryTrait, geom::Polygon) = numInteriorRings(geom.ptr) + 1
function GeoInterface.getgeom(::AbstractGeometryTrait, geom::Polygon, i)
    if i == 1
        LinearRing(exteriorRing(geom.ptr))
    else
        LinearRing(interiorRing(geom.ptr, i - 1))
    end
end

GeoInterface.ngeom(t::AbstractGeometryTrait, geom::PreparedGeometry) = GeoInterface.ngeom(t, geom.ownedby)
GeoInterface.getgeom(t::AbstractGeometryTrait, geom::PreparedGeometry, i) = GeoInterface.getgeom(t, geom.ownedby, i)

GeoInterface.ncoord(::AbstractGeometryTrait, geom::AbstractGeometry) =
    isEmpty(geom.ptr) ? 0 : getCoordinateDimension(geom.ptr)
GeoInterface.getcoord(::AbstractGeometryTrait, geom::AbstractGeometry, i) =
    getCoordinates(getCoordSeq(geom.ptr), 1)[i]

GeoInterface.ncoord(t::AbstractGeometryTrait, geom::PreparedGeometry) = GeoInterface.ncoord(t, geom.ownedby)
GeoInterface.getcoord(t::AbstractGeometryTrait, geom::PreparedGeometry, i) = GeoInterface.getcoord(t, geom.ownedby, i)

function GeoInterface.extent(::AbstractGeometryTrait, geom::AbstractGeometry)
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

function Base.convert(
    t::Type{<:AbstractGeometry},
    type::AbstractGeometryTrait,
    geom,
)
    error(
        "Cannot convert an object of $(typeof(geom)) with the $(typeof(type)) trait to a $t (yet). Please report an issue.",
    )
    return f(GeoInterface.coordinates(geom))
end
