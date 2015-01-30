# Julia wrapper for header: geos_c.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function initGEOS(notice_function::GEOSMessageHandler,error_function::GEOSMessageHandler)
    ccall((:initGEOS,libgeos),Void,(GEOSMessageHandler,GEOSMessageHandler),notice_function,error_function)
end

function finishGEOS()
    ccall((:finishGEOS,libgeos),Void,())
end

function GEOS_interruptRegisterCallback(cb::Ptr{GEOSInterruptCallback})
    ccall((:GEOS_interruptRegisterCallback,libgeos),Ptr{GEOSInterruptCallback},(Ptr{GEOSInterruptCallback},),cb)
end

function initGEOS_r(notice_function::GEOSMessageHandler,error_function::GEOSMessageHandler)
    ccall((:initGEOS_r,libgeos),GEOSContextHandle_t,(GEOSMessageHandler,GEOSMessageHandler),notice_function,error_function)
end

function finishGEOS_r(handle::GEOSContextHandle_t)
    ccall((:finishGEOS_r,libgeos),Void,(GEOSContextHandle_t,),handle)
end

function GEOSContext_setNoticeHandler_r(extHandle::GEOSContextHandle_t,nf::GEOSMessageHandler)
    ccall((:GEOSContext_setNoticeHandler_r,libgeos),GEOSMessageHandler,(GEOSContextHandle_t,GEOSMessageHandler),extHandle,nf)
end

function GEOSContext_setErrorHandler_r(extHandle::GEOSContextHandle_t,ef::GEOSMessageHandler)
    ccall((:GEOSContext_setErrorHandler_r,libgeos),GEOSMessageHandler,(GEOSContextHandle_t,GEOSMessageHandler),extHandle,ef)
end

function GEOSGeomFromWKT(wkt::Ptr{Uint8})
    ccall((:GEOSGeomFromWKT,libgeos),Ptr{GEOSGeometry},(Ptr{Uint8},),wkt)
end

function GEOSGeomToWKT(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomToWKT,libgeos),Ptr{Uint8},(Ptr{GEOSGeometry},),g)
end

function GEOSGeomFromWKT_r(handle::GEOSContextHandle_t,wkt::Ptr{Uint8})
    ccall((:GEOSGeomFromWKT_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{Uint8}),handle,wkt)
end

function GEOSGeomToWKT_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomToWKT_r,libgeos),Ptr{Uint8},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOS_setWKBOutputDims(newDims::Cint)
    ccall((:GEOS_setWKBOutputDims,libgeos),Cint,(Cint,),newDims)
end

function GEOS_getWKBOutputDims_r(handle::GEOSContextHandle_t)
    ccall((:GEOS_getWKBOutputDims_r,libgeos),Cint,(GEOSContextHandle_t,),handle)
end

function GEOS_setWKBOutputDims_r(handle::GEOSContextHandle_t,newDims::Cint)
    ccall((:GEOS_setWKBOutputDims_r,libgeos),Cint,(GEOSContextHandle_t,Cint),handle,newDims)
end

function GEOS_setWKBByteOrder(byteOrder::Cint)
    ccall((:GEOS_setWKBByteOrder,libgeos),Cint,(Cint,),byteOrder)
end

function GEOSGeomFromWKB_buf(wkb::Ptr{Cuchar},size::Csize_t)
    ccall((:GEOSGeomFromWKB_buf,libgeos),Ptr{GEOSGeometry},(Ptr{Cuchar},Csize_t),wkb,size)
end

function GEOSGeomToWKB_buf(g::Ptr{GEOSGeometry},size::Ptr{Csize_t})
    ccall((:GEOSGeomToWKB_buf,libgeos),Ptr{Cuchar},(Ptr{GEOSGeometry},Ptr{Csize_t}),g,size)
end

function GEOSGeomFromHEX_buf(hex::Ptr{Cuchar},size::Csize_t)
    ccall((:GEOSGeomFromHEX_buf,libgeos),Ptr{GEOSGeometry},(Ptr{Cuchar},Csize_t),hex,size)
end

function GEOSGeomToHEX_buf(g::Ptr{GEOSGeometry},size::Ptr{Csize_t})
    ccall((:GEOSGeomToHEX_buf,libgeos),Ptr{Cuchar},(Ptr{GEOSGeometry},Ptr{Csize_t}),g,size)
end

function GEOS_getWKBByteOrder_r(handle::GEOSContextHandle_t)
    ccall((:GEOS_getWKBByteOrder_r,libgeos),Cint,(GEOSContextHandle_t,),handle)
end

function GEOS_setWKBByteOrder_r(handle::GEOSContextHandle_t,byteOrder::Cint)
    ccall((:GEOS_setWKBByteOrder_r,libgeos),Cint,(GEOSContextHandle_t,Cint),handle,byteOrder)
end

function GEOSGeomFromWKB_buf_r(handle::GEOSContextHandle_t,wkb::Ptr{Cuchar},size::Csize_t)
    ccall((:GEOSGeomFromWKB_buf_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{Cuchar},Csize_t),handle,wkb,size)
end

function GEOSGeomToWKB_buf_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},size::Ptr{Csize_t})
    ccall((:GEOSGeomToWKB_buf_r,libgeos),Ptr{Cuchar},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{Csize_t}),handle,g,size)
end

function GEOSGeomFromHEX_buf_r(handle::GEOSContextHandle_t,hex::Ptr{Cuchar},size::Csize_t)
    ccall((:GEOSGeomFromHEX_buf_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{Cuchar},Csize_t),handle,hex,size)
end

function GEOSGeomToHEX_buf_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},size::Ptr{Csize_t})
    ccall((:GEOSGeomToHEX_buf_r,libgeos),Ptr{Cuchar},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{Csize_t}),handle,g,size)
end

function GEOSCoordSeq_create(size::Uint32,dims::Uint32)
    ccall((:GEOSCoordSeq_create,libgeos),Ptr{GEOSCoordSequence},(Uint32,Uint32),size,dims)
end

function GEOSCoordSeq_create_r(handle::GEOSContextHandle_t,size::Uint32,dims::Uint32)
    ccall((:GEOSCoordSeq_create_r,libgeos),Ptr{GEOSCoordSequence},(GEOSContextHandle_t,Uint32,Uint32),handle,size,dims)
end

function GEOSCoordSeq_clone(s::Ptr{GEOSCoordSequence})
    ccall((:GEOSCoordSeq_clone,libgeos),Ptr{GEOSCoordSequence},(Ptr{GEOSCoordSequence},),s)
end

function GEOSCoordSeq_clone_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence})
    ccall((:GEOSCoordSeq_clone_r,libgeos),Ptr{GEOSCoordSequence},(GEOSContextHandle_t,Ptr{GEOSCoordSequence}),handle,s)
end

function GEOSCoordSeq_destroy(s::Ptr{GEOSCoordSequence})
    ccall((:GEOSCoordSeq_destroy,libgeos),Void,(Ptr{GEOSCoordSequence},),s)
end

function GEOSCoordSeq_destroy_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence})
    ccall((:GEOSCoordSeq_destroy_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSCoordSequence}),handle,s)
end

function GEOSCoordSeq_setX(s::Ptr{GEOSCoordSequence},idx::Uint32,val::Cdouble)
    ccall((:GEOSCoordSeq_setX,libgeos),Cint,(Ptr{GEOSCoordSequence},Uint32,Cdouble),s,idx,val)
end

function GEOSCoordSeq_setY(s::Ptr{GEOSCoordSequence},idx::Uint32,val::Cdouble)
    ccall((:GEOSCoordSeq_setY,libgeos),Cint,(Ptr{GEOSCoordSequence},Uint32,Cdouble),s,idx,val)
end

function GEOSCoordSeq_setZ(s::Ptr{GEOSCoordSequence},idx::Uint32,val::Cdouble)
    ccall((:GEOSCoordSeq_setZ,libgeos),Cint,(Ptr{GEOSCoordSequence},Uint32,Cdouble),s,idx,val)
