type Point <: GeoInterface.AbstractPoint
    ptr::GEOSGeom

    function Point(ptr::GEOSGeom)
        point = new(ptr)
        finalizer(point, destroyGeom)
        point
    end
    Point(coords::Vector{Float64}) = Point(createPoint(coords))
    Point(x::Float64, y::Float64) = Point(createPoint(x,y))
    Point(x::Float64, y::Float64, z::Float64) = Point(createPoint(x,y,z))
    Point{T<:GeoInterface.AbstractPoint}(obj::T) = Point(GeoInterface.coordinates(obj))
end

type MultiPoint <: GeoInterface.AbstractMultiPoint
    ptr::GEOSGeom

    function MultiPoint(ptr::GEOSGeom)
        multipoint = new(ptr)
        finalizer(multipoint, destroyGeom)
        multipoint
    end
    MultiPoint(multipoint::Vector{Vector{Float64}}) = MultiPoint(createCollection(GEOS_MULTIPOINT, GEOSGeom[createPoint(coords) for coords in multipoint]))
    MultiPoint{T<:GeoInterface.AbstractMultiPoint}(obj::T) = MultiPoint(GeoInterface.coordinates(obj))
end

type LineString <: GeoInterface.AbstractLineString
    ptr::GEOSGeom

    function LineString(ptr::GEOSGeom)
        line = new(ptr)
        finalizer(line, destroyGeom)
        line
    end
    LineString(line::Vector{Vector{Float64}}) = LineString(createLineString(line))
    LineString{T<:GeoInterface.AbstractLineString}(obj::T) = LineString(GeoInterface.coordinates(obj))
end

type MultiLineString <: GeoInterface.AbstractMultiLineString
    ptr::GEOSGeom

    function MultiLineString(ptr::GEOSGeom)
        multiline = new(ptr)
        finalizer(multiline, destroyGeom)
        multiline
    end
    MultiLineString(multiline::Vector{Vector{Vector{Float64}}}) = MultiLineString(createCollection(GEOS_MULTILINESTRING, GEOSGeom[createLineString(coords) for coords in multiline]))
    MultiLineString{T<:GeoInterface.AbstractMultiLineString}(obj::T) = MultiLineString(GeoInterface.coordinates(obj))
end

type LinearRing <: GeoInterface.AbstractLineString
    ptr::GEOSGeom

    function LinearRing(ptr::GEOSGeom)
        ring = new(ptr)
        finalizer(ring, destroyGeom)
        ring
    end
    LinearRing(ring::Vector{Vector{Float64}}) = LinearRing(createLinearRing(ring))
    LinearRing{T<:GeoInterface.AbstractLineString}(obj::T) = LinearRing(GeoInterface.coordinates(obj))
end

type Polygon <: GeoInterface.AbstractPolygon
    ptr::GEOSGeom

    function Polygon(ptr::GEOSGeom)
        polygon = new(ptr)
        finalizer(polygon, destroyGeom)
        polygon
    end
    function Polygon(coords::Vector{Vector{Vector{Float64}}})
        exterior = createLinearRing(coords[1])
        interiors = GEOSGeom[createLinearRing(lr) for lr in coords[2:end]]
        polygon = new(createPolygon(exterior,interiors))
        finalizer(polygon, destroyGeom)
        polygon
    end
    Polygon{T<:GeoInterface.AbstractPolygon}(obj::T) = Polygon(GeoInterface.coordinates(obj))
end

type MultiPolygon <: GeoInterface.AbstractMultiPolygon
    ptr::GEOSGeom

    function MultiPolygon(ptr::GEOSGeom)
        multipolygon = new(ptr)
        finalizer(multipolygon, destroyGeom)
        multipolygon
    end
    MultiPolygon(multipolygon::Vector{Vector{Vector{Vector{Float64}}}}) = MultiPolygon(createCollection(GEOS_MULTIPOLYGON, GEOSGeom[createPolygon(coords) for coords in multipolygon]))
    MultiPolygon{T<:GeoInterface.AbstractMultiPolygon}(obj::T) = MultiPolygon(GeoInterface.coordinates(obj))
end

type GeometryCollection <: GeoInterface.AbstractGeometryCollection
    ptr::GEOSGeom

    function GeometryCollection(ptr::GEOSGeom)
        geometrycollection = new(ptr)
        finalizer(geometrycollection, destroyGeom)
        geometrycollection
    end
    GeometryCollection(collection::Vector{GEOSGeom}) = GeometryCollection(createCollection(GEOS_GEOMETRYCOLLECTION, collection))
end

for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    @eval begin
        function destroyGeom(obj::$geom)
            destroyGeom(obj.ptr)
            obj.ptr = C_NULL
        end
    end
end
