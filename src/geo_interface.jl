# Position

Base.copy(pos::Position) = Position(cloneCoord(pos.ptr))
Base.convert(::Type{Position}, coords::Vector) = Position(coords)

GeoInterface.x(pos::Position) = getX(pos.ptr)
GeoInterface.y(pos::Position) = getY(pos.ptr)
GeoInterface.z(pos::Position) = getZ(pos.ptr)
GeoInterface.hasz(pos::Position) = (getDimension(pos.ptr) >= 3)
GeoInterface.coordinates(pos::Position) = getCoordinates(pos.ptr)

# Geometries

for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon)
    @eval Base.copy(obj::$geom) = ($geom)(GEOSGeom_clone(obj.ptr))
end

GeoInterface.coordinates(obj::Point) = isEmpty(obj.ptr) ? Float64[] : getCoordinates(getCoordSeq(obj.ptr), 1)
GeoInterface.coordinates(obj::LineString) = getCoordinates(getCoordSeq(obj.ptr))
GeoInterface.coordinates(obj::LinearRing) = getCoordinates(getCoordSeq(obj.ptr))

function GeoInterface.coordinates(polygon::Polygon)
    exterior = LinearRing(exteriorRing(polygon.ptr))
    interiors = map(LinearRing,interiorRings(polygon.ptr))
    if length(interiors) == 0
        return Vector{Vector{Float64}}[GeoInterface.coordinates(exterior)]
    else
        return [Vector{Vector{Float64}}[GeoInterface.coordinates(exterior)],
                map(GeoInterface.coordinates, interiors)]
    end
end

GeoInterface.coordinates(multipoint::MultiPoint) = Vector{Float64}[map(GeoInterface.coordinates,map(Point,getGeometries(multipoint.ptr)))...]
GeoInterface.coordinates(multiline::MultiLineString) = Vector{Vector{Float64}}[map(GeoInterface.coordinates,map(LineString,getGeometries(multiline.ptr)))...]
GeoInterface.coordinates(multipolygon::MultiPolygon) = Vector{Vector{Vector{Float64}}}[map(GeoInterface.coordinates,map(Polygon,getGeometries(multipolygon.ptr)))...]

function GeoInterface.geometries(obj::GeometryCollection)
    collection = GeoInterface.AbstractGeometry[]
    sizehint(collection, numGeometries(obj.ptr))
    for geom in getGeometries(obj.ptr)
        if geomTypeId(geom) == GEOS_POINT
            push!(collection, Point(geom))
        elseif geomTypeId(geom) == GEOS_LINESTRING
            push!(collection, LineString(geom))
        elseif geomTypeId(geom) == GEOS_LINEARRING
            push!(collection, LinearRing(geom))
        elseif geomTypeId(geom) == GEOS_POLYGON
            push!(collection, Polygon(geom))
        elseif geomTypeId(geom) == GEOS_MULTIPOINT
            push!(collection, MultiPoint(geom))
        elseif geomTypeId(geom) == GEOS_MULTILINESTRING
            push!(collection, MultiLineString(geom))
        elseif geomTypeId(geom) == GEOS_MULTIPOLYGON
            push!(collection, MultiPolygon(geom))
        else
            @assert geomTypeId(geom) == GEOS_GEOMETRYCOLLECTION
            push!(collection, GeometryCollection(geom))
        end
    end
    collection
end
