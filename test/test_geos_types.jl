
# Function to test if a geomerty is valid and if its type matches the geometry ID and has the correct dimensions
function testValidTypeDims(geom::LibGEOS.Geometry, typeid::LibGEOS.GEOSGeomTypes, dims::Integer)
    @test LibGEOS.isValid(geom)
    @test LibGEOS.geomTypeId(geom.ptr) == typeid
    @test LibGEOS.getGeomDimensions(geom.ptr) == dims
end
testValidTypeDims(point::LibGEOS.Point) = 
    testValidTypeDims(point, LibGEOS.GEOS_POINT, 0)
testValidTypeDims(multipoint::LibGEOS.MultiPoint) =
    testValidTypeDims(multipoint, LibGEOS.GEOS_MULTIPOINT, 0)
testValidTypeDims(linestring::LibGEOS.LineString) =
    testValidTypeDims(linestring, LibGEOS.GEOS_LINESTRING, 1) 
testValidTypeDims(multilinestring::LibGEOS.MultiLineString) =
    testValidTypeDims(multilinestring, LibGEOS.GEOS_MULTILINESTRING, 1)
testValidTypeDims(ring::LibGEOS.LinearRing) =
    testValidTypeDims(ring, LibGEOS.GEOS_LINEARRING, 1)
testValidTypeDims(poly::LibGEOS.Polygon) = 
    testValidTypeDims(poly, LibGEOS.GEOS_POLYGON, 2)
testValidTypeDims(multipoly::LibGEOS.MultiPolygon) =
    testValidTypeDims(multipoly, LibGEOS.GEOS_MULTIPOLYGON, 2)

