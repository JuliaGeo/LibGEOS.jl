function testValidTypeDims(geom::LibGEOS.Geometry, typeid::LibGEOS.GEOSGeomTypes, dims::Integer)
    @test LibGEOS.isValid(geom)
    @test LibGEOS.geomTypeId(geom.ptr) == typeid
    @test LibGEOS.getGeomDimensions(geom.ptr) == dims
end
testValidTypeDims(point::LibGEOS.Point) = 
    testValidTypeDims(point, LibGEOS.GEOS_POINT, 0)
testValidTypeDims(multipoint::LibGEOS.MultiPoint) =
    testValidTypeDims(multipoint, LibGEOS.GEOS_MULTIPOINT, 0)
testValidTypeDims(ring::LibGEOS.LinearRing) =
    testValidTypeDims(ring, LibGEOS.GEOS_LINEARRING, 1)
testValidTypeDims(poly::LibGEOS.Polygon) = 
    testValidTypeDims(poly, LibGEOS.GEOS_POLYGON, 2)

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
        point_vec = LibGEOS.Point([0.0, 0.0, 0.2])
        testValidTypeDims(point_vec, LibGEOS.GEOS_POINT, 0)
        @test LibGEOS.equals(point_vec, point3D)

        # Test point made from point pointer
        point_ptr = LibGEOS.Point(point2D.ptr)
        testValidTypeDims(point_ptr)
        @test LibGEOS.equals(point_ptr, point2D)

        # Test point made from polygon pointer --> should not work
        @test_throws ErrorException LibGEOS.Point(LibGEOS.Polygon(
            [[[-2.0, -2.0], [2.0, 2.0],[-2.0,2.0], [-2.0, -2.0]]]).ptr)

        LibGEOS.destroyGeom(point2D)
        LibGEOS.destroyGeom(point3D)
        LibGEOS.destroyGeom(point_vec)
        LibGEOS.destroyGeom(point_ptr)
    end

    @testset "MultiPoint" begin
        # Test MultiPoint made from vector of coordinates
        coord_vec = LibGEOS.MultiPoint([[0.0, 0.0], [1.0, 1.0]])
        point1 = Point(0.0, 0.0)
        point2 = Point(1.0, 1.0)
        testValidTypeDims(coord_vec)
        @test GeoInterface.coordinates(coord_vec) == [[0.0, 0.0], [1.0, 1.0]]
        @test LibGEOS.numGeometries(coord_vec) == 2
        @test LibGEOS.equals(LibGEOS.getGeometry(coord_vec, 1), 
                             point1)
        @test LibGEOS.equals(LibGEOS.getGeometry(coord_vec, 2),
                            point2)

        # Test MultiPoint made from MultiPoint pointer
        multipoint_ptr = LibGEOS.MultiPoint(coord_vec.ptr)
        testValidTypeDims(multipoint_ptr)
        @test LibGEOS.equals(multipoint_ptr, coord_vec)
        @test LibGEOS.equals(LibGEOS.getGeometry(coord_vec, 1), 
                             LibGEOS.getGeometry(multipoint_ptr, 1))
        @test LibGEOS.equals(LibGEOS.getGeometry(coord_vec, 2), 
                             LibGEOS.getGeometry(multipoint_ptr, 2))

        # Test MultiPoint made from Point pointer
        point_ptr = LibGEOS.MultiPoint(LibGEOS.getGeometry(coord_vec, 1).ptr)
        testValidTypeDims(point_ptr)
        @test LibGEOS.equals(LibGEOS.getGeometry(point_ptr, 1), 
                             Point(0.0, 0.0))

        # Test MultiPoint made from Polygon pointer
        @test_throws ErrorException LibGEOS.MultiPoint(LibGEOS.Polygon(
            [[[-2.0, -2.0], [2.0, 2.0],[-2.0,2.0], [-2.0, -2.0]]]).ptr)

        # Test MultiPoint made from vector of 1 point and 2 points
        point_vec1 = LibGEOS.MultiPoint([point1])
        point_vec2 = LibGEOS.MultiPoint([point1, point2])
        testValidTypeDims(point_vec1)
        testValidTypeDims(point_vec2)
        @test LibGEOS.numGeometries(point_vec1) == 1
        @test LibGEOS.equals(point_vec2, coord_vec)

        LibGEOS.destroyGeom(coord_vec)
        LibGEOS.destroyGeom(point1)
        LibGEOS.destroyGeom(point2)
        LibGEOS.destroyGeom(multipoint_ptr)
        LibGEOS.destroyGeom(point_ptr)
        LibGEOS.destroyGeom(point_vec1)
        LibGEOS.destroyGeom(point_vec2)
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

end