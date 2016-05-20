
for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    @eval geomToWKT(obj::$geom) = geomToWKT(obj.ptr)
end

function geomFromGEOS(ptr::GEOSGeom)
    if geomTypeId(ptr) == GEOS_POINT
        return Point(ptr)
    elseif geomTypeId(ptr) == GEOS_LINESTRING
        return LineString(ptr)
    elseif geomTypeId(ptr) == GEOS_LINEARRING
        return LinearRing(ptr)
    elseif geomTypeId(ptr) == GEOS_POLYGON
        return Polygon(ptr)
    elseif geomTypeId(ptr) == GEOS_MULTIPOINT
        return MultiPoint(ptr)
    elseif geomTypeId(ptr) == GEOS_MULTILINESTRING
        return MultiLineString(ptr)
    elseif geomTypeId(ptr) == GEOS_MULTIPOLYGON
        return MultiPolygon(ptr)
    else @assert geomTypeId(ptr) == GEOS_GEOMETRYCOLLECTION
        return GeometryCollection(ptr)
    end
end
parseWKT(geom::ASCIIString) = geomFromGEOS(geomFromWKT(geom))

# -----
# Linear referencing functions -- there are more, but these are probably sufficient for most purposes
# -----
project(line::LineString, point::Point) = project(line.ptr, point.ptr)
projectNormalized(line::LineString, point::Point) = projectprojectNormalized(line.ptr, point.ptr)
interpolate(line::LineString, dist::Real) = Point(interpolate(line.ptr, dist))
interpolateNormalized(line::LineString, dist::Real) = Point(interpolateNormalized(line.ptr, dist))

# # -----
# # Topology operations
# # -----
for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    @eval buffer(obj::$geom, dist::Real, quadsegs::Integer=8) = Polygon(buffer(obj.ptr, dist, quadsegs))
    @eval envelope(obj::$geom) = geomFromGEOS(envelope(obj.ptr))
    @eval convexhull(obj::$geom) = geomFromGEOS(convexhull(obj.ptr))
    @eval boundary(obj::$geom) = geomFromGEOS(boundary(obj.ptr))
    @eval unaryUnion(obj::$geom) = geomFromGEOS(unaryUnion(obj.ptr))
    @eval pointOnSurface(obj::$geom) = Point(pointOnSurface(obj.ptr))
    @eval centroid(obj::$geom) = Point(centroid(obj.ptr))
    @eval node(obj::$geom) = geomFromGEOS(node(obj.ptr))
end

for g1 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    for g2 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
        @eval intersection(obj1::$g1, obj2::$g2) = geomFromGEOS(intersection(obj1.ptr, obj2.ptr))
        @eval difference(obj1::$g1, obj2::$g2) = geomFromGEOS(difference(obj1.ptr, obj2.ptr))
        @eval symmetricDifference(obj1::$g1, obj2::$g2) = geomFromGEOS(symmetricDifference(obj1.ptr, obj2.ptr))
        @eval union(obj1::$g1, obj2::$g2) = geomFromGEOS(union(obj1.ptr, obj2.ptr))
    end
end

# # all arguments remain ownership of the caller (both Geometries and pointers)
# function polygonize(geoms::Vector{GEOSGeom})
#     result = GEOSPolygonize(pointer(geoms), length(geoms))
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSPolygonize")
#     end
#     result
# end
# # GEOSPolygonizer_getCutEdges
# # GEOSPolygonize_full

# function lineMerge(ptr::GEOSGeom)
#     result = GEOSLineMerge(ptr)
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSLineMerge")
#     end
#     result
# end

for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    @eval simplify(obj::$geom, tol::Real) = geomFromGEOS(simplify(obj.ptr, tol))
    @eval topologyPreserveSimplify(obj::$geom, tol::Real) = geomFromGEOS(topologyPreserveSimplify(obj.ptr, tol))
    @eval uniquePoints(obj::$geom) = MultiPoint(uniquePoints(obj.ptr))
    @eval delaunayTriangulationEdges(obj::$geom, tol::Real=0.0) = MultiLineString(delaunayTriangulation(obj.ptr, tol, true))
    @eval delaunayTriangulation(obj::$geom, tol::Real=0.0) = GeometryCollection(delaunayTriangulation(obj.ptr, tol, false))
end

sharedPaths(obj1::LineString, obj2::LineString) = GeometryCollection(sharedPaths(obj1.ptr, obj2.ptr))

# # Snap first geometry on to second with given tolerance
for g1 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    for g2 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
        @eval snap(obj1::$g1, obj2::$g2, tol::Real) = geomFromGEOS(snap(obj1.ptr, obj2.ptr, tol))
    end
end

