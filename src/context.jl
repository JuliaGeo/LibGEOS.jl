"""
    GEOSContext

Every LibGEOS object needs to live somewhere in memory. Also many LibGEOS functions
need scratch memory or caches to do their job.

A `GEOSContext` governs such memory. Almost every function in LibGEOS accepts a `context`
argument, that allows passing a context explicitly. If no context is passed, a global context is used.

Using the global context is fine, as long as no multi-threading is used.
If multi threading is used, the global context should be avoided and every operation should only
involve objects that live in the context passed to the operation.
"""
mutable struct GEOSContext
    ptr::Ptr{Cvoid}  # GEOSContextHandle_t

    function GEOSContext()
        context = new(GEOS_init_r())
        GEOSContext_setNoticeHandler_r(context, C_NULL)
        GEOSContext_setErrorHandler_r(
            context,
            @cfunction(geosjl_errorhandler, Ptr{Cvoid}, (Ptr{UInt8}, Ptr{Cvoid}))
        )
        finalizer(context -> (GEOS_finish_r(context); context.ptr = C_NULL), context)
        context
    end
end

function Base.:(==)(c1::GEOSContext, c2::GEOSContext)
    (c1.ptr == c2.ptr)
end
function Base.hash(c::GEOSContext, h::UInt)
    hash(c.ptr, h)
end

"Get a copy of a string from GEOS, freeing the GEOS managed memory."
function string_copy_free(s::Cstring, context::GEOSContext = get_global_context())::String
    copy = unsafe_string(s)
    GEOSFree_r(context, pointer(s))
    return copy
end

const _GLOBAL_CONTEXT = Ref{GEOSContext}()
const _GLOBAL_CONTEXT_ALLOWED = Ref(false)

function get_global_context()::GEOSContext
    if _GLOBAL_CONTEXT_ALLOWED[]
        _GLOBAL_CONTEXT[]
    else
        msg = """
        LibGEOS global context disallowed, a `GEOSContext` must be passed explicitly.
        Alternatively you can allow the global context by calling:
        `LibGEOS.allow_global_context!(true)`
        """
        error(msg)
    end
end

"""

    allow_global_context!(bool::Bool)

Allow (bool=true) or disallow (bool=false) using the global LibGEOS context.


    allow_global_context!(f, bool::Bool)

Call `f` with global context usage allowed according to `bool`

Generally this function should only be used as a debugging tool, mostly for multithreaded programs.
See also [`GEOSContext`](@ref).
"""
function allow_global_context!(bool::Bool)
    _GLOBAL_CONTEXT_ALLOWED[] = bool
end

function allow_global_context!(f, bool::Bool)
    old = _GLOBAL_CONTEXT_ALLOWED[]
    allow_global_context!(bool)
    f()
    allow_global_context!(old)
end
