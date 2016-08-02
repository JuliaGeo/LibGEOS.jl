import GeoInterface
using FactCheck, LibGEOS

function factcheck_equals(obj1::Vector{Vector{Float64}},
                          obj2::Vector{Vector{Float64}}; tol=1e-5)
    for (i,item) in enumerate(obj2)
        @fact obj1[i] --> roughly(item, tol)
    end
end

function factcheck_equals(obj1::Vector{Vector{Vector{Float64}}},
                          obj2::Vector{Vector{Vector{Float64}}}; tol=1e-5)
    for (i,item) in enumerate(obj2)
        factcheck_equals(obj1[i], item, tol=tol)
    end
end

function factcheck_equals(obj1::Vector{Vector{Vector{Vector{Float64}}}},
                          obj2::Vector{Vector{Vector{Vector{Float64}}}}; tol=1e-5)
    for (i,item) in enumerate(obj2)
        factcheck_equals(obj1[i], item, tol=tol)
    end
end

include("test_geos_functions.jl")
include("test_geos_operations.jl")
include("test_geo_interface.jl")