end

function GEOSCoordSeq_setOrdinate(s::Ptr{GEOSCoordSequence},idx::Uint32,dim::Uint32,val::Cdouble)
    ccall((:GEOSCoordSeq_setOrdinate,libgeos),Cint,(Ptr{GEOSCoordSequence},Uint32,Uint32,Cdouble),s,idx,dim,val)
end

function GEOSCoordSeq_setX_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence},idx::Uint32,val::Cdouble)
    ccall((:GEOSCoordSeq_setX_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSCoordSequence},Uint32,Cdouble),handle,s,idx,val)
end

function GEOSCoordSeq_setY_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence},idx::Uint32,val::Cdouble)
    ccall((:GEOSCoordSeq_setY_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSCoordSequence},Uint32,Cdouble),handle,s,idx,val)
end

function GEOSCoordSeq_setZ_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence},idx::Uint32,val::Cdouble)
    ccall((:GEOSCoordSeq_setZ_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSCoordSequence},Uint32,Cdouble),handle,s,idx,val)
end

function GEOSCoordSeq_setOrdinate_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence},idx::Uint32,dim::Uint32,val::Cdouble)
    ccall((:GEOSCoordSeq_setOrdinate_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSCoordSequence},Uint32,Uint32,Cdouble),handle,s,idx,dim,val)
end

function GEOSCoordSeq_getX(s::Ptr{GEOSCoordSequence},idx::Uint32,val::Ptr{Cdouble})
    ccall((:GEOSCoordSeq_getX,libgeos),Cint,(Ptr{GEOSCoordSequence},Uint32,Ptr{Cdouble}),s,idx,val)
end

function GEOSCoordSeq_getY(s::Ptr{GEOSCoordSequence},idx::Uint32,val::Ptr{Cdouble})
    ccall((:GEOSCoordSeq_getY,libgeos),Cint,(Ptr{GEOSCoordSequence},Uint32,Ptr{Cdouble}),s,idx,val)
end

function GEOSCoordSeq_getZ(s::Ptr{GEOSCoordSequence},idx::Uint32,val::Ptr{Cdouble})
    ccall((:GEOSCoordSeq_getZ,libgeos),Cint,(Ptr{GEOSCoordSequence},Uint32,Ptr{Cdouble}),s,idx,val)
end

function GEOSCoordSeq_getOrdinate(s::Ptr{GEOSCoordSequence},idx::Uint32,dim::Uint32,val::Ptr{Cdouble})
    ccall((:GEOSCoordSeq_getOrdinate,libgeos),Cint,(Ptr{GEOSCoordSequence},Uint32,Uint32,Ptr{Cdouble}),s,idx,dim,val)
end

function GEOSCoordSeq_getX_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence},idx::Uint32,val::Ptr{Cdouble})
    ccall((:GEOSCoordSeq_getX_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSCoordSequence},Uint32,Ptr{Cdouble}),handle,s,idx,val)
end

function GEOSCoordSeq_getY_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence},idx::Uint32,val::Ptr{Cdouble})
    ccall((:GEOSCoordSeq_getY_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSCoordSequence},Uint32,Ptr{Cdouble}),handle,s,idx,val)
end

function GEOSCoordSeq_getZ_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence},idx::Uint32,val::Ptr{Cdouble})
    ccall((:GEOSCoordSeq_getZ_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSCoordSequence},Uint32,Ptr{Cdouble}),handle,s,idx,val)
end

function GEOSCoordSeq_getOrdinate_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence},idx::Uint32,dim::Uint32,val::Ptr{Cdouble})
    ccall((:GEOSCoordSeq_getOrdinate_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSCoordSequence},Uint32,Uint32,Ptr{Cdouble}),handle,s,idx,dim,val)
end

function GEOSCoordSeq_getSize(s::Ptr{GEOSCoordSequence},size::Ptr{Uint32})
    ccall((:GEOSCoordSeq_getSize,libgeos),Cint,(Ptr{GEOSCoordSequence},Ptr{Uint32}),s,size)
end

function GEOSCoordSeq_getDimensions(s::Ptr{GEOSCoordSequence},dims::Ptr{Uint32})
    ccall((:GEOSCoordSeq_getDimensions,libgeos),Cint,(Ptr{GEOSCoordSequence},Ptr{Uint32}),s,dims)
end

function GEOSCoordSeq_getSize_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence},size::Ptr{Uint32})
    ccall((:GEOSCoordSeq_getSize_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSCoordSequence},Ptr{Uint32}),handle,s,size)
end

function GEOSCoordSeq_getDimensions_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence},dims::Ptr{Uint32})
    ccall((:GEOSCoordSeq_getDimensions_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSCoordSequence},Ptr{Uint32}),handle,s,dims)
end

function GEOSProject(g::Ptr{GEOSGeometry},p::Ptr{GEOSGeometry})
    ccall((:GEOSProject,libgeos),Cdouble,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g,p)
end

function GEOSProject_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},p::Ptr{GEOSGeometry})
    ccall((:GEOSProject_r,libgeos),Cdouble,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g,p)
end

function GEOSInterpolate(g::Ptr{GEOSGeometry},d::Cdouble)
    ccall((:GEOSInterpolate,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cdouble),g,d)
end

function GEOSInterpolate_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},d::Cdouble)
    ccall((:GEOSInterpolate_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cdouble),handle,g,d)
end

function GEOSProjectNormalized(g::Ptr{GEOSGeometry},p::Ptr{GEOSGeometry})
    ccall((:GEOSProjectNormalized,libgeos),Cdouble,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g,p)
end

function GEOSProjectNormalized_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},p::Ptr{GEOSGeometry})
    ccall((:GEOSProjectNormalized_r,libgeos),Cdouble,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g,p)
end

function GEOSInterpolateNormalized(g::Ptr{GEOSGeometry},d::Cdouble)
    ccall((:GEOSInterpolateNormalized,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cdouble),g,d)
end

function GEOSInterpolateNormalized_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},d::Cdouble)
    ccall((:GEOSInterpolateNormalized_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cdouble),handle,g,d)
end

function GEOSBuffer(g::Ptr{GEOSGeometry},width::Cdouble,quadsegs::Cint)
    ccall((:GEOSBuffer,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cdouble,Cint),g,width,quadsegs)
end

function GEOSBuffer_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},width::Cdouble,quadsegs::Cint)
    ccall((:GEOSBuffer_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cdouble,Cint),handle,g,width,quadsegs)
end

function GEOSBufferParams_create_r(handle::GEOSContextHandle_t)
    ccall((:GEOSBufferParams_create_r,libgeos),Ptr{GEOSBufferParams},(GEOSContextHandle_t,),handle)
end

function GEOSBufferParams_destroy(parms::Ptr{GEOSBufferParams})
    ccall((:GEOSBufferParams_destroy,libgeos),Void,(Ptr{GEOSBufferParams},),parms)
end

function GEOSBufferParams_destroy_r(handle::GEOSContextHandle_t,parms::Ptr{GEOSBufferParams})
    ccall((:GEOSBufferParams_destroy_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSBufferParams}),handle,parms)
end

function GEOSBufferParams_setEndCapStyle(p::Ptr{GEOSBufferParams},style::Cint)
    ccall((:GEOSBufferParams_setEndCapStyle,libgeos),Cint,(Ptr{GEOSBufferParams},Cint),p,style)
end

function GEOSBufferParams_setEndCapStyle_r(handle::GEOSContextHandle_t,p::Ptr{GEOSBufferParams},style::Cint)
    ccall((:GEOSBufferParams_setEndCapStyle_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSBufferParams},Cint),handle,p,style)
end

function GEOSBufferParams_setJoinStyle(p::Ptr{GEOSBufferParams},joinStyle::Cint)
    ccall((:GEOSBufferParams_setJoinStyle,libgeos),Cint,(Ptr{GEOSBufferParams},Cint),p,joinStyle)
