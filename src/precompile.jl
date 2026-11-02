using PrecompileTools: @setup_workload, @compile_workload

@setup_workload begin
    wkt1 = "POLYGON((0 0, 10 0, 10 10, 0 10, 0 0))"
    wkt2 = "POLYGON((5 5, 15 5, 15 15, 5 15, 5 5))"
    ring = [(0.0, 0.0), (1.0, 0.0), (1.0, 1.0), (0.0, 0.0)]
    @compile_workload begin
        # __init__ doesn't run while this module precompiles
        __init__()
        p = readgeom(wkt1)
        q = readgeom(wkt2)
        r = intersection(p, q)
        area(r)
        intersects(p, q)
        intersects(prepareGeom(p), q)
        writegeom(buffer(p, 1.0))
        GeoInterface.coordinates(r)
        collect(GeoInterface.getpoint(r))
        gp = GeoInterface.Polygon([ring])
        GeoInterface.convert(LibGEOS, gp)
        intersects(gp, p)
        query(STRtree([p, q]), r)
        _GLOBAL_CONTEXT_ALLOWED[] = false
    end
end
