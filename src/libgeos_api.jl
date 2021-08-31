const GEOSContextHandle_HS = Cvoid

const GEOSContextHandle_t = Ptr{GEOSContextHandle_HS}

# typedef void ( * GEOSMessageHandler ) ( const char * fmt , ... )
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
end

@cenum GEOSByteOrders::UInt32 begin
    GEOS_WKB_XDR = 0
    GEOS_WKB_NDR = 1
end

# typedef void ( * GEOSQueryCallback ) ( void * item , void * userdata )
const GEOSQueryCallback = Ptr{Cvoid}

# typedef int ( * GEOSDistanceCallback ) ( const void * item1 , const void * item2 , double * distance , void * userdata )
const GEOSDistanceCallback = Ptr{Cvoid}

# typedef void ( GEOSInterruptCallback ) ( )
const GEOSInterruptCallback = Cvoid

function GEOS_interruptRegisterCallback(cb)
    ccall((:GEOS_interruptRegisterCallback, libgeos), Ptr{Cvoid}, (Ptr{Cvoid},), cb)
end

# no prototype is found for this function at geos_c.h:163:22, please use with caution
function GEOS_interruptRequest()
    ccall((:GEOS_interruptRequest, libgeos), Cvoid, ())
end

# no prototype is found for this function at geos_c.h:165:22, please use with caution
function GEOS_interruptCancel()
    ccall((:GEOS_interruptCancel, libgeos), Cvoid, ())
end

function initGEOS_r(notice_function, error_function)
    ccall((:initGEOS_r, libgeos), GEOSContextHandle_t, (GEOSMessageHandler, GEOSMessageHandler), notice_function, error_function)
end

function finishGEOS_r(handle)
    ccall((:finishGEOS_r, libgeos), Cvoid, (GEOSContextHandle_t,), handle)
end

# no prototype is found for this function at geos_c.h:180:37, please use with caution
function GEOS_init_r()
    ccall((:GEOS_init_r, libgeos), GEOSContextHandle_t, ())
end

function GEOS_finish_r(handle)
    ccall((:GEOS_finish_r, libgeos), Cvoid, (GEOSContextHandle_t,), handle)
end

function GEOSContext_setNoticeHandler_r(extHandle, nf)
    ccall((:GEOSContext_setNoticeHandler_r, libgeos), GEOSMessageHandler, (GEOSContextHandle_t, GEOSMessageHandler), extHandle, nf)
end

function GEOSContext_setErrorHandler_r(extHandle, ef)
    ccall((:GEOSContext_setErrorHandler_r, libgeos), GEOSMessageHandler, (GEOSContextHandle_t, GEOSMessageHandler), extHandle, ef)
end

function GEOSContext_setNoticeMessageHandler_r(extHandle, nf, userData)
    ccall((:GEOSContext_setNoticeMessageHandler_r, libgeos), GEOSMessageHandler_r, (GEOSContextHandle_t, GEOSMessageHandler_r, Ptr{Cvoid}), extHandle, nf, userData)
end

function GEOSContext_setErrorMessageHandler_r(extHandle, ef, userData)
    ccall((:GEOSContext_setErrorMessageHandler_r, libgeos), GEOSMessageHandler_r, (GEOSContextHandle_t, GEOSMessageHandler_r, Ptr{Cvoid}), extHandle, ef, userData)
end

# no prototype is found for this function at geos_c.h:215:29, please use with caution
function GEOSversion()
    unsafe_string(ccall((:GEOSversion, libgeos), Cstring, ()))
end

function GEOSGeomFromWKT_r(handle, wkt)
    ccall((:GEOSGeomFromWKT_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Cstring), handle, wkt)
end

function GEOSGeomToWKT_r(handle, g)
    unsafe_string(ccall((:GEOSGeomToWKT_r, libgeos), Cstring, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g))
end

function GEOS_getWKBOutputDims_r(handle)
    ccall((:GEOS_getWKBOutputDims_r, libgeos), Cint, (GEOSContextHandle_t,), handle)
end

function GEOS_setWKBOutputDims_r(handle, newDims)
    ccall((:GEOS_setWKBOutputDims_r, libgeos), Cint, (GEOSContextHandle_t, Cint), handle, newDims)
end

function GEOS_getWKBByteOrder_r(handle)
    ccall((:GEOS_getWKBByteOrder_r, libgeos), Cint, (GEOSContextHandle_t,), handle)
end

function GEOS_setWKBByteOrder_r(handle, byteOrder)
    ccall((:GEOS_setWKBByteOrder_r, libgeos), Cint, (GEOSContextHandle_t, Cint), handle, byteOrder)
end

function GEOSGeomFromWKB_buf_r(handle, wkb, size)
    ccall((:GEOSGeomFromWKB_buf_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{Cuchar}, Csize_t), handle, wkb, size)
end

function GEOSGeomToWKB_buf_r(handle, g, size)
    ccall((:GEOSGeomToWKB_buf_r, libgeos), Ptr{Cuchar}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Csize_t}), handle, g, size)
end

function GEOSGeomFromHEX_buf_r(handle, hex, size)
    ccall((:GEOSGeomFromHEX_buf_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{Cuchar}, Csize_t), handle, hex, size)
end

function GEOSGeomToHEX_buf_r(handle, g, size)
    ccall((:GEOSGeomToHEX_buf_r, libgeos), Ptr{Cuchar}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Csize_t}), handle, g, size)
end

function GEOSCoordSeq_create_r(handle, size, dims)
    ccall((:GEOSCoordSeq_create_r, libgeos), Ptr{GEOSCoordSequence}, (GEOSContextHandle_t, Cuint, Cuint), handle, size, dims)
end

function GEOSCoordSeq_clone_r(handle, s)
    ccall((:GEOSCoordSeq_clone_r, libgeos), Ptr{GEOSCoordSequence}, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}), handle, s)
end

function GEOSCoordSeq_destroy_r(handle, s)
    ccall((:GEOSCoordSeq_destroy_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}), handle, s)
end

function GEOSCoordSeq_setX_r(handle, s, idx, val)
    ccall((:GEOSCoordSeq_setX_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Cdouble), handle, s, idx, val)
end

function GEOSCoordSeq_setY_r(handle, s, idx, val)
    ccall((:GEOSCoordSeq_setY_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Cdouble), handle, s, idx, val)
end

function GEOSCoordSeq_setZ_r(handle, s, idx, val)
    ccall((:GEOSCoordSeq_setZ_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Cdouble), handle, s, idx, val)
end

function GEOSCoordSeq_setXY_r(handle, s, idx, x, y)
    ccall((:GEOSCoordSeq_setXY_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Cdouble, Cdouble), handle, s, idx, x, y)
end

function GEOSCoordSeq_setXYZ_r(handle, s, idx, x, y, z)
    ccall((:GEOSCoordSeq_setXYZ_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Cdouble, Cdouble, Cdouble), handle, s, idx, x, y, z)
end

function GEOSCoordSeq_setOrdinate_r(handle, s, idx, dim, val)
    ccall((:GEOSCoordSeq_setOrdinate_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Cuint, Cdouble), handle, s, idx, dim, val)
end

function GEOSCoordSeq_getX_r(handle, s, idx, val)
    ccall((:GEOSCoordSeq_getX_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Ptr{Cdouble}), handle, s, idx, val)
end

function GEOSCoordSeq_getY_r(handle, s, idx, val)
    ccall((:GEOSCoordSeq_getY_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Ptr{Cdouble}), handle, s, idx, val)
end

function GEOSCoordSeq_getZ_r(handle, s, idx, val)
    ccall((:GEOSCoordSeq_getZ_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Ptr{Cdouble}), handle, s, idx, val)
end

function GEOSCoordSeq_getXY_r(handle, s, idx, x, y)
    ccall((:GEOSCoordSeq_getXY_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Ptr{Cdouble}, Ptr{Cdouble}), handle, s, idx, x, y)
end

function GEOSCoordSeq_getXYZ_r(handle, s, idx, x, y, z)
    ccall((:GEOSCoordSeq_getXYZ_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), handle, s, idx, x, y, z)
end

function GEOSCoordSeq_getOrdinate_r(handle, s, idx, dim, val)
    ccall((:GEOSCoordSeq_getOrdinate_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cuint, Cuint, Ptr{Cdouble}), handle, s, idx, dim, val)
end

function GEOSCoordSeq_getSize_r(handle, s, size)
    ccall((:GEOSCoordSeq_getSize_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Ptr{Cuint}), handle, s, size)
end

function GEOSCoordSeq_getDimensions_r(handle, s, dims)
    ccall((:GEOSCoordSeq_getDimensions_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Ptr{Cuint}), handle, s, dims)
end

function GEOSCoordSeq_isCCW_r(handle, s, is_ccw)
    ccall((:GEOSCoordSeq_isCCW_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}, Cstring), handle, s, is_ccw)
end

function GEOSProject_r(handle, g, p)
    ccall((:GEOSProject_r, libgeos), Cdouble, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g, p)
end

function GEOSInterpolate_r(handle, g, d)
    ccall((:GEOSInterpolate_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble), handle, g, d)
end

function GEOSProjectNormalized_r(handle, g, p)
    ccall((:GEOSProjectNormalized_r, libgeos), Cdouble, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g, p)
end

