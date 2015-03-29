# GEOSCoordSeq

setX(ptr::GEOSCoordSeq, value::Float64) = GEOSCoordSeq_setX(ptr, uint32(0), value)
setY(ptr::GEOSCoordSeq, value::Float64) = GEOSCoordSeq_setY(ptr, uint32(0), value)
setZ(ptr::GEOSCoordSeq, value::Float64) = GEOSCoordSeq_setZ(ptr, uint32(0), value)

function setCoord{T<:Real}(ptr::GEOSCoordSeq, coords::Vector{T})
    setX(ptr, coords[1])
    setY(ptr, coords[2])
    length(coords) == 3 && setZ(ptr, coords[3])
    ptr
end
createCoord(ndim::Int) = GEOSCoordSeq_create(uint32(1), uint32(ndim))
createCoord(coords::Vector{Float64}) = setCoord(createCoord(length(coords)), coords)

function getDimension(ptr::GEOSCoordSeq)
    ndim = Array(Uint32, 1)
    GEOSCoordSeq_getDimensions(ptr, pointer(ndim))
    ndim[1]
end

function getSize(ptr::GEOSCoordSeq)
    ncoords = Array(Uint32, 1)
    GEOSCoordSeq_getSize(ptr, pointer(ncoords))
    ncoords[1]
end

getX(ptr::GEOSCoordSeq, index::Int, coord::Vector{Float64}) = GEOSCoordSeq_getX(ptr, uint32(index), pointer(coord))
getY(ptr::GEOSCoordSeq, index::Int, coord::Vector{Float64}) = GEOSCoordSeq_getY(ptr, uint32(index), pointer(coord)+sizeof(Float64))
getZ(ptr::GEOSCoordSeq, index::Int, coord::Vector{Float64}) = GEOSCoordSeq_getZ(ptr, uint32(index), pointer(coord)+2*sizeof(Float64))
getX(ptr::GEOSCoordSeq, coord::Vector{Float64}) = getX(ptr, 0, coord)
getY(ptr::GEOSCoordSeq, coord::Vector{Float64}) = getY(ptr, 0, coord)
getZ(ptr::GEOSCoordSeq, coord::Vector{Float64}) = getZ(ptr, 0, coord)

function getX(ptr::GEOSCoordSeq)
    coord = Array(Float64, 1)
    GEOSCoordSeq_getX(ptr, uint32(0), pointer(coord))
    coord[1]
end
function getY(ptr::GEOSCoordSeq)
    coord = Array(Float64, 1)
    GEOSCoordSeq_getY(ptr, uint32(0), pointer(coord))
    coord[1]
end
function getZ(ptr::GEOSCoordSeq)
    coord = Array(Float64, 1)
    GEOSCoordSeq_getZ(ptr, uint32(0), pointer(coord))
    coord[1]
end

function getCoord(ptr::GEOSCoordSeq)
    ndim = getDimension(ptr)
    coord = Array(Float64, ndim)
    getX(ptr, coord)
    getY(ptr, coord)
    ndim == 3 && getZ(ptr, coord)
    coord
end

function getCoordSeq(ptr::GEOSCoordSeq)
    ndim = getDimension(ptr)
    coord = Array(Float64, ndim)
    getX(ptr, coord)
    getY(ptr, coord)
    ndim == 3 && getZ(ptr, coord)
    coord
end

cloneCoord(ptr::GEOSCoordSeq) = GEOSCoordSeq_clone(ptr)

# GEOSGeometry
GEOMTYPE = @compat Dict( GEOS_POINT => :Point,
                         GEOS_LINESTRING => :LineString,
                         GEOS_LINEARRING => :LinearRing,
                         GEOS_POLYGON => :Polygon,
                         GEOS_MULTIPOINT => :MultiPoint,
                         GEOS_MULTILINESTRING => :MultiLineString,
                         GEOS_MULTIPOLYGON => :MultiPolygon,
                         GEOS_GEOMETRYCOLLECTION => :GeometryCollection)

getDimension(ptr::GEOSGeom) = GEOSGeom_getCoordinateDimension(ptr)
getGeomCoord(ptr::GEOSGeom) = getCoord(GEOSGeom_getCoordSeq(ptr))
getType(ptr::GEOSGeom) = GEOMTYPE[GEOSGeomTypeId(ptr)]
cloneGeom(ptr::GEOSGeom) = GEOSGeom_clone(ptr)

# Point <: GEOSGeometry
createPoint(ptr::GEOSCoordSeq) = GEOSGeom_createPoint(ptr)
createLinearRing(ptr::GEOSCoordSeq) = GEOSGeom_createLinearRing(ptr)
createLineString(ptr::GEOSCoordSeq) = GEOSGeom_createLineString(ptr)
createPolygon(shell::GEOSGeom, holes::GEOSGeom, nholes::Int) = GEOSGeom_createPolygon(shell, holes, uint32(nholes))
createPoint(ptr::GEOSCoordSeq) = GEOSGeom_createPoint(ptr)
createPoint(ptr::GEOSCoordSeq) = GEOSGeom_createPoint(ptr)




