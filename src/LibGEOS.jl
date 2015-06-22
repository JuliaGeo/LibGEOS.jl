module LibGEOS

    @unix_only const libgeos = "libgeos_c"

    using Compat, GeoInterface, Docile
    @docstrings

    export  Point, LineString, MultiLineString, LinearRing, Polygon, MultiPolygon, GeometryCollection,
            parseWKT, geomFromWKT, geomToWKT,
            project, projectNormalized, interpolate, interpolateNormalized, 
            buffer, envelope, intersection, convexhull, difference, symmetricDifference,
            boundary, union, unaryUnion, pointOnSurface, centroid, node,
            polygonize, lineMerge, simplify, topologyPreserveSimplify, uniquePoints, sharedPaths,
            snap, delaunayTriangulation,
            disjoint, touches, intersects, crosses, within, contains, overlaps, equals, equalsexact, covers, coveredby, 
            prepareGeom, prepcontains, prepcontainsproperly, prepcoveredby, prepcovers, prepcrosses,
            prepdisjoint, prepintersects, prepoverlaps, preptouches, prepwithin,
            isEmpty, isSimple, isRing, hasZ, isClosed, isValid,
            normalize!, startPoint, endPoint, geomArea, geomLength, geomDistance, hausdorffdistance, getLength, nearestPoints



    include("geos_c.jl")
    
    #  --- GEOSconnection ---
    type GEOSconnection
        status::Symbol

        function GEOSconnection()
            geos_status = new(:Initialized)
            initializeGEOS()
            finalizer(geos_status, finalizeGEOS)
            geos_status
        end
    end
    initializeGEOS() = initGEOS(C_NULL, C_NULL)
    finalizeGEOS(status::GEOSconnection) = finishGEOS()

    _connection = GEOSconnection()
    # --- END GEOSconnection ---

    include("geos_functions.jl")
    include("geos_types.jl")
    include("geos_operations.jl")
    include("geo_interface.jl")
end