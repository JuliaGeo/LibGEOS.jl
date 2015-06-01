type Position <: GeoInterface.AbstractPosition
    ptr::GEOSCoordSeq
end
Position(x::Float64, y::Float64) = Position(createCoordSeq(Vector{Float64}[[x,y]]))
Position(x::Float64, y::Float64, z::Float64) = Position(createCoordSeq(Vector{Float64}[[x,y,z]]))
Position(coords::Vector{Float64}) = Position(createCoordSeq(Vector{Float64}[coords]))
GeoInterface.coordinates(pos::Position) = getCoordinates(pos.ptr)

type Point <: GeoInterface.AbstractPoint
    ptr::GEOSGeom
end
Point(position::Position) = Point(createPoint(cloneCoord(position.ptr)))
Point(coords::Vector{Float64}) = Point(createPoint(coords))
Point(x::Float64, y::Float64, z::Float64) = Point([x,y,z])
Point(x::Float64, y::Float64) = Point([x,y])

ndim(point::Point) = getCoordinateDimension(point.ptr)
GeoInterface.coordinates(point::Point) = getCoordinates(getCoordSeq(point))

type MultiPoint <: GeoInterface.AbstractMultiPoint
    ptr::GEOSGeom
end
MultiPoint(points::Vector{Vector{Float64}}) = MultiPoint(createCollection(GEOS_MULTIPOINT, GEOSGeom[createPoint(coords) for coords in points]))

ndim(multipoint::MultiPoint) = getCoordinateDimension(multipoint.ptr)
GeoInterface.coordinates(multipoint::MultiPoint) = Vector{Float64}[map(GeoInterface.coordinates,getGeometries(multipoint.ptr))...]

type LineString <: GeoInterface.AbstractLineString
    ptr::GEOSGeom
end
LineString(line::Vector{Vector{Float64}}) = LineString(createLineString(line))

ndim(line::LineString) = getCoordinateDimension(line.ptr)
GeoInterface.coordinates(line::LineString) = getCoordinates(getCoordSeq(line))

type MultiLineString <: GeoInterface.AbstractMultiLineString
    ptr::GEOSGeom
end
MultiLineString(lines::Vector{Vector{Vector{Float64}}}) = MultiLineString(createCollection(GEOS_MULTILINESTRING, GEOSGeom[createLineString(coords) for coords in lines]))

GeoInterface.coordinates(multiline::MultiLineString) = Vector{Vector{Float64}}[map(GeoInterface.coordinates,getGeometries(multiline.ptr))...]

type LinearRing <: GeoInterface.AbstractLineString
    ptr::GEOSGeom
end
LinearRing(ring::Vector{Vector{Float64}}) = LinearRing(createLinearRing(ring))

ndim(ring::LinearRing) = getCoordinateDimension(ring.ptr)
GeoInterface.coordinates(ring::LinearRing) = getCoordinates(getCoordSeq(ring.ptr))

type Polygon <: GeoInterface.AbstractPolygon
    ptr::GEOSGeom
end
Polygon(coords::Vector{Vector{Vector{Float64}}}) = Polygon(createPolygon(coords))

function GeoInterface.coordinates(polygon::Polygon)
    exterior = exteriorRing(polygon)
    interiors = interiorRings(polygon)
    if length(interiors) == 0
        return Vector{Vector{Float64}}[Vector{Float64}[GeoInterface.coordinates(exterior)]]
    else
        return Vector{Vector{Float64}}[Vector{Float64}[GeoInterface.coordinates(exterior)],
                                       map(GeoInterface.coordinates, interiors)]
    end
end

type MultiPolygon <: GeoInterface.AbstractMultiPolygon
    ptr::GEOSGeom
end
MultiPolygon(polygons::Vector{Vector{Vector{Vector{Float64}}}}) = MultiPolygon(createCollection(GEOS_MULTIPOLYGON, GEOSGeom[createPolygon(coords) for coords in polygons]))

GeoInterface.coordinates(multipolygon::MultiPolygon) = Vector{Vector{Vector{Float64}}}[map(GeoInterface.coordinates,getGeometries(multipolygon.ptr))...]

type GeometryCollection <: GeoInterface.AbstractGeometryCollection
    ptr::GEOSGeom
end
GeometryCollection(collection::Vector{GEOSGeom}) = GeometryCollection(createCollection(GEOS_GEOMETRYCOLLECTION, collection))

function GeoInterface.geometries(obj::GeometryCollection)
    collection = GeoInterface.AbstractGeometry[]
    sizehint(collection, numGeometries(obj))
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
