abstract type AbstractGeometry end

function Base.show(io::IO, geo::AbstractGeometry)
    compact = get(io, :compact, false)
    if compact
        print(io, typeof(geo), "(...)")
    else
        s = writegeom(geo)
        print(io, s)
    end
end

"""

    get_context(geom::AbstractGeometry)::GEOSContext
    get_context(geometries...)::GEOSContext

Return the `GEOSContext` that `geom` belongs to.
It is also possible to pass multiple `geometries` to this function.
In that case it is checked, that all `geometries` share the same context
and that shared context is returned. If contexts of some geometries differ,
an error is thrown.
"""
function get_context end

function get_context(gs::AbstractVector)::GEOSContext
    if isempty(gs)
        get_global_context() # is this a good idea?
    else
        ctx = get_context(first(gs))
        _get_context(ctx, gs)
    end
end
function get_context(g1::AbstractGeometry, g2, gs...)
    ctx = get_context(g1)
    _get_context(ctx, g2, gs...)
end
function _get_context(ctx::GEOSContext, gs::AbstractVector)
    for g in gs
        _get_context(ctx, g)
    end
    ctx
end
function _get_context(ctx::GEOSContext, g::AbstractGeometry)
    if ctx !== get_context(g)
        throw(ArgumentError("Objects have distinct GEOSContext."))
    end
    ctx
end
function _get_context(ctx::GEOSContext, g, gs...)
    _get_context(ctx, g)
    _get_context(ctx, gs...)
    return ctx
end

mutable struct Point <: AbstractGeometry
    ptr::GEOSGeom
    context::GEOSContext
    # create a point from a pointer - only makese sense if it is a pointer to a point, otherwise error
    function Point(ptr::GEOSGeom, context::GEOSContext = get_global_context())
        id = LibGEOS.geomTypeId(ptr, context)
        point = if id == GEOS_POINT
            point = new(cloneGeom(ptr, context), context)
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a point (yet).
                   Please open an issue if you think this conversion makes sense.")
        end
        finalizer(destroyGeom, point)
        point
    end
    # create a point from a vector of floats
    Point(coords::Vector{Float64}, context::GEOSContext = get_global_context()) =
        Point(createPoint(coords, context), context)
    Point(x::Real, y::Real, context::GEOSContext = get_global_context()) =
        Point(createPoint(x, y, context), context)
    Point(x::Real, y::Real, z::Real, context::GEOSContext = get_global_context()) =
        Point(createPoint(x, y, z, context), context)
end

mutable struct MultiPoint <: AbstractGeometry
    ptr::GEOSGeom
    context::GEOSContext
    # create a multipoint from a pointer - only makes sense if it is a pointer to a multipoint
    # or to a point, otherwise error
    function MultiPoint(ptr::GEOSGeom, context::GEOSContext = get_global_context())
        id = LibGEOS.geomTypeId(ptr, context)
        multipoint = if id == GEOS_MULTIPOINT
            new(cloneGeom(ptr, context), context)
        elseif id == GEOS_POINT
            new(createCollection(GEOS_MULTIPOINT, 
                                 GEOSGeom[cloneGeom(ptr, context)],
                                 context), 
                context
               )
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a multipoint (yet).
                   Please open an issue if you think this conversion makes sense.")
        end
        finalizer(destroyGeom, multipoint)
        multipoint
    end
    # create a multipoint frome a vector of vector coordinates
    MultiPoint(multipoint::Vector{Vector{Float64}}, context::GEOSContext = get_global_context()) =
        MultiPoint(
            createCollection(
                GEOS_MULTIPOINT,
                GEOSGeom[createPoint(coords, context) for coords in multipoint],
                context),
            context)
    # create a multipoint from a list of points
    MultiPoint(points::Vector{LibGEOS.Point}, context::GEOSContext = get_context(points)) =
        MultiPoint(
            createCollection(
                GEOS_MULTIPOINT,
                GEOSGeom[point.ptr for point in points],
                context),
            context)
end

mutable struct LineString <: AbstractGeometry
    ptr::GEOSGeom
    context::GEOSContext
    # create a linestring from a linestring pointer, otherwise error
    function LineString(ptr::GEOSGeom, context::GEOSContext = get_global_context())
        id = LibGEOS.geomTypeId(ptr, context)
        line = if id == GEOS_LINESTRING
            new(cloneGeom(ptr, context), context)
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a linestring (yet).
                   Please open an issue if you think this conversion makes sense.")
        end
        finalizer(destroyGeom, line)
        line
    end
    #create a linestring from a list of coordiantes
    function LineString(coords::Vector{Vector{Float64}}, context::GEOSContext = get_global_context())
        line = new(createLineString(coords, context), context)
        finalizer(destroyGeom, line)
        line
    end
end

