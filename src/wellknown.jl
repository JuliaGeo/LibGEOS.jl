mutable struct WKTReader
    ptr::Ptr{GEOSWKTReader}

    function WKTReader(context::GEOSContext)
        reader = new(GEOSWKTReader_create_r(context))
        finalizer(function (reader)
            GEOSWKTReader_destroy_r(context, reader)
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
        writer = new(GEOSWKTWriter_create_r(context))
        GEOSWKTWriter_setTrim_r(context, writer, UInt8(trim))
        GEOSWKTWriter_setOutputDimension_r(context, writer, outputdim)
        GEOSWKTWriter_setRoundingPrecision_r(context, writer, roundingprecision)
        finalizer(function (writer)
            GEOSWKTWriter_destroy_r(context, writer)
            writer.ptr = C_NULL
        end, writer)
        writer
    end
end

mutable struct WKBReader
    ptr::Ptr{GEOSWKBReader}

    function WKBReader(context::GEOSContext)
        reader = new(GEOSWKBReader_create_r(context))
        finalizer(function (reader)
            GEOSWKBReader_destroy_r(context, reader)
            reader.ptr = C_NULL
        end, reader)
        reader
    end
end

mutable struct WKBWriter
    ptr::Ptr{GEOSWKBWriter}

    function WKBWriter(context::GEOSContext)
        writer = new(GEOSWKBWriter_create_r(context))
        finalizer(function (writer)
            GEOSWKBWriter_destroy_r(context, writer)
            writer.ptr = C_NULL
        end, writer)
        writer
    end
end
