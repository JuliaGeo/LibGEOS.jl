const GEOSContextHandle_HS = Cvoid

const GEOSContextHandle_t = Ptr{GEOSContextHandle_HS}

# typedef void ( * GEOSMessageHandler ) ( GEOS_PRINTF_FORMAT const char * fmt , ... )
const GEOSMessageHandler = Ptr{Cvoid}

# typedef void ( * GEOSMessageHandler_r ) ( const char * message , void * userdata )
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

const GEOSCoverageCleanParams_t = Cvoid

const GEOSCoverageCleanParams = GEOSCoverageCleanParams_t

const GEOSMakeValidParams_t = Cvoid

const GEOSMakeValidParams = GEOSMakeValidParams_t

const GEOSClusterInfo_t = Cvoid

const GEOSClusterInfo = GEOSClusterInfo_t

const GEOSGeom = Ptr{GEOSGeometry}

const GEOSCoordSeq = Ptr{GEOSCoordSequence}

@cenum GEOSGeomTypes::UInt32 begin
    GEOS_POINT = 0
    GEOS_LINESTRING = 1
    GEOS_LINEARRING = 2
    GEOS_POLYGON = 3
    GEOS_MULTIPOINT = 4
    GEOS_MULTILINESTRING = 5
    GEOS_MULTIPOLYGON = 6
    GEOS_GEOMETRYCOLLECTION = 7
    GEOS_CIRCULARSTRING = 8
    GEOS_COMPOUNDCURVE = 9
    GEOS_CURVEPOLYGON = 10
    GEOS_MULTICURVE = 11
    GEOS_MULTISURFACE = 12
end

@cenum GEOSWKBByteOrders::UInt32 begin
    GEOS_WKB_XDR = 0
    GEOS_WKB_NDR = 1
end

@cenum GEOSWKBFlavors::UInt32 begin
    GEOS_WKB_EXTENDED = 1
    GEOS_WKB_ISO = 2
end

@cenum GEOSOverlapMerge::UInt32 begin
    GEOS_MERGE_LONGEST_BORDER = 0
    GEOS_MERGE_MAX_AREA = 1
    GEOS_MERGE_MIN_AREA = 2
    GEOS_MERGE_MIN_INDEX = 3
end

# typedef void ( * GEOSQueryCallback ) ( void * item , void * userdata )
const GEOSQueryCallback = Ptr{Cvoid}

# typedef int ( * GEOSDistanceCallback ) ( const void * item1 , const void * item2 , double * distance , void * userdata )
const GEOSDistanceCallback = Ptr{Cvoid}

# typedef int ( * GEOSTransformXYCallback ) ( double * x , double * y , void * userdata )
const GEOSTransformXYCallback = Ptr{Cvoid}

# typedef int ( * GEOSTransformXYZCallback ) ( double * x , double * y , double * z , void * userdata )
const GEOSTransformXYZCallback = Ptr{Cvoid}

# typedef void ( GEOSInterruptCallback ) ( void )
const GEOSInterruptCallback = Cvoid

# typedef int ( GEOSContextInterruptCallback ) ( void * )
const GEOSContextInterruptCallback = Cvoid

function GEOS_interruptRegisterCallback(cb)
    @ccall libgeos.GEOS_interruptRegisterCallback(
        cb::Ptr{GEOSInterruptCallback},
    )::Ptr{GEOSInterruptCallback}
end

function GEOSContext_setInterruptCallback_r(extHandle, cb, userData)
    @ccall libgeos.GEOSContext_setInterruptCallback_r(
        extHandle::GEOSContextHandle_t,
        cb::Ptr{GEOSContextInterruptCallback},
        userData::Ptr{Cvoid},
    )::Ptr{GEOSContextInterruptCallback}
end

function GEOS_interruptRequest()
    @ccall libgeos.GEOS_interruptRequest()::Cvoid
end

function GEOS_interruptThread()
    @ccall libgeos.GEOS_interruptThread()::Cvoid
end

function GEOS_interruptCancel()
    @ccall libgeos.GEOS_interruptCancel()::Cvoid
end

function GEOS_init_r()
    @ccall libgeos.GEOS_init_r()::GEOSContextHandle_t
end

function GEOS_finish_r(handle)
    @ccall libgeos.GEOS_finish_r(handle::GEOSContextHandle_t)::Cvoid
end

function GEOSContext_setNoticeHandler_r(extHandle, nf)
    @ccall libgeos.GEOSContext_setNoticeHandler_r(
        extHandle::GEOSContextHandle_t,
        nf::GEOSMessageHandler,
    )::GEOSMessageHandler
end

function GEOSContext_setErrorHandler_r(extHandle, ef)
    @ccall libgeos.GEOSContext_setErrorHandler_r(
        extHandle::GEOSContextHandle_t,
        ef::GEOSMessageHandler,
    )::GEOSMessageHandler
end

function GEOSContext_setNoticeMessageHandler_r(extHandle, nf, userData)
    @ccall libgeos.GEOSContext_setNoticeMessageHandler_r(
        extHandle::GEOSContextHandle_t,
        nf::GEOSMessageHandler_r,
        userData::Ptr{Cvoid},
    )::GEOSMessageHandler_r
end

function GEOSContext_setErrorMessageHandler_r(extHandle, ef, userData)
    @ccall libgeos.GEOSContext_setErrorMessageHandler_r(
        extHandle::GEOSContextHandle_t,
        ef::GEOSMessageHandler_r,
        userData::Ptr{Cvoid},
    )::GEOSMessageHandler_r
end

function GEOSCoordSeq_create_r(handle, size, dims)
    @ccall libgeos.GEOSCoordSeq_create_r(
        handle::GEOSContextHandle_t,
        size::Cuint,
        dims::Cuint,
    )::Ptr{GEOSCoordSequence}
end

function GEOSCoordSeq_createWithDimensions_r(handle, size, hasZ, hasM)
    @ccall libgeos.GEOSCoordSeq_createWithDimensions_r(
        handle::GEOSContextHandle_t,
        size::Cuint,
        hasZ::Cint,
        hasM::Cint,
    )::Ptr{GEOSCoordSequence}
end

function GEOSCoordSeq_copyFromBuffer_r(handle, buf, size, hasZ, hasM)
    @ccall libgeos.GEOSCoordSeq_copyFromBuffer_r(
        handle::GEOSContextHandle_t,
        buf::Ptr{Cdouble},
        size::Cuint,
        hasZ::Cint,
        hasM::Cint,
    )::Ptr{GEOSCoordSequence}
end

function GEOSCoordSeq_copyFromArrays_r(handle, x, y, z, m, size)
    @ccall libgeos.GEOSCoordSeq_copyFromArrays_r(
        handle::GEOSContextHandle_t,
        x::Ptr{Cdouble},
        y::Ptr{Cdouble},
        z::Ptr{Cdouble},
        m::Ptr{Cdouble},
        size::Cuint,
    )::Ptr{GEOSCoordSequence}
end

function GEOSCoordSeq_copyToBuffer_r(handle, s, buf, hasZ, hasM)
    @ccall libgeos.GEOSCoordSeq_copyToBuffer_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        buf::Ptr{Cdouble},
        hasZ::Cint,
        hasM::Cint,
    )::Cint
end

function GEOSCoordSeq_copyToArrays_r(handle, s, x, y, z, m)
    @ccall libgeos.GEOSCoordSeq_copyToArrays_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        x::Ptr{Cdouble},
        y::Ptr{Cdouble},
        z::Ptr{Cdouble},
        m::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_clone_r(handle, s)
    @ccall libgeos.GEOSCoordSeq_clone_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
    )::Ptr{GEOSCoordSequence}
end

function GEOSCoordSeq_destroy_r(handle, s)
    @ccall libgeos.GEOSCoordSeq_destroy_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
    )::Cvoid
end

function GEOSCoordSeq_hasZ_r(handle, s)
    @ccall libgeos.GEOSCoordSeq_hasZ_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
    )::Cchar
end

function GEOSCoordSeq_hasM_r(handle, s)
    @ccall libgeos.GEOSCoordSeq_hasM_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
    )::Cchar
end

function GEOSCoordSeq_setX_r(handle, s, idx, val)
    @ccall libgeos.GEOSCoordSeq_setX_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setY_r(handle, s, idx, val)
    @ccall libgeos.GEOSCoordSeq_setY_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setZ_r(handle, s, idx, val)
    @ccall libgeos.GEOSCoordSeq_setZ_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setM_r(handle, s, idx, val)
    @ccall libgeos.GEOSCoordSeq_setM_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setXY_r(handle, s, idx, x, y)
    @ccall libgeos.GEOSCoordSeq_setXY_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        x::Cdouble,
        y::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setXYZ_r(handle, s, idx, x, y, z)
    @ccall libgeos.GEOSCoordSeq_setXYZ_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        x::Cdouble,
        y::Cdouble,
        z::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setOrdinate_r(handle, s, idx, dim, val)
    @ccall libgeos.GEOSCoordSeq_setOrdinate_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        dim::Cuint,
        val::Cdouble,
    )::Cint
end

function GEOSCoordSeq_getX_r(handle, s, idx, val)
    @ccall libgeos.GEOSCoordSeq_getX_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getY_r(handle, s, idx, val)
    @ccall libgeos.GEOSCoordSeq_getY_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getZ_r(handle, s, idx, val)
    @ccall libgeos.GEOSCoordSeq_getZ_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getM_r(handle, s, idx, val)
    @ccall libgeos.GEOSCoordSeq_getM_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getXY_r(handle, s, idx, x, y)
    @ccall libgeos.GEOSCoordSeq_getXY_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        x::Ptr{Cdouble},
        y::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getXYZ_r(handle, s, idx, x, y, z)
    @ccall libgeos.GEOSCoordSeq_getXYZ_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        x::Ptr{Cdouble},
        y::Ptr{Cdouble},
        z::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getOrdinate_r(handle, s, idx, dim, val)
    @ccall libgeos.GEOSCoordSeq_getOrdinate_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        dim::Cuint,
        val::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getSize_r(handle, s, size)
    @ccall libgeos.GEOSCoordSeq_getSize_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        size::Ptr{Cuint},
    )::Cint
end

function GEOSCoordSeq_getDimensions_r(handle, s, dims)
    @ccall libgeos.GEOSCoordSeq_getDimensions_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        dims::Ptr{Cuint},
    )::Cint
end

function GEOSCoordSeq_isCCW_r(handle, s, is_ccw)
    @ccall libgeos.GEOSCoordSeq_isCCW_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
        is_ccw::Cstring,
    )::Cint
end

function GEOSProject_r(handle, line, point)
    @ccall libgeos.GEOSProject_r(
        handle::GEOSContextHandle_t,
        line::Ptr{GEOSGeometry},
        point::Ptr{GEOSGeometry},
    )::Cdouble
end

function GEOSInterpolate_r(handle, line, d)
    @ccall libgeos.GEOSInterpolate_r(
        handle::GEOSContextHandle_t,
        line::Ptr{GEOSGeometry},
        d::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSProjectNormalized_r(handle, g, p)
    @ccall libgeos.GEOSProjectNormalized_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        p::Ptr{GEOSGeometry},
    )::Cdouble
end

function GEOSInterpolateNormalized_r(handle, g, d)
    @ccall libgeos.GEOSInterpolateNormalized_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        d::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSBuffer_r(handle, g, width, quadsegs)
    @ccall libgeos.GEOSBuffer_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        width::Cdouble,
        quadsegs::Cint,
    )::Ptr{GEOSGeometry}
end

@cenum GEOSBufCapStyles::UInt32 begin
    GEOSBUF_CAP_ROUND = 1
    GEOSBUF_CAP_FLAT = 2
    GEOSBUF_CAP_SQUARE = 3
end

@cenum GEOSBufJoinStyles::UInt32 begin
    GEOSBUF_JOIN_ROUND = 1
    GEOSBUF_JOIN_MITRE = 2
    GEOSBUF_JOIN_BEVEL = 3
end

function GEOSBufferParams_create_r(handle)
    @ccall libgeos.GEOSBufferParams_create_r(
        handle::GEOSContextHandle_t,
    )::Ptr{GEOSBufferParams}
end

function GEOSBufferParams_destroy_r(handle, parms)
    @ccall libgeos.GEOSBufferParams_destroy_r(
        handle::GEOSContextHandle_t,
        parms::Ptr{GEOSBufferParams},
    )::Cvoid
end

function GEOSBufferParams_setEndCapStyle_r(handle, p, style)
    @ccall libgeos.GEOSBufferParams_setEndCapStyle_r(
        handle::GEOSContextHandle_t,
        p::Ptr{GEOSBufferParams},
        style::Cint,
    )::Cint
end

function GEOSBufferParams_setJoinStyle_r(handle, p, joinStyle)
    @ccall libgeos.GEOSBufferParams_setJoinStyle_r(
        handle::GEOSContextHandle_t,
        p::Ptr{GEOSBufferParams},
        joinStyle::Cint,
    )::Cint
end

function GEOSBufferParams_setMitreLimit_r(handle, p, mitreLimit)
    @ccall libgeos.GEOSBufferParams_setMitreLimit_r(
        handle::GEOSContextHandle_t,
        p::Ptr{GEOSBufferParams},
        mitreLimit::Cdouble,
    )::Cint
end

function GEOSBufferParams_setQuadrantSegments_r(handle, p, quadSegs)
    @ccall libgeos.GEOSBufferParams_setQuadrantSegments_r(
        handle::GEOSContextHandle_t,
        p::Ptr{GEOSBufferParams},
        quadSegs::Cint,
    )::Cint
end

function GEOSBufferParams_setSingleSided_r(handle, p, singleSided)
    @ccall libgeos.GEOSBufferParams_setSingleSided_r(
        handle::GEOSContextHandle_t,
        p::Ptr{GEOSBufferParams},
        singleSided::Cint,
    )::Cint
end

