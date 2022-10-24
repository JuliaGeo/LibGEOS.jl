module LibGEOS

using GEOS_jll
using GeoInterface
using GeoInterfaceRecipes
using Extents
using CEnum

export Point,
    MultiPoint,
    LineString,
    MultiLineString,
    LinearRing,
    Polygon,
    MultiPolygon,
    GeometryCollection,
    readgeom,
    writegeom,
    project,
    projectNormalized,
    interpolate,
    interpolateNormalized,
    buffer,
    bufferWithStyle,
    envelope,
    intersection,
    convexhull,
    difference,
    symmetricDifference,
    boundary,
    union,
    unaryUnion,
    pointOnSurface,
    centroid,
    node,
    polygonize,
    lineMerge,
    simplify,
    topologyPreserveSimplify,
    uniquePoints,
    sharedPaths,
    snap,
    delaunayTriangulation,
    delaunayTriangulationEdges,
    constrainedDelaunayTriangulation,
    disjoint,
    touches,
    intersects,
    crosses,
    within,
    overlaps,
    equals,
    equalsexact,
    covers,
    coveredby,
    prepareGeom,
    prepcontains,
    prepcontainsproperly,
    prepcoveredby,
    prepcovers,
    prepcrosses,
    prepdisjoint,
    prepintersects,
    prepoverlaps,
    preptouches,
    prepwithin,
    isEmpty,
    isSimple,
    isRing,
    hasZ,
    isClosed,
    isValid,
    interiorRing,
    interiorRings,
    exteriorRing,
    numGeometries,
    numPoints,
    startPoint,
    endPoint,
    area,
    geomLength,
    distance,
    hausdorffdistance,
    nearestPoints,
    getPrecision,
    setPrecision,
    getXMin,
    getYMin,
    getXMax,
    getYMax,
    minimumRotatedRectangle,
    getGeometry,
    getGeometries,
    STRtree,
    query

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
    ptr::Ptr{Cvoid}  # GEOSContextHandle_t

    function GEOSContext()
        context = new(GEOS_init_r())
        GEOSContext_setNoticeHandler_r(context.ptr, C_NULL)
        GEOSContext_setErrorHandler_r(
            context.ptr,
            @cfunction(geosjl_errorhandler, Ptr{Cvoid}, (Ptr{UInt8}, Ptr{Cvoid}))
        )
        finalizer(context -> (GEOS_finish_r(context.ptr); context.ptr = C_NULL), context)
        context
    end
end

"Get a copy of a string from GEOS, freeing the GEOS managed memory."
function string_copy_free(s::Cstring, context::Ptr{Cvoid} = get_global_context().ptr)::String
    copy = unsafe_string(s)
    GEOSFree_r(context, pointer(s))
    return copy
end

include("libgeos_api.jl")

mutable struct WKTReader
    ptr::Ptr{GEOSWKTReader}

    function WKTReader(context::GEOSContext)
        reader = new(GEOSWKTReader_create_r(context.ptr))
        finalizer(function (reader)
            GEOSWKTReader_destroy_r(context.ptr, reader.ptr)
            reader.ptr = C_NULL
        end, reader)
        reader
    end
end

mutable struct WKTWriter
    ptr::Ptr{GEOSWKTWriter}

    function WKTWriter(
        context::GEOSContext;
        trim::Bool = true,
        outputdim::Int = 3,
        roundingprecision::Int = -1,
    )
        writer = new(GEOSWKTWriter_create_r(context.ptr))
        GEOSWKTWriter_setTrim_r(context.ptr, writer.ptr, UInt8(trim))
        GEOSWKTWriter_setOutputDimension_r(context.ptr, writer.ptr, outputdim)
        GEOSWKTWriter_setRoundingPrecision_r(context.ptr, writer.ptr, roundingprecision)
        finalizer(function (writer)
            GEOSWKTWriter_destroy_r(context.ptr, writer.ptr)
            writer.ptr = C_NULL
        end, writer)
        writer
    end
end

mutable struct WKBReader
    ptr::Ptr{GEOSWKBReader}

    function WKBReader(context::GEOSContext)
        reader = new(GEOSWKBReader_create_r(context.ptr))
        finalizer(function (reader)
            GEOSWKBReader_destroy_r(context.ptr, reader.ptr)
            reader.ptr = C_NULL
        end, reader)
        reader
    end
end

mutable struct WKBWriter
    ptr::Ptr{GEOSWKBWriter}

    function WKBWriter(context::GEOSContext)
        writer = new(GEOSWKBWriter_create_r(context.ptr))
        finalizer(function (writer)
            GEOSWKBWriter_destroy_r(context.ptr, writer.ptr)
            writer.ptr = C_NULL
        end, writer)
        writer
    end
end

const _GLOBAL_CONTEXT = Ref{GEOSContext}()
const _GLOBAL_CONTEXT_ALLOWED = Ref(false)

function get_global_context()::GEOSContext
    if _GLOBAL_CONTEXT_ALLOWED[]
        _GLOBAL_CONTEXT[]
    else
        msg = """
        LibGEOS global context disallowed, a GEOSContext must be passed explicitly.
        """
        error(msg)
    end
end

function allow_global_context!(bool::Bool)
    _GLOBAL_CONTEXT_ALLOWED[] = bool
end

function __init__()
    _GLOBAL_CONTEXT_ALLOWED[] = true
    _GLOBAL_CONTEXT[] = GEOSContext()
end

include("geos_functions.jl")
include("geos_types.jl")
include("geos_operations.jl")
include("geo_interface.jl")
include("strtree.jl")

end  # module
