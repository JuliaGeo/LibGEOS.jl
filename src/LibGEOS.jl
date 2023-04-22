module LibGEOS

using GEOS_jll
using GeoInterface
using GeoInterfaceRecipes
using Extents
using CEnum

const GI = GeoInterface

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
    containsproperly,
    covers,
    coveredby,
    prepareGeom,
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

include("generated/libgeos_api.jl")
include("error.jl")
include("context.jl")
include("wellknown.jl")
include("geos_types.jl")
include("geos_functions.jl")
include("geo_interface.jl")
include("strtree.jl")
include("deprecated.jl")

function __init__()
    _GLOBAL_CONTEXT_ALLOWED[] = true
    _GLOBAL_CONTEXT[] = GEOSContext()
end

end  # module
