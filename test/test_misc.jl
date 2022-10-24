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
