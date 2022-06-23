const lookup_method = Dict{DataType,DataType}(
    GeoInterface.PointTrait => Point,
    GeoInterface.MultiPointTrait => MultiPoint,
    GeoInterface.LineStringTrait => LineString,
    GeoInterface.LinearRingTrait => LinearRing,
    GeoInterface.MultiLineStringTrait => MultiLineString,
    GeoInterface.PolygonTrait => Polygon,
    GeoInterface.MultiPolygonTrait => MultiPolygon,
)

GeoInterface.isgeometry(::Type{Point}) = true
GeoInterface.isgeometry(::Type{MultiPoint}) = true
GeoInterface.isgeometry(::Type{LineString}) = true
GeoInterface.isgeometry(::Type{MultiLineString}) = true
GeoInterface.isgeometry(::Type{LinearRing}) = true
GeoInterface.isgeometry(::Type{Polygon}) = true
GeoInterface.isgeometry(::Type{MultiPolygon}) = true
GeoInterface.isgeometry(::Type{GeometryCollection}) = true

GeoInterface.geomtrait(geom::Point) = PointTrait()
GeoInterface.geomtrait(geom::MultiPoint) = MultiPointTrait()
GeoInterface.geomtrait(geom::LineString) = LineStringTrait()
GeoInterface.geomtrait(geom::MultiLineString) = MultiLineStringTrait()
GeoInterface.geomtrait(geom::LinearRing) = LinearRingTrait()
GeoInterface.geomtrait(geom::Polygon) = PolygonTrait()
GeoInterface.geomtrait(geom::MultiPolygon) = MultiPolygonTrait()
GeoInterface.geomtrait(geom::GeometryCollection) = GeometryCollectionTrait()

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

GeoInterface.ncoord(::AbstractGeometryTrait, geom::AbstractGeometry) =
    isEmpty(geom.ptr) ? 0 : getCoordinateDimension(geom.ptr)
GeoInterface.getcoord(::AbstractGeometryTrait, geom::AbstractGeometry, i) =
    getCoordinates(getCoordSeq(geom.ptr), 1)[i]

function GeoInterface.extent(::AbstractGeometryTrait, geom::AbstractGeometry)
    # minx, miny, maxx, maxy = getExtent(geom)
    env = envelope(geom)
    return Extent(X = (getXMin(env), getXMax(env)), Y = (getYMin(env), getYMax(env)))
end

function Base.convert(::Type{T}, geom::X) where {T<:AbstractGeometry,X}
    return Base.convert(T, GeoInterface.geomtrait(geom), geom)
end

function Base.convert(
    ::Type{T},
    ::AbstractGeometryTrait,
    geom::T,
) where {T<:AbstractGeometry}
    return geom
end  # fast fallthrough without conversion

function Base.convert(::Type{T}, ::Nothing, geom::T) where {T<:AbstractGeometry}
    return geom
end  # fast fallthrough without conversion

function Base.convert(
    ::Type{T},
    type::AbstractGeometryTrait,
    geom,
) where {T<:AbstractGeometry}
    f = get(lookup_method, typeof(type), nothing)
    isnothing(f) && error(
        "Cannot convert an object of $(typeof(geom)) with the $(typeof(type)) trait (yet). Please report an issue.",
    )
    return f(GeoInterface.coordinates(geom))
end