mutable struct MultiLineString <: AbstractGeometry
    ptr::GEOSGeom
    context::GEOSContext
    # create a multiline string from a multilinestring or a linestring pointer, else error
    function MultiLineString(ptr::GEOSGeom, context::GEOSContext = get_global_context())
        id = LibGEOS.geomTypeId(ptr, context)
        multiline = if id == GEOS_MULTILINESTRING
            new(cloneGeom(ptr, context), context)
        elseif id == GEOS_LINESTRING
            new(createCollection(GEOS_MULTILINESTRING, 
                                 GEOSGeom[cloneGeom(ptr, context)], 
                                 context), context)
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a multi-linestring (yet).
                   Please open an issue if you think this conversion makes sense.")
        end
        finalizer(destroyGeom, multiline)
        multiline
    end
    # create a multilinestring from a list of linestring coordiantes
    MultiLineString(multiline::Vector{Vector{Vector{Float64}}},context::GEOSContext = get_global_context()) =
        MultiLineString(
            createCollection(
                GEOS_MULTILINESTRING,
                GEOSGeom[createLineString(coords, context) for coords in multiline],
                context),
            context)
end

mutable struct LinearRing <: AbstractGeometry
    ptr::GEOSGeom
    context::GEOSContext
    # create a linear ring from a linear ring pointer, otherwise error
    function LinearRing(ptr::GEOSGeom, context::GEOSContext = get_global_context())
        id = LibGEOS.geomTypeId(ptr, context)
        ring = if id == GEOS_LINEARRING
            new(cloneGeom(ptr, context), context)
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a linear ring (yet).
                   Please open an issue if you think this conversion makes sense.")
        end
        finalizer(destroyGeom, ring)
        ring
    end
    # create linear ring from a list of coordinates - 
    # first and last coordinates must be the same
    function LinearRing(coords::Vector{Vector{Float64}}, context::GEOSContext = get_global_context())
        ring = new(createLinearRing(coords, context), context)
        finalizer(destroyGeom, ring)
        ring
    end

end

mutable struct Polygon <: AbstractGeometry
    ptr::GEOSGeom
    context::GEOSContext
    # create polygon using GEOSGeom pointer - only makes sense if pointer points to a polygon or a linear ring to start with. 
    function Polygon(ptr::GEOSGeom, context::GEOSContext = get_global_context())
        id = LibGEOS.geomTypeId(ptr, context)
        polygon = if id == GEOS_POLYGON
            new(cloneGeom(ptr, context), context)
        elseif id == GEOS_LINEARRING
            new(cloneGeom(createPolygon(ptr, context), context), context)
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a polygon (yet).
                   Please open an issue if you think this conversion makes sense.")
        end
        finalizer(destroyGeom, polygon)
        polygon
    end
    # using vector of coordinates in following form:
    # [[exterior], [hole1], [hole2], ...] where exterior and holeN are coordinates where the first and last point are the same
    function Polygon(coords::Vector{Vector{Vector{Float64}}}, context::GEOSContext = get_global_context())
        exterior = createLinearRing(coords[1], context)
        interiors = GEOSGeom[createLinearRing(lr, context) for lr in coords[2:end]]
        polygon = new(createPolygon(exterior, interiors, context), context)
        finalizer(destroyGeom, polygon)
        polygon
    end
    # using 1 linear ring to form polygon with no holes - linear ring will be outer boundary of polygon
    Polygon(ring::LinearRing, context::GEOSContext = get_context(ring)) =
        Polygon(ring.ptr, context)
    # using multiple linear rings to form polygon with holes - exterior linear ring will be polygon boundary and list of interior linear rings will form holes
    Polygon(exterior::LinearRing, holes::Vector{LinearRing}, context::GEOSContext = get_context(exterior, holes)) = 
        Polygon(
            createPolygon(exterior.ptr,
                          GEOSGeom[ring.ptr for ring in holes],
                          context),
            context)
end

mutable struct MultiPolygon <: AbstractGeometry
    ptr::GEOSGeom
    context::GEOSContext
    # create multipolygon using a multipolygon or polygon pointer, else error
    function MultiPolygon(ptr::GEOSGeom, context::GEOSContext = get_global_context())
        id = LibGEOS.geomTypeId(ptr, context)
        multipolygon = if id == GEOS_MULTIPOLYGON
            new(cloneGeom(ptr, context), context)
        elseif id == GEOS_POLYGON
            new(createCollection(
                    GEOS_MULTIPOLYGON,
                    GEOSGeom[cloneGeom(ptr, context)],
                    context),
                context
               )
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a multi-polygon (yet).
                   Please open an issue if you think this conversion makes sense.")    
        end
        finalizer(destroyGeom, multipolygon)
        multipolygon
    end

    # create multipolygon from list of Polygon objects
    MultiPolygon(polygons::Vector{Polygon}, context::GEOSContext = get_context(polygons)) =
        MultiPolygon(
            createCollection(
                GEOS_MULTIPOLYGON,
                GEOSGeom[poly.ptr for poly in polygons],
                context),
            context)

    # create multipolygon using list of polygon coordinates - note that each polygon can have holes as explained above in Polygon comments
    MultiPolygon(multipolygon::Vector{Vector{Vector{Vector{Float64}}}}, context::GEOSContext = get_global_context()) =
        MultiPolygon(
            createCollection(
                GEOS_MULTIPOLYGON,
                GEOSGeom[
                    createPolygon(
                        createLinearRing(coords[1], context),
                        GEOSGeom[createLinearRing(c, context) for c in coords[2:end]],
                        context)
                    for coords in multipolygon],
                context),
            context)
