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

function test_hash_eq(obj1, obj2)

    @test obj1 == obj1
    @test isequal(obj1, obj1)
    @test hash(obj1) === hash(obj1)

    @test obj1 == deepcopy(obj1)
    @test isequal(obj1, deepcopy(obj1))
    @test hash(obj1) === hash(deepcopy(obj1))

    @test obj1 != obj2
    @test !isequal(obj1, obj2)
    @test hash(obj1) != hash(obj2)
end

@testset "hash eq" begin
    ctx1 = LibGEOS.GEOSContext()
    ctx2 = LibGEOS.GEOSContext()
    test_hash_eq(ctx1, ctx2)

    geos = [
        readgeom("POINT(0.12345 2.000 0.1)"),
        readgeom("POINT(0.12345 2.000 0.10000001)"),
        readgeom("POLYGON EMPTY"),
        readgeom("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))"),
        readgeom("POLYGON((1 1,1 2,2 2,2 1,1 1))"),
        readgeom("POLYGON((1 1,1 2,2 2,2.00000001 1,1 1))"),
        readgeom("LINESTRING (130 240, 650 240)"),
        readgeom("LINESTRING (130 240, -650 240)"),
    ]
    for g1 in geos
        for g2 in geos
            if g1 === g2
                continue
            end
            test_hash_eq(g1, g2)
        end
    end
end
