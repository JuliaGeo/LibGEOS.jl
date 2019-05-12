# Automatically generated using Clang.jl


const GEOS_VERSION_MAJOR = 3
const GEOS_VERSION_MINOR = 7
const GEOS_VERSION_PATCH = 2
const GEOS_VERSION = "3.7.2"
const GEOS_JTS_PORT = "1.13.0"
const GEOS_CAPI_VERSION_MAJOR = 1
const GEOS_CAPI_VERSION_MINOR = 11
const GEOS_CAPI_VERSION_PATCH = 2
const GEOS_CAPI_VERSION = "3.7.2-CAPI-1.11.2"
const GEOS_CAPI_FIRST_INTERFACE = GEOS_CAPI_VERSION_MAJOR
const GEOS_CAPI_LAST_INTERFACE = GEOS_CAPI_VERSION_MAJOR + GEOS_CAPI_VERSION_MINOR
const GEOS_PREC_NO_TOPO = 1 << 0
const GEOS_PREC_KEEP_COLLAPSED = 1 << 1
const GEOSContextHandle_HS = Cvoid
const GEOSContextHandle_t = Ptr{GEOSContextHandle_HS}
const GEOSMessageHandler = Ptr{Cvoid}
const GEOSMessageHandler_r = Ptr{Cvoid}
const GEOSGeom_t = Cvoid
const GEOSGeometry = GEOSGeom_t
const GEOSPrepGeom_t = Cvoid
const GEOSPreparedGeometry = GEOSPrepGeom_t
const GEOSCoordSeq_t = Cvoid
const GEOSCoordSequence = GEOSCoordSeq_t
const GEOSSTRtree_t = Cvoid
const GEOSSTRtree = GEOSSTRtree_t
const GEOSBufParams_t = Cvoid
const GEOSBufferParams = GEOSBufParams_t
const GEOSGeom = Ptr{GEOSGeometry}
const GEOSCoordSeq = Ptr{GEOSCoordSequence}

@cenum(GEOSGeomTypes,
    GEOS_POINT = 0,
    GEOS_LINESTRING = 1,
    GEOS_LINEARRING = 2,
    GEOS_POLYGON = 3,
    GEOS_MULTIPOINT = 4,
    GEOS_MULTILINESTRING = 5,
    GEOS_MULTIPOLYGON = 6,
    GEOS_GEOMETRYCOLLECTION = 7,
)
@cenum(GEOSByteOrders,
    GEOS_WKB_XDR = 0,
    GEOS_WKB_NDR = 1,
)

const GEOSQueryCallback = Ptr{Cvoid}
const GEOSDistanceCallback = Ptr{Cvoid}
const GEOSInterruptCallback = Cvoid

@cenum(GEOSBufCapStyles,
    GEOSBUF_CAP_ROUND = 1,
    GEOSBUF_CAP_FLAT = 2,
    GEOSBUF_CAP_SQUARE = 3,
)
@cenum(GEOSBufJoinStyles,
    GEOSBUF_JOIN_ROUND = 1,
    GEOSBUF_JOIN_MITRE = 2,
    GEOSBUF_JOIN_BEVEL = 3,
)
@cenum(GEOSRelateBoundaryNodeRules,
    GEOSRELATE_BNR_MOD2 = 1,
    GEOSRELATE_BNR_OGC = 1,
    GEOSRELATE_BNR_ENDPOINT = 2,
    GEOSRELATE_BNR_MULTIVALENT_ENDPOINT = 3,
    GEOSRELATE_BNR_MONOVALENT_ENDPOINT = 4,
)
@cenum(GEOSValidFlags,
    GEOSVALID_ALLOW_SELFTOUCHING_RING_FORMING_HOLE = 1,
)

const GEOSWKTReader_t = Cvoid
const GEOSWKTReader = GEOSWKTReader_t
const GEOSWKTWriter_t = Cvoid
const GEOSWKTWriter = GEOSWKTWriter_t
const GEOSWKBReader_t = Cvoid
const GEOSWKBReader = GEOSWKBReader_t
const GEOSWKBWriter_t = Cvoid
const GEOSWKBWriter = GEOSWKBWriter_t