# -----
# Binary predicates
# -----
for g1 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    for g2 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
        @eval disjoint(obj1::$g1, obj2::$g2) = disjoint(obj1.ptr, obj2.ptr)
        @eval touches(obj1::$g1, obj2::$g2) = touches(obj1.ptr, obj2.ptr)
        @eval intersects(obj1::$g1, obj2::$g2) = intersects(obj1.ptr, obj2.ptr)
        @eval crosses(obj1::$g1, obj2::$g2) = crosses(obj1.ptr, obj2.ptr)
        @eval within(obj1::$g1, obj2::$g2) = within(obj1.ptr, obj2.ptr)
        @eval contains(obj1::$g1, obj2::$g2) = contains(obj1.ptr, obj2.ptr)
        @eval overlaps(obj1::$g1, obj2::$g2) = overlaps(obj1.ptr, obj2.ptr)
        @eval equals(obj1::$g1, obj2::$g2) = equals(obj1.ptr, obj2.ptr)
        @eval equalsexact(obj1::$g1, obj2::$g2, tol::Real) = equalsexact(obj1.ptr, obj2.ptr, tol)
        @eval covers(obj1::$g1, obj2::$g2) = covers(obj1.ptr, obj2.ptr)
        @eval coveredby(obj1::$g1, obj2::$g2) = coveredby(obj1.ptr, obj2.ptr)
    end
end

# # -----
# # Prepared Geometry Binary predicates - return 2 on exception, 1 on true, 0 on false
# # -----

# # GEOSGeometry ownership is retained by caller
# function prepareGeom(ptr::GEOSGeom)
#     result = GEOSPrepare(ptr)
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSPrepare")
#     end
#     result
# end

# destroyPreparedGeom(ptr::Ptr{GEOSPreparedGeometry}) = GEOSPreparedGeom_destroy(ptr)

# function prepcontains(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
#     result = GEOSPreparedContains(g1, g2)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSPreparedContains")
#     end
#     bool(result)
# end

# function prepcontainsproperly(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
#     result = GEOSPreparedContainsProperly(g1, g2)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSPreparedContainsProperly")
#     end
#     bool(result)
# end

# function prepcoveredby(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
#     result = GEOSPreparedCoveredBy(g1, g2)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSPreparedCoveredBy")
#     end
#     bool(result)
# end

# function prepcovers(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
#     result = GEOSPreparedCovers(g1, g2)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSPreparedCovers")
#     end
#     bool(result)
# end

# function prepcrosses(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
#     result = GEOSPreparedCrosses(g1, g2)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSPreparedCrosses")
#     end
#     bool(result)
# end

# function prepdisjoint(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
#     result = GEOSPreparedDisjoint(g1, g2)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSPreparedDisjoint")
#     end
#     bool(result)
# end

# function prepintersects(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
#     result = GEOSPreparedIntersects(g1, g2)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSPreparedIntersects")
#     end
#     bool(result)
# end

# function prepoverlaps(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
#     result = GEOSPreparedOverlaps(g1, g2)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSPreparedOverlaps")
#     end
#     bool(result)
# end

# function preptouches(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
#     result = GEOSPreparedTouches(g1, g2)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSPreparedTouches")
#     end
#     bool(result)
# end

# function prepwithin(g1::Ptr{GEOSPreparedGeometry}, g2::GEOSGeom)
#     result = GEOSPreparedWithin(g1, g2)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSPreparedWithin")
#     end
#     bool(result)
# end

# # -----
# # STRtree functions
# # -----
# # GEOSSTRtree_create
# # GEOSSTRtree_insert
# # GEOSSTRtree_query
# # GEOSSTRtree_iterate
# # GEOSSTRtree_remove
# # GEOSSTRtree_destroy

# # -----
# # Unary predicate - return 2 on exception, 1 on true, 0 on false
# # -----
for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    @eval isEmpty(obj::$geom) = isEmpty(obj.ptr)
    @eval isSimple(obj::$geom) = isSimple(obj.ptr)
    @eval isRing(obj::$geom) = isRing(obj.ptr)
    @eval isValid(obj::$geom) = isValid(obj.ptr)
    @eval hasZ(obj::$geom) = hasZ(obj.ptr)
end

isClosed(obj::LineString) = isClosed(obj.ptr) # Call only on LINESTRING

# # -----
# # Dimensionally Extended 9 Intersection Model related
# # -----

# # GEOSRelatePattern (return 2 on exception, 1 on true, 0 on false)
# # GEOSRelate (return NULL on exception, a string to GEOSFree otherwise)
# # GEOSRelatePatternMatch (return 2 on exception, 1 on true, 0 on false)
# # GEOSRelateBoundaryNodeRule (return NULL on exception, a string to GEOSFree otherwise)

# # -----
# # Validity checking -- return 2 on exception, 1 on true, 0 on false
# # -----

# # /* These are for use with GEOSisValidDetail (flags param) */
# # enum GEOSValidFlags {
# #     GEOSVALID_ALLOW_SELFTOUCHING_RING_FORMING_HOLE=1
# # };

# # * return NULL on exception, a string to GEOSFree otherwise
# # GEOSisValidReason

# # * Caller has the responsibility to destroy 'reason' (GEOSFree)
# # * and 'location' (GEOSGeom_destroy) params
# # * return 2 on exception, 1 when valid, 0 when invalid
# # GEOSisValidDetail

