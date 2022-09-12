function testValidTypeDims(geom, typeid, dims)
    @test LibGEOS.isValid(geom)
    @test LibGEOS.geomTypeId(geom.ptr) == typeid
    @test LibGEOS.getGeomDimensions(geom.ptr) == dims
end

@testset "GEOS types" begin
    @testset "Point" begin
        # Test 2D point made from real x and y
        point2D = LibGEOS.Point(0.0, 0.0)
        testValidTypeDims(point2D, LibGEOS.GEOS_POINT, 0)
        @test LibGEOS.area(point2D) == 0.0
        @test LibGEOS.GeoInterface.coordinates(point2D) == [0.0, 0.0]

        # Test 3D point made from real x, y, and z
        point3D = LibGEOS.Point(0.0, 0.0, 2.0)
        testValidTypeDims(point3D, LibGEOS.GEOS_POINT, 0)
        @test LibGEOS.area(point3D) == 0.0
        @test LibGEOS.GeoInterface.coordinates(point3D) == [0.0, 0.0, 2.0]

        # Test point made from vector 
        point_vec = LibGEOS.Point([0.0, 0.0, 0.2])
        testValidTypeDims(point_vec, LibGEOS.GEOS_POINT, 0)
        @test LibGEOS.equals(point_vec, point3D)

        # Test point made from point pointer
        point_ptr = LibGEOS.Point(point2D.ptr)
        testValidTypeDims(point_ptr, LibGEOS.GEOS_POINT, 0)
        @test LibGEOS.equals(point_ptr, point2D)

        # Test point made from polygon pointer --> should not work
        @test_throws ErrorException LibGEOS.Point(LibGEOS.Polygon(
            [[[-2.0, -2.0], [2.0, 2.0],[-2.0,2.0], [-2.0, -2.0]]]).ptr)
    end


    @testset "Polygon" begin
        # Test polygon made from vectors
        poly_vec = LibGEOS.Polygon([
            [[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0], [-2.0,2.0], [-2.0, -2.0]],
            [[0.0, 0.0], [1.0, 1.0], [1.0,0.0], [0.0, 0.0]]])
        @test LibGEOS.isValid(poly_vec)
        @test LibGEOS.area(poly_vec) == 15.5
        @test !LibGEOS.isEmpty(poly_vec)
        @test LibGEOS.geomTypeId(poly_vec.ptr) == LibGEOS.GEOS_POLYGON
        @test LibGEOS.getGeomDimensions(poly_vec.ptr) == 2
        @test LibGEOS.GeoInterface.coordinates(poly_vec) == 
            [[[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0], [-2.0,2.0], [-2.0, -2.0]],
             [[0.0, 0.0], [1.0, 1.0], [1.0,0.0], [0.0, 0.0]]]
        @test length(LibGEOS.interiorRings(poly_vec)) == 1

        # Test polygon made from  polygon pointer
        poly_ptr = LibGEOS.Polygon(poly_vec.ptr)
        @test LibGEOS.isValid(poly_ptr)
        @test LibGEOS.equals(poly_vec, poly_ptr) # same area and coordinates
        @test LibGEOS.geomTypeId(poly_vec.ptr) == LibGEOS.GEOS_POLYGON
        @test LibGEOS.getGeomDimensions(poly_vec.ptr) == 2
        @test length(LibGEOS.interiorRings(poly_vec)) == 1

        # Test polygon made from linear ring pointer
        ring_ext = LibGEOS.LinearRing([[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0],
                                       [-2.0, 2.0], [-2.0, -2.0]])
        poly_ringptr = LibGEOS.Polygon(ring_ext.ptr)
        # These change when made into polygon - compare below
        @test LibGEOS.geomTypeId(ring_ext.ptr) == LibGEOS.GEOS_LINEARRING
        @test LibGEOS.getGeomDimensions(ring_ext.ptr) == 1

        @test LibGEOS.isValid(poly_ringptr)
        @test LibGEOS.area(poly_ringptr) == 16
        @test !LibGEOS.isEmpty(poly_ringptr)
        @test LibGEOS.geomTypeId(poly_ringptr.ptr) == LibGEOS.GEOS_POLYGON
        @test LibGEOS.getGeomDimensions(poly_ringptr.ptr) == 2

        # Test polygon made from point pointer
        point = LibGEOS.Point(1.0, 2.0)
        @test_throws ErrorException LibGEOS.Polygon(point.ptr)

        # Test polygon made from 1 linear ring
        poly_ring = LibGEOS.Polygon(ring_ext)
        @test LibGEOS.isValid(poly_ring)
        @test LibGEOS.area(poly_ring) == 16
        @test !LibGEOS.isEmpty(poly_ring)
        @test LibGEOS.geomTypeId(poly_ring.ptr) == LibGEOS.GEOS_POLYGON
        @test LibGEOS.getGeomDimensions(poly_ring.ptr) == 2
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
        @test LibGEOS.isValid(poly_rings1)
        @test LibGEOS.geomTypeId(poly_rings1.ptr) == LibGEOS.GEOS_POLYGON
        @test LibGEOS.getGeomDimensions(poly_rings1.ptr) == 2
        @test length(LibGEOS.interiorRings(poly_rings1)) == 1
        @test LibGEOS.equals(poly_rings1, poly_vec)

        #2 rings
        poly_rings2 = LibGEOS.Polygon(ring_ext, [ring_int1, ring_int2])

        @test LibGEOS.isValid(poly_rings2)
        @test LibGEOS.area(poly_rings2) == 14.5
        @test !LibGEOS.isEmpty(poly_rings2)
        @test LibGEOS.geomTypeId(poly_rings2.ptr) == LibGEOS.GEOS_POLYGON
        @test LibGEOS.getGeomDimensions(poly_rings2.ptr) == 2
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