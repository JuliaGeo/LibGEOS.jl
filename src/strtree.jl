"""
    STRtree(items; nodecapacity=10, context::GEOSContext=get_global_context())

Create a Sort Tile Recursive tree for fast intersection queries of objects for which an
envelope is defined. The tree cannot be changed after its creation.

## Arguments
- `items`: The items to store in the tree.
- `nodecapacity`: The maximum number of items that can be stored per tree node (default 10).
- `context`: The GEOS context in which the tree should be created in. Defaults to the global
  LibGEOS context.
"""
mutable struct STRtree{T}
    ptr::Ptr{GEOSSTRtree}  # void pointer to the tree
    items::T  # any geometry for which an envelope can be derived
    context::GEOSContext
    function STRtree(items; nodecapacity = 10, context::GEOSContext = get_global_context())
        tree = LibGEOS.GEOSSTRtree_create_r(context, nodecapacity)
        for item in items
            GEOSSTRtree_insert_r(context, tree, envelope(item), pointer_from_objref(item))
        end
        T = typeof(items)
        ret = new{T}(tree, items, context)
        finalizer(destroySTRtree, ret)
        return ret
    end
end

get_context(obj::STRtree) = obj.context

function destroySTRtree(obj::STRtree)
    context = get_context(obj)
    GEOSSTRtree_destroy_r(context, obj)
    obj.ptr = C_NULL
    return nothing
end

function get_context(tree::STRtree, g::Geometry)
    ctx = get_context(tree)
    _get_context(ctx, g)
end

"""
    query(tree::STRtree, geometry; context::GEOSContext=get_global_context())

Returns the objects within `tree`, whose envelope intersects the envelope of `geometry`.

## Arguments
- `tree`: The STRtree to query
- `geometry`: The LibGEOS geometry (e.g. Polygon) to run the query for
- `context`: The GEOS context. Defaults to the global LibGEOS context.
"""
function query(
    tree::STRtree{T},
    geometry::Geometry;
    context::GEOSContext = get_context(tree, geometry),
) where {T}
    matches = eltype(T)[]

    # called for each overlapping item in the tree, used to push the item to matches
    function callback(item, userdata)::Ptr{Cvoid}
        item_ = unsafe_pointer_to_objref(item)
        userdata_ = unsafe_pointer_to_objref(userdata)
        push!(userdata_, item_)
        return C_NULL
    end

    cfun_callback = @cfunction($callback, Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}))
    GC.@preserve matches begin
        GEOSSTRtree_query_r(
            context,
            tree,
            geometry,
            cfun_callback,
            pointer_from_objref(matches),
        )
    end
    return matches
end
