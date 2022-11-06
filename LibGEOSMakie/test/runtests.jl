using Test
import LibGEOSMakie
import LibGEOS as LG
using Makie

@testset "smoketest" begin
    unitsquare = LG.readgeom("POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))")
    bigsquare = LG.readgeom("POLYGON((0 0, 11 0, 11 11, 0 11, 0 0))")
    smallsquare = LG.readgeom("POLYGON((5 5, 8 5, 8 8, 5 8, 5 5))")
    fig = Figure()
    geoms = [
        unitsquare,
        LG.difference(bigsquare, smallsquare),
        LG.boundary(unitsquare),
        LG.union(smallsquare, unitsquare),
        LG.readgeom("POINT(1 0)"),
        LG.readgeom("MULTIPOINT(1 2, 2 3, 3 4)"),
    ]
    for (i,geom) in enumerate(geoms)
        Makie.plot!(Axis(fig[i,1], title="$(typeof(geom))"), geom)
    end
    fig
end
