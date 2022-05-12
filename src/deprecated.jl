Base.@deprecate parseWKT(geom::String) readgeom(geom)
Base.@deprecate geomFromWKT(geom::String) _readgeom(geom)
Base.@deprecate geomToWKT(geom::Ptr{GEOSGeometry}) writegeom(geom)

Base.@deprecate_binding CAP_ROUND GEOSBUF_CAP_ROUND
Base.@deprecate_binding CAP_FLAT GEOSBUF_CAP_FLAT
Base.@deprecate_binding CAP_SQUARE GEOSBUF_CAP_SQUARE
Base.@deprecate_binding JOIN_ROUND GEOSBUF_JOIN_ROUND
Base.@deprecate_binding JOIN_MITRE GEOSBUF_JOIN_MITRE
Base.@deprecate_binding JOIN_BEVEL GEOSBUF_JOIN_BEVEL
