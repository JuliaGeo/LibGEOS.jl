facts("LibGEOS regressions") do

    # https://github.com/JuliaGeo/LibGEOS.jl/issues/29
    pts = [[0.,0.],[10.,0.], [10.,10.],[0.,10.]]
    @fact_throws polygon = Polygon([pts])

    # https://github.com/JuliaGeo/LibGEOS.jl/issues/24
    point = Point(2, 3)
    @fact GeoInterface.geotype(point) --> :Point

    # https://github.com/JuliaGeo/LibGEOS.jl/issues/25
    a = LibGEOS.createCoordSeq([0.0, 2.0])
    @fact LibGEOS.getCoordinates(a) --> Array{Float64,1}[[0.0,2.0]]

    # https://github.com/JuliaGeo/LibGEOS.jl/issues/12
    mp = LibGEOS.MultiPoint(Vector{Float64}[[0,0],[10,0],[10,10],[11,10]])
    @fact GeoInterface.geotype(mp) --> :MultiPoint

end