function GEOSInterpolateNormalized_r(handle, g, d)
    ccall((:GEOSInterpolateNormalized_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble), handle, g, d)
end

function GEOSBuffer_r(handle, g, width, quadsegs)
    ccall((:GEOSBuffer_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble, Cint), handle, g, width, quadsegs)
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
    ccall((:GEOSBufferParams_create_r, libgeos), Ptr{GEOSBufferParams}, (GEOSContextHandle_t,), handle)
end

function GEOSBufferParams_destroy_r(handle, parms)
    ccall((:GEOSBufferParams_destroy_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSBufferParams}), handle, parms)
end

function GEOSBufferParams_setEndCapStyle_r(handle, p, style)
    ccall((:GEOSBufferParams_setEndCapStyle_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSBufferParams}, Cint), handle, p, style)
end

function GEOSBufferParams_setJoinStyle_r(handle, p, joinStyle)
    ccall((:GEOSBufferParams_setJoinStyle_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSBufferParams}, Cint), handle, p, joinStyle)
end

function GEOSBufferParams_setMitreLimit_r(handle, p, mitreLimit)
    ccall((:GEOSBufferParams_setMitreLimit_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSBufferParams}, Cdouble), handle, p, mitreLimit)
end

function GEOSBufferParams_setQuadrantSegments_r(handle, p, quadSegs)
    ccall((:GEOSBufferParams_setQuadrantSegments_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSBufferParams}, Cint), handle, p, quadSegs)
end

function GEOSBufferParams_setSingleSided_r(handle, p, singleSided)
    ccall((:GEOSBufferParams_setSingleSided_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSBufferParams}, Cint), handle, p, singleSided)
end

function GEOSBufferWithParams_r(handle, g, p, width)
    ccall((:GEOSBufferWithParams_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSBufferParams}, Cdouble), handle, g, p, width)
end

function GEOSBufferWithStyle_r(handle, g, width, quadsegs, endCapStyle, joinStyle, mitreLimit)
    ccall((:GEOSBufferWithStyle_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble, Cint, Cint, Cint, Cdouble), handle, g, width, quadsegs, endCapStyle, joinStyle, mitreLimit)
end

function GEOSSingleSidedBuffer_r(handle, g, width, quadsegs, joinStyle, mitreLimit, leftSide)
    ccall((:GEOSSingleSidedBuffer_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble, Cint, Cint, Cdouble, Cint), handle, g, width, quadsegs, joinStyle, mitreLimit, leftSide)
end

function GEOSOffsetCurve_r(handle, g, width, quadsegs, joinStyle, mitreLimit)
    ccall((:GEOSOffsetCurve_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble, Cint, Cint, Cdouble), handle, g, width, quadsegs, joinStyle, mitreLimit)
end

function GEOSGeom_createPoint_r(handle, s)
    ccall((:GEOSGeom_createPoint_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}), handle, s)
end

function GEOSGeom_createPointFromXY_r(handle, x, y)
    ccall((:GEOSGeom_createPointFromXY_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Cdouble, Cdouble), handle, x, y)
end

function GEOSGeom_createEmptyPoint_r(handle)
    ccall((:GEOSGeom_createEmptyPoint_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t,), handle)
end

function GEOSGeom_createLinearRing_r(handle, s)
    ccall((:GEOSGeom_createLinearRing_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}), handle, s)
end

function GEOSGeom_createLineString_r(handle, s)
    ccall((:GEOSGeom_createLineString_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSCoordSequence}), handle, s)
end

function GEOSGeom_createEmptyLineString_r(handle)
    ccall((:GEOSGeom_createEmptyLineString_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t,), handle)
end

function GEOSGeom_createEmptyPolygon_r(handle)
    ccall((:GEOSGeom_createEmptyPolygon_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t,), handle)
end

function GEOSGeom_createPolygon_r(handle, shell, holes, nholes)
    ccall((:GEOSGeom_createPolygon_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Ptr{GEOSGeometry}}, Cuint), handle, shell, holes, nholes)
end

function GEOSGeom_createCollection_r(handle, type, geoms, ngeoms)
    ccall((:GEOSGeom_createCollection_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Cint, Ptr{Ptr{GEOSGeometry}}, Cuint), handle, type, geoms, ngeoms)
end

function GEOSGeom_createEmptyCollection_r(handle, type)
    ccall((:GEOSGeom_createEmptyCollection_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Cint), handle, type)
end

