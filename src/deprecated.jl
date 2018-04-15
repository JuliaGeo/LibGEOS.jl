@Base.deprecate parseWKT(geom::String) readgeom(geom)
@Base.deprecate geomFromWKT(geom::String) _readgeom(geom)
@Base.deprecate geomToWKT(geom::Ptr{GEOSGeometry}) writegeom(geom)