end

function GEOSBufferParams_setJoinStyle_r(handle::GEOSContextHandle_t,p::Ptr{GEOSBufferParams},joinStyle::Cint)
    ccall((:GEOSBufferParams_setJoinStyle_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSBufferParams},Cint),handle,p,joinStyle)
end

function GEOSBufferParams_setMitreLimit(p::Ptr{GEOSBufferParams},mitreLimit::Cdouble)
    ccall((:GEOSBufferParams_setMitreLimit,libgeos),Cint,(Ptr{GEOSBufferParams},Cdouble),p,mitreLimit)
end

function GEOSBufferParams_setMitreLimit_r(handle::GEOSContextHandle_t,p::Ptr{GEOSBufferParams},mitreLimit::Cdouble)
    ccall((:GEOSBufferParams_setMitreLimit_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSBufferParams},Cdouble),handle,p,mitreLimit)
end

function GEOSBufferParams_setQuadrantSegments(p::Ptr{GEOSBufferParams},quadSegs::Cint)
    ccall((:GEOSBufferParams_setQuadrantSegments,libgeos),Cint,(Ptr{GEOSBufferParams},Cint),p,quadSegs)
end

function GEOSBufferParams_setQuadrantSegments_r(handle::GEOSContextHandle_t,p::Ptr{GEOSBufferParams},quadSegs::Cint)
    ccall((:GEOSBufferParams_setQuadrantSegments_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSBufferParams},Cint),handle,p,quadSegs)
end

function GEOSBufferParams_setSingleSided(p::Ptr{GEOSBufferParams},singleSided::Cint)
    ccall((:GEOSBufferParams_setSingleSided,libgeos),Cint,(Ptr{GEOSBufferParams},Cint),p,singleSided)
end

function GEOSBufferParams_setSingleSided_r(handle::GEOSContextHandle_t,p::Ptr{GEOSBufferParams},singleSided::Cint)
    ccall((:GEOSBufferParams_setSingleSided_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSBufferParams},Cint),handle,p,singleSided)
end

function GEOSBufferWithParams(g::Ptr{GEOSGeometry},p::Ptr{GEOSBufferParams},width::Cdouble)
    ccall((:GEOSBufferWithParams,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Ptr{GEOSBufferParams},Cdouble),g,p,width)
end

function GEOSBufferWithParams_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},p::Ptr{GEOSBufferParams},width::Cdouble)
    ccall((:GEOSBufferWithParams_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSBufferParams},Cdouble),handle,g,p,width)
end

function GEOSBufferWithStyle(g::Ptr{GEOSGeometry},width::Cdouble,quadsegs::Cint,endCapStyle::Cint,joinStyle::Cint,mitreLimit::Cdouble)
    ccall((:GEOSBufferWithStyle,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cdouble,Cint,Cint,Cint,Cdouble),g,width,quadsegs,endCapStyle,joinStyle,mitreLimit)
end

function GEOSBufferWithStyle_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},width::Cdouble,quadsegs::Cint,endCapStyle::Cint,joinStyle::Cint,mitreLimit::Cdouble)
    ccall((:GEOSBufferWithStyle_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cdouble,Cint,Cint,Cint,Cdouble),handle,g,width,quadsegs,endCapStyle,joinStyle,mitreLimit)
end

function GEOSSingleSidedBuffer(g::Ptr{GEOSGeometry},width::Cdouble,quadsegs::Cint,joinStyle::Cint,mitreLimit::Cdouble,leftSide::Cint)
    ccall((:GEOSSingleSidedBuffer,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cdouble,Cint,Cint,Cdouble,Cint),g,width,quadsegs,joinStyle,mitreLimit,leftSide)
end

function GEOSSingleSidedBuffer_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},width::Cdouble,quadsegs::Cint,joinStyle::Cint,mitreLimit::Cdouble,leftSide::Cint)
    ccall((:GEOSSingleSidedBuffer_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cdouble,Cint,Cint,Cdouble,Cint),handle,g,width,quadsegs,joinStyle,mitreLimit,leftSide)
end

function GEOSOffsetCurve(g::Ptr{GEOSGeometry},width::Cdouble,quadsegs::Cint,joinStyle::Cint,mitreLimit::Cdouble)
    ccall((:GEOSOffsetCurve,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cdouble,Cint,Cint,Cdouble),g,width,quadsegs,joinStyle,mitreLimit)
end

function GEOSOffsetCurve_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},width::Cdouble,quadsegs::Cint,joinStyle::Cint,mitreLimit::Cdouble)
    ccall((:GEOSOffsetCurve_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cdouble,Cint,Cint,Cdouble),handle,g,width,quadsegs,joinStyle,mitreLimit)
end

function GEOSGeom_createPoint(s::Ptr{GEOSCoordSequence})
    ccall((:GEOSGeom_createPoint,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSCoordSequence},),s)
end

function GEOSGeom_createLinearRing(s::Ptr{GEOSCoordSequence})
    ccall((:GEOSGeom_createLinearRing,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSCoordSequence},),s)
end

function GEOSGeom_createLineString(s::Ptr{GEOSCoordSequence})
    ccall((:GEOSGeom_createLineString,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSCoordSequence},),s)
end

function GEOSGeom_createPoint_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence})
    ccall((:GEOSGeom_createPoint_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSCoordSequence}),handle,s)
end

function GEOSGeom_createEmptyPoint_r(handle::GEOSContextHandle_t)
    ccall((:GEOSGeom_createEmptyPoint_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,),handle)
end

function GEOSGeom_createLinearRing_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence})
    ccall((:GEOSGeom_createLinearRing_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSCoordSequence}),handle,s)
end

function GEOSGeom_createLineString_r(handle::GEOSContextHandle_t,s::Ptr{GEOSCoordSequence})
    ccall((:GEOSGeom_createLineString_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSCoordSequence}),handle,s)
end

function GEOSGeom_createEmptyLineString_r(handle::GEOSContextHandle_t)
    ccall((:GEOSGeom_createEmptyLineString_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,),handle)
end

function GEOSGeom_createPolygon(shell::Ptr{GEOSGeometry},holes::Ptr{Ptr{GEOSGeometry}},nholes::Uint32)
    ccall((:GEOSGeom_createPolygon,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Ptr{Ptr{GEOSGeometry}},Uint32),shell,holes,nholes)
end

function GEOSGeom_createCollection(_type::Cint,geoms::Ptr{Ptr{GEOSGeometry}},ngeoms::Uint32)
    ccall((:GEOSGeom_createCollection,libgeos),Ptr{GEOSGeometry},(Cint,Ptr{Ptr{GEOSGeometry}},Uint32),_type,geoms,ngeoms)
end

function GEOSGeom_createEmptyCollection(_type::Cint)
    ccall((:GEOSGeom_createEmptyCollection,libgeos),Ptr{GEOSGeometry},(Cint,),_type)
end

function GEOSGeom_createEmptyPolygon_r(handle::GEOSContextHandle_t)
    ccall((:GEOSGeom_createEmptyPolygon_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,),handle)
end

function GEOSGeom_createPolygon_r(handle::GEOSContextHandle_t,shell::Ptr{GEOSGeometry},holes::Ptr{Ptr{GEOSGeometry}},nholes::Uint32)
    ccall((:GEOSGeom_createPolygon_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{Ptr{GEOSGeometry}},Uint32),handle,shell,holes,nholes)
end

function GEOSGeom_createCollection_r(handle::GEOSContextHandle_t,_type::Cint,geoms::Ptr{Ptr{GEOSGeometry}},ngeoms::Uint32)
    ccall((:GEOSGeom_createCollection_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Cint,Ptr{Ptr{GEOSGeometry}},Uint32),handle,_type,geoms,ngeoms)
end

function GEOSGeom_createEmptyCollection_r(handle::GEOSContextHandle_t,_type::Cint)
    ccall((:GEOSGeom_createEmptyCollection_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Cint),handle,_type)
