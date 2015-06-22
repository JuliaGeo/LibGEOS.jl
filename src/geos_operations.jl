
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
interpolate(line::LineString, dist::Float64) = Point(interpolate(line.ptr, dist))
interpolateNormalized(line::LineString, dist::Float64) = Point(interpolateNormalized(line.ptr, dist))

# # -----
# # Topology operations
# # -----
for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
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
    @eval simplify(obj::$geom, tol::Float64) = geomFromGEOS(simplify(obj.ptr, tol))
    @eval topologyPreserveSimplify(obj::$geom, tol::Float64) = geomFromGEOS(topologyPreserveSimplify(obj.ptr, tol))
    @eval uniquePoints(obj::$geom) = MultiPoint(uniquePoints(obj.ptr))
end

sharedPaths(obj1::LineString, obj2::LineString) = GeometryCollection(sharedPaths(obj1.ptr, obj2.ptr))

# # Snap first geometry on to second with given tolerance
for g1 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    for g2 in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
        @eval snap(obj1::$g1, obj2::$g2, tol::Float64) = geomFromGEOS(snap(obj1.ptr, obj2.ptr, tol))
    end
end

# Return a Delaunay triangulation of the vertex of the given geometry
# @param g the input geometry whose vertex will be used as "sites"
# @param tolerance optional snapping tolerance to use for improved robustness
# @param onlyEdges if non-zero will return a MULTILINESTRING, otherwise it will
#                  return a GEOMETRYCOLLECTION containing triangular POLYGONs.
for geom in (:Point, :MultiPoint, :LineString, :MultiLineString, :LinearRing, :Polygon, :MultiPolygon, :GeometryCollection)
    @eval delaunayTriangulationEdges(obj::$geom, tol::Float64=0.0) = MultiLineString(delaunayTriangulation(obj.ptr, tol, true))
    @eval delaunayTriangulation(obj::$geom, tol::Float64=0.0) = GeometryCollection(delaunayTriangulation(obj.ptr, tol, false))
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
        @eval equalsexact(obj1::$g1, obj2::$g2, tol::Float64) = equalsexact(obj1.ptr, obj2.ptr, tol)
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
    @eval hasZ(obj::$geom) = hasZ(obj.ptr)
    @eval pointOnSurface(obj::$geom) = Point(pointOnSurface(obj.ptr))
    @eval centroid(obj::$geom) = Point(centroid(obj.ptr))
    @eval node(obj::$geom) = geomFromGEOS(node(obj.ptr))
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

# function isValid(ptr::GEOSGeom)
#     result = GEOSisValid(ptr)
#     if result == 0x02
#         error("LibGEOS: Error in GEOSisValid")
#     end
#     bool(result)
# end

# # * return NULL on exception, a string to GEOSFree otherwise
# # GEOSisValidReason

# # * Caller has the responsibility to destroy 'reason' (GEOSFree)
# # * and 'location' (GEOSGeom_destroy) params
# # * return 2 on exception, 1 when valid, 0 when invalid
# # GEOSisValidDetail

# # -----
# # Geometry info
# # -----

# # Return NULL on exception, result must be freed by caller
# # function geomType(ptr::GEOSGeom)
# #     result = GEOSGeomType(ptr)
# #     if result == C_NULL
# #         error("LibGEOS: Error in GEOSGeomType")
# #     end
# #     result
# # end

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
# function getGeometry(ptr::GEOSGeom, n::Int)
#     result = GEOSGetGeometryN(ptr, int32(n-1))
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

# # Return -1 on exception
# function numInteriorRings(ptr::GEOSGeom)
#     result = GEOSGetNumInteriorRings(ptr)
#     if result == -1
#         error("LibGEOS: Error in GEOSGetNumInteriorRings")
#     end
#     result
# end

# # Call only on LINESTRING (returns -1 on exception)
# function numPoints(ptr::GEOSGeom)
#     result = GEOSGeomGetNumPoints(ptr)
#     if result == -1
#         error("LibGEOS: Error in GEOSGeomGetNumPoints")
#     end
#     result
# end