function GEOSBufferWithParams_r(handle, g, p, width)
    @ccall libgeos.GEOSBufferWithParams_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        p::Ptr{GEOSBufferParams},
        width::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSBufferWithStyle_r(
    handle,
    g,
    width,
    quadsegs,
    endCapStyle,
    joinStyle,
    mitreLimit,
)
    @ccall libgeos.GEOSBufferWithStyle_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        width::Cdouble,
        quadsegs::Cint,
        endCapStyle::Cint,
        joinStyle::Cint,
        mitreLimit::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSDensify_r(handle, g, tolerance)
    @ccall libgeos.GEOSDensify_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSOffsetCurve_r(handle, g, width, quadsegs, joinStyle, mitreLimit)
    @ccall libgeos.GEOSOffsetCurve_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        width::Cdouble,
        quadsegs::Cint,
        joinStyle::Cint,
        mitreLimit::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createPoint_r(handle, s)
    @ccall libgeos.GEOSGeom_createPoint_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createPointFromXY_r(handle, x, y)
    @ccall libgeos.GEOSGeom_createPointFromXY_r(
        handle::GEOSContextHandle_t,
        x::Cdouble,
        y::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createEmptyPoint_r(handle)
    @ccall libgeos.GEOSGeom_createEmptyPoint_r(
        handle::GEOSContextHandle_t,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createLinearRing_r(handle, s)
    @ccall libgeos.GEOSGeom_createLinearRing_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createLineString_r(handle, s)
    @ccall libgeos.GEOSGeom_createLineString_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createEmptyLineString_r(handle)
    @ccall libgeos.GEOSGeom_createEmptyLineString_r(
        handle::GEOSContextHandle_t,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createEmptyPolygon_r(handle)
    @ccall libgeos.GEOSGeom_createEmptyPolygon_r(
        handle::GEOSContextHandle_t,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createPolygon_r(handle, shell, holes, nholes)
    @ccall libgeos.GEOSGeom_createPolygon_r(
        handle::GEOSContextHandle_t,
        shell::Ptr{GEOSGeometry},
        holes::Ptr{Ptr{GEOSGeometry}},
        nholes::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createCollection_r(handle, type, geoms, ngeoms)
    @ccall libgeos.GEOSGeom_createCollection_r(
        handle::GEOSContextHandle_t,
        type::Cint,
        geoms::Ptr{Ptr{GEOSGeometry}},
        ngeoms::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_releaseCollection_r(handle, collection, ngeoms)
    @ccall libgeos.GEOSGeom_releaseCollection_r(
        handle::GEOSContextHandle_t,
        collection::Ptr{GEOSGeometry},
        ngeoms::Ptr{Cuint},
    )::Ptr{Ptr{GEOSGeometry}}
end

function GEOSGeom_createEmptyCollection_r(handle, type)
    @ccall libgeos.GEOSGeom_createEmptyCollection_r(
        handle::GEOSContextHandle_t,
        type::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createRectangle_r(handle, xmin, ymin, xmax, ymax)
    @ccall libgeos.GEOSGeom_createRectangle_r(
        handle::GEOSContextHandle_t,
        xmin::Cdouble,
        ymin::Cdouble,
        xmax::Cdouble,
        ymax::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_clone_r(handle, g)
    @ccall libgeos.GEOSGeom_clone_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createCircularString_r(handle, s)
    @ccall libgeos.GEOSGeom_createCircularString_r(
        handle::GEOSContextHandle_t,
        s::Ptr{GEOSCoordSequence},
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createEmptyCircularString_r(handle)
    @ccall libgeos.GEOSGeom_createEmptyCircularString_r(
        handle::GEOSContextHandle_t,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createCompoundCurve_r(handle, curves, ncurves)
    @ccall libgeos.GEOSGeom_createCompoundCurve_r(
        handle::GEOSContextHandle_t,
        curves::Ptr{Ptr{GEOSGeometry}},
        ncurves::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createEmptyCompoundCurve_r(handle)
    @ccall libgeos.GEOSGeom_createEmptyCompoundCurve_r(
        handle::GEOSContextHandle_t,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createCurvePolygon_r(handle, shell, holes, nholes)
    @ccall libgeos.GEOSGeom_createCurvePolygon_r(
        handle::GEOSContextHandle_t,
        shell::Ptr{GEOSGeometry},
        holes::Ptr{Ptr{GEOSGeometry}},
        nholes::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createEmptyCurvePolygon_r(handle)
    @ccall libgeos.GEOSGeom_createEmptyCurvePolygon_r(
        handle::GEOSContextHandle_t,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_destroy_r(handle, g)
    @ccall libgeos.GEOSGeom_destroy_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Cvoid
end

function GEOSCoverageUnion_r(handle, g)
    @ccall libgeos.GEOSCoverageUnion_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSCoverageIsValid_r(extHandle, input, gapWidth, output)
    @ccall libgeos.GEOSCoverageIsValid_r(
        extHandle::GEOSContextHandle_t,
        input::Ptr{GEOSGeometry},
        gapWidth::Cdouble,
        output::Ptr{Ptr{GEOSGeometry}},
    )::Cint
end

function GEOSCoverageSimplifyVW_r(extHandle, input, tolerance, preserveBoundary)
    @ccall libgeos.GEOSCoverageSimplifyVW_r(
        extHandle::GEOSContextHandle_t,
        input::Ptr{GEOSGeometry},
        tolerance::Cdouble,
        preserveBoundary::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSCoverageCleanParams_create_r(extHandle)
    @ccall libgeos.GEOSCoverageCleanParams_create_r(
        extHandle::GEOSContextHandle_t,
    )::Ptr{GEOSCoverageCleanParams}
end

function GEOSCoverageCleanParams_destroy_r(extHandle, params)
    @ccall libgeos.GEOSCoverageCleanParams_destroy_r(
        extHandle::GEOSContextHandle_t,
        params::Ptr{GEOSCoverageCleanParams},
    )::Cvoid
end

function GEOSCoverageCleanParams_setSnappingDistance_r(extHandle, params, snappingDistance)
    @ccall libgeos.GEOSCoverageCleanParams_setSnappingDistance_r(
        extHandle::GEOSContextHandle_t,
        params::Ptr{GEOSCoverageCleanParams},
        snappingDistance::Cdouble,
    )::Cint
end

function GEOSCoverageCleanParams_setGapMaximumWidth_r(extHandle, params, gapMaximumWidth)
    @ccall libgeos.GEOSCoverageCleanParams_setGapMaximumWidth_r(
        extHandle::GEOSContextHandle_t,
        params::Ptr{GEOSCoverageCleanParams},
        gapMaximumWidth::Cdouble,
    )::Cint
end

function GEOSCoverageCleanParams_setOverlapMergeStrategy_r(
    extHandle,
    params,
    overlapMergeStrategy,
)
    @ccall libgeos.GEOSCoverageCleanParams_setOverlapMergeStrategy_r(
        extHandle::GEOSContextHandle_t,
        params::Ptr{GEOSCoverageCleanParams},
        overlapMergeStrategy::Cint,
    )::Cint
end

function GEOSCoverageCleanWithParams_r(extHandle, input, params)
    @ccall libgeos.GEOSCoverageCleanWithParams_r(
        extHandle::GEOSContextHandle_t,
        input::Ptr{GEOSGeometry},
        params::Ptr{GEOSCoverageCleanParams},
    )::Ptr{GEOSGeometry}
end

function GEOSCoverageClean_r(extHandle, input)
    @ccall libgeos.GEOSCoverageClean_r(
        extHandle::GEOSContextHandle_t,
        input::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSEnvelope_r(handle, g)
    @ccall libgeos.GEOSEnvelope_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSIntersection_r(handle, g1, g2)
    @ccall libgeos.GEOSIntersection_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSIntersectionPrec_r(handle, g1, g2, gridSize)
    @ccall libgeos.GEOSIntersectionPrec_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        gridSize::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSConvexHull_r(handle, g)
    @ccall libgeos.GEOSConvexHull_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSConcaveHull_r(handle, g, ratio, allowHoles)
    @ccall libgeos.GEOSConcaveHull_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        ratio::Cdouble,
        allowHoles::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSConcaveHullByLength_r(handle, g, ratio, allowHoles)
    @ccall libgeos.GEOSConcaveHullByLength_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        ratio::Cdouble,
        allowHoles::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSPolygonHullSimplify_r(handle, g, isOuter, vertexNumFraction)
    @ccall libgeos.GEOSPolygonHullSimplify_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        isOuter::Cuint,
        vertexNumFraction::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSPolygonHullSimplifyMode_r(handle, g, isOuter, parameterMode, parameter)
    @ccall libgeos.GEOSPolygonHullSimplifyMode_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        isOuter::Cuint,
        parameterMode::Cuint,
        parameter::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSConcaveHullOfPolygons_r(handle, g, lengthRatio, isTight, isHolesAllowed)
    @ccall libgeos.GEOSConcaveHullOfPolygons_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        lengthRatio::Cdouble,
        isTight::Cuint,
        isHolesAllowed::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSMinimumRotatedRectangle_r(handle, g)
    @ccall libgeos.GEOSMinimumRotatedRectangle_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSMaximumInscribedCircle_r(handle, g, tolerance)
    @ccall libgeos.GEOSMaximumInscribedCircle_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSLargestEmptyCircle_r(handle, g, boundary, tolerance)
    @ccall libgeos.GEOSLargestEmptyCircle_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        boundary::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSMinimumWidth_r(handle, g)
    @ccall libgeos.GEOSMinimumWidth_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSMinimumClearanceLine_r(handle, g)
    @ccall libgeos.GEOSMinimumClearanceLine_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSMinimumClearance_r(handle, g, distance)
    @ccall libgeos.GEOSMinimumClearance_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        distance::Ptr{Cdouble},
    )::Cint
end

function GEOSDifference_r(handle, g1, g2)
    @ccall libgeos.GEOSDifference_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSDifferencePrec_r(handle, g1, g2, gridSize)
    @ccall libgeos.GEOSDifferencePrec_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        gridSize::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSSymDifference_r(handle, g1, g2)
    @ccall libgeos.GEOSSymDifference_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSSymDifferencePrec_r(handle, g1, g2, gridSize)
    @ccall libgeos.GEOSSymDifferencePrec_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        gridSize::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSBoundary_r(handle, g)
    @ccall libgeos.GEOSBoundary_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSUnion_r(handle, g1, g2)
    @ccall libgeos.GEOSUnion_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSUnionPrec_r(handle, g1, g2, gridSize)
    @ccall libgeos.GEOSUnionPrec_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        gridSize::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSUnaryUnion_r(handle, g)
    @ccall libgeos.GEOSUnaryUnion_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSUnaryUnionPrec_r(handle, g, gridSize)
    @ccall libgeos.GEOSUnaryUnionPrec_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        gridSize::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSDisjointSubsetUnion_r(handle, g)
    @ccall libgeos.GEOSDisjointSubsetUnion_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSPointOnSurface_r(handle, g)
    @ccall libgeos.GEOSPointOnSurface_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSGetCentroid_r(handle, g)
    @ccall libgeos.GEOSGetCentroid_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSMinimumBoundingCircle_r(handle, g, radius, center)
    @ccall libgeos.GEOSMinimumBoundingCircle_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        radius::Ptr{Cdouble},
        center::Ptr{Ptr{GEOSGeometry}},
    )::Ptr{GEOSGeometry}
end

function GEOSNode_r(handle, g)
    @ccall libgeos.GEOSNode_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSClipByRect_r(handle, g, xmin, ymin, xmax, ymax)
    @ccall libgeos.GEOSClipByRect_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        xmin::Cdouble,
        ymin::Cdouble,
        xmax::Cdouble,
        ymax::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSGridIntersectionFractions_r(handle, g, xmin, ymin, xmax, ymax, nx, ny, buf)
    @ccall libgeos.GEOSGridIntersectionFractions_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        xmin::Cdouble,
        ymin::Cdouble,
        xmax::Cdouble,
        ymax::Cdouble,
        nx::Cuint,
        ny::Cuint,
        buf::Ptr{Cfloat},
    )::Cint
end

function GEOSPolygonize_r(handle, geoms, ngeoms)
    @ccall libgeos.GEOSPolygonize_r(
        handle::GEOSContextHandle_t,
        geoms::Ptr{Ptr{GEOSGeometry}},
        ngeoms::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSPolygonize_valid_r(handle, geoms, ngems)
    @ccall libgeos.GEOSPolygonize_valid_r(
        handle::GEOSContextHandle_t,
        geoms::Ptr{Ptr{GEOSGeometry}},
        ngems::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSPolygonizer_getCutEdges_r(handle, geoms, ngeoms)
    @ccall libgeos.GEOSPolygonizer_getCutEdges_r(
        handle::GEOSContextHandle_t,
        geoms::Ptr{Ptr{GEOSGeometry}},
        ngeoms::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSPolygonize_full_r(handle, input, cuts, dangles, invalidRings)
    @ccall libgeos.GEOSPolygonize_full_r(
        handle::GEOSContextHandle_t,
        input::Ptr{GEOSGeometry},
        cuts::Ptr{Ptr{GEOSGeometry}},
        dangles::Ptr{Ptr{GEOSGeometry}},
        invalidRings::Ptr{Ptr{GEOSGeometry}},
    )::Ptr{GEOSGeometry}
end

function GEOSBuildArea_r(handle, g)
    @ccall libgeos.GEOSBuildArea_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSLineMerge_r(handle, g)
    @ccall libgeos.GEOSLineMerge_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSLineMergeDirected_r(handle, g)
    @ccall libgeos.GEOSLineMergeDirected_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSLineSubstring_r(handle, g, start_fraction, end_fdraction)
    @ccall libgeos.GEOSLineSubstring_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        start_fraction::Cdouble,
        end_fdraction::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSReverse_r(handle, g)
    @ccall libgeos.GEOSReverse_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSSimplify_r(handle, g, tolerance)
    @ccall libgeos.GEOSSimplify_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSTopologyPreserveSimplify_r(handle, g, tolerance)
    @ccall libgeos.GEOSTopologyPreserveSimplify_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_extractUniquePoints_r(handle, g)
    @ccall libgeos.GEOSGeom_extractUniquePoints_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSSharedPaths_r(handle, g1, g2)
    @ccall libgeos.GEOSSharedPaths_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSSnap_r(handle, g1, g2, tolerance)
    @ccall libgeos.GEOSSnap_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSDelaunayTriangulation_r(handle, g, tolerance, onlyEdges)
    @ccall libgeos.GEOSDelaunayTriangulation_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        tolerance::Cdouble,
        onlyEdges::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSConstrainedDelaunayTriangulation_r(handle, g)
    @ccall libgeos.GEOSConstrainedDelaunayTriangulation_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSVoronoiDiagram_r(extHandle, g, env, tolerance, flags)
    @ccall libgeos.GEOSVoronoiDiagram_r(
        extHandle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        env::Ptr{GEOSGeometry},
        tolerance::Cdouble,
        flags::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSSegmentIntersection_r(
    extHandle,
    ax0,
    ay0,
    ax1,
    ay1,
    bx0,
    by0,
    bx1,
    by1,
    cx,
    cy,
)
    @ccall libgeos.GEOSSegmentIntersection_r(
        extHandle::GEOSContextHandle_t,
        ax0::Cdouble,
        ay0::Cdouble,
        ax1::Cdouble,
        ay1::Cdouble,
        bx0::Cdouble,
        by0::Cdouble,
        bx1::Cdouble,
        by1::Cdouble,
        cx::Ptr{Cdouble},
        cy::Ptr{Cdouble},
    )::Cint
end

function GEOSDisjoint_r(handle, g1, g2)
    @ccall libgeos.GEOSDisjoint_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSTouches_r(handle, g1, g2)
    @ccall libgeos.GEOSTouches_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSIntersects_r(handle, g1, g2)
    @ccall libgeos.GEOSIntersects_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSCrosses_r(handle, g1, g2)
    @ccall libgeos.GEOSCrosses_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSWithin_r(handle, g1, g2)
    @ccall libgeos.GEOSWithin_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSContains_r(handle, g1, g2)
    @ccall libgeos.GEOSContains_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSOverlaps_r(handle, g1, g2)
    @ccall libgeos.GEOSOverlaps_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSEquals_r(handle, g1, g2)
    @ccall libgeos.GEOSEquals_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSEqualsExact_r(handle, g1, g2, tolerance)
    @ccall libgeos.GEOSEqualsExact_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Cchar
end

function GEOSEqualsIdentical_r(handle, g1, g2)
    @ccall libgeos.GEOSEqualsIdentical_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSCovers_r(handle, g1, g2)
    @ccall libgeos.GEOSCovers_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSCoveredBy_r(handle, g1, g2)
    @ccall libgeos.GEOSCoveredBy_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPrepare_r(handle, g)
    @ccall libgeos.GEOSPrepare_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSPreparedGeometry}
end

function GEOSPreparedGeom_destroy_r(handle, g)
    @ccall libgeos.GEOSPreparedGeom_destroy_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSPreparedGeometry},
    )::Cvoid
end

function GEOSPreparedContains_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedContains_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedContainsXY_r(handle, pg1, x, y)
    @ccall libgeos.GEOSPreparedContainsXY_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        x::Cdouble,
        y::Cdouble,
    )::Cchar
end

function GEOSPreparedContainsProperly_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedContainsProperly_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedCoveredBy_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedCoveredBy_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedCovers_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedCovers_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedCrosses_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedCrosses_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedDisjoint_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedDisjoint_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedIntersects_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedIntersects_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedIntersectsXY_r(handle, pg1, x, y)
    @ccall libgeos.GEOSPreparedIntersectsXY_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        x::Cdouble,
        y::Cdouble,
    )::Cchar
end

function GEOSPreparedOverlaps_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedOverlaps_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedTouches_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedTouches_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedWithin_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedWithin_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedRelate_r(handle, pg1, g2)
    string_copy_free(
        @ccall(
            libgeos.GEOSPreparedRelate_r(
                handle::GEOSContextHandle_t,
                pg1::Ptr{GEOSPreparedGeometry},
                g2::Ptr{GEOSGeometry},
            )::Cstring
        ),
        handle,
    )
end

function GEOSPreparedRelatePattern_r(handle, pg1, g2, im)
    @ccall libgeos.GEOSPreparedRelatePattern_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
        im::Cstring,
    )::Cchar
end

function GEOSPreparedNearestPoints_r(handle, pg1, g2)
    @ccall libgeos.GEOSPreparedNearestPoints_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSCoordSequence}
end

function GEOSPreparedDistance_r(handle, pg1, g2, dist)
    @ccall libgeos.GEOSPreparedDistance_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSPreparedDistanceWithin_r(handle, pg1, g2, dist)
    @ccall libgeos.GEOSPreparedDistanceWithin_r(
        handle::GEOSContextHandle_t,
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Cdouble,
    )::Cchar
end

function GEOSSTRtree_create_r(handle, nodeCapacity)
    @ccall libgeos.GEOSSTRtree_create_r(
        handle::GEOSContextHandle_t,
        nodeCapacity::Csize_t,
    )::Ptr{GEOSSTRtree}
end

function GEOSSTRtree_build_r(handle, tree)
    @ccall libgeos.GEOSSTRtree_build_r(
        handle::GEOSContextHandle_t,
        tree::Ptr{GEOSSTRtree},
    )::Cint
end

function GEOSSTRtree_insert_r(handle, tree, g, item)
    @ccall libgeos.GEOSSTRtree_insert_r(
        handle::GEOSContextHandle_t,
        tree::Ptr{GEOSSTRtree},
        g::Ptr{GEOSGeometry},
        item::Ptr{Cvoid},
    )::Cvoid
end

function GEOSSTRtree_query_r(handle, tree, g, callback, userdata)
    @ccall libgeos.GEOSSTRtree_query_r(
        handle::GEOSContextHandle_t,
        tree::Ptr{GEOSSTRtree},
        g::Ptr{GEOSGeometry},
        callback::GEOSQueryCallback,
        userdata::Ptr{Cvoid},
    )::Cvoid
end

function GEOSSTRtree_nearest_r(handle, tree, geom)
    @ccall libgeos.GEOSSTRtree_nearest_r(
        handle::GEOSContextHandle_t,
        tree::Ptr{GEOSSTRtree},
        geom::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSSTRtree_nearest_generic_r(
    handle,
    tree,
    item,
    itemEnvelope,
    distancefn,
    userdata,
)
    @ccall libgeos.GEOSSTRtree_nearest_generic_r(
        handle::GEOSContextHandle_t,
        tree::Ptr{GEOSSTRtree},
        item::Ptr{Cvoid},
        itemEnvelope::Ptr{GEOSGeometry},
        distancefn::GEOSDistanceCallback,
        userdata::Ptr{Cvoid},
    )::Ptr{Cvoid}
end

function GEOSSTRtree_iterate_r(handle, tree, callback, userdata)
    @ccall libgeos.GEOSSTRtree_iterate_r(
        handle::GEOSContextHandle_t,
        tree::Ptr{GEOSSTRtree},
        callback::GEOSQueryCallback,
        userdata::Ptr{Cvoid},
    )::Cvoid
end

function GEOSSTRtree_remove_r(handle, tree, g, item)
    @ccall libgeos.GEOSSTRtree_remove_r(
        handle::GEOSContextHandle_t,
        tree::Ptr{GEOSSTRtree},
        g::Ptr{GEOSGeometry},
        item::Ptr{Cvoid},
    )::Cchar
end

function GEOSSTRtree_destroy_r(handle, tree)
    @ccall libgeos.GEOSSTRtree_destroy_r(
        handle::GEOSContextHandle_t,
        tree::Ptr{GEOSSTRtree},
    )::Cvoid
end

function GEOSisEmpty_r(handle, g)
    @ccall libgeos.GEOSisEmpty_r(handle::GEOSContextHandle_t, g::Ptr{GEOSGeometry})::Cchar
end

function GEOSisSimple_r(handle, g)
    @ccall libgeos.GEOSisSimple_r(handle::GEOSContextHandle_t, g::Ptr{GEOSGeometry})::Cchar
end

function GEOSisRing_r(handle, g)
    @ccall libgeos.GEOSisRing_r(handle::GEOSContextHandle_t, g::Ptr{GEOSGeometry})::Cchar
end

function GEOSHasZ_r(handle, g)
    @ccall libgeos.GEOSHasZ_r(handle::GEOSContextHandle_t, g::Ptr{GEOSGeometry})::Cchar
end

function GEOSHasM_r(handle, g)
    @ccall libgeos.GEOSHasM_r(handle::GEOSContextHandle_t, g::Ptr{GEOSGeometry})::Cchar
end

function GEOSisClosed_r(handle, g)
    @ccall libgeos.GEOSisClosed_r(handle::GEOSContextHandle_t, g::Ptr{GEOSGeometry})::Cchar
end

@cenum GEOSRelateBoundaryNodeRules::UInt32 begin
    GEOSRELATE_BNR_MOD2 = 1
    GEOSRELATE_BNR_OGC = 1
    GEOSRELATE_BNR_ENDPOINT = 2
    GEOSRELATE_BNR_MULTIVALENT_ENDPOINT = 3
    GEOSRELATE_BNR_MONOVALENT_ENDPOINT = 4
end

function GEOSRelatePattern_r(handle, g1, g2, imPattern)
    @ccall libgeos.GEOSRelatePattern_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        imPattern::Cstring,
    )::Cchar
end

function GEOSRelate_r(handle, g1, g2)
    string_copy_free(
        @ccall(
            libgeos.GEOSRelate_r(
                handle::GEOSContextHandle_t,
                g1::Ptr{GEOSGeometry},
                g2::Ptr{GEOSGeometry},
            )::Cstring
        ),
        handle,
    )
end

function GEOSRelatePatternMatch_r(handle, intMatrix, imPattern)
    @ccall libgeos.GEOSRelatePatternMatch_r(
        handle::GEOSContextHandle_t,
        intMatrix::Cstring,
        imPattern::Cstring,
    )::Cchar
end

function GEOSRelateBoundaryNodeRule_r(handle, g1, g2, bnr)
    string_copy_free(
        @ccall(
            libgeos.GEOSRelateBoundaryNodeRule_r(
                handle::GEOSContextHandle_t,
                g1::Ptr{GEOSGeometry},
                g2::Ptr{GEOSGeometry},
                bnr::Cint,
            )::Cstring
        ),
        handle,
    )
end

@cenum GEOSValidFlags::UInt32 begin
    GEOSVALID_ALLOW_SELFTOUCHING_RING_FORMING_HOLE = 1
end

function GEOSisValid_r(handle, g)
    @ccall libgeos.GEOSisValid_r(handle::GEOSContextHandle_t, g::Ptr{GEOSGeometry})::Cchar
end

function GEOSisValidReason_r(handle, g)
    string_copy_free(
        @ccall(
            libgeos.GEOSisValidReason_r(
                handle::GEOSContextHandle_t,
                g::Ptr{GEOSGeometry},
            )::Cstring
        ),
        handle,
    )
end

function GEOSisSimpleDetail_r(handle, g, findAllLocations, location)
    @ccall libgeos.GEOSisSimpleDetail_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        findAllLocations::Cint,
        location::Ptr{Ptr{GEOSGeometry}},
    )::Cchar
end

function GEOSisValidDetail_r(handle, g, flags, reason, location)
    @ccall libgeos.GEOSisValidDetail_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        flags::Cint,
        reason::Ptr{Cstring},
        location::Ptr{Ptr{GEOSGeometry}},
    )::Cchar
end

@cenum GEOSMakeValidMethods::UInt32 begin
    GEOS_MAKE_VALID_LINEWORK = 0
    GEOS_MAKE_VALID_STRUCTURE = 1
end

function GEOSMakeValidParams_create_r(extHandle)
    @ccall libgeos.GEOSMakeValidParams_create_r(
        extHandle::GEOSContextHandle_t,
    )::Ptr{GEOSMakeValidParams}
end

function GEOSMakeValidParams_destroy_r(handle, parms)
    @ccall libgeos.GEOSMakeValidParams_destroy_r(
        handle::GEOSContextHandle_t,
        parms::Ptr{GEOSMakeValidParams},
    )::Cvoid
end

function GEOSMakeValidParams_setKeepCollapsed_r(handle, p, style)
    @ccall libgeos.GEOSMakeValidParams_setKeepCollapsed_r(
        handle::GEOSContextHandle_t,
        p::Ptr{GEOSMakeValidParams},
        style::Cint,
    )::Cint
end

function GEOSMakeValidParams_setMethod_r(handle, p, method)
    @ccall libgeos.GEOSMakeValidParams_setMethod_r(
        handle::GEOSContextHandle_t,
        p::Ptr{GEOSMakeValidParams},
        method::GEOSMakeValidMethods,
    )::Cint
end

function GEOSMakeValid_r(handle, g)
    @ccall libgeos.GEOSMakeValid_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSMakeValidWithParams_r(handle, g, makeValidParams)
    @ccall libgeos.GEOSMakeValidWithParams_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        makeValidParams::Ptr{GEOSMakeValidParams},
    )::Ptr{GEOSGeometry}
end

function GEOSRemoveRepeatedPoints_r(handle, g, tolerance)
    @ccall libgeos.GEOSRemoveRepeatedPoints_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSGeomType_r(handle, g)
    string_copy_free(
        @ccall(
            libgeos.GEOSGeomType_r(
                handle::GEOSContextHandle_t,
                g::Ptr{GEOSGeometry},
            )::Cstring
        ),
        handle,
    )
end

function GEOSGeomTypeId_r(handle, g)
    @ccall libgeos.GEOSGeomTypeId_r(handle::GEOSContextHandle_t, g::Ptr{GEOSGeometry})::Cint
end

function GEOSGetSRID_r(handle, g)
    @ccall libgeos.GEOSGetSRID_r(handle::GEOSContextHandle_t, g::Ptr{GEOSGeometry})::Cint
end

function GEOSSetSRID_r(handle, g, SRID)
    @ccall libgeos.GEOSSetSRID_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        SRID::Cint,
    )::Cvoid
end

function GEOSGeom_getUserData_r(handle, g)
    @ccall libgeos.GEOSGeom_getUserData_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{Cvoid}
end

function GEOSGeom_setUserData_r(handle, g, userData)
    @ccall libgeos.GEOSGeom_setUserData_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        userData::Ptr{Cvoid},
    )::Cvoid
end

function GEOSGetNumGeometries_r(handle, g)
    @ccall libgeos.GEOSGetNumGeometries_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Cint
end

function GEOSGetGeometryN_r(handle, g, n)
    @ccall libgeos.GEOSGetGeometryN_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        n::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSNormalize_r(handle, g)
    @ccall libgeos.GEOSNormalize_r(handle::GEOSContextHandle_t, g::Ptr{GEOSGeometry})::Cint
end

function GEOSOrientPolygons_r(handle, g, exteriorCW)
    @ccall libgeos.GEOSOrientPolygons_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        exteriorCW::Cint,
    )::Cint
end

@cenum GEOSPrecisionRules::UInt32 begin
    GEOS_PREC_VALID_OUTPUT = 0
    GEOS_PREC_NO_TOPO = 1
    GEOS_PREC_KEEP_COLLAPSED = 2
end

function GEOSGeom_setPrecision_r(handle, g, gridSize, flags)
    @ccall libgeos.GEOSGeom_setPrecision_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        gridSize::Cdouble,
        flags::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_getPrecision_r(handle, g)
    @ccall libgeos.GEOSGeom_getPrecision_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Cdouble
end

function GEOSGetNumInteriorRings_r(handle, g)
    @ccall libgeos.GEOSGetNumInteriorRings_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Cint
end

function GEOSGeomGetNumPoints_r(handle, g)
    @ccall libgeos.GEOSGeomGetNumPoints_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Cint
end

function GEOSGeomGetX_r(handle, g, x)
    @ccall libgeos.GEOSGeomGetX_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        x::Ptr{Cdouble},
    )::Cint
end

function GEOSGeomGetY_r(handle, g, y)
    @ccall libgeos.GEOSGeomGetY_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        y::Ptr{Cdouble},
    )::Cint
end

function GEOSGeomGetZ_r(handle, g, z)
    @ccall libgeos.GEOSGeomGetZ_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        z::Ptr{Cdouble},
    )::Cint
end

function GEOSGeomGetM_r(handle, g, m)
    @ccall libgeos.GEOSGeomGetM_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        m::Ptr{Cdouble},
    )::Cint
