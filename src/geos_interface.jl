# Position

Base.copy(pos::Position) = Position(cloneCoord(pos.ptr))
Base.convert(::Type{Position}, coords::Vector) = Position(coords)

GeoInterface.x(pos::Position) = getX(pos.ptr)
GeoInterface.y(pos::Position) = getY(pos.ptr)
GeoInterface.z(pos::Position) = getZ(pos.ptr)
GeoInterface.has_z(pos::Position) = (getDimension(pos.ptr) >= 3)
GeoInterface.coordinates(pos::Position) = getCoord(pos.ptr)

# Point

Base.copy(point::Point) = Point(GEOSGeom_clone(point.ptr))

GeoInterface.coordinates(point::Point) = getGeomCoord(point.ptr)
