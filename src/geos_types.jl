mutable struct Point <: GeoInterface.AbstractPoint
    ptr::GEOSGeom

    function Point(ptr::GEOSGeom)
        point = new(ptr)
        finalizer(destroyGeom, point)
        point
    end
    Point(coords::Vector{Float64}) = Point(createPoint(coords))
    Point(x::Real, y::Real) = Point(createPoint(x,y))
    Point(x::Real, y::Real, z::Real) = Point(createPoint(x,y,z))
    Point(obj::T) where {T<:GeoInterface.AbstractPoint} = Point(GeoInterface.coordinates(obj))
end

mutable struct MultiPoint <: GeoInterface.AbstractMultiPoint
    ptr::GEOSGeom

    function MultiPoint(ptr::GEOSGeom)
        multipoint = new(ptr)
        finalizer(destroyGeom, multipoint)
        multipoint
    end
    MultiPoint(multipoint::Vector{Vector{Float64}}) = MultiPoint(createCollection(GEOS_MULTIPOINT, GEOSGeom[createPoint(coords) for coords in multipoint]))
    MultiPoint(obj::T) where {T<:GeoInterface.AbstractMultiPoint} = MultiPoint(GeoInterface.coordinates(obj))
end

mutable struct LineString <: GeoInterface.AbstractLineString
    ptr::GEOSGeom

    function LineString(ptr::GEOSGeom)
        line = new(ptr)
        finalizer(destroyGeom, line)
        line
    end
    LineString(line::Vector{Vector{Float64}}) = LineString(createLineString(line))
    LineString(obj::T) where {T<:GeoInterface.AbstractLineString} = LineString(GeoInterface.coordinates(obj))
end

mutable struct MultiLineString <: GeoInterface.AbstractMultiLineString
    ptr::GEOSGeom

    function MultiLineString(ptr::GEOSGeom)
        multiline = new(ptr)
        finalizer(destroyGeom, multiline)
        multiline
    end
    MultiLineString(multiline::Vector{Vector{Vector{Float64}}}) = MultiLineString(createCollection(GEOS_MULTILINESTRING, GEOSGeom[createLineString(coords) for coords in multiline]))
    MultiLineString(obj::T) where {T<:GeoInterface.AbstractMultiLineString} = MultiLineString(GeoInterface.coordinates(obj))
end

mutable struct LinearRing <: GeoInterface.AbstractLineString
    ptr::GEOSGeom

    function LinearRing(ptr::GEOSGeom)
        ring = new(ptr)
        finalizer(destroyGeom, ring)
        ring
    end
    LinearRing(ring::Vector{Vector{Float64}}) = LinearRing(createLinearRing(ring))
    LinearRing(obj::T) where {T<:GeoInterface.AbstractLineString} = LinearRing(GeoInterface.coordinates(obj))
end

mutable struct Polygon <: GeoInterface.AbstractPolygon
    ptr::GEOSGeom

    function Polygon(ptr::GEOSGeom)
        polygon = new(ptr)
        finalizer(destroyGeom, polygon)
        polygon
    end
    function Polygon(coords::Vector{Vector{Vector{Float64}}})
        exterior = createLinearRing(coords[1])
        interiors = GEOSGeom[createLinearRing(lr) for lr in coords[2:end]]
        polygon = new(createPolygon(exterior,interiors))
        finalizer(destroyGeom, polygon)
        polygon
    end
    Polygon(obj::T) where {T<:GeoInterface.AbstractPolygon} = Polygon(GeoInterface.coordinates(obj))
end

mutable struct MultiPolygon <: GeoInterface.AbstractMultiPolygon
    ptr::GEOSGeom

    function MultiPolygon(ptr::GEOSGeom)
        multipolygon = new(ptr)
        finalizer(destroyGeom, multipolygon)
        multipolygon
    end
    MultiPolygon(multipolygon::Vector{Vector{Vector{Vector{Float64}}}}) =
        MultiPolygon(createCollection(GEOS_MULTIPOLYGON,
                                      GEOSGeom[createPolygon(createLinearRing(coords[1]),
                                                             GEOSGeom[createLinearRing(c) for c in coords[2:end]])
                                               for coords in multipolygon]))
    MultiPolygon(obj::T) where {T<:GeoInterface.AbstractMultiPolygon} = MultiPolygon(GeoInterface.coordinates(obj))
end

mutable struct GeometryCollection <: GeoInterface.AbstractGeometryCollection
    ptr::GEOSGeom

    function GeometryCollection(ptr::GEOSGeom)
        geometrycollection = new(ptr)
        finalizer(destroyGeom, geometrycollection)
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
