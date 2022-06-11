@testset "STRtree" begin
    # front page examples
    p1 = readgeom("POLYGON((0 0,1 0,1 1,0 0))")
    p2 = readgeom("POLYGON((0 0,1 0,1 1,0 1,0 0))")
    p3 = readgeom("POLYGON((2 0,3 0,3 1,2 1,2 0))")

    # query polygon
    p4 = readgeom("POLYGON((0.5 0.5, 1.5 0.5, 1.5 1.5, 0.5 1.5, 0.5 0.5))")

    tree = STRtree((p1, p2, p3))
    res = query(tree, p4)
    @test res == [p1, p2]

    # let's accidentally "drop" p2
    p2 = Nothing
    p5 = readgeom("POLYGON((0 0,1 0,1 1,0 1,0 0))") # p2
    res = query(tree, p4)
    @test equals(res[1], p1)
    @test equals(res[2], p5)
end
