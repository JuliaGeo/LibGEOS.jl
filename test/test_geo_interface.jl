facts("Geo interface") do
    pt = LibGEOS.Point(1.0,2.0)
    @fact GeoInterface.coordinates(pt) --> roughly([1,2], 1e-5)
    @fact GeoInterface.geotype(pt) --> :Point

    pt = LibGEOS.Point(1, 2)
    @fact GeoInterface.coordinates(pt) --> roughly([1,2], 1e-5)
    @fact GeoInterface.geotype(pt) --> :Point


    pt = LibGEOS.Point(LibGEOS.geomFromWKT("POINT EMPTY"))
    @fact GeoInterface.coordinates(pt) --> roughly(Float64[], 1e-5)
    @fact GeoInterface.geotype(pt) --> :Point

    mpt = LibGEOS.MultiPoint(LibGEOS.geomFromWKT("MULTIPOINT(0 0, 10 0, 10 10, 11 10)"))
    factcheck_equals(GeoInterface.coordinates(mpt), Vector{Float64}[[0,0],[10,0],[10,10],[11,10]])
    @fact GeoInterface.geotype(mpt) --> :MultiPoint

    coords = Vector{Float64}[[8,1],[9,1],[9,2],[8,2]]
    ls = LibGEOS.LineString(coords)
    factcheck_equals(GeoInterface.coordinates(ls), coords)
    @fact GeoInterface.geotype(ls) --> :LineString

    ls = LibGEOS.LineString(LibGEOS.geomFromWKT("LINESTRING EMPTY"))
    factcheck_equals(GeoInterface.coordinates(ls), Vector{Float64}[[]])
    @fact GeoInterface.geotype(ls) --> :LineString

    mls = LibGEOS.MultiLineString(LibGEOS.geomFromWKT("MULTILINESTRING ((5 0, 10 0), (0 0, 5 0))"))
    factcheck_equals(GeoInterface.coordinates(mls), Vector{Vector{Float64}}[Vector{Float64}[[5,0],[0,0],[5,0]]])
    @fact GeoInterface.geotype(mls) --> :MultiLineString

    coords = Vector{Float64}[[8,1],[9,1],[9,2],[8,2],[8,1]]
    lr = LibGEOS.LinearRing(coords)
    factcheck_equals(GeoInterface.coordinates(lr), coords)
    @fact GeoInterface.geotype(lr) --> :LineString

    coords = Vector{Vector{Float64}}[Vector{Float64}[[0,0],[10,0],[10,10],[0,10],[0,0]],
                                     Vector{Float64}[[1,8],[2,8],[2,9],[1,9],[1,8]],
                                     Vector{Float64}[[8,1],[9,1],[9,2],[8,2],[8,1]]]
    polygon = LibGEOS.Polygon(coords)
    factcheck_equals(GeoInterface.coordinates(polygon), coords)
    @fact GeoInterface.geotype(polygon) --> :Polygon

    polygon = LibGEOS.Polygon(LibGEOS.geomFromWKT("POLYGON EMPTY"))
    factcheck_equals(GeoInterface.coordinates(polygon), Vector{Vector{Float64}}[[]])
    @fact GeoInterface.geotype(polygon) --> :Polygon

    multipolygon = LibGEOS.MultiPolygon(LibGEOS.geomFromWKT("MULTIPOLYGON(((0 0,0 10,10 10,10 0,0 0)))"))
    factcheck_equals(GeoInterface.coordinates(multipolygon), Vector{Vector{Vector{Float64}}}[Vector{Vector{Float64}}[Vector{Float64}[[0,0],[0,10],[10,10],[10,0],[0,0]]]])
    @fact GeoInterface.geotype(multipolygon) --> :MultiPolygon

    geomcollection = LibGEOS.GeometryCollection(LibGEOS.geomFromWKT("GEOMETRYCOLLECTION (POLYGON ((8 2, 10 10, 8.5 1, 8 2)), POLYGON ((7 8, 10 10, 8 2, 7 8)), POLYGON ((3 8, 10 10, 7 8, 3 8)), POLYGON ((2 2, 8 2, 8.5 1, 2 2)), POLYGON ((2 2, 7 8, 8 2, 2 2)), POLYGON ((2 2, 3 8, 7 8, 2 2)), POLYGON ((0.5 9, 10 10, 3 8, 0.5 9)), POLYGON ((0.5 9, 3 8, 2 2, 0.5 9)), POLYGON ((0 0, 2 2, 8.5 1, 0 0)), POLYGON ((0 0, 0.5 9, 2 2, 0 0)))"))
    collection = GeoInterface.geometries(geomcollection)
    coords = Vector{Vector{Vector{Float64}}}[Vector{Vector{Float64}}[Vector{Float64}[[8.0,2.0],[10.0,10.0],[8.5,1.0],[8.0,2.0]]],
                                             Vector{Vector{Float64}}[Vector{Float64}[[7.0,8.0],[10.0,10.0],[8.0,2.0],[7.0,8.0]]],
                                             Vector{Vector{Float64}}[Vector{Float64}[[3.0,8.0],[10.0,10.0],[7.0,8.0],[3.0,8.0]]],
                                             Vector{Vector{Float64}}[Vector{Float64}[[2.0,2.0],[ 8.0, 2.0],[8.5,1.0],[2.0,2.0]]],
                                             Vector{Vector{Float64}}[Vector{Float64}[[2.0,2.0],[ 7.0, 8.0],[8.0,2.0],[2.0,2.0]]],
                                             Vector{Vector{Float64}}[Vector{Float64}[[2.0,2.0],[ 3.0, 8.0],[7.0,8.0],[2.0,2.0]]],
                                             Vector{Vector{Float64}}[Vector{Float64}[[0.5,9.0],[10.0,10.0],[3.0,8.0],[0.5,9.0]]],
                                             Vector{Vector{Float64}}[Vector{Float64}[[0.5,9.0],[ 3.0, 8.0],[2.0,2.0],[0.5,9.0]]],
                                             Vector{Vector{Float64}}[Vector{Float64}[[0.0,0.0],[ 2.0, 2.0],[8.5,1.0],[0.0,0.0]]],
                                             Vector{Vector{Float64}}[Vector{Float64}[[0.0,0.0],[ 0.5, 9.0],[2.0,2.0],[0.0,0.0]]]]
    factcheck_equals(map(GeoInterface.coordinates,collection),coords)
    @fact GeoInterface.geotype(geomcollection) --> :GeometryCollection

    geomcollection = LibGEOS.GeometryCollection(LibGEOS.geomFromWKT("GEOMETRYCOLLECTION(MULTIPOINT(0 0, 0 0, 1 1),LINESTRING(1 1, 2 2, 2 2, 0 0),POLYGON((5 5, 0 0, 0 2, 2 2, 5 5)))"))
    collection = GeoInterface.geometries(geomcollection)
    coords = Vector[Vector{Float64}[[0.0,0.0],[0.0,0.0],[1.0,1.0]],
                    Vector{Float64}[[1.0,1.0],[2.0,2.0],[2.0,2.0],[0.0,0.0]],
                    Vector{Vector{Float64}}[Vector{Float64}[[5.0,5.0],[0.0,0.0],[0.0,2.0],[2.0,2.0],[5.0,5.0]]]]
    geotypes = [:MultiPoint,:LineString,:Polygon]
    for (i,item) in enumerate(collection)
        factcheck_equals(GeoInterface.coordinates(item), coords[i])
        @fact GeoInterface.geotype(item) --> geotypes[i]
    end
    @fact GeoInterface.geotype(geomcollection) --> :GeometryCollection

    geomcollection = LibGEOS.GeometryCollection(LibGEOS.geomFromWKT("GEOMETRYCOLLECTION EMPTY"))
    collection = GeoInterface.geometries(geomcollection)
    @fact length(collection) --> 0
    @fact GeoInterface.geotype(geomcollection) --> :GeometryCollection
end
