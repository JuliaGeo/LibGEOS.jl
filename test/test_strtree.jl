@testset "STRtree" begin
    # front page examples
    p1 = readgeom("POLYGON((0 0,1 0,1 1,0 0))")
    p2 = readgeom("POLYGON((0 0,1 0,1 1,0 1,0 0))")
    p3 = readgeom("POLYGON((2 0,3 0,3 1,2 1,2 0))")

    # query polygon
    p4 = readgeom("POLYGON((0.5 0.5, 1.5 0.5, 1.5 1.5, 0.5 1.5, 0.5 0.5))")

    tree = STRtree((p1, p2, p3))
    res = query(tree, p4)
    @test res isa Vector{Polygon}
    @test res == [p1, p2]

    # heterogeneous tree with linestring and polygon
    ls = readgeom("LINESTRING(0 0,1 0,1 1,0 0)")
    tree = STRtree((p1, p2, p3, ls))
    res = query(tree, p4)
    @test res isa Vector{<:LibGEOS.AbstractGeometry}
    @test res == [p1, p2, ls]

    # Let's accidentally "drop" p2. Since it is in the tree it won't be finalized.
    p2 = nothing
    p5 = readgeom("POLYGON((0 0,1 0,1 1,0 1,0 0))") # equal to p2
    res = query(tree, p4)
    @test equals(res[1], p1)
    @test equals(res[2], p5)
end