@testset "GEOS types" begin
    @testset "Point" begin
        # Test 2D point made from real x and y
        point2D = LibGEOS.Point(0.0, 0.0)
        testValidTypeDims(point2D)
        @test LibGEOS.area(point2D) == 0.0
        @test LibGEOS.GeoInterface.coordinates(point2D) == [0.0, 0.0]

        # Test 3D point made from real x, y, and z
        point3D = LibGEOS.Point(0.0, 0.0, 2.0)
        testValidTypeDims(point3D)
        @test LibGEOS.area(point3D) == 0.0
        @test LibGEOS.GeoInterface.coordinates(point3D) == [0.0, 0.0, 2.0]

        # Test point made from vector 
        point_coord = LibGEOS.Point([0.0, 0.0, 0.2])
        testValidTypeDims(point_coord, LibGEOS.GEOS_POINT, 0)
        @test LibGEOS.equals(point_coord, point3D)

        # Test point made from point pointer
        point_ptr = LibGEOS.Point(point2D.ptr)
        testValidTypeDims(point_ptr)
        @test LibGEOS.equals(point_ptr, point2D)

        # Test point made from polygon pointer --> should not work
        @test_throws ErrorException LibGEOS.Point(LibGEOS.Polygon(
            [[[-2.0, -2.0], [2.0, 2.0],[-2.0,2.0], [-2.0, -2.0]]]).ptr)

        LibGEOS.destroyGeom(point2D)
        LibGEOS.destroyGeom(point3D)
        LibGEOS.destroyGeom(point_coord)
        LibGEOS.destroyGeom(point_ptr)
    end

    @testset "MultiPoint" begin
        # Test MultiPoint made from vector of coordinates
        mpoint_coord = LibGEOS.MultiPoint([[0.0, 0.0], [1.0, 1.0]])
        point1 = Point(0.0, 0.0)
        point2 = Point(1.0, 1.0)
        testValidTypeDims(mpoint_coord)
        @test GeoInterface.coordinates(mpoint_coord) == [[0.0, 0.0], [1.0, 1.0]]
        @test LibGEOS.numGeometries(mpoint_coord) == 2
        @test LibGEOS.equals(LibGEOS.getGeometry(mpoint_coord, 1), 
                             point1)
        @test LibGEOS.equals(LibGEOS.getGeometry(mpoint_coord, 2),
                            point2)

        # Test MultiPoint made from MultiPoint pointer
        multipoint_ptr = LibGEOS.MultiPoint(mpoint_coord.ptr)
        testValidTypeDims(multipoint_ptr)
        @test LibGEOS.equals(multipoint_ptr, mpoint_coord)
        @test LibGEOS.equals(LibGEOS.getGeometry(mpoint_coord, 1), 
                             LibGEOS.getGeometry(multipoint_ptr, 1))
        @test LibGEOS.equals(LibGEOS.getGeometry(mpoint_coord, 2), 
                             LibGEOS.getGeometry(multipoint_ptr, 2))

        # Test MultiPoint made from Point pointer
        mpoint_ptr = LibGEOS.MultiPoint(
                             LibGEOS.getGeometry(mpoint_coord, 1).ptr)
        testValidTypeDims(mpoint_ptr)
        @test LibGEOS.equals(LibGEOS.getGeometry(mpoint_ptr, 1), 
                             Point(0.0, 0.0))

        # Test MultiPoint made from Polygon pointer
        @test_throws ErrorException LibGEOS.MultiPoint(LibGEOS.Polygon(
            [[[-2.0, -2.0], [2.0, 2.0],[-2.0,2.0], [-2.0, -2.0]]]).ptr)

        # Test MultiPoint made from vector of 1 point and 2 points
        point_coord1 = LibGEOS.MultiPoint([point1])
        point_coord2 = LibGEOS.MultiPoint([point1, point2])
        testValidTypeDims(point_coord1)
        testValidTypeDims(point_coord2)
        @test LibGEOS.numGeometries(point_coord1) == 1
        @test LibGEOS.equals(point_coord2, mpoint_coord)

        LibGEOS.destroyGeom(mpoint_coord)
        LibGEOS.destroyGeom(point1)
        LibGEOS.destroyGeom(point2)
        LibGEOS.destroyGeom(multipoint_ptr)
        LibGEOS.destroyGeom(mpoint_ptr)
        LibGEOS.destroyGeom(point_coord1)
        LibGEOS.destroyGeom(point_coord2)
    end

    @testset "LineString" begin
        # Test LineString made from vectors
        ls_coord = LibGEOS.LineString([[0.0, 0.0], [1.0, 1.0], [1.0,0.0]])
        testValidTypeDims(ls_coord)
        @test LibGEOS.numCoordinates(ls_coord.ptr) == 3
        
        # Test LineString made from linestring pointer
        ls_ptr = LibGEOS.LineString(ls_coord.ptr)
        testValidTypeDims(ls_ptr)
        @test LibGEOS.equals(ls_coord, ls_ptr)

        # Test LineString made from polygon pointer
        @test_throws ErrorException LibGEOS.LineString(LibGEOS.Polygon(
            [[[-2.0, -2.0], [2.0, 2.0],[-2.0,2.0], [-2.0, -2.0]]]).ptr)

        LibGEOS.destroyGeom(ls_coord)
        LibGEOS.destroyGeom(ls_ptr)
    end

    @testset "MultiLineString" begin
        # Test MultiLineString made from vectors
        mls_coord = LibGEOS.MultiLineString([[[0.0, 0.0], [1.0, 1.0], [1.0,0.0]], [[-2.0, -2.0], [2.0, 2.0],[-2.0,2.0]]])
        testValidTypeDims(mls_coord)
        @test LibGEOS.numGeometries(mls_coord) == 2

        # Test MultiLineString made from MultiLineString pointer
        mls_ptr = LibGEOS.MultiLineString(mls_coord.ptr)
        testValidTypeDims(mls_ptr)
        @test LibGEOS.equals(mls_coord, mls_ptr)

        # Test MultiLineString made from polygon pointer
        @test_throws ErrorException LibGEOS.MultiLineString(LibGEOS.Polygon(
            [[[-2.0, -2.0], [2.0, 2.0],[-2.0,2.0], [-2.0, -2.0]]]).ptr)

        LibGEOS.destroyGeom(mls_coord)
        LibGEOS.destroyGeom(mls_ptr)
    end

    @testset "LinearRing" begin
        # Test LinearRing made from vectors
        lr_coord = LibGEOS.LinearRing([[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0],
        [-2.0, 2.0], [-2.0, -2.0]])
        testValidTypeDims(lr_coord)
        @test LibGEOS.numCoordinates(lr_coord.ptr) == 5

        # Test LinearRing made from LinearRing pointer
        lr_ptr = LibGEOS.LinearRing(lr_coord.ptr)
        testValidTypeDims(lr_ptr)
        @test LibGEOS.equals(lr_ptr, lr_coord)

        # Test LinearRing made from polygon pointer
        @test_throws ErrorException LibGEOS.LinearRing(LibGEOS.Polygon(
            [[[-2.0, -2.0], [2.0, 2.0],[-2.0,2.0], [-2.0, -2.0]]]).ptr)

        LibGEOS.destroyGeom(lr_coord)
        LibGEOS.destroyGeom(lr_ptr)
    end


    @testset "Polygon" begin
        # Test polygon made from vectors
        poly_vec = LibGEOS.Polygon([
            [[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0], [-2.0,2.0], [-2.0, -2.0]],
            [[0.0, 0.0], [1.0, 1.0], [1.0,0.0], [0.0, 0.0]]])
        testValidTypeDims(poly_vec)
        @test LibGEOS.area(poly_vec) == 15.5
        @test !LibGEOS.isEmpty(poly_vec)
        @test LibGEOS.GeoInterface.coordinates(poly_vec) == 
            [[[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0], [-2.0,2.0], [-2.0, -2.0]],
             [[0.0, 0.0], [1.0, 1.0], [1.0,0.0], [0.0, 0.0]]]
        @test length(LibGEOS.interiorRings(poly_vec)) == 1

        # Test polygon made from  polygon pointer
        poly_ptr = LibGEOS.Polygon(poly_vec.ptr)
        testValidTypeDims(poly_ptr)
        @test LibGEOS.equals(poly_vec, poly_ptr) # same area and coordinates
        @test length(LibGEOS.interiorRings(poly_vec)) == 1

        # Test polygon made from linear ring pointer
        ring_ext = LibGEOS.LinearRing([[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0],
                                       [-2.0, 2.0], [-2.0, -2.0]])
        poly_ringptr = LibGEOS.Polygon(ring_ext.ptr)

        # tests that ring's geomTypeID is linear ring and dimensions is 1
        testValidTypeDims(ring_ext) 

        # tests that the geomTypeID is polygon and dimensions is 2
        testValidTypeDims(poly_ringptr) 
        @test LibGEOS.area(poly_ringptr) == 16
        @test !LibGEOS.isEmpty(poly_ringptr)

        # Test polygon made from point pointer
        point = LibGEOS.Point(1.0, 2.0)
        @test_throws ErrorException LibGEOS.Polygon(point.ptr)

        # Test polygon made from 1 linear ring
        poly_ring = LibGEOS.Polygon(ring_ext)
        testValidTypeDims(poly_ring)
        @test LibGEOS.area(poly_ring) == 16
        @test !LibGEOS.isEmpty(poly_ring)
        @test LibGEOS.GeoInterface.coordinates(poly_ring) == 
            [[[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0], [-2.0, 2.0], [-2.0, -2.0]]]
        @test length(LibGEOS.interiorRings(poly_ring)) == 0

        # Test polygon made from multiple linear rings (exterior and interior)
        ring_int1 = LibGEOS.LinearRing([[0.0, 0.0], [1.0, 1.0], [1.0,0.0],
                                        [0.0, 0.0]])
        ring_int2 = LibGEOS.LinearRing([[0.0, 0.0], [0.0, -1.0], [-1.0, -1.0],
                                        [-1.0, 0.0], [0.0, 0.0]])

        #1 ring
        poly_rings1 = LibGEOS.Polygon(ring_ext, [ring_int1])
        testValidTypeDims(poly_rings1)
        @test length(LibGEOS.interiorRings(poly_rings1)) == 1
        @test LibGEOS.equals(poly_rings1, poly_vec)

        #2 rings
        poly_rings2 = LibGEOS.Polygon(ring_ext, [ring_int1, ring_int2])
        testValidTypeDims(poly_rings2)
        @test LibGEOS.area(poly_rings2) == 14.5
        @test !LibGEOS.isEmpty(poly_rings2)
        @test LibGEOS.GeoInterface.coordinates(poly_rings2) == 
            [[[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0], [-2.0, 2.0], [-2.0, -2.0]],
            [[0.0, 0.0], [1.0, 1.0], [1.0,0.0],[0.0, 0.0]],
             [[0.0, 0.0], [0.0, -1.0], [-1.0, -1.0],[-1.0, 0.0], [0.0, 0.0]]]
        @test length(LibGEOS.interiorRings(poly_rings2)) == 2

        LibGEOS.destroyGeom(poly_vec)
        LibGEOS.destroyGeom(poly_ptr)
        LibGEOS.destroyGeom(ring_ext)
        LibGEOS.destroyGeom(poly_ringptr)
        LibGEOS.destroyGeom(point)
        LibGEOS.destroyGeom(poly_ring)
        LibGEOS.destroyGeom(ring_int1)
        LibGEOS.destroyGeom(ring_int2)
        LibGEOS.destroyGeom(poly_rings1)
        LibGEOS.destroyGeom(poly_rings2)
    end

    @testset "MultiPolygon" begin
        poly1 = LibGEOS.Polygon([[[-2.0, -2.0], [2.0, 2.0], 
                                  [-2.0, 2.0], [-2.0, -2.0]]])
        poly2 = LibGEOS.Polygon([[[0.0, 0.0], [1.0, -1.0], 
                                  [1.0, 0.0], [0.0, 0.0]]])
        # Test multipolygon made from vectors
        mpoly_coord = LibGEOS.MultiPolygon([
            [[[-2.0, -2.0], [2.0, 2.0], [-2.0, 2.0], [-2.0, -2.0]]], 
            [[[0.0, 0.0], [1.0, -1.0], [1.0, 0.0], [0.0, 0.0]]]])
        testValidTypeDims(mpoly_coord)
        @test LibGEOS.numGeometries(mpoly_coord) == 2
        @test LibGEOS.equals(LibGEOS.getGeometry(mpoly_coord, 1), poly1)

        # Test multipolygon made from multipolygon pointer
        mpoly_ptr = LibGEOS.MultiPolygon(mpoly_coord.ptr)
        testValidTypeDims(mpoly_coord)
        @test LibGEOS.equals(mpoly_ptr, mpoly_coord)

        # Test multipolygon made from polygon pointer
        mpoly_poly_ptr = LibGEOS.MultiPolygon(poly1.ptr)
        testValidTypeDims(mpoly_poly_ptr)
        @test LibGEOS.equals(LibGEOS.getGeometry(mpoly_poly_ptr, 1), poly1) 

        # Test multipolygon made from point pointer --> should finalizer
        @test_throws ErrorException LibGEOS.MultiPolygon(LibGEOS.Point(1.0, 2.0).ptr)

        # Test multipolygon made from list of polygons
        mpoly_polylist = LibGEOS.MultiPolygon([poly1, poly2])
        testValidTypeDims(mpoly_polylist)
        @test LibGEOS.equals(mpoly_polylist, mpoly_coord)

        LibGEOS.destroyGeom(poly1)
        LibGEOS.destroyGeom(poly2)
        LibGEOS.destroyGeom(mpoly_coord)
        LibGEOS.destroyGeom(mpoly_ptr)
        LibGEOS.destroyGeom(mpoly_poly_ptr)
        LibGEOS.destroyGeom(mpoly_polylist)
    end

    @testset "GeometryCollections" begin
        point = LibGEOS.Point(0.0, 0.0)
        poly = LibGEOS.Polygon([[[-2.0, -2.0], [2.0, 2.0], 
                                  [-2.0, 2.0], [-2.0, -2.0]]])
        # Test GeometryCollection from list of geometry pointers
        geomcol_ptr_list = LibGEOS.GeometryCollection([point.ptr, poly.ptr])
        @test LibGEOS.isValid(geomcol_ptr_list)
        @test LibGEOS.geomTypeId(geomcol_ptr_list.ptr) == LibGEOS.GEOS_GEOMETRYCOLLECTION
        #test GeometryCollection from GeometryCollection pointer
        geomcollection_ptr = LibGEOS.GeometryCollection(geomcol_ptr_list.ptr)
        @test LibGEOS.isValid(geomcollection_ptr)
        @test LibGEOS.geomTypeId(geomcollection_ptr.ptr) == LibGEOS.GEOS_GEOMETRYCOLLECTION
        @test LibGEOS.equals(geomcol_ptr_list, geomcollection_ptr)

        LibGEOS.destroyGeom(point)
        LibGEOS.destroyGeom(poly)
        LibGEOS.destroyGeom(geomcol_ptr_list)
        LibGEOS.destroyGeom(geomcollection_ptr)
    end

end