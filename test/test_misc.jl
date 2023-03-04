using Test
using LibGEOS
import GeoInterface
using Random: MersenneTwister

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
    ctx3 = LibGEOS.GEOSContext()
    p = [[[-1.,-1],[+1,-1],[+1,+1],[-1,+1],[-1,-1]]]
    p1 = LibGEOS.Polygon(p, ctx1)
    p2 = LibGEOS.Polygon(p, ctx2)

    q = [[[-1.,-1],[+1,-1],[+1,+1],[-1,+1],[-1,-1]]]
    q1 = LibGEOS.Polygon(q, ctx1)
    q2 = LibGEOS.Polygon(q, ctx2)
    @test LibGEOS.intersects(p1, q1)
    @test LibGEOS.intersects(p1, q1, ctx1)
    @test LibGEOS.intersects(p1, q1, ctx2)
    @test LibGEOS.intersects(p2, q2)
    @test LibGEOS.intersects(p2, q2, ctx1)
    @test LibGEOS.intersects(p2, q2, ctx2)
    @test LibGEOS.intersects(p1, q2)
    @test LibGEOS.intersects(p1, q2, ctx1)
    @test LibGEOS.intersects(p1, q2, ctx2)
    @test LibGEOS.intersects(p2, q1)
    @test LibGEOS.intersects(p2, q1, ctx1)
    @test LibGEOS.intersects(p2, q1, ctx2)
    @test LibGEOS.intersects(p2, q1, ctx3)
end

@testset "hash eq" begin
    ctx1 = LibGEOS.GEOSContext()
    ctx2 = LibGEOS.GEOSContext()
    @test ctx1 != ctx2
    @test ctx1 == ctx1
    @test hash(ctx1) != hash(ctx2)
    pt1 = readgeom("POINT(0.12345 2.000 0.1)")
    pt2 = readgeom("POINT(0.12345 2.000 0.2)")
    @test pt1 != pt2
    @test hash(pt1) != hash(pt2)
    @test !isequal(pt1, pt2)
    @test !isapprox(pt1, pt2)
    @test !isapprox(pt1, pt2, atol=0, rtol=0)
    @test isapprox(pt1, pt2, atol=0.2)
    @test isapprox(pt1, pt2, rtol=0.1)
    @test readgeom("LINESTRING (130 240, 650 240)") != readgeom("LINESTRING (130 240, -650 240)")
    @test !(readgeom("LINESTRING (130 240, 650 240)") ≈ readgeom("LINESTRING (130 240, -650 240)"))
    @test readgeom("LINESTRING (130 240, 650 240)") ≈ readgeom("LINESTRING (130 240, -650 240)") atol=1300
    @test readgeom("LINESTRING (130 240, 650 240)") ≈ readgeom("LINESTRING (130 240, 650 240.00000001)")

    @test isapprox(readgeom("POLYGON((1 1,0 0,            1 2,2 2,2 4,1 1))"),
                   readgeom("POLYGON((1 1,0 0.00000000001,1 2,2 2,2 4,1 1))"))

    pt = readgeom("POINT(-1 NaN)")
    @test isequal(pt, pt)
    @test pt != pt
    @test !(isapprox(pt, pt))
    @test !(isapprox(pt, pt, atol=Inf))

    pt = readgeom("POINT(0 NaN)")
    @test isequal(pt, pt)
    @test pt != pt
    @test !(isapprox(pt, pt))
    @test !(isapprox(pt, pt, atol=Inf))

    geo = readgeom("POLYGON((1 1,1 2,2 2,2 NaN,1 1))")
    @test isequal(geo,geo)
    @test geo != geo
    @test !(isapprox(geo, geo))
    @test !(isapprox(geo, geo, atol=Inf))

    geos = [
        readgeom("POINT(0.12345 2.000 0.1)"),
        readgeom("POINT(0.12345 2.000)"),
        readgeom("POINT(0.12345 2.000 0.2)"),
        readgeom("POLYGON EMPTY"),
        readgeom("LINESTRING EMPTY"),
        readgeom("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))"),
        readgeom("POLYGON((1 1,1 2,2 2,2 1,1 1))"),
        readgeom("POLYGON((1 1,1 2,2 2,2.1 1,1 1))"),
        readgeom("LINESTRING (130 240, 650 240)"),
        readgeom("MULTILINESTRING ((5 0, 10 0), (0 0, 5 0))"),
        readgeom("GEOMETRYCOLLECTION (LINESTRING (1 2, 2 2), LINESTRING (2 1, 1 1), POLYGON ((0.5 1, 1 2, 1 1, 0.5 1)), POLYGON ((9 2, 9.5 1, 2 1, 2 2, 9 2)))"),
        readgeom("MULTIPOINT(0 0, 5 0, 10 0)"),
    ]
    for g1 in geos
        for g2 in geos
            if g1 === g2
                @test g1 == g2
                @test isequal(g1,g2)
                @test hash(g1) == hash(g2)
                @test isapprox(g1,g2)
            else
                @test g1 != g2
                @test !isequal(g1,g2)
                @test !isapprox(g1,g2)
                @test hash(g1) != hash(g2)
            end
        end
    end
    for g in geos
        @test g == LibGEOS.clone(g)
        @test g ≈ LibGEOS.clone(g)
        @test isequal(g, LibGEOS.clone(g))
        @test hash(g) == hash(LibGEOS.clone(g))
    end