end

function GEOSGeom_clone(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_clone,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSGeom_clone_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_clone_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGeom_destroy(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_destroy,libgeos),Void,(Ptr{GEOSGeometry},),g)
end

function GEOSGeom_destroy_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_destroy_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSEnvelope(g::Ptr{GEOSGeometry})
    ccall((:GEOSEnvelope,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSIntersection(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSIntersection,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSConvexHull(g::Ptr{GEOSGeometry})
    ccall((:GEOSConvexHull,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSDifference(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSDifference,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSSymDifference(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSSymDifference,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSBoundary(g::Ptr{GEOSGeometry})
    ccall((:GEOSBoundary,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSUnion(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSUnion,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSUnaryUnion(g::Ptr{GEOSGeometry})
    ccall((:GEOSUnaryUnion,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSUnionCascaded(g::Ptr{GEOSGeometry})
    ccall((:GEOSUnionCascaded,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSPointOnSurface(g::Ptr{GEOSGeometry})
    ccall((:GEOSPointOnSurface,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSGetCentroid(g::Ptr{GEOSGeometry})
    ccall((:GEOSGetCentroid,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSNode(g::Ptr{GEOSGeometry})
    ccall((:GEOSNode,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSEnvelope_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSEnvelope_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSIntersection_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSIntersection_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSConvexHull_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSConvexHull_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSDifference_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSDifference_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSSymDifference_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSSymDifference_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSBoundary_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSBoundary_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSUnion_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSUnion_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSUnaryUnion_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSUnaryUnion_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSUnionCascaded_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSUnionCascaded_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSPointOnSurface_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSPointOnSurface_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGetCentroid_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGetCentroid_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSNode_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSNode_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSPolygonize(geoms::Ptr{Ptr{GEOSGeometry}},ngeoms::Uint32)
    ccall((:GEOSPolygonize,libgeos),Ptr{GEOSGeometry},(Ptr{Ptr{GEOSGeometry}},Uint32),geoms,ngeoms)
end

function GEOSPolygonizer_getCutEdges(geoms::Ptr{Ptr{GEOSGeometry}},ngeoms::Uint32)
    ccall((:GEOSPolygonizer_getCutEdges,libgeos),Ptr{GEOSGeometry},(Ptr{Ptr{GEOSGeometry}},Uint32),geoms,ngeoms)
end

function GEOSPolygonize_full(input::Ptr{GEOSGeometry},cuts::Ptr{Ptr{GEOSGeometry}},dangles::Ptr{Ptr{GEOSGeometry}},invalid::Ptr{Ptr{GEOSGeometry}})
    ccall((:GEOSPolygonize_full,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Ptr{Ptr{GEOSGeometry}},Ptr{Ptr{GEOSGeometry}},Ptr{Ptr{GEOSGeometry}}),input,cuts,dangles,invalid)
end

function GEOSLineMerge(g::Ptr{GEOSGeometry})
    ccall((:GEOSLineMerge,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSSimplify(g::Ptr{GEOSGeometry},tolerance::Cdouble)
    ccall((:GEOSSimplify,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cdouble),g,tolerance)
end

function GEOSTopologyPreserveSimplify(g::Ptr{GEOSGeometry},tolerance::Cdouble)
    ccall((:GEOSTopologyPreserveSimplify,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cdouble),g,tolerance)
end

function GEOSPolygonize_r(handle::GEOSContextHandle_t,geoms::Ptr{Ptr{GEOSGeometry}},ngeoms::Uint32)
    ccall((:GEOSPolygonize_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{Ptr{GEOSGeometry}},Uint32),handle,geoms,ngeoms)
end

function GEOSPolygonizer_getCutEdges_r(handle::GEOSContextHandle_t,geoms::Ptr{Ptr{GEOSGeometry}},ngeoms::Uint32)
    ccall((:GEOSPolygonizer_getCutEdges_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{Ptr{GEOSGeometry}},Uint32),handle,geoms,ngeoms)
end

function GEOSPolygonize_full_r(handle::GEOSContextHandle_t,input::Ptr{GEOSGeometry},cuts::Ptr{Ptr{GEOSGeometry}},dangles::Ptr{Ptr{GEOSGeometry}},invalidRings::Ptr{Ptr{GEOSGeometry}})
    ccall((:GEOSPolygonize_full_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{Ptr{GEOSGeometry}},Ptr{Ptr{GEOSGeometry}},Ptr{Ptr{GEOSGeometry}}),handle,input,cuts,dangles,invalidRings)
end

function GEOSLineMerge_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSLineMerge_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSSimplify_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},tolerance::Cdouble)
    ccall((:GEOSSimplify_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cdouble),handle,g,tolerance)
end

function GEOSTopologyPreserveSimplify_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},tolerance::Cdouble)
    ccall((:GEOSTopologyPreserveSimplify_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cdouble),handle,g,tolerance)
end

function GEOSGeom_extractUniquePoints(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_extractUniquePoints,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSGeom_extractUniquePoints_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_extractUniquePoints_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSSharedPaths(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSSharedPaths,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSSharedPaths_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSSharedPaths_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSSnap(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},tolerance::Cdouble)
    ccall((:GEOSSnap,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Ptr{GEOSGeometry},Cdouble),g1,g2,tolerance)
end

function GEOSSnap_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},tolerance::Cdouble)
    ccall((:GEOSSnap_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry},Cdouble),handle,g1,g2,tolerance)
end

function GEOSDelaunayTriangulation(g::Ptr{GEOSGeometry},tolerance::Cdouble,onlyEdges::Cint)
    ccall((:GEOSDelaunayTriangulation,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cdouble,Cint),g,tolerance,onlyEdges)
end

function GEOSDelaunayTriangulation_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},tolerance::Cdouble,onlyEdges::Cint)
    ccall((:GEOSDelaunayTriangulation_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cdouble,Cint),handle,g,tolerance,onlyEdges)
end

function GEOSDisjoint(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSDisjoint,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSTouches(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSTouches,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSIntersects(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSIntersects,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSCrosses(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSCrosses,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSWithin(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSWithin,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSContains(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSContains,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSOverlaps(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSOverlaps,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSEquals(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSEquals,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSEqualsExact(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},tolerance::Cdouble)
    ccall((:GEOSEqualsExact,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry},Cdouble),g1,g2,tolerance)
end

function GEOSCovers(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSCovers,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSCoveredBy(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSCoveredBy,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSDisjoint_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSDisjoint_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSTouches_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSTouches_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSIntersects_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSIntersects_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSCrosses_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSCrosses_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSWithin_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSWithin_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSContains_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSContains_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSOverlaps_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSOverlaps_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSEquals_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSEquals_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSEqualsExact_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},tolerance::Cdouble)
    ccall((:GEOSEqualsExact_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry},Cdouble),handle,g1,g2,tolerance)
end

function GEOSCovers_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSCovers_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSCoveredBy_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSCoveredBy_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSPrepare(g::Ptr{GEOSGeometry})
    ccall((:GEOSPrepare,libgeos),Ptr{GEOSPreparedGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSPreparedGeom_destroy(g::Ptr{GEOSPreparedGeometry})
    ccall((:GEOSPreparedGeom_destroy,libgeos),Void,(Ptr{GEOSPreparedGeometry},),g)
end

function GEOSPreparedContains(pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedContains,libgeos),Uint8,(Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),pg1,g2)
end

function GEOSPreparedContainsProperly(pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedContainsProperly,libgeos),Uint8,(Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),pg1,g2)
end

function GEOSPreparedCoveredBy(pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedCoveredBy,libgeos),Uint8,(Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),pg1,g2)
end

function GEOSPreparedCovers(pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedCovers,libgeos),Uint8,(Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),pg1,g2)
end

function GEOSPreparedCrosses(pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedCrosses,libgeos),Uint8,(Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),pg1,g2)
end

function GEOSPreparedDisjoint(pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedDisjoint,libgeos),Uint8,(Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),pg1,g2)
end

function GEOSPreparedIntersects(pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedIntersects,libgeos),Uint8,(Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),pg1,g2)
end

function GEOSPreparedOverlaps(pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedOverlaps,libgeos),Uint8,(Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),pg1,g2)
end

function GEOSPreparedTouches(pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedTouches,libgeos),Uint8,(Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),pg1,g2)
end

function GEOSPreparedWithin(pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedWithin,libgeos),Uint8,(Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),pg1,g2)
end

function GEOSPrepare_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSPrepare_r,libgeos),Ptr{GEOSPreparedGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSPreparedGeom_destroy_r(handle::GEOSContextHandle_t,g::Ptr{GEOSPreparedGeometry})
    ccall((:GEOSPreparedGeom_destroy_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry}),handle,g)
end

function GEOSPreparedContains_r(handle::GEOSContextHandle_t,pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedContains_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),handle,pg1,g2)
end

function GEOSPreparedContainsProperly_r(handle::GEOSContextHandle_t,pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedContainsProperly_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),handle,pg1,g2)
end

function GEOSPreparedCoveredBy_r(handle::GEOSContextHandle_t,pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedCoveredBy_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),handle,pg1,g2)
end

function GEOSPreparedCovers_r(handle::GEOSContextHandle_t,pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedCovers_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),handle,pg1,g2)
end

function GEOSPreparedCrosses_r(handle::GEOSContextHandle_t,pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedCrosses_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),handle,pg1,g2)
end

function GEOSPreparedDisjoint_r(handle::GEOSContextHandle_t,pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedDisjoint_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),handle,pg1,g2)
end

function GEOSPreparedIntersects_r(handle::GEOSContextHandle_t,pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedIntersects_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),handle,pg1,g2)
end

function GEOSPreparedOverlaps_r(handle::GEOSContextHandle_t,pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedOverlaps_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),handle,pg1,g2)
end

function GEOSPreparedTouches_r(handle::GEOSContextHandle_t,pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedTouches_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),handle,pg1,g2)
end

function GEOSPreparedWithin_r(handle::GEOSContextHandle_t,pg1::Ptr{GEOSPreparedGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSPreparedWithin_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSPreparedGeometry},Ptr{GEOSGeometry}),handle,pg1,g2)
end

