module LibGEOS

    if isfile(joinpath(dirname(@__FILE__),"..","deps","deps.jl"))
        include("../deps/deps.jl")
    else
        error("LibGEOS not properly installed. Please run Pkg.build(\"LibGEOS\")")
    end

    using GeoInterface
    import Base: contains

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

    type GEOSError <: Exception
        msg::String
    end
    Base.showerror(io::IO, err::GEOSError) = print(io, "GEOSError\n\t$(err.msg)")

    function geosjl_errorhandler(message::Ptr{UInt8}, userdata)
        if unsafe_string(message) == "%s"
            throw(GEOSError(unsafe_string(Cstring(userdata))))
        else
            throw(GEOSError(unsafe_string(message)))
        end
    end

    type GEOSconnection
        status::Symbol

        function GEOSconnection()
            connection = new(:Initialized)
            initializeGEOS(
                C_NULL,
                cfunction(geosjl_errorhandler,Ptr{Void},(Ptr{UInt8},Ptr{Void}))
            )
            finalizer(connection, finalizeGEOS)
            connection
        end
    end

    initializeGEOS(notice_f, error_f) = initGEOS(notice_f, error_f)
    function finalizeGEOS(connection::GEOSconnection)
        connection.status = :Finished
        finishGEOS()
    end

    _connection = GEOSconnection()

    include("geos_functions.jl")
    include("geos_types.jl")
    include("geos_operations.jl")
    include("geo_interface.jl")
end