function GEOSGeom_clone_r(handle, g)
    ccall((:GEOSGeom_clone_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeom_destroy_r(handle, g)
    ccall((:GEOSGeom_destroy_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSEnvelope_r(handle, g)
    ccall((:GEOSEnvelope_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSIntersection_r(handle, g1, g2)
    ccall((:GEOSIntersection_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSIntersectionPrec_r(handle, g1, g2, gridSize)
    ccall((:GEOSIntersectionPrec_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), handle, g1, g2, gridSize)
end

function GEOSConvexHull_r(handle, g)
    ccall((:GEOSConvexHull_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSMinimumRotatedRectangle_r(handle, g)
    ccall((:GEOSMinimumRotatedRectangle_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSMaximumInscribedCircle_r(handle, g, tolerance)
    ccall((:GEOSMaximumInscribedCircle_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble), handle, g, tolerance)
end

function GEOSLargestEmptyCircle_r(handle, g, boundary, tolerance)
    ccall((:GEOSLargestEmptyCircle_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), handle, g, boundary, tolerance)
end

function GEOSMinimumWidth_r(handle, g)
    ccall((:GEOSMinimumWidth_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSMinimumClearanceLine_r(handle, g)
    ccall((:GEOSMinimumClearanceLine_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSMinimumClearance_r(handle, g, distance)
    ccall((:GEOSMinimumClearance_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, distance)
end

function GEOSDifference_r(handle, g1, g2)
    ccall((:GEOSDifference_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSDifferencePrec_r(handle, g1, g2, gridSize)
    ccall((:GEOSDifferencePrec_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), handle, g1, g2, gridSize)
end

function GEOSSymDifference_r(handle, g1, g2)
    ccall((:GEOSSymDifference_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSSymDifferencePrec_r(handle, g1, g2, gridSize)
    ccall((:GEOSSymDifferencePrec_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), handle, g1, g2, gridSize)
end

function GEOSBoundary_r(handle, g)
    ccall((:GEOSBoundary_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSUnion_r(handle, g1, g2)
    ccall((:GEOSUnion_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSUnionPrec_r(handle, g1, g2, gridSize)
    ccall((:GEOSUnionPrec_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), handle, g1, g2, gridSize)
end

function GEOSUnaryUnion_r(handle, g)
    ccall((:GEOSUnaryUnion_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSUnaryUnionPrec_r(handle, g, gridSize)
    ccall((:GEOSUnaryUnionPrec_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble), handle, g, gridSize)
end

function GEOSCoverageUnion_r(handle, g)
    ccall((:GEOSCoverageUnion_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSUnionCascaded_r(handle, g)
    ccall((:GEOSUnionCascaded_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSPointOnSurface_r(handle, g)
    ccall((:GEOSPointOnSurface_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGetCentroid_r(handle, g)
    ccall((:GEOSGetCentroid_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSMinimumBoundingCircle_r(handle, g, radius, center)
    ccall((:GEOSMinimumBoundingCircle_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}, Ptr{Ptr{GEOSGeometry}}), handle, g, radius, center)
end

function GEOSNode_r(handle, g)
    ccall((:GEOSNode_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSClipByRect_r(handle, g, xmin, ymin, xmax, ymax)
    ccall((:GEOSClipByRect_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble, Cdouble, Cdouble, Cdouble), handle, g, xmin, ymin, xmax, ymax)
end

function GEOSPolygonize_r(handle, geoms, ngeoms)
    ccall((:GEOSPolygonize_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{Ptr{GEOSGeometry}}, Cuint), handle, geoms, ngeoms)
end

function GEOSPolygonize_valid_r(handle, geoms, ngems)
    ccall((:GEOSPolygonize_valid_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{Ptr{GEOSGeometry}}, Cuint), handle, geoms, ngems)
end

function GEOSPolygonizer_getCutEdges_r(handle, geoms, ngeoms)
    ccall((:GEOSPolygonizer_getCutEdges_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{Ptr{GEOSGeometry}}, Cuint), handle, geoms, ngeoms)
end

function GEOSPolygonize_full_r(handle, input, cuts, dangles, invalidRings)
    ccall((:GEOSPolygonize_full_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Ptr{GEOSGeometry}}, Ptr{Ptr{GEOSGeometry}}, Ptr{Ptr{GEOSGeometry}}), handle, input, cuts, dangles, invalidRings)
end

function GEOSBuildArea_r(handle, g)
    ccall((:GEOSBuildArea_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSLineMerge_r(handle, g)
    ccall((:GEOSLineMerge_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSReverse_r(handle, g)
    ccall((:GEOSReverse_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSSimplify_r(handle, g, tolerance)
    ccall((:GEOSSimplify_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble), handle, g, tolerance)
end

function GEOSTopologyPreserveSimplify_r(handle, g, tolerance)
    ccall((:GEOSTopologyPreserveSimplify_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble), handle, g, tolerance)
end

function GEOSGeom_extractUniquePoints_r(handle, g)
    ccall((:GEOSGeom_extractUniquePoints_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSSharedPaths_r(handle, g1, g2)
    ccall((:GEOSSharedPaths_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSSnap_r(handle, g1, g2, tolerance)
    ccall((:GEOSSnap_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), handle, g1, g2, tolerance)
end

function GEOSDelaunayTriangulation_r(handle, g, tolerance, onlyEdges)
    ccall((:GEOSDelaunayTriangulation_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble, Cint), handle, g, tolerance, onlyEdges)
end

function GEOSVoronoiDiagram_r(extHandle, g, env, tolerance, onlyEdges)
    ccall((:GEOSVoronoiDiagram_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble, Cint), extHandle, g, env, tolerance, onlyEdges)
end

function GEOSSegmentIntersection_r(extHandle, ax0, ay0, ax1, ay1, bx0, by0, bx1, by1, cx, cy)
    ccall((:GEOSSegmentIntersection_r, libgeos), Cint, (GEOSContextHandle_t, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Ptr{Cdouble}, Ptr{Cdouble}), extHandle, ax0, ay0, ax1, ay1, bx0, by0, bx1, by1, cx, cy)
end

function GEOSDisjoint_r(handle, g1, g2)
    ccall((:GEOSDisjoint_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSTouches_r(handle, g1, g2)
    ccall((:GEOSTouches_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSIntersects_r(handle, g1, g2)
    ccall((:GEOSIntersects_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSCrosses_r(handle, g1, g2)
    ccall((:GEOSCrosses_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSWithin_r(handle, g1, g2)
    ccall((:GEOSWithin_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSContains_r(handle, g1, g2)
    ccall((:GEOSContains_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSOverlaps_r(handle, g1, g2)
    ccall((:GEOSOverlaps_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSEquals_r(handle, g1, g2)
    ccall((:GEOSEquals_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSEqualsExact_r(handle, g1, g2, tolerance)
    ccall((:GEOSEqualsExact_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), handle, g1, g2, tolerance)
end

function GEOSCovers_r(handle, g1, g2)
    ccall((:GEOSCovers_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSCoveredBy_r(handle, g1, g2)
    ccall((:GEOSCoveredBy_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSPrepare_r(handle, g)
    ccall((:GEOSPrepare_r, libgeos), Ptr{GEOSPreparedGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSPreparedGeom_destroy_r(handle, g)
    ccall((:GEOSPreparedGeom_destroy_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}), handle, g)
end

function GEOSPreparedContains_r(handle, pg1, g2)
    ccall((:GEOSPreparedContains_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedContainsProperly_r(handle, pg1, g2)
    ccall((:GEOSPreparedContainsProperly_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedCoveredBy_r(handle, pg1, g2)
    ccall((:GEOSPreparedCoveredBy_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedCovers_r(handle, pg1, g2)
    ccall((:GEOSPreparedCovers_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedCrosses_r(handle, pg1, g2)
    ccall((:GEOSPreparedCrosses_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedDisjoint_r(handle, pg1, g2)
    ccall((:GEOSPreparedDisjoint_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedIntersects_r(handle, pg1, g2)
    ccall((:GEOSPreparedIntersects_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedOverlaps_r(handle, pg1, g2)
    ccall((:GEOSPreparedOverlaps_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedTouches_r(handle, pg1, g2)
    ccall((:GEOSPreparedTouches_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedWithin_r(handle, pg1, g2)
    ccall((:GEOSPreparedWithin_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedNearestPoints_r(handle, pg1, g2)
    ccall((:GEOSPreparedNearestPoints_r, libgeos), Ptr{GEOSCoordSequence}, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), handle, pg1, g2)
end

function GEOSPreparedDistance_r(handle, pg1, g2, dist)
    ccall((:GEOSPreparedDistance_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, pg1, g2, dist)
end

function GEOSSTRtree_create_r(handle, nodeCapacity)
    ccall((:GEOSSTRtree_create_r, libgeos), Ptr{GEOSSTRtree}, (GEOSContextHandle_t, Csize_t), handle, nodeCapacity)
end

function GEOSSTRtree_insert_r(handle, tree, g, item)
    ccall((:GEOSSTRtree_insert_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSSTRtree}, Ptr{GEOSGeometry}, Ptr{Cvoid}), handle, tree, g, item)
end

function GEOSSTRtree_query_r(handle, tree, g, callback, userdata)
    ccall((:GEOSSTRtree_query_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSSTRtree}, Ptr{GEOSGeometry}, GEOSQueryCallback, Ptr{Cvoid}), handle, tree, g, callback, userdata)
end

function GEOSSTRtree_nearest_r(handle, tree, geom)
    ccall((:GEOSSTRtree_nearest_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSSTRtree}, Ptr{GEOSGeometry}), handle, tree, geom)
end

function GEOSSTRtree_nearest_generic_r(handle, tree, item, itemEnvelope, distancefn, userdata)
    ccall((:GEOSSTRtree_nearest_generic_r, libgeos), Ptr{Cvoid}, (GEOSContextHandle_t, Ptr{GEOSSTRtree}, Ptr{Cvoid}, Ptr{GEOSGeometry}, GEOSDistanceCallback, Ptr{Cvoid}), handle, tree, item, itemEnvelope, distancefn, userdata)
end

function GEOSSTRtree_iterate_r(handle, tree, callback, userdata)
    ccall((:GEOSSTRtree_iterate_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSSTRtree}, GEOSQueryCallback, Ptr{Cvoid}), handle, tree, callback, userdata)
end

function GEOSSTRtree_remove_r(handle, tree, g, item)
    ccall((:GEOSSTRtree_remove_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSSTRtree}, Ptr{GEOSGeometry}, Ptr{Cvoid}), handle, tree, g, item)
end

function GEOSSTRtree_destroy_r(handle, tree)
    ccall((:GEOSSTRtree_destroy_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSSTRtree}), handle, tree)
end

function GEOSisEmpty_r(handle, g)
    ccall((:GEOSisEmpty_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSisSimple_r(handle, g)
    ccall((:GEOSisSimple_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSisRing_r(handle, g)
    ccall((:GEOSisRing_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSHasZ_r(handle, g)
    ccall((:GEOSHasZ_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSisClosed_r(handle, g)
    ccall((:GEOSisClosed_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

@cenum GEOSRelateBoundaryNodeRules::UInt32 begin
    GEOSRELATE_BNR_MOD2 = 1
    GEOSRELATE_BNR_OGC = 1
    GEOSRELATE_BNR_ENDPOINT = 2
    GEOSRELATE_BNR_MULTIVALENT_ENDPOINT = 3
    GEOSRELATE_BNR_MONOVALENT_ENDPOINT = 4
end

function GEOSRelatePattern_r(handle, g1, g2, pat)
    ccall((:GEOSRelatePattern_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cstring), handle, g1, g2, pat)
end

function GEOSRelate_r(handle, g1, g2)
    unsafe_string(ccall((:GEOSRelate_r, libgeos), Cstring, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2))
end

function GEOSRelatePatternMatch_r(handle, mat, pat)
    ccall((:GEOSRelatePatternMatch_r, libgeos), Cchar, (GEOSContextHandle_t, Cstring, Cstring), handle, mat, pat)
end

function GEOSRelateBoundaryNodeRule_r(handle, g1, g2, bnr)
    unsafe_string(ccall((:GEOSRelateBoundaryNodeRule_r, libgeos), Cstring, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cint), handle, g1, g2, bnr))
end

@cenum GEOSValidFlags::UInt32 begin
    GEOSVALID_ALLOW_SELFTOUCHING_RING_FORMING_HOLE = 1
end

function GEOSisValid_r(handle, g)
    ccall((:GEOSisValid_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSisValidReason_r(handle, g)
    unsafe_string(ccall((:GEOSisValidReason_r, libgeos), Cstring, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g))
end

function GEOSisValidDetail_r(handle, g, flags, reason, location)
    ccall((:GEOSisValidDetail_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cint, Ptr{Cstring}, Ptr{Ptr{GEOSGeometry}}), handle, g, flags, reason, location)
end

function GEOSMakeValid_r(handle, g)
    ccall((:GEOSMakeValid_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeomType_r(handle, g)
    unsafe_string(ccall((:GEOSGeomType_r, libgeos), Cstring, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g))
end

function GEOSGeomTypeId_r(handle, g)
    ccall((:GEOSGeomTypeId_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGetSRID_r(handle, g)
    ccall((:GEOSGetSRID_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSSetSRID_r(handle, g, SRID)
    ccall((:GEOSSetSRID_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cint), handle, g, SRID)
end

function GEOSGeom_getUserData_r(handle, g)
    ccall((:GEOSGeom_getUserData_r, libgeos), Ptr{Cvoid}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeom_setUserData_r(handle, g, userData)
    ccall((:GEOSGeom_setUserData_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cvoid}), handle, g, userData)
end

function GEOSGetNumGeometries_r(handle, g)
    ccall((:GEOSGetNumGeometries_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGetGeometryN_r(handle, g, n)
    ccall((:GEOSGetGeometryN_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cint), handle, g, n)
end

function GEOSNormalize_r(handle, g)
    ccall((:GEOSNormalize_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeom_setPrecision_r(handle, g, gridSize, flags)
    ccall((:GEOSGeom_setPrecision_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cdouble, Cint), handle, g, gridSize, flags)
end

function GEOSGeom_getPrecision_r(handle, g)
    ccall((:GEOSGeom_getPrecision_r, libgeos), Cdouble, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGetNumInteriorRings_r(handle, g)
    ccall((:GEOSGetNumInteriorRings_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeomGetNumPoints_r(handle, g)
    ccall((:GEOSGeomGetNumPoints_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeomGetX_r(handle, g, x)
    ccall((:GEOSGeomGetX_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, x)
end

function GEOSGeomGetY_r(handle, g, y)
    ccall((:GEOSGeomGetY_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, y)
end

function GEOSGeomGetZ_r(handle, g, z)
    ccall((:GEOSGeomGetZ_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, z)
end

function GEOSGetInteriorRingN_r(handle, g, n)
    ccall((:GEOSGetInteriorRingN_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cint), handle, g, n)
end

function GEOSGetExteriorRing_r(handle, g)
    ccall((:GEOSGetExteriorRing_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGetNumCoordinates_r(handle, g)
    ccall((:GEOSGetNumCoordinates_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeom_getCoordSeq_r(handle, g)
    ccall((:GEOSGeom_getCoordSeq_r, libgeos), Ptr{GEOSCoordSequence}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeom_getDimensions_r(handle, g)
    ccall((:GEOSGeom_getDimensions_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeom_getCoordinateDimension_r(handle, g)
    ccall((:GEOSGeom_getCoordinateDimension_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeom_getXMin_r(handle, g, value)
    ccall((:GEOSGeom_getXMin_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, value)
end

function GEOSGeom_getYMin_r(handle, g, value)
    ccall((:GEOSGeom_getYMin_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, value)
end

function GEOSGeom_getXMax_r(handle, g, value)
    ccall((:GEOSGeom_getXMax_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, value)
end

function GEOSGeom_getYMax_r(handle, g, value)
    ccall((:GEOSGeom_getYMax_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, value)
end

function GEOSGeomGetPointN_r(handle, g, n)
    ccall((:GEOSGeomGetPointN_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Cint), handle, g, n)
end

function GEOSGeomGetStartPoint_r(handle, g)
    ccall((:GEOSGeomGetStartPoint_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSGeomGetEndPoint_r(handle, g)
    ccall((:GEOSGeomGetEndPoint_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSGeometry}), handle, g)
end

function GEOSArea_r(handle, g, area)
    ccall((:GEOSArea_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, area)
end

function GEOSLength_r(handle, g, length)
    ccall((:GEOSLength_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, length)
end

function GEOSDistance_r(handle, g1, g2, dist)
    ccall((:GEOSDistance_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g1, g2, dist)
end

function GEOSDistanceIndexed_r(handle, g1, g2, dist)
    ccall((:GEOSDistanceIndexed_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g1, g2, dist)
end

function GEOSHausdorffDistance_r(handle, g1, g2, dist)
    ccall((:GEOSHausdorffDistance_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g1, g2, dist)
end

function GEOSHausdorffDistanceDensify_r(handle, g1, g2, densifyFrac, dist)
    ccall((:GEOSHausdorffDistanceDensify_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble, Ptr{Cdouble}), handle, g1, g2, densifyFrac, dist)
end

function GEOSFrechetDistance_r(handle, g1, g2, dist)
    ccall((:GEOSFrechetDistance_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g1, g2, dist)
end

function GEOSFrechetDistanceDensify_r(handle, g1, g2, densifyFrac, dist)
    ccall((:GEOSFrechetDistanceDensify_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble, Ptr{Cdouble}), handle, g1, g2, densifyFrac, dist)
end

function GEOSGeomGetLength_r(handle, g, length)
    ccall((:GEOSGeomGetLength_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{Cdouble}), handle, g, length)
end

function GEOSNearestPoints_r(handle, g1, g2)
    ccall((:GEOSNearestPoints_r, libgeos), Ptr{GEOSCoordSequence}, (GEOSContextHandle_t, Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), handle, g1, g2)
end

function GEOSOrientationIndex_r(handle, Ax, Ay, Bx, By, Px, Py)
    ccall((:GEOSOrientationIndex_r, libgeos), Cint, (GEOSContextHandle_t, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble), handle, Ax, Ay, Bx, By, Px, Py)
end

const GEOSWKTReader_t = Cvoid

const GEOSWKTReader = GEOSWKTReader_t

const GEOSWKTWriter_t = Cvoid

const GEOSWKTWriter = GEOSWKTWriter_t

const GEOSWKBReader_t = Cvoid

const GEOSWKBReader = GEOSWKBReader_t

const GEOSWKBWriter_t = Cvoid

const GEOSWKBWriter = GEOSWKBWriter_t

function GEOSWKTReader_create_r(handle)
    ccall((:GEOSWKTReader_create_r, libgeos), Ptr{GEOSWKTReader}, (GEOSContextHandle_t,), handle)
end

function GEOSWKTReader_destroy_r(handle, reader)
    ccall((:GEOSWKTReader_destroy_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKTReader}), handle, reader)
end

function GEOSWKTReader_read_r(handle, reader, wkt)
    ccall((:GEOSWKTReader_read_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSWKTReader}, Cstring), handle, reader, wkt)
end

function GEOSWKTWriter_create_r(handle)
    ccall((:GEOSWKTWriter_create_r, libgeos), Ptr{GEOSWKTWriter}, (GEOSContextHandle_t,), handle)
end

function GEOSWKTWriter_destroy_r(handle, writer)
    ccall((:GEOSWKTWriter_destroy_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKTWriter}), handle, writer)
end

function GEOSWKTWriter_write_r(handle, writer, g)
    unsafe_string(ccall((:GEOSWKTWriter_write_r, libgeos), Cstring, (GEOSContextHandle_t, Ptr{GEOSWKTWriter}, Ptr{GEOSGeometry}), handle, writer, g))
end

function GEOSWKTWriter_setTrim_r(handle, writer, trim)
    ccall((:GEOSWKTWriter_setTrim_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKTWriter}, Cchar), handle, writer, trim)
end

function GEOSWKTWriter_setRoundingPrecision_r(handle, writer, precision)
    ccall((:GEOSWKTWriter_setRoundingPrecision_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKTWriter}, Cint), handle, writer, precision)
end

function GEOSWKTWriter_setOutputDimension_r(handle, writer, dim)
    ccall((:GEOSWKTWriter_setOutputDimension_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKTWriter}, Cint), handle, writer, dim)
end

function GEOSWKTWriter_getOutputDimension_r(handle, writer)
    ccall((:GEOSWKTWriter_getOutputDimension_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSWKTWriter}), handle, writer)
end

function GEOSWKTWriter_setOld3D_r(handle, writer, useOld3D)
    ccall((:GEOSWKTWriter_setOld3D_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKTWriter}, Cint), handle, writer, useOld3D)
end

function GEOSWKBReader_create_r(handle)
    ccall((:GEOSWKBReader_create_r, libgeos), Ptr{GEOSWKBReader}, (GEOSContextHandle_t,), handle)
end

function GEOSWKBReader_destroy_r(handle, reader)
    ccall((:GEOSWKBReader_destroy_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKBReader}), handle, reader)
end

function GEOSWKBReader_read_r(handle, reader, wkb, size)
    ccall((:GEOSWKBReader_read_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSWKBReader}, Ptr{Cuchar}, Csize_t), handle, reader, wkb, size)
end

function GEOSWKBReader_readHEX_r(handle, reader, hex, size)
    ccall((:GEOSWKBReader_readHEX_r, libgeos), Ptr{GEOSGeometry}, (GEOSContextHandle_t, Ptr{GEOSWKBReader}, Ptr{Cuchar}, Csize_t), handle, reader, hex, size)
end

function GEOSWKBWriter_create_r(handle)
    ccall((:GEOSWKBWriter_create_r, libgeos), Ptr{GEOSWKBWriter}, (GEOSContextHandle_t,), handle)
end

function GEOSWKBWriter_destroy_r(handle, writer)
    ccall((:GEOSWKBWriter_destroy_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKBWriter}), handle, writer)
end

function GEOSWKBWriter_write_r(handle, writer, g, size)
    ccall((:GEOSWKBWriter_write_r, libgeos), Ptr{Cuchar}, (GEOSContextHandle_t, Ptr{GEOSWKBWriter}, Ptr{GEOSGeometry}, Ptr{Csize_t}), handle, writer, g, size)
end

function GEOSWKBWriter_writeHEX_r(handle, writer, g, size)
    ccall((:GEOSWKBWriter_writeHEX_r, libgeos), Ptr{Cuchar}, (GEOSContextHandle_t, Ptr{GEOSWKBWriter}, Ptr{GEOSGeometry}, Ptr{Csize_t}), handle, writer, g, size)
end

function GEOSWKBWriter_getOutputDimension_r(handle, writer)
    ccall((:GEOSWKBWriter_getOutputDimension_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSWKBWriter}), handle, writer)
end

function GEOSWKBWriter_setOutputDimension_r(handle, writer, newDimension)
    ccall((:GEOSWKBWriter_setOutputDimension_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKBWriter}, Cint), handle, writer, newDimension)
end

function GEOSWKBWriter_getByteOrder_r(handle, writer)
    ccall((:GEOSWKBWriter_getByteOrder_r, libgeos), Cint, (GEOSContextHandle_t, Ptr{GEOSWKBWriter}), handle, writer)
end

function GEOSWKBWriter_setByteOrder_r(handle, writer, byteOrder)
    ccall((:GEOSWKBWriter_setByteOrder_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKBWriter}, Cint), handle, writer, byteOrder)
end

function GEOSWKBWriter_getIncludeSRID_r(handle, writer)
    ccall((:GEOSWKBWriter_getIncludeSRID_r, libgeos), Cchar, (GEOSContextHandle_t, Ptr{GEOSWKBWriter}), handle, writer)
end

function GEOSWKBWriter_setIncludeSRID_r(handle, writer, writeSRID)
    ccall((:GEOSWKBWriter_setIncludeSRID_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{GEOSWKBWriter}, Cchar), handle, writer, writeSRID)
end

function GEOSFree_r(handle, buffer)
    ccall((:GEOSFree_r, libgeos), Cvoid, (GEOSContextHandle_t, Ptr{Cvoid}), handle, buffer)
end

function initGEOS(notice_function, error_function)
    ccall((:initGEOS, libgeos), Cvoid, (GEOSMessageHandler, GEOSMessageHandler), notice_function, error_function)
end

function finishGEOS()
    ccall((:finishGEOS, libgeos), Cvoid, ())
end

function GEOSGeomFromWKT(wkt)
    ccall((:GEOSGeomFromWKT, libgeos), Ptr{GEOSGeometry}, (Cstring,), wkt)
end

function GEOSGeomToWKT(g)
    unsafe_string(ccall((:GEOSGeomToWKT, libgeos), Cstring, (Ptr{GEOSGeometry},), g))
end

# no prototype is found for this function at geos_c.h:1399:21, please use with caution
function GEOS_getWKBOutputDims()
    ccall((:GEOS_getWKBOutputDims, libgeos), Cint, ())
end

function GEOS_setWKBOutputDims(newDims)
    ccall((:GEOS_setWKBOutputDims, libgeos), Cint, (Cint,), newDims)
end

# no prototype is found for this function at geos_c.h:1406:21, please use with caution
function GEOS_getWKBByteOrder()
    ccall((:GEOS_getWKBByteOrder, libgeos), Cint, ())
end

function GEOS_setWKBByteOrder(byteOrder)
    ccall((:GEOS_setWKBByteOrder, libgeos), Cint, (Cint,), byteOrder)
end

function GEOSGeomFromWKB_buf(wkb, size)
    ccall((:GEOSGeomFromWKB_buf, libgeos), Ptr{GEOSGeometry}, (Ptr{Cuchar}, Csize_t), wkb, size)
end

function GEOSGeomToWKB_buf(g, size)
    ccall((:GEOSGeomToWKB_buf, libgeos), Ptr{Cuchar}, (Ptr{GEOSGeometry}, Ptr{Csize_t}), g, size)
end

function GEOSGeomFromHEX_buf(hex, size)
    ccall((:GEOSGeomFromHEX_buf, libgeos), Ptr{GEOSGeometry}, (Ptr{Cuchar}, Csize_t), hex, size)
end

function GEOSGeomToHEX_buf(g, size)
    ccall((:GEOSGeomToHEX_buf, libgeos), Ptr{Cuchar}, (Ptr{GEOSGeometry}, Ptr{Csize_t}), g, size)
end

function GEOSCoordSeq_create(size, dims)
    ccall((:GEOSCoordSeq_create, libgeos), Ptr{GEOSCoordSequence}, (Cuint, Cuint), size, dims)
end

function GEOSCoordSeq_clone(s)
    ccall((:GEOSCoordSeq_clone, libgeos), Ptr{GEOSCoordSequence}, (Ptr{GEOSCoordSequence},), s)
end

function GEOSCoordSeq_destroy(s)
    ccall((:GEOSCoordSeq_destroy, libgeos), Cvoid, (Ptr{GEOSCoordSequence},), s)
end

function GEOSCoordSeq_setX(s, idx, val)
    ccall((:GEOSCoordSeq_setX, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Cdouble), s, idx, val)
end

function GEOSCoordSeq_setY(s, idx, val)
    ccall((:GEOSCoordSeq_setY, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Cdouble), s, idx, val)
end

function GEOSCoordSeq_setZ(s, idx, val)
    ccall((:GEOSCoordSeq_setZ, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Cdouble), s, idx, val)
end

function GEOSCoordSeq_setXY(s, idx, x, y)
    ccall((:GEOSCoordSeq_setXY, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Cdouble, Cdouble), s, idx, x, y)
end

function GEOSCoordSeq_setXYZ(s, idx, x, y, z)
    ccall((:GEOSCoordSeq_setXYZ, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Cdouble, Cdouble, Cdouble), s, idx, x, y, z)
end

function GEOSCoordSeq_setOrdinate(s, idx, dim, val)
    ccall((:GEOSCoordSeq_setOrdinate, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Cuint, Cdouble), s, idx, dim, val)
end

function GEOSCoordSeq_getX(s, idx, val)
    ccall((:GEOSCoordSeq_getX, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Ptr{Cdouble}), s, idx, val)
end

function GEOSCoordSeq_getY(s, idx, val)
    ccall((:GEOSCoordSeq_getY, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Ptr{Cdouble}), s, idx, val)
end

function GEOSCoordSeq_getZ(s, idx, val)
    ccall((:GEOSCoordSeq_getZ, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Ptr{Cdouble}), s, idx, val)
end

function GEOSCoordSeq_getXY(s, idx, x, y)
    ccall((:GEOSCoordSeq_getXY, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Ptr{Cdouble}, Ptr{Cdouble}), s, idx, x, y)
end

function GEOSCoordSeq_getXYZ(s, idx, x, y, z)
    ccall((:GEOSCoordSeq_getXYZ, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), s, idx, x, y, z)
end

function GEOSCoordSeq_getOrdinate(s, idx, dim, val)
    ccall((:GEOSCoordSeq_getOrdinate, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cuint, Cuint, Ptr{Cdouble}), s, idx, dim, val)
end

function GEOSCoordSeq_getSize(s, size)
    ccall((:GEOSCoordSeq_getSize, libgeos), Cint, (Ptr{GEOSCoordSequence}, Ptr{Cuint}), s, size)
end

function GEOSCoordSeq_getDimensions(s, dims)
    ccall((:GEOSCoordSeq_getDimensions, libgeos), Cint, (Ptr{GEOSCoordSequence}, Ptr{Cuint}), s, dims)
end

function GEOSCoordSeq_isCCW(s, is_ccw)
    ccall((:GEOSCoordSeq_isCCW, libgeos), Cint, (Ptr{GEOSCoordSequence}, Cstring), s, is_ccw)
end

function GEOSProject(g, p)
    ccall((:GEOSProject, libgeos), Cdouble, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g, p)
end

function GEOSInterpolate(g, d)
    ccall((:GEOSInterpolate, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble), g, d)
end

function GEOSProjectNormalized(g, p)
    ccall((:GEOSProjectNormalized, libgeos), Cdouble, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g, p)
end

function GEOSInterpolateNormalized(g, d)
    ccall((:GEOSInterpolateNormalized, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble), g, d)
end

function GEOSBuffer(g, width, quadsegs)
    ccall((:GEOSBuffer, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble, Cint), g, width, quadsegs)
end

# no prototype is found for this function at geos_c.h:1529:35, please use with caution
function GEOSBufferParams_create()
    ccall((:GEOSBufferParams_create, libgeos), Ptr{GEOSBufferParams}, ())
end

function GEOSBufferParams_destroy(parms)
    ccall((:GEOSBufferParams_destroy, libgeos), Cvoid, (Ptr{GEOSBufferParams},), parms)
end

function GEOSBufferParams_setEndCapStyle(p, style)
    ccall((:GEOSBufferParams_setEndCapStyle, libgeos), Cint, (Ptr{GEOSBufferParams}, Cint), p, style)
end

function GEOSBufferParams_setJoinStyle(p, joinStyle)
    ccall((:GEOSBufferParams_setJoinStyle, libgeos), Cint, (Ptr{GEOSBufferParams}, Cint), p, joinStyle)
end

function GEOSBufferParams_setMitreLimit(p, mitreLimit)
    ccall((:GEOSBufferParams_setMitreLimit, libgeos), Cint, (Ptr{GEOSBufferParams}, Cdouble), p, mitreLimit)
end

function GEOSBufferParams_setQuadrantSegments(p, quadSegs)
    ccall((:GEOSBufferParams_setQuadrantSegments, libgeos), Cint, (Ptr{GEOSBufferParams}, Cint), p, quadSegs)
end

function GEOSBufferParams_setSingleSided(p, singleSided)
    ccall((:GEOSBufferParams_setSingleSided, libgeos), Cint, (Ptr{GEOSBufferParams}, Cint), p, singleSided)
end

function GEOSBufferWithParams(g, p, width)
    ccall((:GEOSBufferWithParams, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSBufferParams}, Cdouble), g, p, width)
end

function GEOSBufferWithStyle(g, width, quadsegs, endCapStyle, joinStyle, mitreLimit)
    ccall((:GEOSBufferWithStyle, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble, Cint, Cint, Cint, Cdouble), g, width, quadsegs, endCapStyle, joinStyle, mitreLimit)
end

function GEOSSingleSidedBuffer(g, width, quadsegs, joinStyle, mitreLimit, leftSide)
    ccall((:GEOSSingleSidedBuffer, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble, Cint, Cint, Cdouble, Cint), g, width, quadsegs, joinStyle, mitreLimit, leftSide)
end

function GEOSOffsetCurve(g, width, quadsegs, joinStyle, mitreLimit)
    ccall((:GEOSOffsetCurve, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble, Cint, Cint, Cdouble), g, width, quadsegs, joinStyle, mitreLimit)
end

function GEOSGeom_createPoint(s)
    ccall((:GEOSGeom_createPoint, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSCoordSequence},), s)
end

function GEOSGeom_createPointFromXY(x, y)
    ccall((:GEOSGeom_createPointFromXY, libgeos), Ptr{GEOSGeometry}, (Cdouble, Cdouble), x, y)
end

# no prototype is found for this function at geos_c.h:1595:31, please use with caution
function GEOSGeom_createEmptyPoint()
    ccall((:GEOSGeom_createEmptyPoint, libgeos), Ptr{GEOSGeometry}, ())
end

function GEOSGeom_createLinearRing(s)
    ccall((:GEOSGeom_createLinearRing, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSCoordSequence},), s)
end

function GEOSGeom_createLineString(s)
    ccall((:GEOSGeom_createLineString, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSCoordSequence},), s)
end

# no prototype is found for this function at geos_c.h:1598:31, please use with caution
function GEOSGeom_createEmptyLineString()
    ccall((:GEOSGeom_createEmptyLineString, libgeos), Ptr{GEOSGeometry}, ())
end

# no prototype is found for this function at geos_c.h:1605:31, please use with caution
function GEOSGeom_createEmptyPolygon()
    ccall((:GEOSGeom_createEmptyPolygon, libgeos), Ptr{GEOSGeometry}, ())
end

function GEOSGeom_createPolygon(shell, holes, nholes)
    ccall((:GEOSGeom_createPolygon, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{Ptr{GEOSGeometry}}, Cuint), shell, holes, nholes)
end

function GEOSGeom_createCollection(type, geoms, ngeoms)
    ccall((:GEOSGeom_createCollection, libgeos), Ptr{GEOSGeometry}, (Cint, Ptr{Ptr{GEOSGeometry}}, Cuint), type, geoms, ngeoms)
end

function GEOSGeom_createEmptyCollection(type)
    ccall((:GEOSGeom_createEmptyCollection, libgeos), Ptr{GEOSGeometry}, (Cint,), type)
end

function GEOSGeom_clone(g)
    ccall((:GEOSGeom_clone, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSGeom_destroy(g)
    ccall((:GEOSGeom_destroy, libgeos), Cvoid, (Ptr{GEOSGeometry},), g)
end

function GEOSEnvelope(g)
    ccall((:GEOSEnvelope, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSIntersection(g1, g2)
    ccall((:GEOSIntersection, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSIntersectionPrec(g1, g2, gridSize)
    ccall((:GEOSIntersectionPrec, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), g1, g2, gridSize)
end

function GEOSConvexHull(g)
    ccall((:GEOSConvexHull, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSMinimumRotatedRectangle(g)
    ccall((:GEOSMinimumRotatedRectangle, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSMaximumInscribedCircle(g, tolerance)
    ccall((:GEOSMaximumInscribedCircle, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble), g, tolerance)
end

function GEOSLargestEmptyCircle(g, boundary, tolerance)
    ccall((:GEOSLargestEmptyCircle, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), g, boundary, tolerance)
end

function GEOSMinimumWidth(g)
    ccall((:GEOSMinimumWidth, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSMinimumClearance(g, d)
    ccall((:GEOSMinimumClearance, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, d)
end

function GEOSMinimumClearanceLine(g)
    ccall((:GEOSMinimumClearanceLine, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSDifference(g1, g2)
    ccall((:GEOSDifference, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSDifferencePrec(g1, g2, gridSize)
    ccall((:GEOSDifferencePrec, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), g1, g2, gridSize)
end

function GEOSSymDifference(g1, g2)
    ccall((:GEOSSymDifference, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSSymDifferencePrec(g1, g2, gridSize)
    ccall((:GEOSSymDifferencePrec, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), g1, g2, gridSize)
end

function GEOSBoundary(g)
    ccall((:GEOSBoundary, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSUnion(g1, g2)
    ccall((:GEOSUnion, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSUnionPrec(g1, g2, gridSize)
    ccall((:GEOSUnionPrec, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), g1, g2, gridSize)
end

function GEOSUnaryUnion(g)
    ccall((:GEOSUnaryUnion, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSUnaryUnionPrec(g, gridSize)
    ccall((:GEOSUnaryUnionPrec, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble), g, gridSize)
end

function GEOSCoverageUnion(g)
    ccall((:GEOSCoverageUnion, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSUnionCascaded(g)
    ccall((:GEOSUnionCascaded, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSPointOnSurface(g)
    ccall((:GEOSPointOnSurface, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSGetCentroid(g)
    ccall((:GEOSGetCentroid, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSMinimumBoundingCircle(g, radius, center)
    ccall((:GEOSMinimumBoundingCircle, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{Cdouble}, Ptr{Ptr{GEOSGeometry}}), g, radius, center)
end

function GEOSNode(g)
    ccall((:GEOSNode, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSClipByRect(g, xmin, ymin, xmax, ymax)
    ccall((:GEOSClipByRect, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble, Cdouble, Cdouble, Cdouble), g, xmin, ymin, xmax, ymax)
end

function GEOSPolygonize(geoms, ngeoms)
    ccall((:GEOSPolygonize, libgeos), Ptr{GEOSGeometry}, (Ptr{Ptr{GEOSGeometry}}, Cuint), geoms, ngeoms)
end

function GEOSPolygonize_valid(geoms, ngeoms)
    ccall((:GEOSPolygonize_valid, libgeos), Ptr{GEOSGeometry}, (Ptr{Ptr{GEOSGeometry}}, Cuint), geoms, ngeoms)
end

function GEOSPolygonizer_getCutEdges(geoms, ngeoms)
    ccall((:GEOSPolygonizer_getCutEdges, libgeos), Ptr{GEOSGeometry}, (Ptr{Ptr{GEOSGeometry}}, Cuint), geoms, ngeoms)
end

function GEOSPolygonize_full(input, cuts, dangles, invalid)
    ccall((:GEOSPolygonize_full, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{Ptr{GEOSGeometry}}, Ptr{Ptr{GEOSGeometry}}, Ptr{Ptr{GEOSGeometry}}), input, cuts, dangles, invalid)
end

function GEOSBuildArea(g)
    ccall((:GEOSBuildArea, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSLineMerge(g)
    ccall((:GEOSLineMerge, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSReverse(g)
    ccall((:GEOSReverse, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSSimplify(g, tolerance)
    ccall((:GEOSSimplify, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble), g, tolerance)
end

function GEOSTopologyPreserveSimplify(g, tolerance)
    ccall((:GEOSTopologyPreserveSimplify, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble), g, tolerance)
end

function GEOSGeom_extractUniquePoints(g)
    ccall((:GEOSGeom_extractUniquePoints, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSSharedPaths(g1, g2)
    ccall((:GEOSSharedPaths, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSSnap(g1, g2, tolerance)
    ccall((:GEOSSnap, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), g1, g2, tolerance)
end

function GEOSDelaunayTriangulation(g, tolerance, onlyEdges)
    ccall((:GEOSDelaunayTriangulation, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble, Cint), g, tolerance, onlyEdges)
end

function GEOSVoronoiDiagram(g, env, tolerance, onlyEdges)
    ccall((:GEOSVoronoiDiagram, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble, Cint), g, env, tolerance, onlyEdges)
end

function GEOSSegmentIntersection(ax0, ay0, ax1, ay1, bx0, by0, bx1, by1, cx, cy)
    ccall((:GEOSSegmentIntersection, libgeos), Cint, (Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Ptr{Cdouble}, Ptr{Cdouble}), ax0, ay0, ax1, ay1, bx0, by0, bx1, by1, cx, cy)
end

function GEOSDisjoint(g1, g2)
    ccall((:GEOSDisjoint, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSTouches(g1, g2)
    ccall((:GEOSTouches, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSIntersects(g1, g2)
    ccall((:GEOSIntersects, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSCrosses(g1, g2)
    ccall((:GEOSCrosses, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSWithin(g1, g2)
    ccall((:GEOSWithin, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSContains(g1, g2)
    ccall((:GEOSContains, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSOverlaps(g1, g2)
    ccall((:GEOSOverlaps, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSEquals(g1, g2)
    ccall((:GEOSEquals, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSCovers(g1, g2)
    ccall((:GEOSCovers, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSCoveredBy(g1, g2)
    ccall((:GEOSCoveredBy, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSEqualsExact(g1, g2, tolerance)
    ccall((:GEOSEqualsExact, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble), g1, g2, tolerance)
end

function GEOSPrepare(g)
    ccall((:GEOSPrepare, libgeos), Ptr{GEOSPreparedGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSPreparedGeom_destroy(g)
    ccall((:GEOSPreparedGeom_destroy, libgeos), Cvoid, (Ptr{GEOSPreparedGeometry},), g)
end

function GEOSPreparedContains(pg1, g2)
    ccall((:GEOSPreparedContains, libgeos), Cchar, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedContainsProperly(pg1, g2)
    ccall((:GEOSPreparedContainsProperly, libgeos), Cchar, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedCoveredBy(pg1, g2)
    ccall((:GEOSPreparedCoveredBy, libgeos), Cchar, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedCovers(pg1, g2)
    ccall((:GEOSPreparedCovers, libgeos), Cchar, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedCrosses(pg1, g2)
    ccall((:GEOSPreparedCrosses, libgeos), Cchar, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedDisjoint(pg1, g2)
    ccall((:GEOSPreparedDisjoint, libgeos), Cchar, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedIntersects(pg1, g2)
    ccall((:GEOSPreparedIntersects, libgeos), Cchar, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedOverlaps(pg1, g2)
    ccall((:GEOSPreparedOverlaps, libgeos), Cchar, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedTouches(pg1, g2)
    ccall((:GEOSPreparedTouches, libgeos), Cchar, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedWithin(pg1, g2)
    ccall((:GEOSPreparedWithin, libgeos), Cchar, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedNearestPoints(pg1, g2)
    ccall((:GEOSPreparedNearestPoints, libgeos), Ptr{GEOSCoordSequence}, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}), pg1, g2)
end

function GEOSPreparedDistance(pg1, g2, dist)
    ccall((:GEOSPreparedDistance, libgeos), Cint, (Ptr{GEOSPreparedGeometry}, Ptr{GEOSGeometry}, Ptr{Cdouble}), pg1, g2, dist)
end

function GEOSSTRtree_create(nodeCapacity)
    ccall((:GEOSSTRtree_create, libgeos), Ptr{GEOSSTRtree}, (Csize_t,), nodeCapacity)
end

function GEOSSTRtree_insert(tree, g, item)
    ccall((:GEOSSTRtree_insert, libgeos), Cvoid, (Ptr{GEOSSTRtree}, Ptr{GEOSGeometry}, Ptr{Cvoid}), tree, g, item)
end

function GEOSSTRtree_query(tree, g, callback, userdata)
    ccall((:GEOSSTRtree_query, libgeos), Cvoid, (Ptr{GEOSSTRtree}, Ptr{GEOSGeometry}, GEOSQueryCallback, Ptr{Cvoid}), tree, g, callback, userdata)
end

function GEOSSTRtree_nearest(tree, geom)
    ccall((:GEOSSTRtree_nearest, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSSTRtree}, Ptr{GEOSGeometry}), tree, geom)
end

function GEOSSTRtree_nearest_generic(tree, item, itemEnvelope, distancefn, userdata)
    ccall((:GEOSSTRtree_nearest_generic, libgeos), Ptr{Cvoid}, (Ptr{GEOSSTRtree}, Ptr{Cvoid}, Ptr{GEOSGeometry}, GEOSDistanceCallback, Ptr{Cvoid}), tree, item, itemEnvelope, distancefn, userdata)
end

function GEOSSTRtree_iterate(tree, callback, userdata)
    ccall((:GEOSSTRtree_iterate, libgeos), Cvoid, (Ptr{GEOSSTRtree}, GEOSQueryCallback, Ptr{Cvoid}), tree, callback, userdata)
end

function GEOSSTRtree_remove(tree, g, item)
    ccall((:GEOSSTRtree_remove, libgeos), Cchar, (Ptr{GEOSSTRtree}, Ptr{GEOSGeometry}, Ptr{Cvoid}), tree, g, item)
end

function GEOSSTRtree_destroy(tree)
    ccall((:GEOSSTRtree_destroy, libgeos), Cvoid, (Ptr{GEOSSTRtree},), tree)
end

function GEOSisEmpty(g)
    ccall((:GEOSisEmpty, libgeos), Cchar, (Ptr{GEOSGeometry},), g)
end

function GEOSisSimple(g)
    ccall((:GEOSisSimple, libgeos), Cchar, (Ptr{GEOSGeometry},), g)
end

function GEOSisRing(g)
    ccall((:GEOSisRing, libgeos), Cchar, (Ptr{GEOSGeometry},), g)
end

function GEOSHasZ(g)
    ccall((:GEOSHasZ, libgeos), Cchar, (Ptr{GEOSGeometry},), g)
end

function GEOSisClosed(g)
    ccall((:GEOSisClosed, libgeos), Cchar, (Ptr{GEOSGeometry},), g)
end

function GEOSRelatePattern(g1, g2, pat)
    ccall((:GEOSRelatePattern, libgeos), Cchar, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cstring), g1, g2, pat)
end

function GEOSRelate(g1, g2)
    unsafe_string(ccall((:GEOSRelate, libgeos), Cstring, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2))
end

function GEOSRelatePatternMatch(mat, pat)
    ccall((:GEOSRelatePatternMatch, libgeos), Cchar, (Cstring, Cstring), mat, pat)
end

function GEOSRelateBoundaryNodeRule(g1, g2, bnr)
    unsafe_string(ccall((:GEOSRelateBoundaryNodeRule, libgeos), Cstring, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cint), g1, g2, bnr))
end

function GEOSisValid(g)
    ccall((:GEOSisValid, libgeos), Cchar, (Ptr{GEOSGeometry},), g)
end

function GEOSisValidReason(g)
    unsafe_string(ccall((:GEOSisValidReason, libgeos), Cstring, (Ptr{GEOSGeometry},), g))
end

function GEOSisValidDetail(g, flags, reason, location)
    ccall((:GEOSisValidDetail, libgeos), Cchar, (Ptr{GEOSGeometry}, Cint, Ptr{Cstring}, Ptr{Ptr{GEOSGeometry}}), g, flags, reason, location)
end

function GEOSMakeValid(g)
    ccall((:GEOSMakeValid, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSGeomType(g)
    unsafe_string(ccall((:GEOSGeomType, libgeos), Cstring, (Ptr{GEOSGeometry},), g))
end

function GEOSGeomTypeId(g)
    ccall((:GEOSGeomTypeId, libgeos), Cint, (Ptr{GEOSGeometry},), g)
end

function GEOSGetSRID(g)
    ccall((:GEOSGetSRID, libgeos), Cint, (Ptr{GEOSGeometry},), g)
end

function GEOSSetSRID(g, SRID)
    ccall((:GEOSSetSRID, libgeos), Cvoid, (Ptr{GEOSGeometry}, Cint), g, SRID)
end

function GEOSGeom_getUserData(g)
    ccall((:GEOSGeom_getUserData, libgeos), Ptr{Cvoid}, (Ptr{GEOSGeometry},), g)
end

function GEOSGeom_setUserData(g, userData)
    ccall((:GEOSGeom_setUserData, libgeos), Cvoid, (Ptr{GEOSGeometry}, Ptr{Cvoid}), g, userData)
end

function GEOSGetNumGeometries(g)
    ccall((:GEOSGetNumGeometries, libgeos), Cint, (Ptr{GEOSGeometry},), g)
end

function GEOSGetGeometryN(g, n)
    ccall((:GEOSGetGeometryN, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cint), g, n)
end

function GEOSNormalize(g)
    ccall((:GEOSNormalize, libgeos), Cint, (Ptr{GEOSGeometry},), g)
end

function GEOSGeom_setPrecision(g, gridSize, flags)
    ccall((:GEOSGeom_setPrecision, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cdouble, Cint), g, gridSize, flags)
end

function GEOSGeom_getPrecision(g)
    ccall((:GEOSGeom_getPrecision, libgeos), Cdouble, (Ptr{GEOSGeometry},), g)
end

function GEOSGetNumInteriorRings(g)
    ccall((:GEOSGetNumInteriorRings, libgeos), Cint, (Ptr{GEOSGeometry},), g)
end

function GEOSGeomGetNumPoints(g)
    ccall((:GEOSGeomGetNumPoints, libgeos), Cint, (Ptr{GEOSGeometry},), g)
end

function GEOSGeomGetX(g, x)
    ccall((:GEOSGeomGetX, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, x)
end

function GEOSGeomGetY(g, y)
    ccall((:GEOSGeomGetY, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, y)
end

function GEOSGeomGetZ(g, z)
    ccall((:GEOSGeomGetZ, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, z)
end

function GEOSGetInteriorRingN(g, n)
    ccall((:GEOSGetInteriorRingN, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cint), g, n)
end

function GEOSGetExteriorRing(g)
    ccall((:GEOSGetExteriorRing, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSGetNumCoordinates(g)
    ccall((:GEOSGetNumCoordinates, libgeos), Cint, (Ptr{GEOSGeometry},), g)
end

function GEOSGeom_getCoordSeq(g)
    ccall((:GEOSGeom_getCoordSeq, libgeos), Ptr{GEOSCoordSequence}, (Ptr{GEOSGeometry},), g)
end

function GEOSGeom_getDimensions(g)
    ccall((:GEOSGeom_getDimensions, libgeos), Cint, (Ptr{GEOSGeometry},), g)
end

function GEOSGeom_getCoordinateDimension(g)
    ccall((:GEOSGeom_getCoordinateDimension, libgeos), Cint, (Ptr{GEOSGeometry},), g)
end

function GEOSGeom_getXMin(g, value)
    ccall((:GEOSGeom_getXMin, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, value)
end

function GEOSGeom_getYMin(g, value)
    ccall((:GEOSGeom_getYMin, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, value)
end

function GEOSGeom_getXMax(g, value)
    ccall((:GEOSGeom_getXMax, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, value)
end

function GEOSGeom_getYMax(g, value)
    ccall((:GEOSGeom_getYMax, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, value)
end

function GEOSGeomGetPointN(g, n)
    ccall((:GEOSGeomGetPointN, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry}, Cint), g, n)
end

function GEOSGeomGetStartPoint(g)
    ccall((:GEOSGeomGetStartPoint, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSGeomGetEndPoint(g)
    ccall((:GEOSGeomGetEndPoint, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSGeometry},), g)
end

function GEOSArea(g, area)
    ccall((:GEOSArea, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, area)
end

function GEOSLength(g, length)
    ccall((:GEOSLength, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, length)
end

function GEOSDistance(g1, g2, dist)
    ccall((:GEOSDistance, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Ptr{Cdouble}), g1, g2, dist)
end

function GEOSDistanceIndexed(g1, g2, dist)
    ccall((:GEOSDistanceIndexed, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Ptr{Cdouble}), g1, g2, dist)
end

function GEOSHausdorffDistance(g1, g2, dist)
    ccall((:GEOSHausdorffDistance, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Ptr{Cdouble}), g1, g2, dist)
end

function GEOSHausdorffDistanceDensify(g1, g2, densifyFrac, dist)
    ccall((:GEOSHausdorffDistanceDensify, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble, Ptr{Cdouble}), g1, g2, densifyFrac, dist)
end

function GEOSFrechetDistance(g1, g2, dist)
    ccall((:GEOSFrechetDistance, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Ptr{Cdouble}), g1, g2, dist)
end

function GEOSFrechetDistanceDensify(g1, g2, densifyFrac, dist)
    ccall((:GEOSFrechetDistanceDensify, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}, Cdouble, Ptr{Cdouble}), g1, g2, densifyFrac, dist)
end

function GEOSGeomGetLength(g, length)
    ccall((:GEOSGeomGetLength, libgeos), Cint, (Ptr{GEOSGeometry}, Ptr{Cdouble}), g, length)
end

function GEOSNearestPoints(g1, g2)
    ccall((:GEOSNearestPoints, libgeos), Ptr{GEOSCoordSequence}, (Ptr{GEOSGeometry}, Ptr{GEOSGeometry}), g1, g2)
end

function GEOSOrientationIndex(Ax, Ay, Bx, By, Px, Py)
    ccall((:GEOSOrientationIndex, libgeos), Cint, (Cdouble, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble), Ax, Ay, Bx, By, Px, Py)
end

# no prototype is found for this function at geos_c.h:2210:32, please use with caution
function GEOSWKTReader_create()
    ccall((:GEOSWKTReader_create, libgeos), Ptr{GEOSWKTReader}, ())
end

function GEOSWKTReader_destroy(reader)
    ccall((:GEOSWKTReader_destroy, libgeos), Cvoid, (Ptr{GEOSWKTReader},), reader)
end

function GEOSWKTReader_read(reader, wkt)
    ccall((:GEOSWKTReader_read, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSWKTReader}, Cstring), reader, wkt)
end

# no prototype is found for this function at geos_c.h:2215:32, please use with caution
function GEOSWKTWriter_create()
    ccall((:GEOSWKTWriter_create, libgeos), Ptr{GEOSWKTWriter}, ())
end

function GEOSWKTWriter_destroy(writer)
    ccall((:GEOSWKTWriter_destroy, libgeos), Cvoid, (Ptr{GEOSWKTWriter},), writer)
end

function GEOSWKTWriter_write(writer, g)
    unsafe_string(ccall((:GEOSWKTWriter_write, libgeos), Cstring, (Ptr{GEOSWKTWriter}, Ptr{GEOSGeometry}), writer, g))
end

function GEOSWKTWriter_setTrim(writer, trim)
    ccall((:GEOSWKTWriter_setTrim, libgeos), Cvoid, (Ptr{GEOSWKTWriter}, Cchar), writer, trim)
end

function GEOSWKTWriter_setRoundingPrecision(writer, precision)
    ccall((:GEOSWKTWriter_setRoundingPrecision, libgeos), Cvoid, (Ptr{GEOSWKTWriter}, Cint), writer, precision)
end

function GEOSWKTWriter_setOutputDimension(writer, dim)
    ccall((:GEOSWKTWriter_setOutputDimension, libgeos), Cvoid, (Ptr{GEOSWKTWriter}, Cint), writer, dim)
end

function GEOSWKTWriter_getOutputDimension(writer)
    ccall((:GEOSWKTWriter_getOutputDimension, libgeos), Cint, (Ptr{GEOSWKTWriter},), writer)
end

function GEOSWKTWriter_setOld3D(writer, useOld3D)
    ccall((:GEOSWKTWriter_setOld3D, libgeos), Cvoid, (Ptr{GEOSWKTWriter}, Cint), writer, useOld3D)
end

# no prototype is found for this function at geos_c.h:2225:32, please use with caution
function GEOSWKBReader_create()
    ccall((:GEOSWKBReader_create, libgeos), Ptr{GEOSWKBReader}, ())
end

function GEOSWKBReader_destroy(reader)
    ccall((:GEOSWKBReader_destroy, libgeos), Cvoid, (Ptr{GEOSWKBReader},), reader)
end

function GEOSWKBReader_read(reader, wkb, size)
    ccall((:GEOSWKBReader_read, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSWKBReader}, Ptr{Cuchar}, Csize_t), reader, wkb, size)
end

function GEOSWKBReader_readHEX(reader, hex, size)
    ccall((:GEOSWKBReader_readHEX, libgeos), Ptr{GEOSGeometry}, (Ptr{GEOSWKBReader}, Ptr{Cuchar}, Csize_t), reader, hex, size)
end

# no prototype is found for this function at geos_c.h:2231:32, please use with caution
function GEOSWKBWriter_create()
    ccall((:GEOSWKBWriter_create, libgeos), Ptr{GEOSWKBWriter}, ())
end

function GEOSWKBWriter_destroy(writer)
    ccall((:GEOSWKBWriter_destroy, libgeos), Cvoid, (Ptr{GEOSWKBWriter},), writer)
end

function GEOSWKBWriter_write(writer, g, size)
    ccall((:GEOSWKBWriter_write, libgeos), Ptr{Cuchar}, (Ptr{GEOSWKBWriter}, Ptr{GEOSGeometry}, Ptr{Csize_t}), writer, g, size)
end

function GEOSWKBWriter_writeHEX(writer, g, size)
    ccall((:GEOSWKBWriter_writeHEX, libgeos), Ptr{Cuchar}, (Ptr{GEOSWKBWriter}, Ptr{GEOSGeometry}, Ptr{Csize_t}), writer, g, size)
end

function GEOSWKBWriter_getOutputDimension(writer)
    ccall((:GEOSWKBWriter_getOutputDimension, libgeos), Cint, (Ptr{GEOSWKBWriter},), writer)
end

function GEOSWKBWriter_setOutputDimension(writer, newDimension)
    ccall((:GEOSWKBWriter_setOutputDimension, libgeos), Cvoid, (Ptr{GEOSWKBWriter}, Cint), writer, newDimension)
end

function GEOSWKBWriter_getByteOrder(writer)
    ccall((:GEOSWKBWriter_getByteOrder, libgeos), Cint, (Ptr{GEOSWKBWriter},), writer)
end

function GEOSWKBWriter_setByteOrder(writer, byteOrder)
    ccall((:GEOSWKBWriter_setByteOrder, libgeos), Cvoid, (Ptr{GEOSWKBWriter}, Cint), writer, byteOrder)
end

function GEOSWKBWriter_getIncludeSRID(writer)
    ccall((:GEOSWKBWriter_getIncludeSRID, libgeos), Cchar, (Ptr{GEOSWKBWriter},), writer)
end

function GEOSWKBWriter_setIncludeSRID(writer, writeSRID)
    ccall((:GEOSWKBWriter_setIncludeSRID, libgeos), Cvoid, (Ptr{GEOSWKBWriter}, Cchar), writer, writeSRID)
end

function GEOSFree(buffer)
    ccall((:GEOSFree, libgeos), Cvoid, (Ptr{Cvoid},), buffer)
end

const GEOS_VERSION_MAJOR = 3

const GEOS_VERSION_MINOR = 9

const GEOS_VERSION_PATCH = 0

const GEOS_VERSION = "3.9.0"

const GEOS_JTS_PORT = "1.17.0"

const GEOS_CAPI_VERSION_MAJOR = 1

const GEOS_CAPI_VERSION_MINOR = 16

const GEOS_CAPI_VERSION_PATCH = 2

const GEOS_CAPI_VERSION = "3.9.0-CAPI-1.16.2"

const GEOS_CAPI_FIRST_INTERFACE = GEOS_CAPI_VERSION_MAJOR

const GEOS_CAPI_LAST_INTERFACE = GEOS_CAPI_VERSION_MAJOR + GEOS_CAPI_VERSION_MINOR

const GEOS_PREC_NO_TOPO = 1 << 0

const GEOS_PREC_KEEP_COLLAPSED = 1 << 1

