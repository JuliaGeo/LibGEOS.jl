abstract type AbstractGeometry end

mutable struct Point <: AbstractGeometry
    ptr::GEOSGeom

    function Point(ptr::GEOSGeom)
        point = new(ptr)
        finalizer(destroyGeom, point)
        point
    end
    Point(coords::Vector{Float64}) = Point(createPoint(coords))
    Point(x::Real, y::Real) = Point(createPoint(x, y))
    Point(x::Real, y::Real, z::Real) = Point(createPoint(x, y, z))

end

mutable struct MultiPoint <: AbstractGeometry
    ptr::GEOSGeom

    function MultiPoint(ptr::GEOSGeom)
        multipoint = new(ptr)
        finalizer(destroyGeom, multipoint)
        multipoint
    end
    MultiPoint(multipoint::Vector{Vector{Float64}}) = MultiPoint(
        createCollection(
            GEOS_MULTIPOINT,
            GEOSGeom[createPoint(coords) for coords in multipoint],
        ),
    )

end

mutable struct LineString <: AbstractGeometry
    ptr::GEOSGeom

    function LineString(ptr::GEOSGeom)
        line = new(ptr)
        finalizer(destroyGeom, line)
        line
    end
    LineString(line::Vector{Vector{Float64}}) = LineString(createLineString(line))

end

mutable struct MultiLineString <: AbstractGeometry
    ptr::GEOSGeom

    function MultiLineString(ptr::GEOSGeom)
        multiline = new(ptr)
        finalizer(destroyGeom, multiline)
        multiline
    end
    MultiLineString(multiline::Vector{Vector{Vector{Float64}}}) = MultiLineString(
        createCollection(
            GEOS_MULTILINESTRING,
            GEOSGeom[createLineString(coords) for coords in multiline],
        ),
    )

end

mutable struct LinearRing <: AbstractGeometry
    ptr::GEOSGeom

    function LinearRing(ptr::GEOSGeom)
        ring = new(ptr)
        finalizer(destroyGeom, ring)
        ring
    end
    LinearRing(ring::Vector{Vector{Float64}}) = LinearRing(createLinearRing(ring))

end

mutable struct Polygon <: AbstractGeometry
    ptr::GEOSGeom
    # create polygon using GEOSGeom pointer - only makes sense if pointer points to a polygon or a linear ring to start with. 
    function Polygon(ptr::GEOSGeom)
        id = LibGEOS.geomTypeId(ptr)
        if id == 3
            polygon = new(cloneGeom(ptr))
        elseif id == 2
            polygon = new(cloneGeom(createPolygon(ptr)))
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a polygon (yet). Please open an issue if you think this conversion makes sense. ")
        end
        finalizer(destroyGeom, polygon)
        polygon
    end
    # using vector of coordinates in following form:
    # [[exterior], [hole1], [hole2], ...] where exterior and holeN are coordiantes where the first and last point are the same
    function Polygon(coords::Vector{Vector{Vector{Float64}}})
        exterior = createLinearRing(coords[1])
        interiors = GEOSGeom[createLinearRing(lr) for lr in coords[2:end]]
        polygon = new(createPolygon(exterior, interiors))
        finalizer(destroyGeom, polygon)
        polygon
    end
    # using 1 linear ring to form polygon with no holes - linear ring will be outer boundary of polygon
    Polygon(ring::LinearRing) = Polygon(ring.ptr)
    # using multiple linear rings to form polygon with holes - exterior linear ring will be polygon boundary and list of interior linear rings will form holes
    Polygon(exterior::LinearRing, interior::Vector{LinearRing}) = 
        Polygon(createPolygon(exterior.ptr, 
                              GEOSGeom[ring.ptr for ring in interior]))
end

mutable struct MultiPolygon <: AbstractGeometry
    ptr::GEOSGeom

    function MultiPolygon(ptr::GEOSGeom)
        multipolygon = new(ptr)
        finalizer(destroyGeom, multipolygon)
        multipolygon
    end
    MultiPolygon(multipolygon::Vector{Vector{Vector{Vector{Float64}}}}) = MultiPolygon(
        createCollection(
            GEOS_MULTIPOLYGON,
            GEOSGeom[
                createPolygon(
                    createLinearRing(coords[1]),
                    GEOSGeom[createLinearRing(c) for c in coords[2:end]],
                ) for coords in multipolygon
            ],
        ),
    )

end

mutable struct GeometryCollection <: AbstractGeometry
    ptr::GEOSGeom

    function GeometryCollection(ptr::GEOSGeom)
        geometrycollection = new(ptr)
        finalizer(destroyGeom, geometrycollection)
        geometrycollection
    end
    GeometryCollection(collection::Vector{GEOSGeom}) =
        GeometryCollection(createCollection(GEOS_GEOMETRYCOLLECTION, collection))
end

const Geometry = Union{
    Point,
    MultiPoint,
    LineString,
    MultiLineString,
    LinearRing,
    Polygon,
    MultiPolygon,
    GeometryCollection,
}

function destroyGeom(obj::Geometry, context::GEOSContext = _context)
    destroyGeom(obj.ptr, context)
    obj.ptr = C_NULL
end

mutable struct PreparedGeometry{G<:AbstractGeometry} <: AbstractGeometry
    ptr::Ptr{GEOSPreparedGeometry}
    ownedby::G
end

function destroyGeom(obj::PreparedGeometry, context::GEOSContext = _context)
    destroyPreparedGeom(obj.ptr, context)
    obj.ptr = C_NULL
end

const geomtypes = [
    Point,
    LineString,
    LinearRing,
    Polygon,
    MultiPoint,
    MultiLineString,
    MultiPolygon,
    GeometryCollection,
]
