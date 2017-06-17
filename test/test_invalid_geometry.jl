facts("LibGEOS invalid geometry") do
    # LibGEOS shouldn't crash but error out
    # on invalid geometry

    # Self intersecting polygon
    polygon = LibGEOS.geomFromWKT("POLYGON((0 0, 10 10, 0 10, 10 0, 0 0))")
    @fact LibGEOS.isValid(polygon) --> false

    # Hole outside of base
    polygon = LibGEOS.geomFromWKT("POLYGON((0 0, 10 0, 10 10, 0 10, 0 0), (15 15, 15 20, 20 20, 20 15, 15 15))")
    @fact LibGEOS.isValid(polygon) --> false

end