# # Return -1 on exception, Geometry must be a Point.
# function getGeomX(ptr::GEOSGeom)
#     x = Array(Float64, 1)
#     result = GEOSGeomGetX(ptr, pointer(x))
#     if result == -1
#         error("LibGEOS: Error in GEOSGeomGetX")
#     end
#     x[1]
# end

# function getGeomY(ptr::GEOSGeom)
#     y = Array(Float64, 1)
#     result = GEOSGeomGetY(ptr, pointer(y))
#     if result == -1
#         error("LibGEOS: Error in GEOSGeomGetY")
#     end
#     y[1]
# end

# # Return NULL on exception, Geometry must be a Polygon.
# # Returned object is a pointer to internal storage: it must NOT be destroyed directly.
# function interiorRing(ptr::GEOSGeom, n::Int)
#     result = GEOSGetInteriorRingN(ptr, int32(n))
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSGetInteriorRingN")
#     end
#     result
# end

# function interiorRings(ptr::GEOSGeom)
#     n = numInteriorRings(ptr)
#     if n == 0
#         return GEOSGeom[]
#     else
#         return GEOSGeom[GEOSGetInteriorRingN(ptr, int32(i)) for i=0:n-1]
#     end
# end

# # Return NULL on exception, Geometry must be a Polygon.
# # Returned object is a pointer to internal storage: it must NOT be destroyed directly.
# function exteriorRing(ptr::GEOSGeom)
#     result = GEOSGetExteriorRing(ptr)
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSGetExteriorRing")
#     end
#     result
# end

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
# function getPoint(ptr::GEOSGeom, n::Int)
#     result = GEOSGeomGetPointN(ptr, int32(n-1))
#     if result == C_NULL
#         error("LibGEOS: Error in GEOSGeomGetPointN")
#     end
#     result
# end

startPoint(obj::LineString) = Point(startPoint(obj.ptr)) # Call only on LINESTRING
endPoint(obj::LineString) = Point(endPoint(obj.ptr)) # Call only on LINESTRING

# # -----
# # Misc functions
# # -----
# function geomArea(ptr::GEOSGeom)
#     area = Array(Float64, 1)
#     # Return 0 on exception, 1 otherwise
#     result = GEOSArea(ptr, pointer(area))
#     if result == 0
#         error("LibGEOS: Error in GEOSArea")
#     end
#     area[1]
# end

# function geomLength(ptr::GEOSGeom)
#     len = Array(Float64, 1)
#     # Return 0 on exception, 1 otherwise
#     result = GEOSLength(ptr, pointer(len))
#     if result == 0
#         error("LibGEOS: Error in GEOSLength")
#     end
#     len[1]
# end

# function geomDistance(g1::GEOSGeom, g2::GEOSGeom)
#     dist = Array(Float64, 1)
#     # Return 0 on exception, 1 otherwise
#     result = GEOSDistance(g1, g2, pointer(dist))
#     if result == 0
#         error("LibGEOS: Error in GEOSDistance")
#     end
#     dist[1]
# end

# function hausdorffdistance(g1::GEOSGeom, g2::GEOSGeom)
#     dist = Array(Float64, 1)
#     # Return 0 on exception, 1 otherwise
#     result = GEOSHausdorffDistance(g1, g2, pointer(dist))
#     if result == 0
#         error("LibGEOS: Error in GEOSHausdorffDistance")
#     end
#     dist[1]
# end

# function hausdorffdistance(g1::GEOSGeom, g2::GEOSGeom, densifyFrac::Float64)
#     dist = Array(Float64, 1)
#     # Return 0 on exception, 1 otherwise
#     result = GEOSHausdorffDistanceDensify(g1, g2, densifyFrac, pointer(dist))
#     if result == 0
#         error("LibGEOS: Error in GEOSHausdorffDistanceDensify")
#     end
#     dist[1]
# end

getLength(obj::LineString) = getLength(obj.ptr) # Call only on LINESTRING

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

