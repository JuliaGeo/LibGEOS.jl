@Base.deprecate parseWKT(geom::String) = geomFromGEOS(geomFromWKT(geom))
@Base.deprecate function geomFromWKT(geom::String)
    result = GEOSGeomFromWKT(geom)
    if result == C_NULL
        error("LibGEOS: Error in GEOSGeomFromWKT")
    end
    result
end
@Base.deprecate geomToWKT(geom::Ptr{GEOSGeometry}) = unsafe_string(GEOSGeomToWKT(geom))