function GEOSSTRtree_create(nodeCapacity::Csize_t)
    ccall((:GEOSSTRtree_create,libgeos),Ptr{GEOSSTRtree},(Csize_t,),nodeCapacity)
end

function GEOSSTRtree_insert(tree::Ptr{GEOSSTRtree},g::Ptr{GEOSGeometry},item::Ptr{Void})
    ccall((:GEOSSTRtree_insert,libgeos),Void,(Ptr{GEOSSTRtree},Ptr{GEOSGeometry},Ptr{Void}),tree,g,item)
end

function GEOSSTRtree_query(tree::Ptr{GEOSSTRtree},g::Ptr{GEOSGeometry},callback::Cint,userdata::Ptr{Void})
    ccall((:GEOSSTRtree_query,libgeos),Void,(Ptr{GEOSSTRtree},Ptr{GEOSGeometry},Cint,Ptr{Void}),tree,g,callback,userdata)
end

function GEOSSTRtree_iterate(tree::Ptr{GEOSSTRtree},callback::Cint,userdata::Ptr{Void})
    ccall((:GEOSSTRtree_iterate,libgeos),Void,(Ptr{GEOSSTRtree},Cint,Ptr{Void}),tree,callback,userdata)
end

function GEOSSTRtree_remove(tree::Ptr{GEOSSTRtree},g::Ptr{GEOSGeometry},item::Ptr{Void})
    ccall((:GEOSSTRtree_remove,libgeos),Uint8,(Ptr{GEOSSTRtree},Ptr{GEOSGeometry},Ptr{Void}),tree,g,item)
end

function GEOSSTRtree_destroy(tree::Ptr{GEOSSTRtree})
    ccall((:GEOSSTRtree_destroy,libgeos),Void,(Ptr{GEOSSTRtree},),tree)
end

function GEOSSTRtree_create_r(handle::GEOSContextHandle_t,nodeCapacity::Csize_t)
    ccall((:GEOSSTRtree_create_r,libgeos),Ptr{GEOSSTRtree},(GEOSContextHandle_t,Csize_t),handle,nodeCapacity)
end

function GEOSSTRtree_insert_r(handle::GEOSContextHandle_t,tree::Ptr{GEOSSTRtree},g::Ptr{GEOSGeometry},item::Ptr{Void})
    ccall((:GEOSSTRtree_insert_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSSTRtree},Ptr{GEOSGeometry},Ptr{Void}),handle,tree,g,item)
end

function GEOSSTRtree_query_r(handle::GEOSContextHandle_t,tree::Ptr{GEOSSTRtree},g::Ptr{GEOSGeometry},callback::Cint,userdata::Ptr{Void})
    ccall((:GEOSSTRtree_query_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSSTRtree},Ptr{GEOSGeometry},Cint,Ptr{Void}),handle,tree,g,callback,userdata)
end

function GEOSSTRtree_iterate_r(handle::GEOSContextHandle_t,tree::Ptr{GEOSSTRtree},callback::Cint,userdata::Ptr{Void})
    ccall((:GEOSSTRtree_iterate_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSSTRtree},Cint,Ptr{Void}),handle,tree,callback,userdata)
end

function GEOSSTRtree_remove_r(handle::GEOSContextHandle_t,tree::Ptr{GEOSSTRtree},g::Ptr{GEOSGeometry},item::Ptr{Void})
    ccall((:GEOSSTRtree_remove_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSSTRtree},Ptr{GEOSGeometry},Ptr{Void}),handle,tree,g,item)
end

function GEOSSTRtree_destroy_r(handle::GEOSContextHandle_t,tree::Ptr{GEOSSTRtree})
    ccall((:GEOSSTRtree_destroy_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSSTRtree}),handle,tree)
end

function GEOSisEmpty(g::Ptr{GEOSGeometry})
    ccall((:GEOSisEmpty,libgeos),Uint8,(Ptr{GEOSGeometry},),g)
end

function GEOSisSimple(g::Ptr{GEOSGeometry})
    ccall((:GEOSisSimple,libgeos),Uint8,(Ptr{GEOSGeometry},),g)
end

function GEOSisRing(g::Ptr{GEOSGeometry})
    ccall((:GEOSisRing,libgeos),Uint8,(Ptr{GEOSGeometry},),g)
end

function GEOSHasZ(g::Ptr{GEOSGeometry})
    ccall((:GEOSHasZ,libgeos),Uint8,(Ptr{GEOSGeometry},),g)
end

function GEOSisClosed(g::Ptr{GEOSGeometry})
    ccall((:GEOSisClosed,libgeos),Uint8,(Ptr{GEOSGeometry},),g)
end

function GEOSisEmpty_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSisEmpty_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSisSimple_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSisSimple_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSisRing_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSisRing_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSHasZ_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSHasZ_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSisClosed_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSisClosed_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSRelatePattern(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},pat::Ptr{Uint8})
    ccall((:GEOSRelatePattern,libgeos),Uint8,(Ptr{GEOSGeometry},Ptr{GEOSGeometry},Ptr{Uint8}),g1,g2,pat)
end

function GEOSRelatePattern_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},pat::Ptr{Uint8})
    ccall((:GEOSRelatePattern_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry},Ptr{Uint8}),handle,g1,g2,pat)
end

function GEOSRelate(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSRelate,libgeos),Ptr{Uint8},(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSRelate_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSRelate_r,libgeos),Ptr{Uint8},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSRelatePatternMatch(mat::Ptr{Uint8},pat::Ptr{Uint8})
    ccall((:GEOSRelatePatternMatch,libgeos),Uint8,(Ptr{Uint8},Ptr{Uint8}),mat,pat)
end

