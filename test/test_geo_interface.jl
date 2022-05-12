@testset "Geo interface" begin
    pt = LibGEOS.Point(1.0, 2.0)
    @test GeoInterface.coordinates(pt) ≈ [1, 2] atol = 1e-5
    @test GeoInterface.geotype(pt) == :Point

    pt = LibGEOS.Point(1, 2)
    @test GeoInterface.coordinates(pt) ≈ [1, 2] atol = 1e-5
    @test GeoInterface.geotype(pt) == :Point


    pt = LibGEOS.readgeom("POINT EMPTY")
    @test GeoInterface.coordinates(pt) ≈ Float64[] atol = 1e-5
    @test GeoInterface.geotype(pt) == :Point

    mpt = LibGEOS.readgeom("MULTIPOINT(0 0, 10 0, 10 10, 11 10)")
    @test GeoInterface.coordinates(mpt) ==
          Vector{Float64}[[0, 0], [10, 0], [10, 10], [11, 10]]
    @test GeoInterface.geotype(mpt) == :MultiPoint

    coords = Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2]]
    ls = LibGEOS.LineString(coords)
    @test GeoInterface.coordinates(ls) == coords
    @test GeoInterface.geotype(ls) == :LineString

    ls = LibGEOS.readgeom("LINESTRING EMPTY")
    @test GeoInterface.coordinates(ls) == []
    @test GeoInterface.geotype(ls) == :LineString

    mls = LibGEOS.readgeom("MULTILINESTRING ((5 0, 10 0), (0 0, 5 0))")
    @test GeoInterface.coordinates(mls) == [[[5, 0], [10, 0]], [[0, 0], [5, 0]]]
    @test GeoInterface.geotype(mls) == :MultiLineString

    coords = Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2], [8, 1]]
    lr = LibGEOS.LinearRing(coords)
    @test GeoInterface.coordinates(lr) == coords
    @test GeoInterface.geotype(lr) == :LineString

    coords = Vector{Vector{Float64}}[
        Vector{Float64}[[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]],
        Vector{Float64}[[1, 8], [2, 8], [2, 9], [1, 9], [1, 8]],
        Vector{Float64}[[8, 1], [9, 1], [9, 2], [8, 2], [8, 1]],
    ]
    polygon = LibGEOS.Polygon(coords)
    @test GeoInterface.coordinates(polygon) == coords
    @test GeoInterface.geotype(polygon) == :Polygon

    polygon = LibGEOS.readgeom("POLYGON EMPTY")
    @test GeoInterface.coordinates(polygon) == [[]]
    @test GeoInterface.geotype(polygon) == :Polygon

    multipolygon = LibGEOS.readgeom("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))")
    @test GeoInterface.coordinates(multipolygon) ==
          Vector{Vector{Vector{Float64}}}[Vector{Vector{Float64}}[Vector{Float64}[
        [0, 0],
        [0, 10],
        [10, 10],
        [10, 0],
        [0, 0],
    ]]]
    @test GeoInterface.geotype(multipolygon) == :MultiPolygon

    geomcollection = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION (POLYGON ((8 2, 10 10, 8.5 1, 8 2)), POLYGON ((7 8, 10 10, 8 2, 7 8)), POLYGON ((3 8, 10 10, 7 8, 3 8)), POLYGON ((2 2, 8 2, 8.5 1, 2 2)), POLYGON ((2 2, 7 8, 8 2, 2 2)), POLYGON ((2 2, 3 8, 7 8, 2 2)), POLYGON ((0.5 9, 10 10, 3 8, 0.5 9)), POLYGON ((0.5 9, 3 8, 2 2, 0.5 9)), POLYGON ((0 0, 2 2, 8.5 1, 0 0)), POLYGON ((0 0, 0.5 9, 2 2, 0 0)))",
    )
    collection = GeoInterface.geometries(geomcollection)
    coords = Vector{Vector{Vector{Float64}}}[
        Vector{Vector{Float64}}[Vector{Float64}[
            [8.0, 2.0],
            [10.0, 10.0],
            [8.5, 1.0],
            [8.0, 2.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [7.0, 8.0],
            [10.0, 10.0],
            [8.0, 2.0],
            [7.0, 8.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [3.0, 8.0],
            [10.0, 10.0],
            [7.0, 8.0],
            [3.0, 8.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [2.0, 2.0],
            [8.0, 2.0],
            [8.5, 1.0],
            [2.0, 2.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [2.0, 2.0],
            [7.0, 8.0],
            [8.0, 2.0],
            [2.0, 2.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [2.0, 2.0],
            [3.0, 8.0],
            [7.0, 8.0],
            [2.0, 2.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [0.5, 9.0],
            [10.0, 10.0],
            [3.0, 8.0],
            [0.5, 9.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [0.5, 9.0],
            [3.0, 8.0],
            [2.0, 2.0],
            [0.5, 9.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [0.0, 0.0],
            [2.0, 2.0],
            [8.5, 1.0],
            [0.0, 0.0],
        ]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [0.0, 0.0],
            [0.5, 9.0],
            [2.0, 2.0],
            [0.0, 0.0],
        ]],
    ]
    @test map(GeoInterface.coordinates, collection) == coords
    @test GeoInterface.geotype(geomcollection) == :GeometryCollection

    geomcollection = LibGEOS.readgeom(
        "GEOMETRYCOLLECTION(MULTIPOINT(0 0, 0 0, 1 1),LINESTRING(1 1, 2 2, 2 2, 0 0),POLYGON((5 5, 0 0, 0 2, 2 2, 5 5)))",
    )
    collection = GeoInterface.geometries(geomcollection)
    coords = Vector[
        Vector{Float64}[[0.0, 0.0], [0.0, 0.0], [1.0, 1.0]],
        Vector{Float64}[[1.0, 1.0], [2.0, 2.0], [2.0, 2.0], [0.0, 0.0]],
        Vector{Vector{Float64}}[Vector{Float64}[
            [5.0, 5.0],
            [0.0, 0.0],
            [0.0, 2.0],
            [2.0, 2.0],
            [5.0, 5.0],
        ]],
    ]
    geotypes = [:MultiPoint, :LineString, :Polygon]
    for (i, item) in enumerate(collection)
        @test GeoInterface.coordinates(item) == coords[i]
        @test GeoInterface.geotype(item) == geotypes[i]
    end
    @test GeoInterface.geotype(geomcollection) == :GeometryCollection

    geomcollection = LibGEOS.readgeom("GEOMETRYCOLLECTION EMPTY")
    collection = GeoInterface.geometries(geomcollection)
    @test length(collection) == 0
    @test GeoInterface.geotype(geomcollection) == :GeometryCollection
end