end

function GEOSGetInteriorRingN_r(handle, g, n)
    @ccall libgeos.GEOSGetInteriorRingN_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        n::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSGetExteriorRing_r(handle, g)
    @ccall libgeos.GEOSGetExteriorRing_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSGetNumCoordinates_r(handle, g)
    @ccall libgeos.GEOSGetNumCoordinates_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Cint
end

function GEOSGeom_getCoordSeq_r(handle, g)
    @ccall libgeos.GEOSGeom_getCoordSeq_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSCoordSequence}
end

function GEOSGeom_getDimensions_r(handle, g)
    @ccall libgeos.GEOSGeom_getDimensions_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Cint
end

function GEOSGeom_getCoordinateDimension_r(handle, g)
    @ccall libgeos.GEOSGeom_getCoordinateDimension_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Cint
end

function GEOSGeom_getXMin_r(handle, g, value)
    @ccall libgeos.GEOSGeom_getXMin_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        value::Ptr{Cdouble},
    )::Cint
end

function GEOSGeom_getYMin_r(handle, g, value)
    @ccall libgeos.GEOSGeom_getYMin_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        value::Ptr{Cdouble},
    )::Cint
end

function GEOSGeom_getXMax_r(handle, g, value)
    @ccall libgeos.GEOSGeom_getXMax_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        value::Ptr{Cdouble},
    )::Cint
end

