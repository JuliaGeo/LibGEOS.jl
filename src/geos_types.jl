type Position <: GeoInterface.AbstractPosition
    ptr::GEOSCoordSeq
end
Position(x::Float64, y::Float64) = Position(createCoord([x,y]))
Position(x::Float64, y::Float64, z::Float64) = Position(createCoord([x,y,z]))
Position(coords::Vector{Float64}) = Position(createCoord(coords))

type Point <: GeoInterface.AbstractPoint
    ptr::GEOSGeom
end

Point(position::Position) = Point(createPoint(cloneCoord(position.ptr)))
Point(x::Float64, y::Float64) = Point(createPoint(createCoord([x,y])))
Point(x::Float64, y::Float64, z::Float64) = Point(createPoint(createCoord([x,y,z])))
Point(coords::Vector{Float64}) = Point(createPoint(createCoord(coords)))

ndim(point::Point) = getDimension(point.ptr)

type LinearRing <: GeoInterface.AbstractLineString
    ptr::GEOSGeom
end

type LineString <: GeoInterface.AbstractLineString
    ptr::GEOSGeom
end

type Polygon <: GeoInterface.AbstractPolygon
    ptr::GEOSGeom
end

