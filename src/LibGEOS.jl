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
            parseWKT, geomFromWKT, geomToWKT, readgeom, writegeom,
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

    mutable struct GEOSContext
        ptr::GEOSContextHandle_t

        function GEOSContext()
            context = new(GEOS_init_r())
            GEOSContext_setNoticeHandler_r(context.ptr, C_NULL)
            GEOSContext_setErrorHandler_r(context.ptr,
                cfunction(geosjl_errorhandler,Ptr{Void},(Ptr{UInt8},Ptr{Void}))
            )
            finalizer(context, context -> (GEOS_finish_r(context.ptr); context.ptr = C_NULL))
            context
        end
    end

    mutable struct WKTReader
        ptr::Ptr{GEOSWKTReader}

        function WKTReader(context::GEOSContext)
            reader = new(GEOSWKTReader_create_r(context.ptr))
            finalizer(reader, function(reader)
                GEOSWKTReader_destroy_r(context.ptr, reader.ptr)
                reader.ptr = C_NULL
            end)
            reader
        end
    end

    mutable struct WKTWriter
        ptr::Ptr{GEOSWKTWriter}

        function WKTWriter(context::GEOSContext; trim::Bool=true, outputdim::Int=3, roundingprecision::Int=-1)
            writer = new(GEOSWKTWriter_create_r(context.ptr))
            finalizer(writer, function(writer)
                GEOSWKTWriter_destroy_r(context.ptr, writer.ptr)
                GEOSWKTWriter_setTrim_r(context.ptr, writer.ptr, UInt8(trim))
                GEOSWKTWriter_setOutputDimension_r(context.ptr, writer.ptr, outputdim)
                GEOSWKTWriter_setRoundingPrecision_r(context.ptr, writer.ptr, roundingprecision)
                writer.ptr = C_NULL
            end)
            writer
        end
    end

    mutable struct WKBReader
        ptr::Ptr{GEOSWKBReader}

        function WKBReader(context::GEOSContext)
            reader = new(GEOSWKBReader_create_r(context.ptr))
            finalizer(reader, function(reader)
                GEOSWKBReader_destroy_r(context.ptr, reader.ptr)
                reader.ptr = C_NULL
            end)
            reader
        end
    end

    mutable struct WKBWriter
        ptr::Ptr{GEOSWKBWriter}

        function WKBWriter(context::GEOSContext)
            writer = new(GEOSWKBWriter_create_r(context.ptr))
            finalizer(writer, function(writer)
                GEOSWKBWriter_destroy_r(context.ptr, writer.ptr)
                writer.ptr = C_NULL
            end)
            writer
        end
    end

    function __init__()
        # Always check your dependencies from `deps.jl`
        check_deps()

        global const _context = GEOSContext()
    end

    include("geos_functions.jl")
    include("geos_types.jl")
    include("geos_operations.jl")
    include("geo_interface.jl")
end