function GEOSGeom_getYMax_r(handle, g, value)
    @ccall libgeos.GEOSGeom_getYMax_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        value::Ptr{Cdouble},
    )::Cint
end

function GEOSGeom_getExtent_r(handle, g, xmin, ymin, xmax, ymax)
    @ccall libgeos.GEOSGeom_getExtent_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        xmin::Ptr{Cdouble},
        ymin::Ptr{Cdouble},
        xmax::Ptr{Cdouble},
        ymax::Ptr{Cdouble},
    )::Cint
end

function GEOSGeomGetPointN_r(handle, g, n)
    @ccall libgeos.GEOSGeomGetPointN_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        n::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSGeomGetStartPoint_r(handle, g)
    @ccall libgeos.GEOSGeomGetStartPoint_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSGeomGetEndPoint_r(handle, g)
    @ccall libgeos.GEOSGeomGetEndPoint_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSArea_r(handle, g, area)
    @ccall libgeos.GEOSArea_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        area::Ptr{Cdouble},
    )::Cint
end

function GEOSLength_r(handle, g, length)
    @ccall libgeos.GEOSLength_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        length::Ptr{Cdouble},
    )::Cint
end

function GEOSDistance_r(handle, g1, g2, dist)
    @ccall libgeos.GEOSDistance_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSDistanceWithin_r(handle, g1, g2, dist)
    @ccall libgeos.GEOSDistanceWithin_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Cdouble,
    )::Cchar
end

function GEOSDistanceIndexed_r(handle, g1, g2, dist)
    @ccall libgeos.GEOSDistanceIndexed_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSHausdorffDistance_r(handle, g1, g2, dist)
    @ccall libgeos.GEOSHausdorffDistance_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSHausdorffDistanceDensify_r(handle, g1, g2, densifyFrac, dist)
    @ccall libgeos.GEOSHausdorffDistanceDensify_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        densifyFrac::Cdouble,
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSFrechetDistance_r(handle, g1, g2, dist)
    @ccall libgeos.GEOSFrechetDistance_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSFrechetDistanceDensify_r(handle, g1, g2, densifyFrac, dist)
    @ccall libgeos.GEOSFrechetDistanceDensify_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        densifyFrac::Cdouble,
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSHilbertCode_r(handle, geom, extent, level, code)
    @ccall libgeos.GEOSHilbertCode_r(
        handle::GEOSContextHandle_t,
        geom::Ptr{GEOSGeometry},
        extent::Ptr{GEOSGeometry},
        level::Cuint,
        code::Ptr{Cuint},
    )::Cint
end

function GEOSGeomGetLength_r(handle, g, length)
    @ccall libgeos.GEOSGeomGetLength_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        length::Ptr{Cdouble},
    )::Cint
end

function GEOSNearestPoints_r(handle, g1, g2)
    @ccall libgeos.GEOSNearestPoints_r(
        handle::GEOSContextHandle_t,
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSCoordSequence}
end

function GEOSGeom_transformXY_r(handle, g, callback, userdata)
    @ccall libgeos.GEOSGeom_transformXY_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        callback::GEOSTransformXYCallback,
        userdata::Ptr{Cvoid},
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_transformXYZ_r(handle, g, callback, userdata)
    @ccall libgeos.GEOSGeom_transformXYZ_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        callback::GEOSTransformXYZCallback,
        userdata::Ptr{Cvoid},
    )::Ptr{GEOSGeometry}
end

function GEOSClusterDBSCAN_r(handle, g, eps, minPoints)
    @ccall libgeos.GEOSClusterDBSCAN_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        eps::Cdouble,
        minPoints::Cuint,
    )::Ptr{GEOSClusterInfo}
end

function GEOSClusterGeometryDistance_r(handle, g, d)
    @ccall libgeos.GEOSClusterGeometryDistance_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        d::Cdouble,
    )::Ptr{GEOSClusterInfo}
end

function GEOSClusterGeometryIntersects_r(handle, g)
    @ccall libgeos.GEOSClusterGeometryIntersects_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSClusterInfo}
end

function GEOSClusterEnvelopeDistance_r(handle, g, d)
    @ccall libgeos.GEOSClusterEnvelopeDistance_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        d::Cdouble,
    )::Ptr{GEOSClusterInfo}
end

function GEOSClusterEnvelopeIntersects_r(handle, g)
    @ccall libgeos.GEOSClusterEnvelopeIntersects_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSClusterInfo}
end

function GEOSClusterInfo_getNumClusters_r(arg1, clusters)
    @ccall libgeos.GEOSClusterInfo_getNumClusters_r(
        arg1::GEOSContextHandle_t,
        clusters::Ptr{GEOSClusterInfo},
    )::Csize_t
end

function GEOSClusterInfo_getClusterSize_r(arg1, clusters, i)
    @ccall libgeos.GEOSClusterInfo_getClusterSize_r(
        arg1::GEOSContextHandle_t,
        clusters::Ptr{GEOSClusterInfo},
        i::Csize_t,
    )::Csize_t
end

function GEOSClusterInfo_getClustersForInputs_r(arg1, clusters)
    @ccall libgeos.GEOSClusterInfo_getClustersForInputs_r(
        arg1::GEOSContextHandle_t,
        clusters::Ptr{GEOSClusterInfo},
    )::Ptr{Csize_t}
end

function GEOSClusterInfo_getInputsForClusterN_r(arg1, clusters, i)
    @ccall libgeos.GEOSClusterInfo_getInputsForClusterN_r(
        arg1::GEOSContextHandle_t,
        clusters::Ptr{GEOSClusterInfo},
        i::Csize_t,
    )::Ptr{Csize_t}
end

function GEOSClusterInfo_destroy_r(arg1, info)
    @ccall libgeos.GEOSClusterInfo_destroy_r(
        arg1::GEOSContextHandle_t,
        info::Ptr{GEOSClusterInfo},
    )::Cvoid
end

function GEOSOrientationIndex_r(handle, Ax, Ay, Bx, By, Px, Py)
    @ccall libgeos.GEOSOrientationIndex_r(
        handle::GEOSContextHandle_t,
        Ax::Cdouble,
        Ay::Cdouble,
        Bx::Cdouble,
        By::Cdouble,
        Px::Cdouble,
        Py::Cdouble,
    )::Cint
end

const GEOSWKTReader_t = Cvoid

const GEOSWKTReader = GEOSWKTReader_t

const GEOSWKTWriter_t = Cvoid

const GEOSWKTWriter = GEOSWKTWriter_t

const GEOSWKBReader_t = Cvoid

const GEOSWKBReader = GEOSWKBReader_t

const GEOSWKBWriter_t = Cvoid

const GEOSWKBWriter = GEOSWKBWriter_t

const GEOSGeoJSONReader_t = Cvoid

const GEOSGeoJSONReader = GEOSGeoJSONReader_t

const GEOSGeoJSONWriter_t = Cvoid

const GEOSGeoJSONWriter = GEOSGeoJSONWriter_t

function GEOSWKTReader_create_r(handle)
    @ccall libgeos.GEOSWKTReader_create_r(handle::GEOSContextHandle_t)::Ptr{GEOSWKTReader}
end

function GEOSWKTReader_destroy_r(handle, reader)
    @ccall libgeos.GEOSWKTReader_destroy_r(
        handle::GEOSContextHandle_t,
        reader::Ptr{GEOSWKTReader},
    )::Cvoid
end

function GEOSWKTReader_read_r(handle, reader, wkt)
    @ccall libgeos.GEOSWKTReader_read_r(
        handle::GEOSContextHandle_t,
        reader::Ptr{GEOSWKTReader},
        wkt::Cstring,
    )::Ptr{GEOSGeometry}
end

function GEOSWKTReader_setFixStructure_r(handle, reader, doFix)
    @ccall libgeos.GEOSWKTReader_setFixStructure_r(
        handle::GEOSContextHandle_t,
        reader::Ptr{GEOSWKTReader},
        doFix::Cchar,
    )::Cvoid
end

function GEOSWKTWriter_create_r(handle)
    @ccall libgeos.GEOSWKTWriter_create_r(handle::GEOSContextHandle_t)::Ptr{GEOSWKTWriter}
end

function GEOSWKTWriter_destroy_r(handle, writer)
    @ccall libgeos.GEOSWKTWriter_destroy_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKTWriter},
    )::Cvoid
end

function GEOSWKTWriter_write_r(handle, writer, g)
    string_copy_free(
        @ccall(
            libgeos.GEOSWKTWriter_write_r(
                handle::GEOSContextHandle_t,
                writer::Ptr{GEOSWKTWriter},
                g::Ptr{GEOSGeometry},
            )::Cstring
        ),
        handle,
    )
end

function GEOSWKTWriter_setTrim_r(handle, writer, trim)
    @ccall libgeos.GEOSWKTWriter_setTrim_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKTWriter},
        trim::Cchar,
    )::Cvoid
end

function GEOSWKTWriter_setRoundingPrecision_r(handle, writer, precision)
    @ccall libgeos.GEOSWKTWriter_setRoundingPrecision_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKTWriter},
        precision::Cint,
    )::Cvoid
end

function GEOSWKTWriter_setOutputDimension_r(handle, writer, dim)
    @ccall libgeos.GEOSWKTWriter_setOutputDimension_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKTWriter},
        dim::Cint,
    )::Cvoid
end

function GEOSWKTWriter_getOutputDimension_r(handle, writer)
    @ccall libgeos.GEOSWKTWriter_getOutputDimension_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKTWriter},
    )::Cint
end

function GEOSWKTWriter_setOld3D_r(handle, writer, useOld3D)
    @ccall libgeos.GEOSWKTWriter_setOld3D_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKTWriter},
        useOld3D::Cint,
    )::Cvoid
end

function GEOS_printDouble(d, precision, result)
    @ccall libgeos.GEOS_printDouble(d::Cdouble, precision::Cuint, result::Cstring)::Cint
end

function GEOSWKBReader_create_r(handle)
    @ccall libgeos.GEOSWKBReader_create_r(handle::GEOSContextHandle_t)::Ptr{GEOSWKBReader}
end

function GEOSWKBReader_destroy_r(handle, reader)
    @ccall libgeos.GEOSWKBReader_destroy_r(
        handle::GEOSContextHandle_t,
        reader::Ptr{GEOSWKBReader},
    )::Cvoid
end

function GEOSWKBReader_setFixStructure_r(handle, reader, doFix)
    @ccall libgeos.GEOSWKBReader_setFixStructure_r(
        handle::GEOSContextHandle_t,
        reader::Ptr{GEOSWKBReader},
        doFix::Cchar,
    )::Cvoid
end

function GEOSWKBReader_read_r(handle, reader, wkb, size)
    @ccall libgeos.GEOSWKBReader_read_r(
        handle::GEOSContextHandle_t,
        reader::Ptr{GEOSWKBReader},
        wkb::Ptr{Cuchar},
        size::Csize_t,
    )::Ptr{GEOSGeometry}
end

function GEOSWKBReader_readHEX_r(handle, reader, hex, size)
    @ccall libgeos.GEOSWKBReader_readHEX_r(
        handle::GEOSContextHandle_t,
        reader::Ptr{GEOSWKBReader},
        hex::Ptr{Cuchar},
        size::Csize_t,
    )::Ptr{GEOSGeometry}
end

function GEOSWKBWriter_create_r(handle)
    @ccall libgeos.GEOSWKBWriter_create_r(handle::GEOSContextHandle_t)::Ptr{GEOSWKBWriter}
end

function GEOSWKBWriter_destroy_r(handle, writer)
    @ccall libgeos.GEOSWKBWriter_destroy_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
    )::Cvoid
end

function GEOSWKBWriter_write_r(handle, writer, g, size)
    @ccall libgeos.GEOSWKBWriter_write_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
        g::Ptr{GEOSGeometry},
        size::Ptr{Csize_t},
    )::Ptr{Cuchar}
end

function GEOSWKBWriter_writeHEX_r(handle, writer, g, size)
    @ccall libgeos.GEOSWKBWriter_writeHEX_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
        g::Ptr{GEOSGeometry},
        size::Ptr{Csize_t},
    )::Ptr{Cuchar}
end

function GEOSWKBWriter_getOutputDimension_r(handle, writer)
    @ccall libgeos.GEOSWKBWriter_getOutputDimension_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
    )::Cint
end

function GEOSWKBWriter_setOutputDimension_r(handle, writer, newDimension)
    @ccall libgeos.GEOSWKBWriter_setOutputDimension_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
        newDimension::Cint,
    )::Cvoid
end

function GEOSWKBWriter_getByteOrder_r(handle, writer)
    @ccall libgeos.GEOSWKBWriter_getByteOrder_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
    )::Cint
end

function GEOSWKBWriter_setByteOrder_r(handle, writer, byteOrder)
    @ccall libgeos.GEOSWKBWriter_setByteOrder_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
        byteOrder::Cint,
    )::Cvoid
end

function GEOSWKBWriter_getFlavor_r(handle, writer)
    @ccall libgeos.GEOSWKBWriter_getFlavor_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
    )::Cint
end

function GEOSWKBWriter_setFlavor_r(handle, writer, flavor)
    @ccall libgeos.GEOSWKBWriter_setFlavor_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
        flavor::Cint,
    )::Cvoid
end

function GEOSWKBWriter_getIncludeSRID_r(handle, writer)
    @ccall libgeos.GEOSWKBWriter_getIncludeSRID_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
    )::Cchar
end

function GEOSWKBWriter_setIncludeSRID_r(handle, writer, writeSRID)
    @ccall libgeos.GEOSWKBWriter_setIncludeSRID_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSWKBWriter},
        writeSRID::Cchar,
    )::Cvoid
end

function GEOSGeoJSONReader_create_r(handle)
    @ccall libgeos.GEOSGeoJSONReader_create_r(
        handle::GEOSContextHandle_t,
    )::Ptr{GEOSGeoJSONReader}
end

function GEOSGeoJSONReader_destroy_r(handle, reader)
    @ccall libgeos.GEOSGeoJSONReader_destroy_r(
        handle::GEOSContextHandle_t,
        reader::Ptr{GEOSGeoJSONReader},
    )::Cvoid
end

function GEOSGeoJSONReader_readGeometry_r(handle, reader, geojson)
    @ccall libgeos.GEOSGeoJSONReader_readGeometry_r(
        handle::GEOSContextHandle_t,
        reader::Ptr{GEOSGeoJSONReader},
        geojson::Cstring,
    )::Ptr{GEOSGeometry}
end

function GEOSGeoJSONWriter_create_r(handle)
    @ccall libgeos.GEOSGeoJSONWriter_create_r(
        handle::GEOSContextHandle_t,
    )::Ptr{GEOSGeoJSONWriter}
end

function GEOSGeoJSONWriter_destroy_r(handle, writer)
    @ccall libgeos.GEOSGeoJSONWriter_destroy_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSGeoJSONWriter},
    )::Cvoid
end

function GEOSGeoJSONWriter_writeGeometry_r(handle, writer, g, indent)
    string_copy_free(
        @ccall(
            libgeos.GEOSGeoJSONWriter_writeGeometry_r(
                handle::GEOSContextHandle_t,
                writer::Ptr{GEOSGeoJSONWriter},
                g::Ptr{GEOSGeometry},
                indent::Cint,
            )::Cstring
        ),
        handle,
    )
