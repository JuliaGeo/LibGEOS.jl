@testset "GEOS types" begin
    @testset "Polygon" begin
        # Test polygon made from vectors
        poly_vec = LibGEOS.Polygon([
            [[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0], [-2.0,2.0], [-2.0, -2.0]],
            [[0.0, 0.0], [1.0, 1.0], [1.0,0.0], [0.0, 0.0]]])
        @test LibGEOS.isValid(poly_vec)
        @test LibGEOS.area(poly_vec) == 15.5
        @test LibGEOS.isEmpty(poly_vec) == false
        @test LibGEOS.geomTypeId(poly_vec.ptr) == 3
        @test LibGEOS.getGeomDimensions(poly_vec.ptr) == 2
        @test LibGEOS.GeoInterface.coordinates(poly_vec) == 
            [[[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0], [-2.0,2.0], [-2.0, -2.0]],
             [[0.0, 0.0], [1.0, 1.0], [1.0,0.0], [0.0, 0.0]]]
        @test length(LibGEOS.interiorRings(poly_vec)) == 1

        # Test polygon made from pointer
        poly_ptr = LibGEOS.Polygon(poly_vec.ptr)
    

        # Test polygon made from 1 linear ring
        #ring_ext = LibGEOS.LinearRing([[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0],
        #                           [-2.0,2.0], [-2.0, -2.0]])
        #poly2 = LibGEOS.Polygon(ring_ext)
        #@test LibGEOS.isValid(poly2)
        #@test LibGEOS.area(poly2) == 16
        #@test LibGEOS.isEmpty(poly2) == false
        #@test LibGEOS.geomTypeId(poly2.ptr) == 3
        #@test LibGEOS.getGeomDimensions(poly2.ptr) == 2
        #@test LibGEOS.GeoInterface.coordinates(poly2) == 
        #    [[[-2.0, -2.0], [2.0, -2.0], [2.0, 2.0], [-2.0,2.0], [-2.0, -2.0]]]
        #@test length(LibGEOS.interiorRings(poly2)) == 0

        # Test polygon made from multiple linear rings (exterior and interior)
    end

end