function GEOSRelatePatternMatch_r(handle::GEOSContextHandle_t,mat::Ptr{Uint8},pat::Ptr{Uint8})
    ccall((:GEOSRelatePatternMatch_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{Uint8},Ptr{Uint8}),handle,mat,pat)
end

function GEOSRelateBoundaryNodeRule(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},bnr::Cint)
    ccall((:GEOSRelateBoundaryNodeRule,libgeos),Ptr{Uint8},(Ptr{GEOSGeometry},Ptr{GEOSGeometry},Cint),g1,g2,bnr)
end

function GEOSRelateBoundaryNodeRule_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},bnr::Cint)
    ccall((:GEOSRelateBoundaryNodeRule_r,libgeos),Ptr{Uint8},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry},Cint),handle,g1,g2,bnr)
end

function GEOSisValid(g::Ptr{GEOSGeometry})
    ccall((:GEOSisValid,libgeos),Uint8,(Ptr{GEOSGeometry},),g)
end

function GEOSisValid_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSisValid_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSisValidReason(g::Ptr{GEOSGeometry})
    ccall((:GEOSisValidReason,libgeos),Ptr{Uint8},(Ptr{GEOSGeometry},),g)
end

function GEOSisValidReason_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSisValidReason_r,libgeos),Ptr{Uint8},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSisValidDetail(g::Ptr{GEOSGeometry},flags::Cint,reason::Ptr{Ptr{Uint8}},location::Ptr{Ptr{GEOSGeometry}})
    ccall((:GEOSisValidDetail,libgeos),Uint8,(Ptr{GEOSGeometry},Cint,Ptr{Ptr{Uint8}},Ptr{Ptr{GEOSGeometry}}),g,flags,reason,location)
end

function GEOSisValidDetail_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},flags::Cint,reason::Ptr{Ptr{Uint8}},location::Ptr{Ptr{GEOSGeometry}})
    ccall((:GEOSisValidDetail_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSGeometry},Cint,Ptr{Ptr{Uint8}},Ptr{Ptr{GEOSGeometry}}),handle,g,flags,reason,location)
end

function GEOSGeomType(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomType,libgeos),Ptr{Uint8},(Ptr{GEOSGeometry},),g)
end

function GEOSGeomType_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomType_r,libgeos),Ptr{Uint8},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGeomTypeId(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomTypeId,libgeos),Cint,(Ptr{GEOSGeometry},),g)
end

function GEOSGeomTypeId_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomTypeId_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGetSRID(g::Ptr{GEOSGeometry})
    ccall((:GEOSGetSRID,libgeos),Cint,(Ptr{GEOSGeometry},),g)
end

function GEOSGetSRID_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGetSRID_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSSetSRID(g::Ptr{GEOSGeometry},SRID::Cint)
    ccall((:GEOSSetSRID,libgeos),Void,(Ptr{GEOSGeometry},Cint),g,SRID)
end

function GEOSSetSRID_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},SRID::Cint)
    ccall((:GEOSSetSRID_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSGeometry},Cint),handle,g,SRID)
end

function GEOSGetNumGeometries(g::Ptr{GEOSGeometry})
    ccall((:GEOSGetNumGeometries,libgeos),Cint,(Ptr{GEOSGeometry},),g)
end

function GEOSGetNumGeometries_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGetNumGeometries_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGetGeometryN(g::Ptr{GEOSGeometry},n::Cint)
    ccall((:GEOSGetGeometryN,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cint),g,n)
end

function GEOSGetGeometryN_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},n::Cint)
    ccall((:GEOSGetGeometryN_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cint),handle,g,n)
end

function GEOSNormalize(g::Ptr{GEOSGeometry})
    ccall((:GEOSNormalize,libgeos),Cint,(Ptr{GEOSGeometry},),g)
end

function GEOSNormalize_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSNormalize_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGetNumInteriorRings(g::Ptr{GEOSGeometry})
    ccall((:GEOSGetNumInteriorRings,libgeos),Cint,(Ptr{GEOSGeometry},),g)
end

function GEOSGetNumInteriorRings_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGetNumInteriorRings_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGeomGetNumPoints(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomGetNumPoints,libgeos),Cint,(Ptr{GEOSGeometry},),g)
end

function GEOSGeomGetNumPoints_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomGetNumPoints_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGeomGetX(g::Ptr{GEOSGeometry},x::Ptr{Cdouble})
    ccall((:GEOSGeomGetX,libgeos),Cint,(Ptr{GEOSGeometry},Ptr{Cdouble}),g,x)
end

function GEOSGeomGetY(g::Ptr{GEOSGeometry},y::Ptr{Cdouble})
    ccall((:GEOSGeomGetY,libgeos),Cint,(Ptr{GEOSGeometry},Ptr{Cdouble}),g,y)
end

function GEOSGeomGetX_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},x::Ptr{Cdouble})
    ccall((:GEOSGeomGetX_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{Cdouble}),handle,g,x)
end

function GEOSGeomGetY_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},y::Ptr{Cdouble})
    ccall((:GEOSGeomGetY_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{Cdouble}),handle,g,y)
end

function GEOSGetInteriorRingN(g::Ptr{GEOSGeometry},n::Cint)
    ccall((:GEOSGetInteriorRingN,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cint),g,n)
end

function GEOSGetInteriorRingN_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},n::Cint)
    ccall((:GEOSGetInteriorRingN_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cint),handle,g,n)
end

function GEOSGetExteriorRing(g::Ptr{GEOSGeometry})
    ccall((:GEOSGetExteriorRing,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSGetExteriorRing_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGetExteriorRing_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGetNumCoordinates(g::Ptr{GEOSGeometry})
    ccall((:GEOSGetNumCoordinates,libgeos),Cint,(Ptr{GEOSGeometry},),g)
end

function GEOSGetNumCoordinates_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGetNumCoordinates_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGeom_getCoordSeq(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_getCoordSeq,libgeos),Ptr{GEOSCoordSequence},(Ptr{GEOSGeometry},),g)
end

function GEOSGeom_getCoordSeq_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_getCoordSeq_r,libgeos),Ptr{GEOSCoordSequence},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGeom_getDimensions(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_getDimensions,libgeos),Cint,(Ptr{GEOSGeometry},),g)
end

function GEOSGeom_getDimensions_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_getDimensions_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGeom_getCoordinateDimension(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_getCoordinateDimension,libgeos),Cint,(Ptr{GEOSGeometry},),g)
end

function GEOSGeom_getCoordinateDimension_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeom_getCoordinateDimension_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGeomGetPointN(g::Ptr{GEOSGeometry},n::Cint)
    ccall((:GEOSGeomGetPointN,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},Cint),g,n)
end

function GEOSGeomGetStartPoint(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomGetStartPoint,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSGeomGetEndPoint(g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomGetEndPoint,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSGeometry},),g)
end

function GEOSGeomGetPointN_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},n::Cint)
    ccall((:GEOSGeomGetPointN_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry},Cint),handle,g,n)
end

function GEOSGeomGetStartPoint_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomGetStartPoint_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSGeomGetEndPoint_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry})
    ccall((:GEOSGeomGetEndPoint_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSGeometry}),handle,g)
end

function GEOSArea(g::Ptr{GEOSGeometry},area::Ptr{Cdouble})
    ccall((:GEOSArea,libgeos),Cint,(Ptr{GEOSGeometry},Ptr{Cdouble}),g,area)
end

function GEOSLength(g::Ptr{GEOSGeometry},length::Ptr{Cdouble})
    ccall((:GEOSLength,libgeos),Cint,(Ptr{GEOSGeometry},Ptr{Cdouble}),g,length)
end

function GEOSDistance(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},dist::Ptr{Cdouble})
    ccall((:GEOSDistance,libgeos),Cint,(Ptr{GEOSGeometry},Ptr{GEOSGeometry},Ptr{Cdouble}),g1,g2,dist)
end

