# TODO add back constructors for geometries using the GeoInterface

GeoInterface.geomtype(g::Point) = GeoInterface.Point()
GeoInterface.geomtype(g::LineString) = GeoInterface.LineString()
GeoInterface.geomtype(g::Polygon) = GeoInterface.Polygon()
GeoInterface.geomtype(g::MultiPoint) = GeoInterface.MultiPoint()
GeoInterface.geomtype(g::MultiLineString) = GeoInterface.MultiLineString()
GeoInterface.geomtype(g::MultiPolygon) = GeoInterface.MultiPolygon()
GeoInterface.geomtype(g::GeometryCollection) = GeoInterface.GeometryCollection()
GeoInterface.geomtype(g::LinearRing) = GeoInterface.LineString()

function GeoInterface.ncoord(g::Geometry)
    cs = getCoordSeq(g.ptr)
    getDimensions(cs)
end

function GeoInterface.getcoord(g::Point, i::Int)
    cs = getCoordSeq(g.ptr)
    if i == 1
        getX(cs, 1)
    elseif i == 2
        getY(cs, 1)
    elseif i == 3
        getZ(cs, 1)
    else
        throw(ArgumentError("GEOS only supports 2 and 3 dimensional points"))
    end
end

function GeoInterface.npoint(g::LineString)
    numPoints(g)
end

function GeoInterface.getpoint(g::LineString, i::Int)
    cs = getCoordSeq(g.ptr)
    nc = getDimensions(cs)
    np = getSize(cs)
    if i > np || i < 1
        # otherwise we get garbage back
        throw(BoundsError(cs, i))
    end
    x = LibGEOS.getX(cs, i)
    y = LibGEOS.getY(cs, i)
    if nc == 2
        Point(x, y)
    else
        z = LibGEOS.getZ(cs, i)
        Point(x, y, z)
    end
end

GeoInterface.isclosed(g::LineString) = isClosed(g)

GeoInterface.getexterior(g::Polygon) = exteriorRing(g)
GeoInterface.nhole(g::Polygon) = numInteriorRings(g.ptr)
GeoInterface.gethole(g::Polygon, i::Int) = interiorRing(g.ptr, i)

GeoInterface.npoint(g::MultiPoint) = getDimensions(g.ptr)
GeoInterface.nlinestring(g::MultiLineString) = getDimensions(g.ptr)
GeoInterface.npolygon(g::MultiPolygon) = getDimensions(g.ptr)
GeoInterface.ngeom(g::GeometryCollection) = getDimensions(g.ptr)

function GeoInterface.getpoint(g::MultiPoint, i::Int)
    ptr = LibGEOS.getGeometry(g.ptr, i)
    Point(ptr)
end

function GeoInterface.getlinestring(g::MultiLineString, i::Int)
    ptr = getGeometry(g.ptr, i)
    LineString(ptr)
end

function GeoInterface.getpolygon(g::MultiPolygon, i::Int)
    ptr = getGeometry(g.ptr, i)
    Polygon(ptr)
end

function GeoInterface.getgeom(g::GeometryCollection, i::Int)
    ptr = getGeometry(g.ptr, i)
    geomFromGEOS(ptr)
end
