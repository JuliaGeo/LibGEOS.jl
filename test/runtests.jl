using LibGEOS, FactCheck

a = LibGEOS.createCoordSeq(Vector{Float64}[[1,2,3],[4,5,6]])
b = LibGEOS.cloneCoordSeq(a)
@fact LibGEOS.getCoordinates(b) => roughly(LibGEOS.getCoordinates(a))
a = LibGEOS.createCoordSeq(Vector{Float64}[[1,2,3],[4,5,6],[7,8,9],[10,11,12]])
b = LibGEOS.cloneCoordSeq(a)
@fact LibGEOS.getCoordinates(b) => roughly(LibGEOS.getCoordinates(a))
LibGEOS.setCoordSeq(b, 2, [3.0, 3.0, 3.0])
@fact LibGEOS.getCoordinates(a) => roughly(Vector{Float64}[[1,2,3],[4,5,6],[7,8,9],[10,11,12]], 1e-5)
@fact LibGEOS.getCoordinates(b) => roughly(Vector{Float64}[[1,2,3],[3,3,3],[7,8,9],[10,11,12]], 1e-5)
c = LibGEOS.createPoint(LibGEOS.createCoordSeq(Vector{Float64}[[1,2]]))
@fact LibGEOS.getCoordinates(LibGEOS.getCoordSeq(c))[1] => roughly([1,2], 1e-5)

# Polygons and Holes
shell = LibGEOS.createLinearRing(Vector{Float64}[[0,0],[10,0],[10,10],[0,10],[0,0]])
hole1 = LibGEOS.createLinearRing(Vector{Float64}[[1,8],[2,8],[2,9],[1,9],[1,8]])
hole2 = LibGEOS.createLinearRing(Vector{Float64}[[8,1],[9,1],[9,2],[8,2],[8,1]])
polygon = LibGEOS.createPolygon(shell,LibGEOS.GEOSGeom[hole1,hole2])
@fact LibGEOS.getDimension(polygon) => 2
@fact LibGEOS.geomTypeId(polygon) => LibGEOS.GEOS_POLYGON
@fact LibGEOS.geomArea(polygon) => roughly(98.0, 1e-5)
exterior = LibGEOS.exteriorRing(polygon)
@fact LibGEOS.getGeomCoordinates(exterior) => roughly(Vector{Float64}[[0,0],[10,0],[10,10],[0,10],[0,0]], 1e-5)
interiors = LibGEOS.interiorRings(polygon)
@fact LibGEOS.getGeomCoordinates(interiors[1]) => roughly(Vector{Float64}[[1,8],[2,8],[2,9],[1,9],[1,8]], 1e-5)
@fact LibGEOS.getGeomCoordinates(interiors[2]) => roughly(Vector{Float64}[[8,1],[9,1],[9,2],[8,2],[8,1]], 1e-5)

# Interpolation and Projection
ls = LibGEOS.createLineString(Vector{Float64}[[8,1],[9,1],[9,2],[8,2]])
pt = LibGEOS.interpolate(ls, 2.5)
coords = LibGEOS.getGeomCoordinates(pt)
@fact length(coords) => 1
@fact coords[1] => roughly([8.5, 2.0], 1e-5)
p1 = LibGEOS.createPoint(Float64[10,1])
p2 = LibGEOS.createPoint(Float64[9,1])
p3 = LibGEOS.createPoint(Float64[10,0])
p4 = LibGEOS.createPoint(Float64[9,2])
p5 = LibGEOS.createPoint(Float64[8.7,1.5])
dist = LibGEOS.project(ls, p1)
@fact dist => roughly(1, 1e-5)
@fact LibGEOS.equals(LibGEOS.interpolate(ls, dist), p2) => true
@fact LibGEOS.project(ls, p2) => roughly(1, 1e-5)
@fact LibGEOS.project(ls, p3) => roughly(1, 1e-5)
@fact LibGEOS.project(ls, p4) => roughly(2, 1e-5)
@fact LibGEOS.project(ls, p5) => roughly(1.5, 1e-5)


