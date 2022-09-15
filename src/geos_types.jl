abstract type AbstractGeometry end

mutable struct Point <: AbstractGeometry
    ptr::GEOSGeom
    # create a point from a pointer - only makese sense if it is a pointer to a point, otherwise error
    function Point(ptr::GEOSGeom)
        id = LibGEOS.geomTypeId(ptr)
        if id == GEOS_POINT
            point = new(cloneGeom(ptr))
            finalizer(destroyGeom, point)
            point
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a point (yet). Please open an issue if you think this conversion makes sense.")
        end
    end
    # create a point from a vector of floats
    Point(coords::Vector{Float64}) = Point(createPoint(coords))
    Point(x::Real, y::Real) = Point(createPoint(x, y))
    Point(x::Real, y::Real, z::Real) = Point(createPoint(x, y, z))
end

mutable struct MultiPoint <: AbstractGeometry
    ptr::GEOSGeom
    # create a multipoint from a pointer - only makes sense if it is a pointer to a multipoint or to a point, otherwise error
    function MultiPoint(ptr::GEOSGeom)
        id = LibGEOS.geomTypeId(ptr)
        if id == GEOS_MULTIPOINT
            multipoint = new(cloneGeom(ptr))
        elseif id == GEOS_POINT
            multipoint = new(createCollection(GEOS_MULTIPOINT, 
                                        GEOSGeom[cloneGeom(ptr)]))
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a multipoint (yet). Please open an issue if you think this conversion makes sense.")
        end
        finalizer(destroyGeom, multipoint)
        multipoint
    end
    # create a multipoint frome a vector of vector coordinates
    MultiPoint(multipoint::Vector{Vector{Float64}}) = MultiPoint(
        createCollection(
            GEOS_MULTIPOINT,
            GEOSGeom[createPoint(coords) for coords in multipoint],
        ),
    )
    # create a multipoint from a list of points
    MultiPoint(points::Vector{LibGEOS.Point}) = MultiPoint(
        createCollection(
            GEOS_MULTIPOINT,
            GEOSGeom[point.ptr for point in points],
        ),
    )
end

mutable struct LineString <: AbstractGeometry
    ptr::GEOSGeom
    # create a linestring from a linestring pointer, otherwise error
    function LineString(ptr::GEOSGeom)
        id = LibGEOS.geomTypeId(ptr)
        if id == GEOS_LINESTRING
            line = new(cloneGeom(ptr))
            finalizer(destroyGeom, line)
            line
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a linestring (yet). Please open an issue if you think this conversion makes sense.")
        end
    end
    #create a linestring from a list of coordiantes
    function LineString(coords::Vector{Vector{Float64}})
        line = new(createLineString(coords))
        finalizer(destroyGeom, line)
        line
    end
end

mutable struct MultiLineString <: AbstractGeometry
    ptr::GEOSGeom
    # create a multiline string from a multilinestring or a linestring pointer, else error
    function MultiLineString(ptr::GEOSGeom)
        id = LibGEOS.geomTypeId(ptr)
        if id == GEOS_MULTILINESTRING
            multiline = new(cloneGeom(ptr))
        elseif id == GEOS_LINESTRING
            multiline = new(createCollection(GEOS_MULTILINESTRING, 
                                        GEOSGeom[cloneGeom(ptr)]))
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a multi-linestring (yet). Please open an issue if you think this conversion makes sense.")
        end
        finalizer(destroyGeom, multiline)
        multiline
    end
    # create a multilinestring from a list of linestring coordiantes
    MultiLineString(multiline::Vector{Vector{Vector{Float64}}}) = MultiLineString(
        createCollection(
            GEOS_MULTILINESTRING,
            GEOSGeom[createLineString(coords) for coords in multiline],
        ),
    )

end

mutable struct LinearRing <: AbstractGeometry
    ptr::GEOSGeom
    # create a linear ring from a linear ring pointer, otherwise error
    function LinearRing(ptr::GEOSGeom)
        id = LibGEOS.geomTypeId(ptr)
        if id == GEOS_LINEARRING
            ring = new(cloneGeom(ptr))
            finalizer(destroyGeom, ring)
            ring
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a linear ring (yet). Please open an issue if you think this conversion makes sense.")
        end
    end
    # create linear ring from a list of coordinates - 
    # first and last coordinates must be the same
    function LinearRing(coords::Vector{Vector{Float64}})
        ring = new(createLinearRing(coords))
        finalizer(destroyGeom, ring)
        ring
    end

end

mutable struct Polygon <: AbstractGeometry
    ptr::GEOSGeom
    # create polygon using GEOSGeom pointer - only makes sense if pointer points to a polygon or a linear ring to start with. 
    function Polygon(ptr::GEOSGeom)
        id = LibGEOS.geomTypeId(ptr)
        if id == GEOS_POLYGON
            polygon = new(cloneGeom(ptr))
        elseif id == GEOS_LINEARRING
            polygon = new(cloneGeom(createPolygon(ptr)))
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a polygon (yet). Please open an issue if you think this conversion makes sense.")
        end
        finalizer(destroyGeom, polygon)
        polygon
    end
    # using vector of coordinates in following form:
    # [[exterior], [hole1], [hole2], ...] where exterior and holeN are coordinates where the first and last point are the same
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
    Polygon(exterior::LinearRing, holes::Vector{LinearRing}) = 
        Polygon(createPolygon(exterior.ptr, 
                              GEOSGeom[ring.ptr for ring in holes]))
end

mutable struct MultiPolygon <: AbstractGeometry
    ptr::GEOSGeom
    # create multipolygon using a multipolygon or polygon pointer, else error
    function MultiPolygon(ptr::GEOSGeom)
        id = LibGEOS.geomTypeId(ptr)
        if id == GEOS_MULTIPOLYGON
            multipolygon = new(cloneGeom(ptr))
        elseif id == GEOS_POLYGON
            multipolygon = new(createCollection(
                                GEOS_MULTIPOLYGON,
                                GEOSGeom[cloneGeom(ptr)]))
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a multi-polygon (yet). Please open an issue if you think this conversion makes sense.")    
        end
        finalizer(destroyGeom, multipolygon)
        multipolygon
    end

    # create multipolygon from list of Polygon objects
    MultiPolygon(polygons::Vector{Polygon}) = MultiPolygon(
        createCollection(
            GEOS_MULTIPOLYGON,
            GEOSGeom[poly.ptr for poly in polygons],))

    # create multipolygon using list of polygon coordinates - note that each polygon can have holes as explained above in Polygon comments
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
    # create a geometric collection from a pointer to a geometric collection, else error
    function GeometryCollection(ptr::GEOSGeom)
        id = LibGEOS.geomTypeId(ptr)
        if id == GEOS_GEOMETRYCOLLECTION
            geometrycollection = new(cloneGeom(ptr))
            finalizer(destroyGeom, geometrycollection)
            geometrycollection
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a geometry collection (yet). Please open an issue if you think this conversion makes sense.")
        end
    end
    # create a geometric collection from a list of pointers to geometric objects
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
