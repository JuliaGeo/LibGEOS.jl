GeoInterface.isgeometry(geom::Point) = true
GeoInterface.isgeometry(geom::MultiPoint) = true
GeoInterface.isgeometry(geom::LineString) = true
GeoInterface.isgeometry(geom::MultiLineString) = true
GeoInterface.isgeometry(geom::LinearRing) = true
GeoInterface.isgeometry(geom::Polygon) = true
GeoInterface.isgeometry(geom::MultiPolygon) = true
GeoInterface.isgeometry(geom::GeometryCollection) = true

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