# # -----
# # Geometry info
# # -----

# # May be called on all geometries in GEOS 3.x, returns -1 on error and 1
# # for non-multi geometries. Older GEOS versions only accept
# # GeometryCollections or Multi* geometries here, and are likely to crash
# # when fed simple geometries, so beware if you need compatibility with
# # old GEOS versions.
# function numGeometries(ptr::GEOSGeom)
#     result = GEOSGetNumGeometries(ptr)
#     if result == -1
#         error("LibGEOS: Error in GEOSGeomTypeId")
#     end
#     result
# end

# # Call only on GEOMETRYCOLLECTION or MULTI*
# # (Return a pointer to the internal Geometry. Return NULL on exception.)
# # Returned object is a pointer to internal storage:
# # it must NOT be destroyed directly.
# # Up to GEOS 3.2.0 the input geometry must be a Collection, in
# # later version it doesn't matter (i.e. getGeometryN(0) for a single will return the input).
# function getGeometry(ptr::GEOSGeom, n::Integer)
#     result = GEOSGetGeometryN(ptr, @compat(Int32(n-1)))
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSGetGeometryN")
#     end
#     result
# end
# getGeometries(ptr::GEOSGeom) = GEOSGeom[getGeometry(ptr, i) for i=1:numGeometries(ptr)]

# Converts Geometry to normal form (or canonical form).
for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    @eval normalize!(obj::$geom) = normalize!(obj.ptr)
end

# # Return -1 on exception, Geometry must be a Point.
# let out = Array(Float64, 1)
#     global getGeomX
#     function getGeomX(ptr::GEOSGeom)
#         result = GEOSGeomGetX(ptr, pointer(out))
#         if result == -1
#             error("LibGEOS: Error in GEOSGeomGetX")
#         end
#         out[1]
#     end
# end

# let out = Array(Float64, 1)
#     global getGeomY
#     function getGeomY(ptr::GEOSGeom)
#         result = GEOSGeomGetY(ptr, pointer(out))
#         if result == -1
#             error("LibGEOS: Error in GEOSGeomGetY")
#         end
#         out[1]
#     end
# end

interiorRings(obj::Polygon) = map(LinearRing, interiorRings(obj.ptr))
exteriorRing(obj::Polygon) = LinearRing(exteriorRing(obj.ptr))

# # Return -1 on exception
# function numCoordinates(ptr::GEOSGeom)
#     result = GEOSGetNumCoordinates(ptr)
#     if result == -1
#         error("LibGEOS: Error in GEOSGetNumCoordinates")
#     end
#     result
# end

# # Geometry must be a LineString, LinearRing or Point (Return NULL on exception)
# function getCoordSeq(ptr::GEOSGeom)
#     result = GEOSGeom_getCoordSeq(ptr)
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSGeom_getCoordSeq")
#     end
#     result
# end
# # getGeomCoordinates(ptr::GEOSGeom) = getCoordinates(getCoordSeq(ptr))

# # Return 0 on exception (or empty geometry)
# getGeomDimensions(ptr::GEOSGeom) = GEOSGeom_getDimensions(ptr)

# # Return 2 or 3.
# getCoordinateDimension(ptr::GEOSGeom) = int(GEOSGeom_getCoordinateDimension(ptr))

# # Call only on LINESTRING, and must be freed by caller (Returns NULL on exception)
# function getPoint(ptr::GEOSGeom, n::Integer)
#     result = GEOSGeomGetPointN(ptr, @compat(Int32(n-1)))
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSGeomGetPointN")
#     end
#     result
# end

numPoints(obj::LineString) = numPoints(obj.ptr) # Call only on LINESTRING
startPoint(obj::LineString) = Point(startPoint(obj.ptr)) # Call only on LINESTRING
endPoint(obj::LineString) = Point(endPoint(obj.ptr)) # Call only on LINESTRING

# # -----
# # Misc functions
# # -----
for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    @eval area(obj::$geom) = geomArea(obj.ptr)
    @eval geomLength(obj::$geom) = geomLength(obj.ptr)
end

for g1 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    for g2 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
        @eval distance(obj1::$g1, obj2::$g2) = geomDistance(obj1.ptr, obj2.ptr)
        @eval hausdorffdistance(obj1::$g1, obj2::$g2) = hausdorffdistance(obj1.ptr, obj2.ptr)
        @eval hausdorffdistance(obj1::$g1, obj2::$g2, densify::Real) = hausdorffdistance(obj1.ptr, obj2.ptr, densify)
    end
end

# Returns the closest points of the two geometries. The first point comes from g1 geometry and the second point comes from g2.
for g1 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    for g2 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
        @eval begin
            function nearestPoints(obj1::$g1, obj2::$g2)
                points = nearestPoints(obj1.ptr, obj2.ptr)
                if points == C_NULL
                    return Point[]
                else
                    return Point[Point(getCoordinates(points,1)),Point(getCoordinates(points,2))]
                end
            end
        end
    end
end

