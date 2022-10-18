mutable struct STRtree{T}
    ptr::Ptr{GEOSSTRtree}  # void pointer to the tree
    items::T  # any geometry for which an envelope can be derived
    context::GEOSContext
    function STRtree(items; nodecapacity = 10, context::GEOSContext = _context)
        tree = LibGEOS.GEOSSTRtree_create_r(context.ptr, nodecapacity)
        for item in items
            envptr = envelope(item).ptr
            GEOSSTRtree_insert_r(context.ptr, tree, envptr, pointer_from_objref(item))
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
    GC.@preserve context begin
        GEOSSTRtree_destroy_r(context.ptr, obj.ptr)
    end
    obj.ptr = C_NULL
end
"""
    STRtree(items; nodecapacity=10, context::GEOSContext=_context)

Create a Sort Tile Recursive tree for fast intersection queries of objects for which an
envelope is defined. The tree cannot be changed after its creation.

## Arguments
- `items`: The items to store in the tree.
- `nodecapacity`: The maximum number of items that can be stored per tree node (default 10).
- `context`: The GEOS context in which the tree should be created in. Defaults to the global
  LibGEOS context.
"""
STRtree

"""
    query(tree::STRtree, geometry; context::GEOSContext=_context)

Returns the objects within `tree`, whose envelope intersects the envelope of `geometry`.

## Arguments
- `tree`: The STRtree to query
- `geometry`: The LibGEOS geometry (e.g. Polygon) to run the query for
- `context`: The GEOS context. Defaults to the global LibGEOS context.
"""
function query(
    tree::STRtree{T},
    geometry::Geometry;
    context::GEOSContext = get_context(tree),
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
    GC.@preserve context tree geometry matches begin
        GEOSSTRtree_query_r(
            context.ptr,
            tree.ptr,
            geometry.ptr,
            cfun_callback,
            pointer_from_objref(matches),
        )
    end
    return matches
end
