__precompile__()

module LibGEOS

    # Load in `deps.jl`, complaining if it does not exist
    const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
    if !isfile(depsjl_path)
        error("LibGEOS not installed properly, run Pkg.build(\"LibGEOS\"), restart Julia and try again")
    end
    include(depsjl_path)

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

    mutable struct GEOSError <: Exception
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

    mutable struct GEOSconnection
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

    function __init__()
        # Always check your dependencies from `deps.jl`
        check_deps()

        global const _connection = GEOSconnection()
    end

    include("geos_functions.jl")
    include("geos_types.jl")
    include("geos_operations.jl")
    include("geo_interface.jl")
end
