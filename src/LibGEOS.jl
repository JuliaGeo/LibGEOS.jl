module LibGEOS

    @unix_only const libgeos = "libgeos_c"

    using Compat, GeoInterface

    export #geos_types
            Position,
            Point,
            LinearRing,
            LineString,
            Polygon,

            ndim,
            coordinates



    include("geos_c.jl")
    
    #  --- GEOSconnection ---
    # (see http://stackoverflow.com/questions/21400550/julia-ptrvoid-finalizer-error)
    # (or  https://groups.google.com/forum/#!msg/julia-dev/qgncotDBFx0/3L1hj9dibrIJ)

    type GEOSconnection
        status::Symbol

        function GEOSconnection()
            geos_status = new(:Initialized)
            initializeGEOS()
            finalizer(geos_status, finalizeGEOS)
            geos_status
        end
    end

    function initializeGEOS()
        initGEOS(C_NULL, C_NULL)
    end

    function finalizeGEOS(status::GEOSconnection)
        finishGEOS()
    end

    status = GEOSconnection()

    # --- END GEOSconnection ---

    include("geos_functions.jl")
    include("geos_types.jl")
    include("geos_interface.jl")
end