function GEOSHausdorffDistance(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},dist::Ptr{Cdouble})
    ccall((:GEOSHausdorffDistance,libgeos),Cint,(Ptr{GEOSGeometry},Ptr{GEOSGeometry},Ptr{Cdouble}),g1,g2,dist)
end

function GEOSHausdorffDistanceDensify(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},densifyFrac::Cdouble,dist::Ptr{Cdouble})
    ccall((:GEOSHausdorffDistanceDensify,libgeos),Cint,(Ptr{GEOSGeometry},Ptr{GEOSGeometry},Cdouble,Ptr{Cdouble}),g1,g2,densifyFrac,dist)
end

function GEOSGeomGetLength(g::Ptr{GEOSGeometry},length::Ptr{Cdouble})
    ccall((:GEOSGeomGetLength,libgeos),Cint,(Ptr{GEOSGeometry},Ptr{Cdouble}),g,length)
end

function GEOSArea_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},area::Ptr{Cdouble})
    ccall((:GEOSArea_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{Cdouble}),handle,g,area)
end

function GEOSLength_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},length::Ptr{Cdouble})
    ccall((:GEOSLength_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{Cdouble}),handle,g,length)
end

function GEOSDistance_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},dist::Ptr{Cdouble})
    ccall((:GEOSDistance_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry},Ptr{Cdouble}),handle,g1,g2,dist)
end

function GEOSHausdorffDistance_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},dist::Ptr{Cdouble})
    ccall((:GEOSHausdorffDistance_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry},Ptr{Cdouble}),handle,g1,g2,dist)
end

function GEOSHausdorffDistanceDensify_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry},densifyFrac::Cdouble,dist::Ptr{Cdouble})
    ccall((:GEOSHausdorffDistanceDensify_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry},Cdouble,Ptr{Cdouble}),handle,g1,g2,densifyFrac,dist)
end

function GEOSGeomGetLength_r(handle::GEOSContextHandle_t,g::Ptr{GEOSGeometry},length::Ptr{Cdouble})
    ccall((:GEOSGeomGetLength_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{Cdouble}),handle,g,length)
end

function GEOSNearestPoints(g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSNearestPoints,libgeos),Ptr{GEOSCoordSequence},(Ptr{GEOSGeometry},Ptr{GEOSGeometry}),g1,g2)
end

function GEOSNearestPoints_r(handle::GEOSContextHandle_t,g1::Ptr{GEOSGeometry},g2::Ptr{GEOSGeometry})
    ccall((:GEOSNearestPoints_r,libgeos),Ptr{GEOSCoordSequence},(GEOSContextHandle_t,Ptr{GEOSGeometry},Ptr{GEOSGeometry}),handle,g1,g2)
end

function GEOSOrientationIndex(Ax::Cdouble,Ay::Cdouble,Bx::Cdouble,By::Cdouble,Px::Cdouble,Py::Cdouble)
    ccall((:GEOSOrientationIndex,libgeos),Cint,(Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),Ax,Ay,Bx,By,Px,Py)
end

function GEOSOrientationIndex_r(handle::GEOSContextHandle_t,Ax::Cdouble,Ay::Cdouble,Bx::Cdouble,By::Cdouble,Px::Cdouble,Py::Cdouble)
    ccall((:GEOSOrientationIndex_r,libgeos),Cint,(GEOSContextHandle_t,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble,Cdouble),handle,Ax,Ay,Bx,By,Px,Py)
end

function GEOSWKTReader_destroy(reader::Ptr{GEOSWKTReader})
    ccall((:GEOSWKTReader_destroy,libgeos),Void,(Ptr{GEOSWKTReader},),reader)
end

function GEOSWKTReader_read(reader::Ptr{GEOSWKTReader},wkt::Ptr{Uint8})
    ccall((:GEOSWKTReader_read,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSWKTReader},Ptr{Uint8}),reader,wkt)
end

function GEOSWKTReader_create_r(handle::GEOSContextHandle_t)
    ccall((:GEOSWKTReader_create_r,libgeos),Ptr{GEOSWKTReader},(GEOSContextHandle_t,),handle)
end

function GEOSWKTReader_destroy_r(handle::GEOSContextHandle_t,reader::Ptr{GEOSWKTReader})
    ccall((:GEOSWKTReader_destroy_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKTReader}),handle,reader)
end

function GEOSWKTReader_read_r(handle::GEOSContextHandle_t,reader::Ptr{GEOSWKTReader},wkt::Ptr{Uint8})
    ccall((:GEOSWKTReader_read_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSWKTReader},Ptr{Uint8}),handle,reader,wkt)
end

function GEOSWKTWriter_destroy(writer::Ptr{GEOSWKTWriter})
    ccall((:GEOSWKTWriter_destroy,libgeos),Void,(Ptr{GEOSWKTWriter},),writer)
end

function GEOSWKTWriter_write(writer::Ptr{GEOSWKTWriter},g::Ptr{GEOSGeometry})
    ccall((:GEOSWKTWriter_write,libgeos),Ptr{Uint8},(Ptr{GEOSWKTWriter},Ptr{GEOSGeometry}),writer,g)
end

function GEOSWKTWriter_setTrim(writer::Ptr{GEOSWKTWriter},trim::Uint8)
    ccall((:GEOSWKTWriter_setTrim,libgeos),Void,(Ptr{GEOSWKTWriter},Uint8),writer,trim)
end

function GEOSWKTWriter_setRoundingPrecision(writer::Ptr{GEOSWKTWriter},precision::Cint)
    ccall((:GEOSWKTWriter_setRoundingPrecision,libgeos),Void,(Ptr{GEOSWKTWriter},Cint),writer,precision)
end

function GEOSWKTWriter_setOutputDimension(writer::Ptr{GEOSWKTWriter},dim::Cint)
    ccall((:GEOSWKTWriter_setOutputDimension,libgeos),Void,(Ptr{GEOSWKTWriter},Cint),writer,dim)
end

function GEOSWKTWriter_getOutputDimension(writer::Ptr{GEOSWKTWriter})
    ccall((:GEOSWKTWriter_getOutputDimension,libgeos),Cint,(Ptr{GEOSWKTWriter},),writer)
end

function GEOSWKTWriter_setOld3D(writer::Ptr{GEOSWKTWriter},useOld3D::Cint)
    ccall((:GEOSWKTWriter_setOld3D,libgeos),Void,(Ptr{GEOSWKTWriter},Cint),writer,useOld3D)
end

function GEOSWKTWriter_create_r(handle::GEOSContextHandle_t)
    ccall((:GEOSWKTWriter_create_r,libgeos),Ptr{GEOSWKTWriter},(GEOSContextHandle_t,),handle)
end

function GEOSWKTWriter_destroy_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKTWriter})
    ccall((:GEOSWKTWriter_destroy_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKTWriter}),handle,writer)
end

function GEOSWKTWriter_write_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKTWriter},g::Ptr{GEOSGeometry})
    ccall((:GEOSWKTWriter_write_r,libgeos),Ptr{Uint8},(GEOSContextHandle_t,Ptr{GEOSWKTWriter},Ptr{GEOSGeometry}),handle,writer,g)
end

function GEOSWKTWriter_setTrim_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKTWriter},trim::Uint8)
    ccall((:GEOSWKTWriter_setTrim_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKTWriter},Uint8),handle,writer,trim)
end

function GEOSWKTWriter_setRoundingPrecision_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKTWriter},precision::Cint)
    ccall((:GEOSWKTWriter_setRoundingPrecision_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKTWriter},Cint),handle,writer,precision)
end

function GEOSWKTWriter_setOutputDimension_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKTWriter},dim::Cint)
    ccall((:GEOSWKTWriter_setOutputDimension_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKTWriter},Cint),handle,writer,dim)
end

function GEOSWKTWriter_getOutputDimension_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKTWriter})
    ccall((:GEOSWKTWriter_getOutputDimension_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSWKTWriter}),handle,writer)
