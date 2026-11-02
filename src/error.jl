mutable struct GEOSError <: Exception
    msg::String
end
Base.showerror(io::IO, err::GEOSError) = print(io, "GEOSError\n\t$(err.msg)")

function geosjl_errorhandler(message::Cstring, userdata::Ptr{Cvoid})
    throw(GEOSError(unsafe_string(message)))
end
