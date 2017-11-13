__precompile__()

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

    mutable struct GEOScontext
        ptr::GEOSContextHandle_t

        function GEOScontext()
            context = new(GEOS_init_r())
            GEOSContext_setNoticeHandler_r(context.ptr, C_NULL)
            GEOSContext_setErrorHandler_r(context.ptr,
                cfunction(geosjl_errorhandler,Ptr{Void},(Ptr{UInt8},Ptr{Void}))
            )
            finalizer(context, context -> (GEOS_finish_r(context.ptr); context.ptr = C_NULL))
            context
        end
    end

    function __init__()
        global const _context = GEOScontext()
    end

    include("geos_functions.jl")
    include("geos_types.jl")
    include("geos_operations.jl")
    include("geo_interface.jl")
end