end

function GEOSGeoJSONWriter_setOutputDimension_r(handle, writer, dim)
    @ccall libgeos.GEOSGeoJSONWriter_setOutputDimension_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSGeoJSONWriter},
        dim::Cint,
    )::Cvoid
end

function GEOSGeoJSONWriter_getOutputDimension_r(handle, writer)
    @ccall libgeos.GEOSGeoJSONWriter_getOutputDimension_r(
        handle::GEOSContextHandle_t,
        writer::Ptr{GEOSGeoJSONWriter},
    )::Cint
end

function GEOSFree_r(handle, buffer)
    @ccall libgeos.GEOSFree_r(handle::GEOSContextHandle_t, buffer::Ptr{Cvoid})::Cvoid
end

function GEOSversion()
    unsafe_string(@ccall(libgeos.GEOSversion()::Cstring))
end

function initGEOS(notice_function, error_function)
    @ccall libgeos.initGEOS(
        notice_function::GEOSMessageHandler,
        error_function::GEOSMessageHandler,
    )::Cvoid
end

function finishGEOS()
    @ccall libgeos.finishGEOS()::Cvoid
end

function GEOSFree(buffer)
    @ccall libgeos.GEOSFree(buffer::Ptr{Cvoid})::Cvoid
end

function GEOSCoordSeq_create(size, dims)
    @ccall libgeos.GEOSCoordSeq_create(size::Cuint, dims::Cuint)::Ptr{GEOSCoordSequence}
end

function GEOSCoordSeq_createWithDimensions(size, hasZ, hasM)
    @ccall libgeos.GEOSCoordSeq_createWithDimensions(
        size::Cuint,
        hasZ::Cint,
        hasM::Cint,
    )::Ptr{GEOSCoordSequence}
end

function GEOSCoordSeq_copyFromBuffer(buf, size, hasZ, hasM)
    @ccall libgeos.GEOSCoordSeq_copyFromBuffer(
        buf::Ptr{Cdouble},
        size::Cuint,
        hasZ::Cint,
        hasM::Cint,
    )::Ptr{GEOSCoordSequence}
end

function GEOSCoordSeq_copyFromArrays(x, y, z, m, size)
    @ccall libgeos.GEOSCoordSeq_copyFromArrays(
        x::Ptr{Cdouble},
        y::Ptr{Cdouble},
        z::Ptr{Cdouble},
        m::Ptr{Cdouble},
        size::Cuint,
    )::Ptr{GEOSCoordSequence}
end

function GEOSCoordSeq_copyToBuffer(s, buf, hasZ, hasM)
    @ccall libgeos.GEOSCoordSeq_copyToBuffer(
        s::Ptr{GEOSCoordSequence},
        buf::Ptr{Cdouble},
        hasZ::Cint,
        hasM::Cint,
    )::Cint
end

