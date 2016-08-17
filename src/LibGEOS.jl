module LibGEOS

    if isfile(joinpath(dirname(@__FILE__),"..","deps","deps.jl"))
        include("../deps/deps.jl")
    else
        error("LibGEOS not properly installed. Please run Pkg.build(\"LibGEOS\")")
    end

    using Compat, GeoInterface
    import Base: contains

    # normalize! was added in julia v0.5, for v0.4 extend Compat version
    if isdefined(Base, :normalize!)
        import Base: normalize!
    else
        import Compat: normalize!
        export normalize!
    end


    export  Point, MultiPoint, LineString, MultiLineString, LinearRing, Polygon, MultiPolygon, GeometryCollection,
            parseWKT, geomFromWKT, geomToWKT,
            project, projectNormalized, interpolate, interpolateNormalized,
            buffer, envelope, intersection, convexhull, difference, symmetricDifference,
            boundary, union, unaryUnion, pointOnSurface, centroid, node,
            polygonize, lineMerge, simplify, topologyPreserveSimplify, uniquePoints, sharedPaths,
            snap, delaunayTriangulation, delaunayTriangulationEdges,
            disjoint, touches, intersects, crosses, within, contains, overlaps, equals, equalsexact, covers, coveredby,
            prepareGeom, prepcontains, prepcontainsproperly, prepcoveredby, prepcovers, prepcrosses,
            prepdisjoint, prepintersects, prepoverlaps, preptouches, prepwithin,
            isEmpty, isSimple, isRing, hasZ, isClosed, isValid, interiorRings, exteriorRing,
            numPoints, startPoint, endPoint, area, geomLength, distance, hausdorffdistance, nearestPoints

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
