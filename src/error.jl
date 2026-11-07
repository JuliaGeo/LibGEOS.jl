mutable struct GEOSError <: Exception
    msg::String
end
Base.showerror(io::IO, err::GEOSError) = print(io, "GEOSError\n\t$(err.msg)")

# GEOS calls this from C++ code, where a Julia exception must not be thrown.
# So it stores the message, and `geos_check` throws it after the call returns.
function geosjl_errorhandler(message::Cstring, userdata::Ptr{Cvoid})
    context = unsafe_pointer_to_objref(userdata)::GEOSContext
    context.errormessage = unsafe_string(message)
    return nothing
end
