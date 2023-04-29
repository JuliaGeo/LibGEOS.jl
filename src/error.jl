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