end

function GEOSWKTWriter_setOld3D_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKTWriter},useOld3D::Cint)
    ccall((:GEOSWKTWriter_setOld3D_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKTWriter},Cint),handle,writer,useOld3D)
end

function GEOSWKBReader_destroy(reader::Ptr{GEOSWKBReader})
    ccall((:GEOSWKBReader_destroy,libgeos),Void,(Ptr{GEOSWKBReader},),reader)
end

function GEOSWKBReader_read(reader::Ptr{GEOSWKBReader},wkb::Ptr{Cuchar},size::Csize_t)
    ccall((:GEOSWKBReader_read,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSWKBReader},Ptr{Cuchar},Csize_t),reader,wkb,size)
end

function GEOSWKBReader_readHEX(reader::Ptr{GEOSWKBReader},hex::Ptr{Cuchar},size::Csize_t)
    ccall((:GEOSWKBReader_readHEX,libgeos),Ptr{GEOSGeometry},(Ptr{GEOSWKBReader},Ptr{Cuchar},Csize_t),reader,hex,size)
end

function GEOSWKBReader_create_r(handle::GEOSContextHandle_t)
    ccall((:GEOSWKBReader_create_r,libgeos),Ptr{GEOSWKBReader},(GEOSContextHandle_t,),handle)
end

function GEOSWKBReader_destroy_r(handle::GEOSContextHandle_t,reader::Ptr{GEOSWKBReader})
    ccall((:GEOSWKBReader_destroy_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKBReader}),handle,reader)
end

function GEOSWKBReader_read_r(handle::GEOSContextHandle_t,reader::Ptr{GEOSWKBReader},wkb::Ptr{Cuchar},size::Csize_t)
    ccall((:GEOSWKBReader_read_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSWKBReader},Ptr{Cuchar},Csize_t),handle,reader,wkb,size)
end

function GEOSWKBReader_readHEX_r(handle::GEOSContextHandle_t,reader::Ptr{GEOSWKBReader},hex::Ptr{Cuchar},size::Csize_t)
    ccall((:GEOSWKBReader_readHEX_r,libgeos),Ptr{GEOSGeometry},(GEOSContextHandle_t,Ptr{GEOSWKBReader},Ptr{Cuchar},Csize_t),handle,reader,hex,size)
end

function GEOSWKBWriter_destroy(writer::Ptr{GEOSWKBWriter})
    ccall((:GEOSWKBWriter_destroy,libgeos),Void,(Ptr{GEOSWKBWriter},),writer)
end

function GEOSWKBWriter_create_r(handle::GEOSContextHandle_t)
    ccall((:GEOSWKBWriter_create_r,libgeos),Ptr{GEOSWKBWriter},(GEOSContextHandle_t,),handle)
end

function GEOSWKBWriter_destroy_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKBWriter})
    ccall((:GEOSWKBWriter_destroy_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKBWriter}),handle,writer)
end

function GEOSWKBWriter_write(writer::Ptr{GEOSWKBWriter},g::Ptr{GEOSGeometry},size::Ptr{Csize_t})
    ccall((:GEOSWKBWriter_write,libgeos),Ptr{Cuchar},(Ptr{GEOSWKBWriter},Ptr{GEOSGeometry},Ptr{Csize_t}),writer,g,size)
end

function GEOSWKBWriter_writeHEX(writer::Ptr{GEOSWKBWriter},g::Ptr{GEOSGeometry},size::Ptr{Csize_t})
    ccall((:GEOSWKBWriter_writeHEX,libgeos),Ptr{Cuchar},(Ptr{GEOSWKBWriter},Ptr{GEOSGeometry},Ptr{Csize_t}),writer,g,size)
end

function GEOSWKBWriter_write_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKBWriter},g::Ptr{GEOSGeometry},size::Ptr{Csize_t})
    ccall((:GEOSWKBWriter_write_r,libgeos),Ptr{Cuchar},(GEOSContextHandle_t,Ptr{GEOSWKBWriter},Ptr{GEOSGeometry},Ptr{Csize_t}),handle,writer,g,size)
end

function GEOSWKBWriter_writeHEX_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKBWriter},g::Ptr{GEOSGeometry},size::Ptr{Csize_t})
    ccall((:GEOSWKBWriter_writeHEX_r,libgeos),Ptr{Cuchar},(GEOSContextHandle_t,Ptr{GEOSWKBWriter},Ptr{GEOSGeometry},Ptr{Csize_t}),handle,writer,g,size)
end

function GEOSWKBWriter_getOutputDimension(writer::Ptr{GEOSWKBWriter})
    ccall((:GEOSWKBWriter_getOutputDimension,libgeos),Cint,(Ptr{GEOSWKBWriter},),writer)
end

function GEOSWKBWriter_setOutputDimension(writer::Ptr{GEOSWKBWriter},newDimension::Cint)
    ccall((:GEOSWKBWriter_setOutputDimension,libgeos),Void,(Ptr{GEOSWKBWriter},Cint),writer,newDimension)
end

function GEOSWKBWriter_getOutputDimension_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKBWriter})
    ccall((:GEOSWKBWriter_getOutputDimension_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSWKBWriter}),handle,writer)
end

function GEOSWKBWriter_setOutputDimension_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKBWriter},newDimension::Cint)
    ccall((:GEOSWKBWriter_setOutputDimension_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKBWriter},Cint),handle,writer,newDimension)
end

function GEOSWKBWriter_getByteOrder(writer::Ptr{GEOSWKBWriter})
    ccall((:GEOSWKBWriter_getByteOrder,libgeos),Cint,(Ptr{GEOSWKBWriter},),writer)
end

function GEOSWKBWriter_setByteOrder(writer::Ptr{GEOSWKBWriter},byteOrder::Cint)
    ccall((:GEOSWKBWriter_setByteOrder,libgeos),Void,(Ptr{GEOSWKBWriter},Cint),writer,byteOrder)
end

function GEOSWKBWriter_getByteOrder_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKBWriter})
    ccall((:GEOSWKBWriter_getByteOrder_r,libgeos),Cint,(GEOSContextHandle_t,Ptr{GEOSWKBWriter}),handle,writer)
end

function GEOSWKBWriter_setByteOrder_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKBWriter},byteOrder::Cint)
    ccall((:GEOSWKBWriter_setByteOrder_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKBWriter},Cint),handle,writer,byteOrder)
end

function GEOSWKBWriter_getIncludeSRID(writer::Ptr{GEOSWKBWriter})
    ccall((:GEOSWKBWriter_getIncludeSRID,libgeos),Uint8,(Ptr{GEOSWKBWriter},),writer)
end

function GEOSWKBWriter_setIncludeSRID(writer::Ptr{GEOSWKBWriter},writeSRID::Uint8)
    ccall((:GEOSWKBWriter_setIncludeSRID,libgeos),Void,(Ptr{GEOSWKBWriter},Uint8),writer,writeSRID)
end

function GEOSWKBWriter_getIncludeSRID_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKBWriter})
    ccall((:GEOSWKBWriter_getIncludeSRID_r,libgeos),Uint8,(GEOSContextHandle_t,Ptr{GEOSWKBWriter}),handle,writer)
end

function GEOSWKBWriter_setIncludeSRID_r(handle::GEOSContextHandle_t,writer::Ptr{GEOSWKBWriter},writeSRID::Uint8)
    ccall((:GEOSWKBWriter_setIncludeSRID_r,libgeos),Void,(GEOSContextHandle_t,Ptr{GEOSWKBWriter},Uint8),handle,writer,writeSRID)
end

function GEOSFree(buffer::Ptr{Void})
    ccall((:GEOSFree,libgeos),Void,(Ptr{Void},),buffer)
end

function GEOSFree_r(handle::GEOSContextHandle_t,buffer::Ptr{Void})
    ccall((:GEOSFree_r,libgeos),Void,(GEOSContextHandle_t,Ptr{Void}),handle,buffer)
end
