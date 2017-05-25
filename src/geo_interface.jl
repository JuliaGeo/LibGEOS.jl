# for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon)
#     @eval Base.copy(obj::$geom) = ($geom)(GEOSGeom_clone(obj.ptr))
# end

GeoInterface.coordinates(obj::Point) = isEmpty(obj.ptr) ? Float64[] : getCoordinates(getCoordSeq(obj.ptr), 1)
GeoInterface.coordinates(obj::LineString) = getCoordinates(getCoordSeq(obj.ptr))
GeoInterface.coordinates(obj::LinearRing) = getCoordinates(getCoordSeq(obj.ptr))

function GeoInterface.coordinates(polygon::Polygon)
    exterior = getCoordinates(getCoordSeq(exteriorRing(polygon.ptr)))
    interiors = [getCoordinates(getCoordSeq(ring)) for ring in interiorRings(polygon.ptr)]
    if length(interiors) == 0
        return Vector{Vector{Float64}}[exterior]
    else
        return [Vector{Vector{Float64}}[exterior]; interiors]
    end
end

GeoInterface.coordinates(multipoint::MultiPoint) = Vector{Float64}[getCoordinates(getCoordSeq(geom),1) for geom in getGeometries(multipoint.ptr)]
GeoInterface.coordinates(multiline::MultiLineString) = Vector{Vector{Float64}}[getCoordinates(getCoordSeq(geom)) for geom in getGeometries(multiline.ptr)]
function GeoInterface.coordinates(multipolygon::MultiPolygon)
    geometries = getGeometries(multipolygon.ptr)
    coords = Array{Vector{Vector{Vector{Float64}}}}(length(geometries))
    for (i,geom) in enumerate(getGeometries(multipolygon.ptr))
        exterior = getCoordinates(getCoordSeq(exteriorRing(geom)))
        interiors = [getCoordinates(getCoordSeq(ring)) for ring in interiorRings(geom)]
        coords[i] = [Vector{Vector{Float64}}[exterior]; interiors]
    end
    coords
end

function GeoInterface.geometries(obj::GeometryCollection)
    collection = GeoInterface.AbstractGeometry[]
    sizehint!(collection, numGeometries(obj.ptr))
    for geom in getGeometries(obj.ptr)
        if geomTypeId(geom) == GEOS_POINT
            push!(collection, Point(cloneGeom(geom)))
        elseif geomTypeId(geom) == GEOS_LINESTRING
            push!(collection, LineString(cloneGeom(geom)))
        elseif geomTypeId(geom) == GEOS_LINEARRING
            push!(collection, LinearRing(cloneGeom(geom)))
        elseif geomTypeId(geom) == GEOS_POLYGON
            push!(collection, Polygon(cloneGeom(geom)))
        elseif geomTypeId(geom) == GEOS_MULTIPOINT
            push!(collection, MultiPoint(cloneGeom(geom)))
        elseif geomTypeId(geom) == GEOS_MULTILINESTRING
            push!(collection, MultiLineString(cloneGeom(geom)))
        elseif geomTypeId(geom) == GEOS_MULTIPOLYGON
            push!(collection, MultiPolygon(cloneGeom(geom)))
        else
            @assert geomTypeId(geom) == GEOS_GEOMETRYCOLLECTION
            push!(collection, GeometryCollection(cloneGeom(geom)))
        end
    end
    collection
end