function GEOSCoordSeq_copyToArrays(s, x, y, z, m)
    @ccall libgeos.GEOSCoordSeq_copyToArrays(
        s::Ptr{GEOSCoordSequence},
        x::Ptr{Cdouble},
        y::Ptr{Cdouble},
        z::Ptr{Cdouble},
        m::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_clone(s)
    @ccall libgeos.GEOSCoordSeq_clone(s::Ptr{GEOSCoordSequence})::Ptr{GEOSCoordSequence}
end

function GEOSCoordSeq_destroy(s)
    @ccall libgeos.GEOSCoordSeq_destroy(s::Ptr{GEOSCoordSequence})::Cvoid
end

function GEOSCoordSeq_hasZ(s)
    @ccall libgeos.GEOSCoordSeq_hasZ(s::Ptr{GEOSCoordSequence})::Cchar
end

function GEOSCoordSeq_hasM(s)
    @ccall libgeos.GEOSCoordSeq_hasM(s::Ptr{GEOSCoordSequence})::Cchar
end

function GEOSCoordSeq_setX(s, idx, val)
    @ccall libgeos.GEOSCoordSeq_setX(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setY(s, idx, val)
    @ccall libgeos.GEOSCoordSeq_setY(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setZ(s, idx, val)
    @ccall libgeos.GEOSCoordSeq_setZ(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setM(s, idx, val)
    @ccall libgeos.GEOSCoordSeq_setM(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setXY(s, idx, x, y)
    @ccall libgeos.GEOSCoordSeq_setXY(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        x::Cdouble,
        y::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setXYZ(s, idx, x, y, z)
    @ccall libgeos.GEOSCoordSeq_setXYZ(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        x::Cdouble,
        y::Cdouble,
        z::Cdouble,
    )::Cint
end

function GEOSCoordSeq_setOrdinate(s, idx, dim, val)
    @ccall libgeos.GEOSCoordSeq_setOrdinate(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        dim::Cuint,
        val::Cdouble,
    )::Cint
end

function GEOSCoordSeq_getX(s, idx, val)
    @ccall libgeos.GEOSCoordSeq_getX(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getY(s, idx, val)
    @ccall libgeos.GEOSCoordSeq_getY(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getZ(s, idx, val)
    @ccall libgeos.GEOSCoordSeq_getZ(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getM(s, idx, val)
    @ccall libgeos.GEOSCoordSeq_getM(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        val::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getXY(s, idx, x, y)
    @ccall libgeos.GEOSCoordSeq_getXY(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        x::Ptr{Cdouble},
        y::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getXYZ(s, idx, x, y, z)
    @ccall libgeos.GEOSCoordSeq_getXYZ(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        x::Ptr{Cdouble},
        y::Ptr{Cdouble},
        z::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getOrdinate(s, idx, dim, val)
    @ccall libgeos.GEOSCoordSeq_getOrdinate(
        s::Ptr{GEOSCoordSequence},
        idx::Cuint,
        dim::Cuint,
        val::Ptr{Cdouble},
    )::Cint
end

function GEOSCoordSeq_getSize(s, size)
    @ccall libgeos.GEOSCoordSeq_getSize(s::Ptr{GEOSCoordSequence}, size::Ptr{Cuint})::Cint
end

function GEOSCoordSeq_getDimensions(s, dims)
    @ccall libgeos.GEOSCoordSeq_getDimensions(
        s::Ptr{GEOSCoordSequence},
        dims::Ptr{Cuint},
    )::Cint
end

function GEOSCoordSeq_isCCW(s, is_ccw)
    @ccall libgeos.GEOSCoordSeq_isCCW(s::Ptr{GEOSCoordSequence}, is_ccw::Cstring)::Cint
end

function GEOSGeom_createPoint(s)
    @ccall libgeos.GEOSGeom_createPoint(s::Ptr{GEOSCoordSequence})::Ptr{GEOSGeometry}
end

function GEOSGeom_createPointFromXY(x, y)
    @ccall libgeos.GEOSGeom_createPointFromXY(x::Cdouble, y::Cdouble)::Ptr{GEOSGeometry}
end

function GEOSGeom_createEmptyPoint()
    @ccall libgeos.GEOSGeom_createEmptyPoint()::Ptr{GEOSGeometry}
end

function GEOSGeom_createLinearRing(s)
    @ccall libgeos.GEOSGeom_createLinearRing(s::Ptr{GEOSCoordSequence})::Ptr{GEOSGeometry}
end

function GEOSGeom_createLineString(s)
    @ccall libgeos.GEOSGeom_createLineString(s::Ptr{GEOSCoordSequence})::Ptr{GEOSGeometry}
end

function GEOSGeom_createEmptyLineString()
    @ccall libgeos.GEOSGeom_createEmptyLineString()::Ptr{GEOSGeometry}
end

function GEOSGeom_createEmptyPolygon()
    @ccall libgeos.GEOSGeom_createEmptyPolygon()::Ptr{GEOSGeometry}
end

function GEOSGeom_createPolygon(shell, holes, nholes)
    @ccall libgeos.GEOSGeom_createPolygon(
        shell::Ptr{GEOSGeometry},
        holes::Ptr{Ptr{GEOSGeometry}},
        nholes::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_createCircularString(s)
    @ccall libgeos.GEOSGeom_createCircularString(
        s::Ptr{GEOSCoordSequence},
    )::Ptr{GEOSGeometry}
end

# no prototype is found for this function at geos_c.h:2810:31, please use with caution
function GEOSGeom_createEmptyCircularString()
    @ccall libgeos.GEOSGeom_createEmptyCircularString()::Ptr{GEOSGeometry}
end

function GEOSGeom_createCompoundCurve(curves, ncurves)
    @ccall libgeos.GEOSGeom_createCompoundCurve(
        curves::Ptr{Ptr{GEOSGeometry}},
        ncurves::Cuint,
    )::Ptr{GEOSGeometry}
end

# no prototype is found for this function at geos_c.h:2829:31, please use with caution
function GEOSGeom_createEmptyCompoundCurve()
    @ccall libgeos.GEOSGeom_createEmptyCompoundCurve()::Ptr{GEOSGeometry}
end

function GEOSGeom_createCurvePolygon(shell, holes, nholes)
    @ccall libgeos.GEOSGeom_createCurvePolygon(
        shell::Ptr{GEOSGeometry},
        holes::Ptr{Ptr{GEOSGeometry}},
        nholes::Cuint,
    )::Ptr{GEOSGeometry}
end

# no prototype is found for this function at geos_c.h:2855:31, please use with caution
function GEOSGeom_createEmptyCurvePolygon()
    @ccall libgeos.GEOSGeom_createEmptyCurvePolygon()::Ptr{GEOSGeometry}
end

function GEOSGeom_createCollection(type, geoms, ngeoms)
    @ccall libgeos.GEOSGeom_createCollection(
        type::Cint,
        geoms::Ptr{Ptr{GEOSGeometry}},
        ngeoms::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_releaseCollection(collection, ngeoms)
    @ccall libgeos.GEOSGeom_releaseCollection(
        collection::Ptr{GEOSGeometry},
        ngeoms::Ptr{Cuint},
    )::Ptr{Ptr{GEOSGeometry}}
end

function GEOSGeom_createEmptyCollection(type)
    @ccall libgeos.GEOSGeom_createEmptyCollection(type::Cint)::Ptr{GEOSGeometry}
end

function GEOSGeom_createRectangle(xmin, ymin, xmax, ymax)
    @ccall libgeos.GEOSGeom_createRectangle(
        xmin::Cdouble,
        ymin::Cdouble,
        xmax::Cdouble,
        ymax::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_clone(g)
    @ccall libgeos.GEOSGeom_clone(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSGeom_destroy(g)
    @ccall libgeos.GEOSGeom_destroy(g::Ptr{GEOSGeometry})::Cvoid
end

function GEOSGeomType(g)
    string_copy_free(@ccall(libgeos.GEOSGeomType(g::Ptr{GEOSGeometry})::Cstring))
end

function GEOSGeomTypeId(g)
    @ccall libgeos.GEOSGeomTypeId(g::Ptr{GEOSGeometry})::Cint
end

function GEOSGetSRID(g)
    @ccall libgeos.GEOSGetSRID(g::Ptr{GEOSGeometry})::Cint
end

function GEOSGeom_getUserData(g)
    @ccall libgeos.GEOSGeom_getUserData(g::Ptr{GEOSGeometry})::Ptr{Cvoid}
end

function GEOSGetNumGeometries(g)
    @ccall libgeos.GEOSGetNumGeometries(g::Ptr{GEOSGeometry})::Cint
end

function GEOSGetGeometryN(g, n)
    @ccall libgeos.GEOSGetGeometryN(g::Ptr{GEOSGeometry}, n::Cint)::Ptr{GEOSGeometry}
end

function GEOSGeom_getPrecision(g)
    @ccall libgeos.GEOSGeom_getPrecision(g::Ptr{GEOSGeometry})::Cdouble
end

function GEOSGetNumInteriorRings(g)
    @ccall libgeos.GEOSGetNumInteriorRings(g::Ptr{GEOSGeometry})::Cint
end

function GEOSGeomGetNumPoints(g)
    @ccall libgeos.GEOSGeomGetNumPoints(g::Ptr{GEOSGeometry})::Cint
end

function GEOSGeomGetX(g, x)
    @ccall libgeos.GEOSGeomGetX(g::Ptr{GEOSGeometry}, x::Ptr{Cdouble})::Cint
end

function GEOSGeomGetY(g, y)
    @ccall libgeos.GEOSGeomGetY(g::Ptr{GEOSGeometry}, y::Ptr{Cdouble})::Cint
end

function GEOSGeomGetZ(g, z)
    @ccall libgeos.GEOSGeomGetZ(g::Ptr{GEOSGeometry}, z::Ptr{Cdouble})::Cint
end

function GEOSGeomGetM(g, m)
    @ccall libgeos.GEOSGeomGetM(g::Ptr{GEOSGeometry}, m::Ptr{Cdouble})::Cint
end

function GEOSGetInteriorRingN(g, n)
    @ccall libgeos.GEOSGetInteriorRingN(g::Ptr{GEOSGeometry}, n::Cint)::Ptr{GEOSGeometry}
end

function GEOSGetExteriorRing(g)
    @ccall libgeos.GEOSGetExteriorRing(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSGetNumCoordinates(g)
    @ccall libgeos.GEOSGetNumCoordinates(g::Ptr{GEOSGeometry})::Cint
end

function GEOSGeom_getCoordSeq(g)
    @ccall libgeos.GEOSGeom_getCoordSeq(g::Ptr{GEOSGeometry})::Ptr{GEOSCoordSequence}
end

function GEOSGeom_getDimensions(g)
    @ccall libgeos.GEOSGeom_getDimensions(g::Ptr{GEOSGeometry})::Cint
end

function GEOSGeom_getCoordinateDimension(g)
    @ccall libgeos.GEOSGeom_getCoordinateDimension(g::Ptr{GEOSGeometry})::Cint
end

function GEOSGeom_getXMin(g, value)
    @ccall libgeos.GEOSGeom_getXMin(g::Ptr{GEOSGeometry}, value::Ptr{Cdouble})::Cint
end

function GEOSGeom_getYMin(g, value)
    @ccall libgeos.GEOSGeom_getYMin(g::Ptr{GEOSGeometry}, value::Ptr{Cdouble})::Cint
end

function GEOSGeom_getXMax(g, value)
    @ccall libgeos.GEOSGeom_getXMax(g::Ptr{GEOSGeometry}, value::Ptr{Cdouble})::Cint
end

function GEOSGeom_getYMax(g, value)
    @ccall libgeos.GEOSGeom_getYMax(g::Ptr{GEOSGeometry}, value::Ptr{Cdouble})::Cint
end

function GEOSGeom_getExtent(g, xmin, ymin, xmax, ymax)
    @ccall libgeos.GEOSGeom_getExtent(
        g::Ptr{GEOSGeometry},
        xmin::Ptr{Cdouble},
        ymin::Ptr{Cdouble},
        xmax::Ptr{Cdouble},
        ymax::Ptr{Cdouble},
    )::Cint
end

function GEOSGeomGetPointN(g, n)
    @ccall libgeos.GEOSGeomGetPointN(g::Ptr{GEOSGeometry}, n::Cint)::Ptr{GEOSGeometry}
end

function GEOSGeomGetStartPoint(g)
    @ccall libgeos.GEOSGeomGetStartPoint(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSGeomGetEndPoint(g)
    @ccall libgeos.GEOSGeomGetEndPoint(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSisEmpty(g)
    @ccall libgeos.GEOSisEmpty(g::Ptr{GEOSGeometry})::Cchar
end

function GEOSisRing(g)
    @ccall libgeos.GEOSisRing(g::Ptr{GEOSGeometry})::Cchar
end

function GEOSHasZ(g)
    @ccall libgeos.GEOSHasZ(g::Ptr{GEOSGeometry})::Cchar
end

function GEOSHasM(g)
    @ccall libgeos.GEOSHasM(g::Ptr{GEOSGeometry})::Cchar
end

function GEOSisClosed(g)
    @ccall libgeos.GEOSisClosed(g::Ptr{GEOSGeometry})::Cchar
end

function GEOSSetSRID(g, SRID)
    @ccall libgeos.GEOSSetSRID(g::Ptr{GEOSGeometry}, SRID::Cint)::Cvoid
end

function GEOSGeom_setUserData(g, userData)
    @ccall libgeos.GEOSGeom_setUserData(g::Ptr{GEOSGeometry}, userData::Ptr{Cvoid})::Cvoid
end

function GEOSNormalize(g)
    @ccall libgeos.GEOSNormalize(g::Ptr{GEOSGeometry})::Cint
end

function GEOSOrientPolygons(g, exteriorCW)
    @ccall libgeos.GEOSOrientPolygons(g::Ptr{GEOSGeometry}, exteriorCW::Cint)::Cint
end

function GEOSisSimple(g)
    @ccall libgeos.GEOSisSimple(g::Ptr{GEOSGeometry})::Cchar
end

function GEOSisSimpleDetail(g, findAllLocations, locations)
    @ccall libgeos.GEOSisSimpleDetail(
        g::Ptr{GEOSGeometry},
        findAllLocations::Cint,
        locations::Ptr{Ptr{GEOSGeometry}},
    )::Cchar
end

function GEOSisValid(g)
    @ccall libgeos.GEOSisValid(g::Ptr{GEOSGeometry})::Cchar
end

function GEOSisValidReason(g)
    string_copy_free(@ccall(libgeos.GEOSisValidReason(g::Ptr{GEOSGeometry})::Cstring))
end

function GEOSisValidDetail(g, flags, reason, location)
    @ccall libgeos.GEOSisValidDetail(
        g::Ptr{GEOSGeometry},
        flags::Cint,
        reason::Ptr{Cstring},
        location::Ptr{Ptr{GEOSGeometry}},
    )::Cchar
end

function GEOSMakeValid(g)
    @ccall libgeos.GEOSMakeValid(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSMakeValidWithParams(g, makeValidParams)
    @ccall libgeos.GEOSMakeValidWithParams(
        g::Ptr{GEOSGeometry},
        makeValidParams::Ptr{GEOSMakeValidParams},
    )::Ptr{GEOSGeometry}
end

function GEOSMakeValidParams_create()
    @ccall libgeos.GEOSMakeValidParams_create()::Ptr{GEOSMakeValidParams}
end

function GEOSMakeValidParams_destroy(parms)
    @ccall libgeos.GEOSMakeValidParams_destroy(parms::Ptr{GEOSMakeValidParams})::Cvoid
end

function GEOSMakeValidParams_setMethod(p, method)
    @ccall libgeos.GEOSMakeValidParams_setMethod(
        p::Ptr{GEOSMakeValidParams},
        method::GEOSMakeValidMethods,
    )::Cint
end

function GEOSMakeValidParams_setKeepCollapsed(p, keepCollapsed)
    @ccall libgeos.GEOSMakeValidParams_setKeepCollapsed(
        p::Ptr{GEOSMakeValidParams},
        keepCollapsed::Cint,
    )::Cint
end

function GEOSMinimumClearance(g, d)
    @ccall libgeos.GEOSMinimumClearance(g::Ptr{GEOSGeometry}, d::Ptr{Cdouble})::Cint
end

function GEOSMinimumClearanceLine(g)
    @ccall libgeos.GEOSMinimumClearanceLine(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSRemoveRepeatedPoints(g, tolerance)
    @ccall libgeos.GEOSRemoveRepeatedPoints(
        g::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSArea(g, area)
    @ccall libgeos.GEOSArea(g::Ptr{GEOSGeometry}, area::Ptr{Cdouble})::Cint
end

function GEOSLength(g, length)
    @ccall libgeos.GEOSLength(g::Ptr{GEOSGeometry}, length::Ptr{Cdouble})::Cint
end

function GEOSGeomGetLength(g, length)
    @ccall libgeos.GEOSGeomGetLength(g::Ptr{GEOSGeometry}, length::Ptr{Cdouble})::Cint
end

function GEOSDistance(g1, g2, dist)
    @ccall libgeos.GEOSDistance(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSDistanceWithin(g1, g2, dist)
    @ccall libgeos.GEOSDistanceWithin(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Cdouble,
    )::Cchar
end

function GEOSDistanceIndexed(g1, g2, dist)
    @ccall libgeos.GEOSDistanceIndexed(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSNearestPoints(g1, g2)
    @ccall libgeos.GEOSNearestPoints(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSCoordSequence}
end

function GEOSHausdorffDistance(g1, g2, dist)
    @ccall libgeos.GEOSHausdorffDistance(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSHausdorffDistanceDensify(g1, g2, densifyFrac, dist)
    @ccall libgeos.GEOSHausdorffDistanceDensify(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        densifyFrac::Cdouble,
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSFrechetDistance(g1, g2, dist)
    @ccall libgeos.GEOSFrechetDistance(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSFrechetDistanceDensify(g1, g2, densifyFrac, dist)
    @ccall libgeos.GEOSFrechetDistanceDensify(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        densifyFrac::Cdouble,
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSProject(line, point)
    @ccall libgeos.GEOSProject(line::Ptr{GEOSGeometry}, point::Ptr{GEOSGeometry})::Cdouble
end

function GEOSInterpolate(line, d)
    @ccall libgeos.GEOSInterpolate(line::Ptr{GEOSGeometry}, d::Cdouble)::Ptr{GEOSGeometry}
end

function GEOSProjectNormalized(line, point)
    @ccall libgeos.GEOSProjectNormalized(
        line::Ptr{GEOSGeometry},
        point::Ptr{GEOSGeometry},
    )::Cdouble
end

function GEOSInterpolateNormalized(line, proportion)
    @ccall libgeos.GEOSInterpolateNormalized(
        line::Ptr{GEOSGeometry},
        proportion::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSIntersection(g1, g2)
    @ccall libgeos.GEOSIntersection(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSIntersectionPrec(g1, g2, gridSize)
    @ccall libgeos.GEOSIntersectionPrec(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        gridSize::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSDifference(ga, gb)
    @ccall libgeos.GEOSDifference(
        ga::Ptr{GEOSGeometry},
        gb::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSDifferencePrec(ga, gb, gridSize)
    @ccall libgeos.GEOSDifferencePrec(
        ga::Ptr{GEOSGeometry},
        gb::Ptr{GEOSGeometry},
        gridSize::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSSymDifference(ga, gb)
    @ccall libgeos.GEOSSymDifference(
        ga::Ptr{GEOSGeometry},
        gb::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSSymDifferencePrec(ga, gb, gridSize)
    @ccall libgeos.GEOSSymDifferencePrec(
        ga::Ptr{GEOSGeometry},
        gb::Ptr{GEOSGeometry},
        gridSize::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSUnion(ga, gb)
    @ccall libgeos.GEOSUnion(
        ga::Ptr{GEOSGeometry},
        gb::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSUnionPrec(ga, gb, gridSize)
    @ccall libgeos.GEOSUnionPrec(
        ga::Ptr{GEOSGeometry},
        gb::Ptr{GEOSGeometry},
        gridSize::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSUnaryUnion(g)
    @ccall libgeos.GEOSUnaryUnion(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSUnaryUnionPrec(g, gridSize)
    @ccall libgeos.GEOSUnaryUnionPrec(
        g::Ptr{GEOSGeometry},
        gridSize::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSDisjointSubsetUnion(g)
    @ccall libgeos.GEOSDisjointSubsetUnion(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSClipByRect(g, xmin, ymin, xmax, ymax)
    @ccall libgeos.GEOSClipByRect(
        g::Ptr{GEOSGeometry},
        xmin::Cdouble,
        ymin::Cdouble,
        xmax::Cdouble,
        ymax::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSGridIntersectionFractions(g, xmin, ymin, xmax, ymax, nx, ny, buf)
    @ccall libgeos.GEOSGridIntersectionFractions(
        g::Ptr{GEOSGeometry},
        xmin::Cdouble,
        ymin::Cdouble,
        xmax::Cdouble,
        ymax::Cdouble,
        nx::Cuint,
        ny::Cuint,
        buf::Ptr{Cfloat},
    )::Cint
end

function GEOSSharedPaths(g1, g2)
    @ccall libgeos.GEOSSharedPaths(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSClusterDBSCAN(g, eps, minPoints)
    @ccall libgeos.GEOSClusterDBSCAN(
        g::Ptr{GEOSGeometry},
        eps::Cdouble,
        minPoints::Cuint,
    )::Ptr{GEOSClusterInfo}
end

function GEOSClusterGeometryDistance(g, d)
    @ccall libgeos.GEOSClusterGeometryDistance(
        g::Ptr{GEOSGeometry},
        d::Cdouble,
    )::Ptr{GEOSClusterInfo}
end

function GEOSClusterGeometryIntersects(g)
    @ccall libgeos.GEOSClusterGeometryIntersects(g::Ptr{GEOSGeometry})::Ptr{GEOSClusterInfo}
end

function GEOSClusterEnvelopeDistance(g, d)
    @ccall libgeos.GEOSClusterEnvelopeDistance(
        g::Ptr{GEOSGeometry},
        d::Cdouble,
    )::Ptr{GEOSClusterInfo}
end

function GEOSClusterEnvelopeIntersects(g)
    @ccall libgeos.GEOSClusterEnvelopeIntersects(g::Ptr{GEOSGeometry})::Ptr{GEOSClusterInfo}
end

function GEOSClusterInfo_getNumClusters(clusters)
    @ccall libgeos.GEOSClusterInfo_getNumClusters(clusters::Ptr{GEOSClusterInfo})::Csize_t
end

function GEOSClusterInfo_getClusterSize(clusters, i)
    @ccall libgeos.GEOSClusterInfo_getClusterSize(
        clusters::Ptr{GEOSClusterInfo},
        i::Csize_t,
    )::Csize_t
end

function GEOSClusterInfo_getClustersForInputs(clusters)
    @ccall libgeos.GEOSClusterInfo_getClustersForInputs(
        clusters::Ptr{GEOSClusterInfo},
    )::Ptr{Csize_t}
end

function GEOSClusterInfo_getInputsForClusterN(clusters, i)
    @ccall libgeos.GEOSClusterInfo_getInputsForClusterN(
        clusters::Ptr{GEOSClusterInfo},
        i::Csize_t,
    )::Ptr{Csize_t}
end

function GEOSClusterInfo_destroy(clusters)
    @ccall libgeos.GEOSClusterInfo_destroy(clusters::Ptr{GEOSClusterInfo})::Cvoid
end

function GEOSBuffer(g, width, quadsegs)
    @ccall libgeos.GEOSBuffer(
        g::Ptr{GEOSGeometry},
        width::Cdouble,
        quadsegs::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSBufferParams_create()
    @ccall libgeos.GEOSBufferParams_create()::Ptr{GEOSBufferParams}
end

function GEOSBufferParams_destroy(parms)
    @ccall libgeos.GEOSBufferParams_destroy(parms::Ptr{GEOSBufferParams})::Cvoid
end

function GEOSBufferParams_setEndCapStyle(p, style)
    @ccall libgeos.GEOSBufferParams_setEndCapStyle(
        p::Ptr{GEOSBufferParams},
        style::Cint,
    )::Cint
end

function GEOSBufferParams_setJoinStyle(p, joinStyle)
    @ccall libgeos.GEOSBufferParams_setJoinStyle(
        p::Ptr{GEOSBufferParams},
        joinStyle::Cint,
    )::Cint
end

function GEOSBufferParams_setMitreLimit(p, mitreLimit)
    @ccall libgeos.GEOSBufferParams_setMitreLimit(
        p::Ptr{GEOSBufferParams},
        mitreLimit::Cdouble,
    )::Cint
end

function GEOSBufferParams_setQuadrantSegments(p, quadSegs)
    @ccall libgeos.GEOSBufferParams_setQuadrantSegments(
        p::Ptr{GEOSBufferParams},
        quadSegs::Cint,
    )::Cint
end

function GEOSBufferParams_setSingleSided(p, singleSided)
    @ccall libgeos.GEOSBufferParams_setSingleSided(
        p::Ptr{GEOSBufferParams},
        singleSided::Cint,
    )::Cint
end

function GEOSBufferWithParams(g, p, width)
    @ccall libgeos.GEOSBufferWithParams(
        g::Ptr{GEOSGeometry},
        p::Ptr{GEOSBufferParams},
        width::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSBufferWithStyle(g, width, quadsegs, endCapStyle, joinStyle, mitreLimit)
    @ccall libgeos.GEOSBufferWithStyle(
        g::Ptr{GEOSGeometry},
        width::Cdouble,
        quadsegs::Cint,
        endCapStyle::Cint,
        joinStyle::Cint,
        mitreLimit::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSOffsetCurve(g, width, quadsegs, joinStyle, mitreLimit)
    @ccall libgeos.GEOSOffsetCurve(
        g::Ptr{GEOSGeometry},
        width::Cdouble,
        quadsegs::Cint,
        joinStyle::Cint,
        mitreLimit::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSCoverageUnion(g)
    @ccall libgeos.GEOSCoverageUnion(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSCoverageIsValid(input, gapWidth, invalidEdges)
    @ccall libgeos.GEOSCoverageIsValid(
        input::Ptr{GEOSGeometry},
        gapWidth::Cdouble,
        invalidEdges::Ptr{Ptr{GEOSGeometry}},
    )::Cint
end

function GEOSCoverageSimplifyVW(input, tolerance, preserveBoundary)
    @ccall libgeos.GEOSCoverageSimplifyVW(
        input::Ptr{GEOSGeometry},
        tolerance::Cdouble,
        preserveBoundary::Cint,
    )::Ptr{GEOSGeometry}
end

# no prototype is found for this function at geos_c.h:4443:1, please use with caution
function GEOSCoverageCleanParams_create()
    @ccall libgeos.GEOSCoverageCleanParams_create()::Ptr{GEOSCoverageCleanParams}
end

function GEOSCoverageCleanParams_destroy(params)
    @ccall libgeos.GEOSCoverageCleanParams_destroy(
        params::Ptr{GEOSCoverageCleanParams},
    )::Cvoid
end

function GEOSCoverageCleanParams_setSnappingDistance(params, snappingDistance)
    @ccall libgeos.GEOSCoverageCleanParams_setSnappingDistance(
        params::Ptr{GEOSCoverageCleanParams},
        snappingDistance::Cdouble,
    )::Cint
end

function GEOSCoverageCleanParams_setGapMaximumWidth(params, gapMaximumWidth)
    @ccall libgeos.GEOSCoverageCleanParams_setGapMaximumWidth(
        params::Ptr{GEOSCoverageCleanParams},
        gapMaximumWidth::Cdouble,
    )::Cint
end

function GEOSCoverageCleanParams_setOverlapMergeStrategy(params, overlapMergeStrategy)
    @ccall libgeos.GEOSCoverageCleanParams_setOverlapMergeStrategy(
        params::Ptr{GEOSCoverageCleanParams},
        overlapMergeStrategy::Cint,
    )::Cint
end

function GEOSCoverageCleanWithParams(input, params)
    @ccall libgeos.GEOSCoverageCleanWithParams(
        input::Ptr{GEOSGeometry},
        params::Ptr{GEOSCoverageCleanParams},
    )::Ptr{GEOSGeometry}
end

function GEOSCoverageClean(input)
    @ccall libgeos.GEOSCoverageClean(input::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSEnvelope(g)
    @ccall libgeos.GEOSEnvelope(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSBoundary(g)
    @ccall libgeos.GEOSBoundary(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSConvexHull(g)
    @ccall libgeos.GEOSConvexHull(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSConcaveHull(g, ratio, allowHoles)
    @ccall libgeos.GEOSConcaveHull(
        g::Ptr{GEOSGeometry},
        ratio::Cdouble,
        allowHoles::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSConcaveHullByLength(g, length, allowHoles)
    @ccall libgeos.GEOSConcaveHullByLength(
        g::Ptr{GEOSGeometry},
        length::Cdouble,
        allowHoles::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSConcaveHullOfPolygons(g, lengthRatio, isTight, isHolesAllowed)
    @ccall libgeos.GEOSConcaveHullOfPolygons(
        g::Ptr{GEOSGeometry},
        lengthRatio::Cdouble,
        isTight::Cuint,
        isHolesAllowed::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSPolygonHullSimplify(g, isOuter, vertexNumFraction)
    @ccall libgeos.GEOSPolygonHullSimplify(
        g::Ptr{GEOSGeometry},
        isOuter::Cuint,
        vertexNumFraction::Cdouble,
    )::Ptr{GEOSGeometry}
end

@cenum GEOSPolygonHullParameterModes::UInt32 begin
    GEOSHULL_PARAM_VERTEX_RATIO = 1
    GEOSHULL_PARAM_AREA_RATIO = 2
end

function GEOSPolygonHullSimplifyMode(g, isOuter, parameterMode, parameter)
    @ccall libgeos.GEOSPolygonHullSimplifyMode(
        g::Ptr{GEOSGeometry},
        isOuter::Cuint,
        parameterMode::Cuint,
        parameter::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSMinimumRotatedRectangle(g)
    @ccall libgeos.GEOSMinimumRotatedRectangle(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSMaximumInscribedCircle(g, tolerance)
    @ccall libgeos.GEOSMaximumInscribedCircle(
        g::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSLargestEmptyCircle(obstacles, boundary, tolerance)
    @ccall libgeos.GEOSLargestEmptyCircle(
        obstacles::Ptr{GEOSGeometry},
        boundary::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSMinimumWidth(g)
    @ccall libgeos.GEOSMinimumWidth(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSPointOnSurface(g)
    @ccall libgeos.GEOSPointOnSurface(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSGetCentroid(g)
    @ccall libgeos.GEOSGetCentroid(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSMinimumBoundingCircle(g, radius, center)
    @ccall libgeos.GEOSMinimumBoundingCircle(
        g::Ptr{GEOSGeometry},
        radius::Ptr{Cdouble},
        center::Ptr{Ptr{GEOSGeometry}},
    )::Ptr{GEOSGeometry}
end

function GEOSDelaunayTriangulation(g, tolerance, onlyEdges)
    @ccall libgeos.GEOSDelaunayTriangulation(
        g::Ptr{GEOSGeometry},
        tolerance::Cdouble,
        onlyEdges::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSConstrainedDelaunayTriangulation(g)
    @ccall libgeos.GEOSConstrainedDelaunayTriangulation(
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

@cenum GEOSVoronoiFlags::UInt32 begin
    GEOS_VORONOI_ONLY_EDGES = 1
    GEOS_VORONOI_PRESERVE_ORDER = 2
end

function GEOSVoronoiDiagram(g, env, tolerance, flags)
    @ccall libgeos.GEOSVoronoiDiagram(
        g::Ptr{GEOSGeometry},
        env::Ptr{GEOSGeometry},
        tolerance::Cdouble,
        flags::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSNode(g)
    @ccall libgeos.GEOSNode(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSPolygonize(geoms, ngeoms)
    @ccall libgeos.GEOSPolygonize(
        geoms::Ptr{Ptr{GEOSGeometry}},
        ngeoms::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSPolygonize_valid(geoms, ngeoms)
    @ccall libgeos.GEOSPolygonize_valid(
        geoms::Ptr{Ptr{GEOSGeometry}},
        ngeoms::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSPolygonizer_getCutEdges(geoms, ngeoms)
    @ccall libgeos.GEOSPolygonizer_getCutEdges(
        geoms::Ptr{Ptr{GEOSGeometry}},
        ngeoms::Cuint,
    )::Ptr{GEOSGeometry}
end

function GEOSPolygonize_full(input, cuts, dangles, invalid)
    @ccall libgeos.GEOSPolygonize_full(
        input::Ptr{GEOSGeometry},
        cuts::Ptr{Ptr{GEOSGeometry}},
        dangles::Ptr{Ptr{GEOSGeometry}},
        invalid::Ptr{Ptr{GEOSGeometry}},
    )::Ptr{GEOSGeometry}
end

function GEOSBuildArea(g)
    @ccall libgeos.GEOSBuildArea(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSDensify(g, tolerance)
    @ccall libgeos.GEOSDensify(g::Ptr{GEOSGeometry}, tolerance::Cdouble)::Ptr{GEOSGeometry}
end

function GEOSLineMerge(g)
    @ccall libgeos.GEOSLineMerge(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSLineMergeDirected(g)
    @ccall libgeos.GEOSLineMergeDirected(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSLineSubstring(g, start_fraction, end_fraction)
    @ccall libgeos.GEOSLineSubstring(
        g::Ptr{GEOSGeometry},
        start_fraction::Cdouble,
        end_fraction::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSReverse(g)
    @ccall libgeos.GEOSReverse(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSSimplify(g, tolerance)
    @ccall libgeos.GEOSSimplify(g::Ptr{GEOSGeometry}, tolerance::Cdouble)::Ptr{GEOSGeometry}
end

function GEOSTopologyPreserveSimplify(g, tolerance)
    @ccall libgeos.GEOSTopologyPreserveSimplify(
        g::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_extractUniquePoints(g)
    @ccall libgeos.GEOSGeom_extractUniquePoints(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSHilbertCode(geom, extent, level, code)
    @ccall libgeos.GEOSHilbertCode(
        geom::Ptr{GEOSGeometry},
        extent::Ptr{GEOSGeometry},
        level::Cuint,
        code::Ptr{Cuint},
    )::Cint
end

function GEOSGeom_transformXY(g, callback, userdata)
    @ccall libgeos.GEOSGeom_transformXY(
        g::Ptr{GEOSGeometry},
        callback::GEOSTransformXYCallback,
        userdata::Ptr{Cvoid},
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_transformXYZ(g, callback, userdata)
    @ccall libgeos.GEOSGeom_transformXYZ(
        g::Ptr{GEOSGeometry},
        callback::GEOSTransformXYZCallback,
        userdata::Ptr{Cvoid},
    )::Ptr{GEOSGeometry}
end

function GEOSSnap(input, snap_target, tolerance)
    @ccall libgeos.GEOSSnap(
        input::Ptr{GEOSGeometry},
        snap_target::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Ptr{GEOSGeometry}
end

function GEOSGeom_setPrecision(g, gridSize, flags)
    @ccall libgeos.GEOSGeom_setPrecision(
        g::Ptr{GEOSGeometry},
        gridSize::Cdouble,
        flags::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSDisjoint(g1, g2)
    @ccall libgeos.GEOSDisjoint(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSTouches(g1, g2)
    @ccall libgeos.GEOSTouches(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSIntersects(g1, g2)
    @ccall libgeos.GEOSIntersects(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSCrosses(g1, g2)
    @ccall libgeos.GEOSCrosses(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSWithin(g1, g2)
    @ccall libgeos.GEOSWithin(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSContains(g1, g2)
    @ccall libgeos.GEOSContains(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSOverlaps(g1, g2)
    @ccall libgeos.GEOSOverlaps(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSEquals(g1, g2)
    @ccall libgeos.GEOSEquals(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSCovers(g1, g2)
    @ccall libgeos.GEOSCovers(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSCoveredBy(g1, g2)
    @ccall libgeos.GEOSCoveredBy(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSEqualsExact(g1, g2, tolerance)
    @ccall libgeos.GEOSEqualsExact(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        tolerance::Cdouble,
    )::Cchar
end

function GEOSEqualsIdentical(g1, g2)
    @ccall libgeos.GEOSEqualsIdentical(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cchar
end

function GEOSRelatePattern(g1, g2, imPattern)
    @ccall libgeos.GEOSRelatePattern(
        g1::Ptr{GEOSGeometry},
        g2::Ptr{GEOSGeometry},
        imPattern::Cstring,
    )::Cchar
end

function GEOSRelate(g1, g2)
    string_copy_free(
        @ccall(libgeos.GEOSRelate(g1::Ptr{GEOSGeometry}, g2::Ptr{GEOSGeometry})::Cstring)
    )
end

function GEOSRelatePatternMatch(intMatrix, imPattern)
    @ccall libgeos.GEOSRelatePatternMatch(intMatrix::Cstring, imPattern::Cstring)::Cchar
end

function GEOSRelateBoundaryNodeRule(g1, g2, bnr)
    string_copy_free(
        @ccall(
            libgeos.GEOSRelateBoundaryNodeRule(
                g1::Ptr{GEOSGeometry},
                g2::Ptr{GEOSGeometry},
                bnr::Cint,
            )::Cstring
        )
    )
end

function GEOSPrepare(g)
    @ccall libgeos.GEOSPrepare(g::Ptr{GEOSGeometry})::Ptr{GEOSPreparedGeometry}
end

function GEOSPreparedGeom_destroy(g)
    @ccall libgeos.GEOSPreparedGeom_destroy(g::Ptr{GEOSPreparedGeometry})::Cvoid
end

function GEOSPreparedContains(pg1, g2)
    @ccall libgeos.GEOSPreparedContains(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedContainsXY(pg1, x, y)
    @ccall libgeos.GEOSPreparedContainsXY(
        pg1::Ptr{GEOSPreparedGeometry},
        x::Cdouble,
        y::Cdouble,
    )::Cchar
end

function GEOSPreparedContainsProperly(pg1, g2)
    @ccall libgeos.GEOSPreparedContainsProperly(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedCoveredBy(pg1, g2)
    @ccall libgeos.GEOSPreparedCoveredBy(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedCovers(pg1, g2)
    @ccall libgeos.GEOSPreparedCovers(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedCrosses(pg1, g2)
    @ccall libgeos.GEOSPreparedCrosses(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedDisjoint(pg1, g2)
    @ccall libgeos.GEOSPreparedDisjoint(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedIntersects(pg1, g2)
    @ccall libgeos.GEOSPreparedIntersects(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedIntersectsXY(pg1, x, y)
    @ccall libgeos.GEOSPreparedIntersectsXY(
        pg1::Ptr{GEOSPreparedGeometry},
        x::Cdouble,
        y::Cdouble,
    )::Cchar
end

function GEOSPreparedOverlaps(pg1, g2)
    @ccall libgeos.GEOSPreparedOverlaps(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedTouches(pg1, g2)
    @ccall libgeos.GEOSPreparedTouches(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedWithin(pg1, g2)
    @ccall libgeos.GEOSPreparedWithin(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Cchar
end

function GEOSPreparedRelate(pg1, g2)
    string_copy_free(
        @ccall(
            libgeos.GEOSPreparedRelate(
                pg1::Ptr{GEOSPreparedGeometry},
                g2::Ptr{GEOSGeometry},
            )::Cstring
        )
    )
end

function GEOSPreparedRelatePattern(pg1, g2, imPattern)
    @ccall libgeos.GEOSPreparedRelatePattern(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
        imPattern::Cstring,
    )::Cchar
end

function GEOSPreparedNearestPoints(pg1, g2)
    @ccall libgeos.GEOSPreparedNearestPoints(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
    )::Ptr{GEOSCoordSequence}
end

function GEOSPreparedDistance(pg1, g2, dist)
    @ccall libgeos.GEOSPreparedDistance(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Ptr{Cdouble},
    )::Cint
end

function GEOSPreparedDistanceWithin(pg1, g2, dist)
    @ccall libgeos.GEOSPreparedDistanceWithin(
        pg1::Ptr{GEOSPreparedGeometry},
        g2::Ptr{GEOSGeometry},
        dist::Cdouble,
    )::Cchar
end

function GEOSSTRtree_create(nodeCapacity)
    @ccall libgeos.GEOSSTRtree_create(nodeCapacity::Csize_t)::Ptr{GEOSSTRtree}
end

function GEOSSTRtree_build(tree)
    @ccall libgeos.GEOSSTRtree_build(tree::Ptr{GEOSSTRtree})::Cint
end

function GEOSSTRtree_insert(tree, g, item)
    @ccall libgeos.GEOSSTRtree_insert(
        tree::Ptr{GEOSSTRtree},
        g::Ptr{GEOSGeometry},
        item::Ptr{Cvoid},
    )::Cvoid
end

function GEOSSTRtree_query(tree, g, callback, userdata)
    @ccall libgeos.GEOSSTRtree_query(
        tree::Ptr{GEOSSTRtree},
        g::Ptr{GEOSGeometry},
        callback::GEOSQueryCallback,
        userdata::Ptr{Cvoid},
    )::Cvoid
end

function GEOSSTRtree_nearest(tree, geom)
    @ccall libgeos.GEOSSTRtree_nearest(
        tree::Ptr{GEOSSTRtree},
        geom::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

function GEOSSTRtree_nearest_generic(tree, item, itemEnvelope, distancefn, userdata)
    @ccall libgeos.GEOSSTRtree_nearest_generic(
        tree::Ptr{GEOSSTRtree},
        item::Ptr{Cvoid},
        itemEnvelope::Ptr{GEOSGeometry},
        distancefn::GEOSDistanceCallback,
        userdata::Ptr{Cvoid},
    )::Ptr{Cvoid}
end

function GEOSSTRtree_iterate(tree, callback, userdata)
    @ccall libgeos.GEOSSTRtree_iterate(
        tree::Ptr{GEOSSTRtree},
        callback::GEOSQueryCallback,
        userdata::Ptr{Cvoid},
    )::Cvoid
end

function GEOSSTRtree_remove(tree, g, item)
    @ccall libgeos.GEOSSTRtree_remove(
        tree::Ptr{GEOSSTRtree},
        g::Ptr{GEOSGeometry},
        item::Ptr{Cvoid},
    )::Cchar
end

function GEOSSTRtree_destroy(tree)
    @ccall libgeos.GEOSSTRtree_destroy(tree::Ptr{GEOSSTRtree})::Cvoid
end

function GEOSSegmentIntersection(ax0, ay0, ax1, ay1, bx0, by0, bx1, by1, cx, cy)
    @ccall libgeos.GEOSSegmentIntersection(
        ax0::Cdouble,
        ay0::Cdouble,
        ax1::Cdouble,
        ay1::Cdouble,
        bx0::Cdouble,
        by0::Cdouble,
        bx1::Cdouble,
        by1::Cdouble,
        cx::Ptr{Cdouble},
        cy::Ptr{Cdouble},
    )::Cint
end

function GEOSOrientationIndex(Ax, Ay, Bx, By, Px, Py)
    @ccall libgeos.GEOSOrientationIndex(
        Ax::Cdouble,
        Ay::Cdouble,
        Bx::Cdouble,
        By::Cdouble,
        Px::Cdouble,
        Py::Cdouble,
    )::Cint
end

function GEOSWKTReader_create()
    @ccall libgeos.GEOSWKTReader_create()::Ptr{GEOSWKTReader}
end

function GEOSWKTReader_destroy(reader)
    @ccall libgeos.GEOSWKTReader_destroy(reader::Ptr{GEOSWKTReader})::Cvoid
end

function GEOSWKTReader_read(reader, wkt)
    @ccall libgeos.GEOSWKTReader_read(
        reader::Ptr{GEOSWKTReader},
        wkt::Cstring,
    )::Ptr{GEOSGeometry}
end

function GEOSWKTReader_setFixStructure(reader, doFix)
    @ccall libgeos.GEOSWKTReader_setFixStructure(
        reader::Ptr{GEOSWKTReader},
        doFix::Cchar,
    )::Cvoid
end

function GEOSWKTWriter_create()
    @ccall libgeos.GEOSWKTWriter_create()::Ptr{GEOSWKTWriter}
end

function GEOSWKTWriter_destroy(writer)
    @ccall libgeos.GEOSWKTWriter_destroy(writer::Ptr{GEOSWKTWriter})::Cvoid
end

function GEOSWKTWriter_write(writer, g)
    string_copy_free(
        @ccall(
            libgeos.GEOSWKTWriter_write(
                writer::Ptr{GEOSWKTWriter},
                g::Ptr{GEOSGeometry},
            )::Cstring
        )
    )
end

function GEOSWKTWriter_setTrim(writer, trim)
    @ccall libgeos.GEOSWKTWriter_setTrim(writer::Ptr{GEOSWKTWriter}, trim::Cchar)::Cvoid
end

function GEOSWKTWriter_setRoundingPrecision(writer, precision)
    @ccall libgeos.GEOSWKTWriter_setRoundingPrecision(
        writer::Ptr{GEOSWKTWriter},
        precision::Cint,
    )::Cvoid
end

function GEOSWKTWriter_setOutputDimension(writer, dim)
    @ccall libgeos.GEOSWKTWriter_setOutputDimension(
        writer::Ptr{GEOSWKTWriter},
        dim::Cint,
    )::Cvoid
end

function GEOSWKTWriter_getOutputDimension(writer)
    @ccall libgeos.GEOSWKTWriter_getOutputDimension(writer::Ptr{GEOSWKTWriter})::Cint
end

function GEOSWKTWriter_setOld3D(writer, useOld3D)
    @ccall libgeos.GEOSWKTWriter_setOld3D(writer::Ptr{GEOSWKTWriter}, useOld3D::Cint)::Cvoid
end

function GEOSWKBReader_create()
    @ccall libgeos.GEOSWKBReader_create()::Ptr{GEOSWKBReader}
end

function GEOSWKBReader_destroy(reader)
    @ccall libgeos.GEOSWKBReader_destroy(reader::Ptr{GEOSWKBReader})::Cvoid
end

function GEOSWKBReader_setFixStructure(reader, doFix)
    @ccall libgeos.GEOSWKBReader_setFixStructure(
        reader::Ptr{GEOSWKBReader},
        doFix::Cchar,
    )::Cvoid
end

function GEOSWKBReader_read(reader, wkb, size)
    @ccall libgeos.GEOSWKBReader_read(
        reader::Ptr{GEOSWKBReader},
        wkb::Ptr{Cuchar},
        size::Csize_t,
    )::Ptr{GEOSGeometry}
end

function GEOSWKBReader_readHEX(reader, hex, size)
    @ccall libgeos.GEOSWKBReader_readHEX(
        reader::Ptr{GEOSWKBReader},
        hex::Ptr{Cuchar},
        size::Csize_t,
    )::Ptr{GEOSGeometry}
end

function GEOSWKBWriter_create()
    @ccall libgeos.GEOSWKBWriter_create()::Ptr{GEOSWKBWriter}
end

function GEOSWKBWriter_destroy(writer)
    @ccall libgeos.GEOSWKBWriter_destroy(writer::Ptr{GEOSWKBWriter})::Cvoid
end

function GEOSWKBWriter_write(writer, g, size)
    @ccall libgeos.GEOSWKBWriter_write(
        writer::Ptr{GEOSWKBWriter},
        g::Ptr{GEOSGeometry},
        size::Ptr{Csize_t},
    )::Ptr{Cuchar}
end

function GEOSWKBWriter_writeHEX(writer, g, size)
    @ccall libgeos.GEOSWKBWriter_writeHEX(
        writer::Ptr{GEOSWKBWriter},
        g::Ptr{GEOSGeometry},
        size::Ptr{Csize_t},
    )::Ptr{Cuchar}
end

function GEOSWKBWriter_getOutputDimension(writer)
    @ccall libgeos.GEOSWKBWriter_getOutputDimension(writer::Ptr{GEOSWKBWriter})::Cint
end

function GEOSWKBWriter_setOutputDimension(writer, newDimension)
    @ccall libgeos.GEOSWKBWriter_setOutputDimension(
        writer::Ptr{GEOSWKBWriter},
        newDimension::Cint,
    )::Cvoid
end

function GEOSWKBWriter_getByteOrder(writer)
    @ccall libgeos.GEOSWKBWriter_getByteOrder(writer::Ptr{GEOSWKBWriter})::Cint
end

function GEOSWKBWriter_setByteOrder(writer, byteOrder)
    @ccall libgeos.GEOSWKBWriter_setByteOrder(
        writer::Ptr{GEOSWKBWriter},
        byteOrder::Cint,
    )::Cvoid
end

function GEOSWKBWriter_getFlavor(writer)
    @ccall libgeos.GEOSWKBWriter_getFlavor(writer::Ptr{GEOSWKBWriter})::Cint
end

function GEOSWKBWriter_setFlavor(writer, flavor)
    @ccall libgeos.GEOSWKBWriter_setFlavor(writer::Ptr{GEOSWKBWriter}, flavor::Cint)::Cvoid
end

function GEOSWKBWriter_getIncludeSRID(writer)
    @ccall libgeos.GEOSWKBWriter_getIncludeSRID(writer::Ptr{GEOSWKBWriter})::Cchar
end

function GEOSWKBWriter_setIncludeSRID(writer, writeSRID)
    @ccall libgeos.GEOSWKBWriter_setIncludeSRID(
        writer::Ptr{GEOSWKBWriter},
        writeSRID::Cchar,
    )::Cvoid
end

function GEOSGeoJSONReader_create()
    @ccall libgeos.GEOSGeoJSONReader_create()::Ptr{GEOSGeoJSONReader}
end

function GEOSGeoJSONReader_destroy(reader)
    @ccall libgeos.GEOSGeoJSONReader_destroy(reader::Ptr{GEOSGeoJSONReader})::Cvoid
end

function GEOSGeoJSONReader_readGeometry(reader, geojson)
    @ccall libgeos.GEOSGeoJSONReader_readGeometry(
        reader::Ptr{GEOSGeoJSONReader},
        geojson::Cstring,
    )::Ptr{GEOSGeometry}
end

function GEOSGeoJSONWriter_create()
    @ccall libgeos.GEOSGeoJSONWriter_create()::Ptr{GEOSGeoJSONWriter}
end

function GEOSGeoJSONWriter_destroy(writer)
    @ccall libgeos.GEOSGeoJSONWriter_destroy(writer::Ptr{GEOSGeoJSONWriter})::Cvoid
end

function GEOSGeoJSONWriter_writeGeometry(writer, g, indent)
    string_copy_free(
        @ccall(
            libgeos.GEOSGeoJSONWriter_writeGeometry(
                writer::Ptr{GEOSGeoJSONWriter},
                g::Ptr{GEOSGeometry},
                indent::Cint,
            )::Cstring
        )
    )
end

function GEOSGeoJSONWriter_setOutputDimension(writer, dim)
    @ccall libgeos.GEOSGeoJSONWriter_setOutputDimension(
        writer::Ptr{GEOSGeoJSONWriter},
        dim::Cint,
    )::Cvoid
end

function GEOSGeoJSONWriter_getOutputDimension(writer)
    @ccall libgeos.GEOSGeoJSONWriter_getOutputDimension(
        writer::Ptr{GEOSGeoJSONWriter},
    )::Cint
end

function GEOSSingleSidedBuffer(g, width, quadsegs, joinStyle, mitreLimit, leftSide)
    @ccall libgeos.GEOSSingleSidedBuffer(
        g::Ptr{GEOSGeometry},
        width::Cdouble,
        quadsegs::Cint,
        joinStyle::Cint,
        mitreLimit::Cdouble,
        leftSide::Cint,
    )::Ptr{GEOSGeometry}
end

function GEOSSingleSidedBuffer_r(
    handle,
    g,
    width,
    quadsegs,
    joinStyle,
    mitreLimit,
    leftSide,
)
    @ccall libgeos.GEOSSingleSidedBuffer_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        width::Cdouble,
        quadsegs::Cint,
        joinStyle::Cint,
        mitreLimit::Cdouble,
        leftSide::Cint,
    )::Ptr{GEOSGeometry}
end

function initGEOS_r(notice_function, error_function)
    @ccall libgeos.initGEOS_r(
        notice_function::GEOSMessageHandler,
        error_function::GEOSMessageHandler,
    )::GEOSContextHandle_t
end

function finishGEOS_r(handle)
    @ccall libgeos.finishGEOS_r(handle::GEOSContextHandle_t)::Cvoid
end

function GEOSGeomFromWKT_r(handle, wkt)
    @ccall libgeos.GEOSGeomFromWKT_r(
        handle::GEOSContextHandle_t,
        wkt::Cstring,
    )::Ptr{GEOSGeometry}
end

function GEOSGeomToWKT_r(handle, g)
    string_copy_free(
        @ccall(
            libgeos.GEOSGeomToWKT_r(
                handle::GEOSContextHandle_t,
                g::Ptr{GEOSGeometry},
            )::Cstring
        ),
        handle,
    )
end

function GEOS_getWKBOutputDims_r(handle)
    @ccall libgeos.GEOS_getWKBOutputDims_r(handle::GEOSContextHandle_t)::Cint
end

function GEOS_setWKBOutputDims_r(handle, newDims)
    @ccall libgeos.GEOS_setWKBOutputDims_r(handle::GEOSContextHandle_t, newDims::Cint)::Cint
end

function GEOS_getWKBByteOrder_r(handle)
    @ccall libgeos.GEOS_getWKBByteOrder_r(handle::GEOSContextHandle_t)::Cint
end

function GEOS_setWKBByteOrder_r(handle, byteOrder)
    @ccall libgeos.GEOS_setWKBByteOrder_r(
        handle::GEOSContextHandle_t,
        byteOrder::Cint,
    )::Cint
end

function GEOSGeomFromWKB_buf_r(handle, wkb, size)
    @ccall libgeos.GEOSGeomFromWKB_buf_r(
        handle::GEOSContextHandle_t,
        wkb::Ptr{Cuchar},
        size::Csize_t,
    )::Ptr{GEOSGeometry}
end

function GEOSGeomToWKB_buf_r(handle, g, size)
    @ccall libgeos.GEOSGeomToWKB_buf_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        size::Ptr{Csize_t},
    )::Ptr{Cuchar}
end

function GEOSGeomFromHEX_buf_r(handle, hex, size)
    @ccall libgeos.GEOSGeomFromHEX_buf_r(
        handle::GEOSContextHandle_t,
        hex::Ptr{Cuchar},
        size::Csize_t,
    )::Ptr{GEOSGeometry}
end

function GEOSGeomToHEX_buf_r(handle, g, size)
    @ccall libgeos.GEOSGeomToHEX_buf_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
        size::Ptr{Csize_t},
    )::Ptr{Cuchar}
end

function GEOSGeomFromWKT(wkt)
    @ccall libgeos.GEOSGeomFromWKT(wkt::Cstring)::Ptr{GEOSGeometry}
end

function GEOSGeomToWKT(g)
    string_copy_free(@ccall(libgeos.GEOSGeomToWKT(g::Ptr{GEOSGeometry})::Cstring))
end

function GEOS_getWKBOutputDims()
    @ccall libgeos.GEOS_getWKBOutputDims()::Cint
end

function GEOS_setWKBOutputDims(newDims)
    @ccall libgeos.GEOS_setWKBOutputDims(newDims::Cint)::Cint
end

function GEOS_getWKBByteOrder()
    @ccall libgeos.GEOS_getWKBByteOrder()::Cint
end

function GEOS_setWKBByteOrder(byteOrder)
    @ccall libgeos.GEOS_setWKBByteOrder(byteOrder::Cint)::Cint
end

function GEOSGeomFromWKB_buf(wkb, size)
    @ccall libgeos.GEOSGeomFromWKB_buf(wkb::Ptr{Cuchar}, size::Csize_t)::Ptr{GEOSGeometry}
end

function GEOSGeomToWKB_buf(g, size)
    @ccall libgeos.GEOSGeomToWKB_buf(g::Ptr{GEOSGeometry}, size::Ptr{Csize_t})::Ptr{Cuchar}
end

function GEOSGeomFromHEX_buf(hex, size)
    @ccall libgeos.GEOSGeomFromHEX_buf(hex::Ptr{Cuchar}, size::Csize_t)::Ptr{GEOSGeometry}
end

function GEOSGeomToHEX_buf(g, size)
    @ccall libgeos.GEOSGeomToHEX_buf(g::Ptr{GEOSGeometry}, size::Ptr{Csize_t})::Ptr{Cuchar}
end

function GEOSUnionCascaded(g)
    @ccall libgeos.GEOSUnionCascaded(g::Ptr{GEOSGeometry})::Ptr{GEOSGeometry}
end

function GEOSUnionCascaded_r(handle, g)
    @ccall libgeos.GEOSUnionCascaded_r(
        handle::GEOSContextHandle_t,
        g::Ptr{GEOSGeometry},
    )::Ptr{GEOSGeometry}
end

const GEOS_VERSION_MAJOR = 3

const GEOS_VERSION_MINOR = 14

const GEOS_VERSION_PATCH = 1

const GEOS_VERSION = "3.14.1"

const GEOS_JTS_PORT = "1.18.0"

const GEOS_CAPI_VERSION_MAJOR = 1

const GEOS_CAPI_VERSION_MINOR = 20

const GEOS_CAPI_VERSION_PATCH = 5

const GEOS_CAPI_VERSION = "3.14.1-CAPI-1.20.5"

const GEOS_CAPI_FIRST_INTERFACE = GEOS_CAPI_VERSION_MAJOR

const GEOS_CAPI_LAST_INTERFACE = GEOS_CAPI_VERSION_MAJOR + GEOS_CAPI_VERSION_MINOR
