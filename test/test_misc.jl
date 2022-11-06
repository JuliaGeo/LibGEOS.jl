using Test
using LibGEOS

@testset "allow_global_context!" begin
    Point(1,2,3)
    LibGEOS.allow_global_context!(false)
    @test_throws ErrorException Point(1,2,3)
    Point(1,2,3, LibGEOS.GEOSContext())
    LibGEOS.allow_global_context!(true) do
        Point(1,2,3)
    end
    @test_throws ErrorException Point(1,2,3)
    LibGEOS.allow_global_context!(true)
    Point(1,2,3)
    Point(1,2,3, LibGEOS.GEOSContext())
    LibGEOS.allow_global_context!(false) do
        @test_throws ErrorException Point(1,2,3)
    end
    Point(1,2,3)
end

@testset "Context mixing" begin
    ctx1 = LibGEOS.GEOSContext()
    ctx2 = LibGEOS.GEOSContext()
    p = [[[-1.,-1],[+1,-1],[+1,+1],[-1,+1],[-1,-1]]]
    p1 = LibGEOS.Polygon(p, ctx1)
    p2 = LibGEOS.Polygon(p, ctx2)

    q = [[[-1.,-1],[+1,-1],[+1,+1],[-1,+1],[-1,-1]]]
    q1 = LibGEOS.Polygon(q, ctx1)
    q2 = LibGEOS.Polygon(q, ctx2)
    @test LibGEOS.intersects(p1, q1)
    @test LibGEOS.intersects(p1, q1, ctx1)
    @test LibGEOS.intersects(p2, q2)
    @test LibGEOS.intersects(p2, q2, ctx2)
    @test_throws ArgumentError LibGEOS.intersects(p1, q2)
    @test_throws ArgumentError LibGEOS.intersects(p2, q1)
end