end

@testset "performance hash eq" begin
    rng = MersenneTwister(123)
    pts1 = [randn(rng, 3) for _ in 1:10^3]
    pts1[end] = pts1[begin]
    lr1 = LinearRing(pts1)
    pts2 = copy(pts1)
    pts2[453] = randn(rng, 3)
    lr2 = LinearRing(pts2)
    @test !(lr1 == lr2)
    @test !isequal(lr1, lr2)
    @test !isapprox(lr1, lr2)
    
    @test 300 > @allocated lr1 == lr2
    @test 300 > @allocated isequal(lr1, lr2)
    @test 300 > @allocated isapprox(lr1, lr2)

    hash(lr1) != hash(lr2)
    @test 300 > @allocated hash(lr1)

    poly1 = Polygon(lr1)
    poly2 = Polygon(lr2)

    poly2 = LinearRing(pts2)
    @test !(poly1 == poly2)
    @test !isequal(poly1, poly2)
    @test !isapprox(poly1, poly2)
    
    @test 300 > @allocated poly1 == poly2
    @test 300 > @allocated isequal(poly1, poly2)
    @test 300 > @allocated isapprox(poly1, poly2)

    @test hash(poly1) != hash(poly2)
    @test 300 > @allocated hash(poly1)
end

@testset "show it like you build it" begin
    for geo in [
        readgeom("POINT(0 0)")
        readgeom("MULTIPOINT(0 0, 5 0, 10 0)")
        readgeom("LINESTRING (130 240, 650 240)")
        readgeom("POLYGON EMPTY")
        readgeom("POLYGON ((10 10, 20 40, 90 90, 90 10, 10 10))")
        readgeom("MULTILINESTRING ((5 0, 10 0), (0 0, 5 0))")
        readgeom("GEOMETRYCOLLECTION (LINESTRING (1 2, 2 2), LINESTRING (2 1, 1 1), POLYGON ((0.5 1, 1 2, 1 1, 0.5 1)), POLYGON ((9 2, 9.5 1, 2 1, 2 2, 9 2)))")
        ]
        geo2 = readgeom(sprint(show, geo))
        @test LibGEOS.equals(geo, geo2)
    end
    p = Polygon([[[0.0, 0.0] for _ in 1:10000]])
    buf = IOBuffer()
    print(IOContext(buf, :compact=>true), p)
    seekstart(buf)
    s = read(buf, String)
    @test length(s) < 30
    @test occursin("Polygon(...)", s)
end
