type Position <: GeoInterface.AbstractPosition
    ptr::GEOSCoordSeq

    function Position(ptr::GEOSCoordSeq)
        position = new(ptr)
        #finalizer(position, destroyPosition)
        position
    end
    Position(coords::Vector{Vector{Float64}}) = Position(createCoordSeq(coords))
    Position(coords::Vector{Float64}) = Position(createCoordSeq(coords))
    Position(x::Float64, y::Float64) = Position(createCoordSeq(x,y))
    Position(x::Float64, y::Float64, z::Float64) = Position(createCoordSeq(x,y,z))
end

function destroyPosition(position::Position)
    destroyCoordSeq(position.ptr)
    position.ptr = C_NULL
end

type Point <: GeoInterface.AbstractPoint
    ptr::GEOSGeom

    function Point(ptr::GEOSGeom)
        point = new(ptr)
        #finalizer(point, destroyGeom)
        point
    end
    Point(position::Position) = Point(createPoint(cloneCoord(position.ptr)))
    Point(coords::Vector{Float64}) = Point(createPoint(coords))
    Point(x::Float64, y::Float64) = Point(createPoint(x,y))
    Point(x::Float64, y::Float64, z::Float64) = Point(createPoint(x,y,z))
end
# ndim(point::Point) = getCoordinateDimension(point.ptr)

type MultiPoint <: GeoInterface.AbstractMultiPoint
    ptr::GEOSGeom

    function MultiPoint(ptr::GEOSGeom)
        multipoint = new(ptr)
        #finalizer(multipoint, destroyGeom)
        multipoint
    end
    MultiPoint(multipoint::Vector{Vector{Float64}}) = MultiPoint(createCollection(GEOS_MULTIPOINT, GEOSGeom[createPoint(coords) for coords in multipoint]))
end
# ndim(multipoint::MultiPoint) = getCoordinateDimension(multipoint.ptr)

type LineString <: GeoInterface.AbstractLineString
    ptr::GEOSGeom

    function LineString(ptr::GEOSGeom)
        line = new(ptr)
        #finalizer(line, destroyGeom)
        line
    end
    LineString(line::Vector{Vector{Float64}}) = LineString(createLineString(line))
end
# ndim(line::LineString) = getCoordinateDimension(line.ptr)

type MultiLineString <: GeoInterface.AbstractMultiLineString
    ptr::GEOSGeom

    function MultiLineString(ptr::GEOSGeom)
        multiline = new(ptr)
        #finalizer(multiline, destroyGeom)
        multiline
    end
    MultiLineString(multiline::Vector{Vector{Vector{Float64}}}) = MultiLineString(createCollection(GEOS_MULTILINESTRING, GEOSGeom[createLineString(coords) for coords in multiline]))
end

type LinearRing <: GeoInterface.AbstractLineString
    ptr::GEOSGeom

    function LinearRing(ptr::GEOSGeom)
        ring = new(ptr)
        #finalizer(ring, destroyGeom)
        ring
    end
    LinearRing(ring::Vector{Vector{Float64}}) = LinearRing(createLinearRing(ring))
end
# ndim(ring::LinearRing) = getCoordinateDimension(ring.ptr)

type Polygon <: GeoInterface.AbstractPolygon
    ptr::GEOSGeom

    function Polygon(ptr::GEOSGeom)
        polygon = new(ptr)
        #finalizer(polygon, destroyGeom)
        polygon
    end
    Polygon(coords::Vector{Vector{Vector{Float64}}}) = Polygon(createPolygon(coords))
end

type MultiPolygon <: GeoInterface.AbstractMultiPolygon
    ptr::GEOSGeom

    function MultiPolygon(ptr::GEOSGeom)
        multipolygon = new(ptr)
        #finalizer(multipolygon, destroyGeom)
        multipolygon
    end
    MultiPolygon(multipolygon::Vector{Vector{Vector{Vector{Float64}}}}) = MultiPolygon(createCollection(GEOS_MULTIPOLYGON, GEOSGeom[createPolygon(coords) for coords in multipolygon]))
end

type GeometryCollection <: GeoInterface.AbstractGeometryCollection
    ptr::GEOSGeom

    function GeometryCollection(ptr::GEOSGeom)
        geometrycollection = new(ptr)
        #finalizer(geometrycollection, destroyGeom)
        geometrycollection
    end
    GeometryCollection(collection::Vector{GEOSGeom}) = GeometryCollection(createCollection(GEOS_GEOMETRYCOLLECTION, collection))
end

for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    @eval destroyGeom(obj::$geom) = destroyGeom(obj.ptr)
end