end

mutable struct GeometryCollection <: AbstractGeometry
    ptr::GEOSGeom
    context::GEOSContext
    # create a geometric collection from a pointer to a geometric collection, else error
    function GeometryCollection(ptr::GEOSGeom, context::GEOSContext = get_global_context())
        id = LibGEOS.geomTypeId(ptr, context)
        geometrycollection = if id == GEOS_GEOMETRYCOLLECTION
            new(cloneGeom(ptr, context), context)
        else
            error("LibGEOS: Can't convert a pointer to an element with a GeomType ID of $id to a geometry collection (yet).
                   Please open an issue if you think this conversion makes sense.")
        end
        finalizer(destroyGeom, geometrycollection)
        geometrycollection
    end
    # create a geometric collection from a list of pointers to geometric objects
    GeometryCollection(collection::Vector{GEOSGeom}, context::GEOSContext = get_global_context()) =
        GeometryCollection(
            createCollection(
                GEOS_GEOMETRYCOLLECTION,
                collection,
                context),
            context)
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

"""
    clone(obj::Geometry, context=get_context(obj))

Create a deep copy of obj, optionally also moving it to a new context.
"""
function clone(obj::Geometry, context=get_context(obj))
    G = typeof(obj)
    # Note that all Geometry constructors 
    # implicitly clone the pointer, in the following line
    GC.@preserve obj G(obj.ptr, context)::G
end

get_context(obj::Geometry) = obj.context
function destroyGeom(obj::Geometry)
    context = get_context(obj)
    destroyGeom(obj.ptr, context)
    obj.ptr = C_NULL
end

mutable struct PreparedGeometry{G<:AbstractGeometry} <: AbstractGeometry
    ptr::Ptr{GEOSPreparedGeometry}
    ownedby::G
end

get_context(obj::PreparedGeometry) = get_context(obj.ownedby)

function destroyGeom(obj::PreparedGeometry)
    context = get_context(obj)
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

function Base.:(==)(geo1::AbstractGeometry, geo2::AbstractGeometry)::Bool
    compare(==, geo1, geo2)
end
function Base.isequal(geo1::AbstractGeometry, geo2::AbstractGeometry)::Bool
    compare(isequal, geo1, geo2)
end
function compare(≅, geo1::AbstractGeometry, geo2::AbstractGeometry)::Bool
    (typeof(geo1) === typeof(geo2)) || return false
    ng1 = ngeom(geo1)
    ng2 = ngeom(geo2)
    ng1 == ng2 || return false
    for i in 1:ng1
        (getgeom(geo1, i) ≅ getgeom(geo2, i)) || return false
    end
    return true
end
function compare(≅, pt1::Point, pt2::Point)::Bool
    is3d = GeoInterface.is3d(pt1)
    is3d === GeoInterface.is3d(pt2) || return false
    GeoInterface.getcoord(pt1,1) ≅ GeoInterface.getcoord(pt2,1) || return false
    GeoInterface.getcoord(pt1,2) ≅ GeoInterface.getcoord(pt2,2) || return false
    if is3d
        GeoInterface.getcoord(pt1,3) ≅ GeoInterface.getcoord(pt2,3) || return false
    end
    return true
end

typesalt(::Type{GeometryCollection} ) = 0xd1fd7c6403c36e5b
typesalt(::Type{PreparedGeometry}   ) = 0xbc1a26fe2f5b7537
typesalt(::Type{LineString}         ) = 0x712352fe219fca15
typesalt(::Type{LinearRing}         ) = 0xac7644fd36955ef1
typesalt(::Type{MultiLineString}    ) = 0x85aff0a53a2f2a32
typesalt(::Type{MultiPoint}         ) = 0x6213e67dbfd3b570
typesalt(::Type{MultiPolygon}       ) = 0xff2f957b4cdb5832
typesalt(::Type{Point}              ) = 0x4b5c101d3843160e
typesalt(::Type{Polygon}            ) = 0xa5c895d62ef56723

function Base.hash(geo::AbstractGeometry, h::UInt)::UInt
    salt = typesalt(typeof(geo))
    h = hash(salt, h)
    for i in 1:ngeom(geo)
        g = getgeom(geo,i)
        h = hash(g, h)
    end
    return h
end

function Base.hash(pt::Point, h::UInt)::UInt
    h = hash(getcoord(pt,1), h)
    h = hash(getcoord(pt,2), h)
    if GeoInterface.is3d(pt)
        h = hash(getcoord(pt,3), h)
    end
    h = hash(getcoord(pt,2), h)
    return h
end
